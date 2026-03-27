"use client";

import { useState } from "react";
import { motion, AnimatePresence } from "framer-motion";

const personalities = [
  {
    emoji: "🎭",
    name: "Dramatic",
    description: "Screams when you tilt it. Gasps when you slam the lid. Lives for chaos.",
    color: "from-red-100 to-orange-100",
    borderColor: "border-red-200",
    reactions: ["AHHH!", "Why would you do this?!", "*gasp*"],
  },
  {
    emoji: "🍔",
    name: "Hungry",
    description: "Gets hangry when battery is low. Very satisfied when you plug it in.",
    color: "from-amber-100 to-yellow-100",
    borderColor: "border-amber-200",
    reactions: ["Feed me...", "*stomach growl*", "Ahhh yummy electricity!"],
  },
  {
    emoji: "😤",
    name: "Judgmental",
    description: "Sighs when you open Twitter. Disappointed when you scroll Reddit. Again.",
    color: "from-purple-100 to-indigo-100",
    borderColor: "border-purple-200",
    reactions: ["*sigh* Really?", "I expected better.", "Here we go again..."],
  },
  {
    emoji: "🥺",
    name: "Needy",
    description: "Misses you when you're away. So happy when you come back. Please don't leave.",
    color: "from-pink-100 to-rose-100",
    borderColor: "border-pink-200",
    reactions: ["Don't leave me!", "You're back! 🥹", "I missed you..."],
  },
];

function MacBookMock({ reaction }: { reaction: string | null }) {
  return (
    <motion.div
      className="relative"
      whileHover={{ rotate: [-2, 2, -2, 0] }}
      transition={{ duration: 0.5 }}
    >
      {/* MacBook Body */}
      <div className="w-64 h-40 bg-gradient-to-b from-gray-200 to-gray-300 rounded-t-lg shadow-lg relative overflow-hidden">
        {/* Screen */}
        <div className="absolute inset-2 bg-gradient-to-br from-gray-800 to-gray-900 rounded-md flex items-center justify-center">
          <AnimatePresence mode="wait">
            {reaction ? (
              <motion.div
                key={reaction}
                initial={{ scale: 0, opacity: 0 }}
                animate={{ scale: 1, opacity: 1 }}
                exit={{ scale: 0, opacity: 0 }}
                className="text-white text-center px-4"
              >
                <span className="text-2xl">{reaction}</span>
              </motion.div>
            ) : (
              <motion.div
                initial={{ opacity: 0 }}
                animate={{ opacity: 1 }}
                className="text-4xl"
              >
                🧠
              </motion.div>
            )}
          </AnimatePresence>
        </div>
        {/* Camera dot */}
        <div className="absolute top-3 left-1/2 -translate-x-1/2 w-1.5 h-1.5 bg-gray-600 rounded-full" />
      </div>
      {/* MacBook Base */}
      <div className="w-72 h-3 bg-gradient-to-b from-gray-300 to-gray-400 rounded-b-lg -mt-0.5 mx-auto shadow-md">
        <div className="w-12 h-1 bg-gray-400 rounded-full mx-auto mt-1" />
      </div>
    </motion.div>
  );
}

function PersonalityCard({
  personality,
  isSelected,
  onClick,
}: {
  personality: (typeof personalities)[0];
  isSelected: boolean;
  onClick: () => void;
}) {
  return (
    <motion.button
      onClick={onClick}
      className={`personality-card p-6 rounded-2xl border-2 text-left w-full bg-gradient-to-br ${personality.color} ${personality.borderColor} ${isSelected ? "ring-2 ring-offset-2 ring-pink-400" : ""}`}
      whileHover={{ scale: 1.02 }}
      whileTap={{ scale: 0.98 }}
    >
      <div className="text-4xl mb-3">{personality.emoji}</div>
      <h3 className="text-xl font-semibold mb-2">{personality.name}</h3>
      <p className="text-gray-600 text-sm">{personality.description}</p>
    </motion.button>
  );
}

