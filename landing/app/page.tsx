"use client";

import { motion } from "framer-motion";
import Image from "next/image";
import { useState } from "react";

const personalities = [
  {
    id: "dramatic",
    name: "Dramatic",
    color: "#FFB347",
    bgColor: "bg-orange-50",
    borderColor: "border-orange-200",
    trigger: "Shake or tilt your laptop",
    quote: "EARTHQUAKE! WE'RE ALL GONNA—oh wait you just shifted positions.",
    image: "/cats/dramatic.svg",
  },
  {
    id: "hungry",
    name: "Hungry",
    color: "#7CB890",
    bgColor: "bg-green-50",
    borderColor: "border-green-200",
    trigger: "Battery drops below 20%",
    quote: "feed me... electrons... I'm fading...",
    image: "/cats/hungry.svg",
  },
  {
    id: "judgmental",
    name: "Judgmental",
    color: "#9B8BB4",
    bgColor: "bg-purple-50",
    borderColor: "border-purple-200",
    trigger: "Open certain apps",
    quote: "Twitter again? It's been 4 minutes since you last checked.",
    image: "/cats/judgmental.svg",
  },
  {
    id: "needy",
    name: "Needy",
    color: "#F08080",
    bgColor: "bg-pink-50",
    borderColor: "border-pink-200",
    trigger: "Leave your Mac idle or close the lid",
    quote: "Wait... you're leaving? Was it something I said?",
    image: "/cats/needy.svg",
  },
];

