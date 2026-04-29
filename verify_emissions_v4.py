import asyncio
from playwright.async_api import async_playwright
import os

async def run():
    async with async_playwright() as p:
        browser = await p.chromium.launch()
        context = await browser.new_context(viewport={'width': 1280, 'height': 800})
        page = await context.new_page()

        print("Navigating to http://localhost:8000...")
        await page.goto("http://localhost:8000")

        print("Waiting 15 seconds for Flutter to initialize and fetch data...")
        await page.wait_for_timeout(15000)

        # Take a screenshot of the top (Map)
        await page.screenshot(path="/home/jules/verification/screenshots/map_final.png")
        print("Captured map_final.png")

        # Scroll down using PageDown
        for i in range(1, 6):
            print(f"Scrolling down ({i}/5)...")
            await page.keyboard.press("PageDown")
            await page.wait_for_timeout(2000)
            await page.screenshot(path=f"/home/jules/verification/screenshots/pagedown_{i}.png")

        await browser.close()

if __name__ == "__main__":
    asyncio.run(run())