export default function Home() {
  const [selectedPersonality, setSelectedPersonality] = useState<number | null>(null);
  const [currentReaction, setCurrentReaction] = useState<string | null>(null);

  const handlePersonalityClick = (index: number) => {
    setSelectedPersonality(index);
    const reactions = personalities[index].reactions;
    const randomReaction = reactions[Math.floor(Math.random() * reactions.length)];
    setCurrentReaction(randomReaction);

    setTimeout(() => setCurrentReaction(null), 2000);
  };

  return (
    <main className="min-h-screen gradient-bg">
      {/* Hero Section */}
      <section className="container mx-auto px-4 pt-20 pb-16">
        <div className="text-center max-w-3xl mx-auto">
          <motion.div
            initial={{ scale: 0 }}
            animate={{ scale: 1 }}
            transition={{ type: "spring", duration: 0.8 }}
            className="text-7xl mb-6"
          >
            🧠
          </motion.div>

          <motion.h1
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ delay: 0.2 }}
            className="text-5xl md:text-6xl font-bold mb-6 bg-gradient-to-r from-pink-500 via-purple-500 to-indigo-500 bg-clip-text text-transparent"
          >
            Your Mac is alive now.
          </motion.h1>

          <motion.p
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ delay: 0.4 }}
            className="text-xl text-gray-600 mb-8 max-w-2xl mx-auto"
          >
            Sentient gives your MacBook a personality. It reacts to how you treat it — 
            tilt it, ignore it, drain its battery, or doom-scroll. 
            Your Mac now has <span className="text-pink-500 font-semibold">feelings</span> about all of it.
          </motion.p>

          <motion.div
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ delay: 0.6 }}
            className="flex flex-col sm:flex-row gap-4 justify-center items-center"
          >
            <a
              href="https://github.com/AnasKhan0607/sentient/releases"
              className="px-8 py-4 bg-gradient-to-r from-pink-500 to-purple-500 text-white font-semibold rounded-full hover:shadow-lg hover:shadow-pink-500/30 transition-all hover:-translate-y-0.5"
            >
              Download for Mac 🍎
            </a>
            <a
              href="https://github.com/AnasKhan0607/sentient"
              className="px-8 py-4 bg-white/80 backdrop-blur border border-gray-200 font-semibold rounded-full hover:bg-white transition-all"
            >
              View on GitHub ↗
            </a>
          </motion.div>

          <motion.p
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            transition={{ delay: 0.8 }}
            className="text-sm text-gray-400 mt-4"
          >
            Requires macOS 13+ and Apple Silicon (M1/M2/M3/M4)
          </motion.p>
        </div>
      </section>

      {/* Interactive Demo Section */}
      <section className="container mx-auto px-4 py-16">
        <div className="text-center mb-12">
          <h2 className="text-3xl font-bold mb-4">Meet the personalities</h2>
          <p className="text-gray-600">Click one to see how your Mac reacts</p>
        </div>

        <div className="flex flex-col lg:flex-row gap-12 items-center justify-center">
          {/* MacBook Preview */}
          <div className="flex-shrink-0">
            <MacBookMock reaction={currentReaction} />
            <p className="text-center text-sm text-gray-400 mt-4">
              {selectedPersonality !== null
                ? `${personalities[selectedPersonality].name} mode`
                : "Pick a personality!"}
            </p>
          </div>

          {/* Personality Cards */}
          <div className="grid grid-cols-1 sm:grid-cols-2 gap-4 max-w-2xl">
            {personalities.map((personality, index) => (
              <PersonalityCard
                key={personality.name}
                personality={personality}
                isSelected={selectedPersonality === index}
                onClick={() => handlePersonalityClick(index)}
              />
            ))}
          </div>
        </div>
      </section>

      {/* Features Section */}
      <section className="container mx-auto px-4 py-16">
        <div className="max-w-4xl mx-auto">
          <h2 className="text-3xl font-bold text-center mb-12">How it works</h2>

          <div className="grid md:grid-cols-3 gap-8">
            <div className="text-center">
              <div className="text-5xl mb-4">📱</div>
              <h3 className="font-semibold text-lg mb-2">Uses real sensors</h3>
              <p className="text-gray-600 text-sm">
                Reads the hidden accelerometer in Apple Silicon Macs to detect tilts, slaps, and shakes.
              </p>
            </div>

            <div className="text-center">
              <div className="text-5xl mb-4">🔋</div>
              <h3 className="font-semibold text-lg mb-2">Watches your battery</h3>
              <p className="text-gray-600 text-sm">
                Gets hungry when low, satisfied when charged. Your Mac has needs now.
              </p>
            </div>

            <div className="text-center">
              <div className="text-5xl mb-4">👀</div>
              <h3 className="font-semibold text-lg mb-2">Judges your apps</h3>
              <p className="text-gray-600 text-sm">
                Knows when you open Twitter. Will sigh. Loudly. Disappointedly.
              </p>
            </div>
          </div>
        </div>
      </section>

      {/* Privacy Section */}
      <section className="container mx-auto px-4 py-16">
        <div className="max-w-2xl mx-auto text-center bg-white/60 backdrop-blur rounded-3xl p-8 border border-gray-100">
          <div className="text-4xl mb-4">🔒</div>
          <h2 className="text-2xl font-bold mb-4">100% Local. 100% Private.</h2>
          <p className="text-gray-600">
            Sentient runs entirely on your Mac. No data is collected, no analytics, no tracking. 
            Your Mac's feelings stay between you and your Mac.
          </p>
        </div>
      </section>

      {/* CTA Section */}
      <section className="container mx-auto px-4 py-20">
        <div className="text-center">
          <h2 className="text-3xl font-bold mb-4">Ready to awaken your Mac?</h2>
          <p className="text-gray-600 mb-8">Free download. No account required.</p>
          <a
            href="https://github.com/AnasKhan0607/sentient/releases"
            className="inline-block px-10 py-5 bg-gradient-to-r from-pink-500 to-purple-500 text-white font-semibold rounded-full text-lg hover:shadow-xl hover:shadow-pink-500/30 transition-all hover:-translate-y-1"
          >
            Download Sentient 🧠
          </a>
        </div>
      </section>

      {/* Footer */}
      <footer className="container mx-auto px-4 py-8 text-center text-gray-400 text-sm">
        <p>
          Made with 💕 by{" "}
          <a
            href="https://twitter.com/AnasKhan0607"
            className="text-pink-500 hover:underline"
          >
            @AnasKhan0607
          </a>
        </p>
        <p className="mt-2">Your Mac didn't ask for this. But here we are.</p>
      </footer>
    </main>
  );
}
