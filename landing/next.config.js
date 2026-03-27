/** @type {import('next').NextConfig} */
const nextConfig = {
  output: "export",
  images: {
    unoptimized: true,
  },
  allowedDevOrigins: ["http://100.109.22.94:3002"],
};

module.exports = nextConfig;