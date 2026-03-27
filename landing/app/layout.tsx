import type { Metadata } from "next";
import { Inter } from "next/font/google";
import "./globals.css";

const inter = Inter({ subsets: ["latin"], variable: "--font-inter" });

export const metadata: Metadata = {
  title: "MacMeow - A judgmental cat in your menu bar",
  description:
    "A cute cat that lives in your Mac's menu bar. He watches what you do, reacts to how you treat your laptop, and has strong opinions about your battery life.",
  keywords: ["mac app", "macos", "cat", "menu bar", "fun", "accelerometer", "macmeow"],
  authors: [{ name: "Anas Khan" }],
  openGraph: {
    title: "MacMeow - A judgmental cat in your menu bar",
    description: "A cute cat that lives in your Mac's menu bar and judges everything you do.",
    type: "website",
    locale: "en_US",
  },
  twitter: {
    card: "summary_large_image",
    title: "MacMeow - A judgmental cat in your menu bar",
    description: "A cute cat that lives in your Mac's menu bar and judges everything you do.",
    creator: "@AnasKhan0607",
  },
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="en">
      <body className={`${inter.variable} font-sans antialiased`}>
        {children}
      </body>
    </html>
  );
}
