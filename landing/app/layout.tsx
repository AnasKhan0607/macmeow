import type { Metadata } from "next";
import { Inter } from "next/font/google";
import "./globals.css";

const inter = Inter({ subsets: ["latin"], variable: "--font-inter" });

export const metadata: Metadata = {
  title: "Sentient - Your Mac is alive now",
  description:
    "Give your MacBook a personality. It reacts to how you treat it — tilt it, ignore it, or doom-scroll. Your Mac now has feelings about all of it.",
  keywords: ["mac app", "macos", "personality", "fun", "menu bar", "accelerometer"],
  authors: [{ name: "Anas Khan" }],
  openGraph: {
    title: "Sentient - Your Mac is alive now",
    description: "Give your MacBook a personality that reacts to how you treat it.",
    type: "website",
    locale: "en_US",
  },
  twitter: {
    card: "summary_large_image",
    title: "Sentient - Your Mac is alive now",
    description: "Give your MacBook a personality that reacts to how you treat it.",
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