export default function Home() {
  const [activePersonality, setActivePersonality] = useState(0);

  return (
    <main className="min-h-screen bg-[#FAFAFA] overflow-hidden">
      {/* Hand-drawn style background elements */}
      <div className="fixed inset-0 pointer-events-none overflow-hidden">
        <svg className="absolute top-20 left-10 w-20 h-20 text-blue-200 opacity-40" viewBox="0 0 100 100">
          <path d="M50 10 Q60 50 50 90 M10 50 Q50 60 90 50" stroke="currentColor" strokeWidth="2" fill="none" strokeLinecap="round"/>
        </svg>
        <svg className="absolute top-40 right-20 w-16 h-16 text-pink-200 opacity-50" viewBox="0 0 100 100">
          <circle cx="50" cy="50" r="40" stroke="currentColor" strokeWidth="2" fill="none" strokeDasharray="8 4"/>
        </svg>
        <svg className="absolute bottom-40 left-20 w-24 h-24 text-purple-200 opacity-30" viewBox="0 0 100 100">
          <path d="M20 50 L50 20 L80 50 L50 80 Z" stroke="currentColor" strokeWidth="2" fill="none"/>
        </svg>
      </div>

      {/* Hero Section */}
      <section className="relative min-h-screen flex flex-col items-center justify-center px-6 py-20">
        {/* Main content */}
        <motion.div
          initial={{ opacity: 0, y: 30 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.8 }}
          className="text-center max-w-2xl mx-auto"
        >
          {/* Cat mascot */}
          <motion.div
            className="relative w-64 h-64 mx-auto mb-8"
            animate={{ y: [0, -10, 0] }}
            transition={{ duration: 3, repeat: Infinity, ease: "easeInOut" }}
          >
            <Image
              src="/cats/mac-hero.svg"
              alt="Mac the Cat"
              fill
              className="object-contain"
              priority
            />
          </motion.div>

          <h1 className="text-5xl md:text-6xl font-bold text-gray-800 mb-4 tracking-tight">
            Meet <span className="text-[#5568C8]">Mac</span>
          </h1>
          
          <p className="text-xl text-gray-600 mb-2">
            The cat that lives in your menu bar.
          </p>
          <p className="text-lg text-gray-500 mb-8">
            He watches. He judges. He has opinions.
          </p>

          <div className="flex flex-col sm:flex-row gap-4 justify-center items-center">
            <motion.button
              whileHover={{ scale: 1.05 }}
              whileTap={{ scale: 0.95 }}
              className="px-8 py-4 bg-[#5568C8] text-white rounded-2xl font-semibold text-lg shadow-lg shadow-blue-200 hover:bg-[#4758B8] transition-colors"
            >
              Download for Mac
            </motion.button>
            <span className="text-gray-400 text-sm">macOS 14+ · Apple Silicon</span>
          </div>
        </motion.div>

        {/* Scroll indicator */}
        <motion.div
          className="absolute bottom-10"
          animate={{ y: [0, 8, 0] }}
          transition={{ duration: 2, repeat: Infinity }}
        >
          <svg className="w-6 h-6 text-gray-300" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M19 14l-7 7m0 0l-7-7m7 7V3" />
          </svg>
        </motion.div>
      </section>

      {/* Personality Section */}
      <section className="py-20 px-6">
        <div className="max-w-5xl mx-auto">
          <motion.div
            initial={{ opacity: 0 }}
            whileInView={{ opacity: 1 }}
            viewport={{ once: true }}
            className="text-center mb-16"
          >
            <h2 className="text-4xl font-bold text-gray-800 mb-4">
              Four personalities. One chaotic cat.
            </h2>
            <p className="text-gray-600 text-lg">
              Mac reacts to what you do. Sometimes helpfully. Usually not.
            </p>
          </motion.div>

          {/* Personality showcase */}
          <div className="grid lg:grid-cols-2 gap-8 items-center">
            {/* Cat display */}
            <motion.div
              key={activePersonality}
              initial={{ opacity: 0, scale: 0.9 }}
              animate={{ opacity: 1, scale: 1 }}
              transition={{ duration: 0.3 }}
              className={`relative aspect-square max-w-md mx-auto w-full rounded-3xl ${personalities[activePersonality].bgColor} ${personalities[activePersonality].borderColor} border-2 p-8 flex flex-col items-center justify-center`}
            >
              <Image
                src={personalities[activePersonality].image}
                alt={personalities[activePersonality].name}
                width={200}
                height={200}
                className="mb-6"
              />
              
              {/* Speech bubble */}
              <div className="relative bg-white rounded-2xl px-6 py-4 shadow-sm max-w-xs">
                <p className="text-gray-700 text-center italic">
                  "{personalities[activePersonality].quote}"
                </p>
                {/* Bubble tail */}
                <div className="absolute -top-2 left-1/2 -translate-x-1/2 w-4 h-4 bg-white rotate-45" />
              </div>
            </motion.div>

            {/* Personality selector */}
            <div className="space-y-4">
              {personalities.map((p, i) => (
                <motion.button
                  key={p.id}
                  onClick={() => setActivePersonality(i)}
                  whileHover={{ x: 4 }}
                  className={`w-full text-left p-5 rounded-2xl border-2 transition-all ${
                    activePersonality === i
                      ? `${p.bgColor} ${p.borderColor}`
                      : "bg-white border-gray-100 hover:border-gray-200"
                  }`}
                >
                  <div className="flex items-center gap-4">
                    <div
                      className="w-12 h-12 rounded-xl flex items-center justify-center"
                      style={{ backgroundColor: `${p.color}20` }}
                    >
                      <Image src={p.image} alt={p.name} width={32} height={32} />
                    </div>
                    <div>
                      <h3 className="font-semibold text-gray-800">{p.name}</h3>
                      <p className="text-sm text-gray-500">{p.trigger}</p>
                    </div>
                  </div>
                </motion.button>
              ))}
            </div>
          </div>
        </div>
      </section>

      {/* How it works - simple */}
      <section className="py-20 px-6 bg-white">
        <div className="max-w-4xl mx-auto">
          <motion.div
            initial={{ opacity: 0 }}
            whileInView={{ opacity: 1 }}
            viewport={{ once: true }}
            className="text-center mb-16"
          >
            <h2 className="text-4xl font-bold text-gray-800 mb-4">
              How it works
            </h2>
          </motion.div>

          <div className="grid md:grid-cols-3 gap-8">
            {[
              {
                step: "1",
                title: "Install",
                desc: "Drop it in Applications. That's it. No setup, no accounts.",
              },
              {
                step: "2",
                title: "Ignore it",
                desc: "Mac lives in your menu bar. He's always watching. Always.",
              },
              {
                step: "3",
                title: "Get judged",
                desc: "Tilt your laptop. Check Twitter too much. Let your battery die. Mac will have thoughts.",
              },
            ].map((item, i) => (
              <motion.div
                key={i}
                initial={{ opacity: 0, y: 20 }}
                whileInView={{ opacity: 1, y: 0 }}
                viewport={{ once: true }}
                transition={{ delay: i * 0.1 }}
                className="text-center"
              >
                <div className="w-12 h-12 rounded-full bg-[#5568C8] text-white flex items-center justify-center text-xl font-bold mx-auto mb-4">
                  {item.step}
                </div>
                <h3 className="font-semibold text-gray-800 mb-2">{item.title}</h3>
                <p className="text-gray-600 text-sm">{item.desc}</p>
              </motion.div>
            ))}
          </div>
        </div>
      </section>

      {/* Privacy - casual */}
      <section className="py-20 px-6">
        <div className="max-w-2xl mx-auto text-center">
          <motion.div
            initial={{ opacity: 0 }}
            whileInView={{ opacity: 1 }}
            viewport={{ once: true }}
          >
            <div className="inline-flex items-center gap-2 bg-green-50 text-green-700 px-4 py-2 rounded-full text-sm font-medium mb-6">
              <svg className="w-4 h-4" fill="currentColor" viewBox="0 0 20 20">
                <path fillRule="evenodd" d="M5 9V7a5 5 0 0110 0v2a2 2 0 012 2v5a2 2 0 01-2 2H5a2 2 0 01-2-2v-5a2 2 0 012-2zm8-2v2H7V7a3 3 0 016 0z" clipRule="evenodd" />
              </svg>
              100% Local
            </div>
            
            <h2 className="text-3xl font-bold text-gray-800 mb-4">
              Mac doesn't phone home
            </h2>
            <p className="text-gray-600 text-lg mb-4">
              No accounts. No analytics. No cloud. No AI watching what you do.
            </p>
            <p className="text-gray-500">
              Everything runs locally on your Mac. The cat is self-contained.
              <br />
              Your battery anxiety stays between you and Mac.
            </p>
          </motion.div>
        </div>
      </section>

      {/* Final CTA */}
      <section className="py-20 px-6">
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          whileInView={{ opacity: 1, y: 0 }}
          viewport={{ once: true }}
          className="max-w-xl mx-auto text-center"
        >
          <Image
            src="/cats/mac-hero.svg"
            alt="Mac"
            width={150}
            height={150}
            className="mx-auto mb-8"
          />
          
          <h2 className="text-3xl font-bold text-gray-800 mb-4">
            Ready to be judged?
          </h2>
          <p className="text-gray-600 mb-8">
            Free to download. Your Mac is about to get a lot more opinionated.
          </p>
          
          <motion.button
            whileHover={{ scale: 1.05 }}
            whileTap={{ scale: 0.95 }}
            className="px-8 py-4 bg-[#5568C8] text-white rounded-2xl font-semibold text-lg shadow-lg shadow-blue-200 hover:bg-[#4758B8] transition-colors"
          >
            Download Sentient
          </motion.button>
          
          <p className="text-gray-400 text-sm mt-4">
            v1.0 · macOS 14 Sonoma or later · Apple Silicon
          </p>
        </motion.div>
      </section>

      {/* Footer */}
      <footer className="py-8 px-6 border-t border-gray-100">
        <div className="max-w-4xl mx-auto flex flex-col md:flex-row justify-between items-center gap-4 text-sm text-gray-500">
          <p>Made with questionable life choices by Anas Khan</p>
          <div className="flex gap-6">
            <a href="https://twitter.com/AnasKhan0607" className="hover:text-gray-800 transition-colors">
              Twitter
            </a>
            <a href="https://github.com/AnasKhan0607/sentient" className="hover:text-gray-800 transition-colors">
              GitHub
            </a>
          </div>
        </div>
      </footer>
    </main>
  );
}