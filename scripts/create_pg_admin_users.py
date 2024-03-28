from playwright.sync_api import Playwright, sync_playwright, expect

pgadmin_url = "https://address.net"
username = "username@corndel.com"
password = "password"

users_to_create = [
    {
        "email": "user1@corndel.com",
        "password": "password"
    },
    {
        "email": "user2@corndel.com",
        "password": "password"
    }
]

def run(playwright: Playwright) -> None:
    browser = playwright.chromium.launch(headless=False)
    context = browser.new_context()
    page = context.new_page()
    page.goto(f"{pgadmin_url}/login?next=%2Fbrowser%2F")
    page.get_by_placeholder("Email Address / Username").fill(username)
    page.get_by_placeholder("Password").fill(password)
    page.get_by_role("button", name="Login").click()

    page.locator("[data-test=\"loggedin-username\"]").click()
    page.get_by_role("menuitem", name="Users").click()
    
    for user in users_to_create:
        add_user(page, user["email"], user["password"])

    page.locator("[data-test=\"Save\"]").click()

    # ---------------------
    context.close()
    browser.close()

def add_user(page, username, user_password):
    page.locator("[data-test=\"add-row\"]").click()
    page.locator("div:nth-child(4) > .MuiInputBase-root > .MuiInputBase-input").first.fill(username)
    page.locator("div:nth-child(7) > .MuiInputBase-root > .MuiInputBase-input").first.fill(user_password)
    page.locator("div:nth-child(8) > .MuiInputBase-root > .MuiInputBase-input").first.fill(user_password)

with sync_playwright() as playwright:
    run(playwright)
