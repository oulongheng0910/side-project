
import Image from "next/image";

export default function Home() {
  return (
    <div className="min-h-screen bg-gradient-to-b from-blue-50 to-white dark:from-gray-900 dark:to-gray-800 font-[family-name:var(--font-geist-sans)]">
      {/* Navigation Bar */}
      <nav className="bg-blue-600 dark:bg-gray-800 sticky top-0 z-50 shadow-lg">
        <div className="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex justify-between h-16 items-center">
            <div className="flex-shrink-0">
              <span className="text-white text-xl font-bold">Oulong</span>
            </div>
            <div className="flex space-x-4">
              <a
                href="#about"
                className="text-white hover:bg-blue-700 dark:hover:bg-gray-700 px-3 py-2 rounded-md text-sm font-medium transition-colors"
              >
                About
              </a>
              <a
                href="#education"
                className="text-white hover:bg-blue-700 dark:hover:bg-gray-700 px-3 py-2 rounded-md text-sm font-medium transition-colors"
              >
                Education
              </a>
              <a
                href="#skills"
                className="text-white hover:bg-blue-700 dark:hover:bg-gray-700 px-3 py-2 rounded-md text-sm font-medium transition-colors"
              >
                Skills
              </a>
              <a
                href="#contact"
                className="text-white hover:bg-blue-700 dark:hover:bg-gray-700 px-3 py-2 rounded-md text-sm font-medium transition-colors"
              >
                Contact
              </a>
            </div>
          </div>
        </div>
      </nav>

      {/* Main Content */}
      <main className="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 py-12">
        {/* Header Section */}
        <section className="text-center mb-12">
          <h1 className="text-4xl sm:text-5xl font-bold text-blue-900 dark:text-white mb-4">
            Oulong
          </h1>
          <p className="text-lg sm:text-xl text-blue-700 dark:text-blue-200">
            Aspiring Web Developer | Year 3 Student at ITC
          </p>
        </section>

        {/* About Me Section */}
        <section id="about" className="mb-12">
          <h2 className="text-2xl sm:text-3xl font-bold text-blue-900 dark:text-white mb-4">
            About Me
          </h2>
          <p className="text-gray-700 dark:text-gray-300">
            Hello! I'm Oulong, a third-year student at the Institute of Technology of Cambodia (ITC), pursuing a career in web development. I'm passionate about creating user-friendly websites and learning new technologies to enhance my skills.
          </p>
        </section>

        {/* Education Section */}
        <section id="education" className="mb-12">
          <h2 className="text-2xl sm:text-3xl font-bold text-blue-900 dark:text-white mb-4">
            Education
          </h2>
          <ul className="list-disc list-inside text-gray-700 dark:text-gray-300">
            <li>Year 3 Student at Institute of Technology of Cambodia (ITC)</li>
            <li>Currently pursuing Web Development</li>
            <li>Expected graduation: 2026</li>
          </ul>
        </section>

        {/* Skills Section */}
        <section id="skills" className="mb-12">
          <h2 className="text-2xl sm:text-3xl font-bold text-blue-900 dark:text-white mb-4">
            Skills
          </h2>
          <ul className="list-disc list-inside text-gray-700 dark:text-gray-300">
            <li>HTML & CSS</li>
            <li>Basic JavaScript</li>
            <li>Web Design Principles</li>
            <li>Responsive Design</li>
          </ul>
        </section>

        {/* Contact Section */}
        <section id="contact" className="mb-12">
          <h2 className="text-2xl sm:text-3xl font-bold text-blue-900 dark:text-white mb-4">
            Contact Me
          </h2>
          <form className="flex flex-col gap-4">
            <input
              type="text"
              placeholder="Your Name"
              required
              className="p-2 border border-gray-300 dark:border-gray-600 rounded-lg dark:bg-gray-800 dark:text-white"
            />
            <input
              type="email"
              placeholder="Your Email"
              required
              className="p-2 border border-gray-300 dark:border-gray-600 rounded-lg dark:bg-gray-800 dark:text-white"
            />
            <textarea
              placeholder="Your Message"
              rows="5"
              required
              className="p-2 border border-gray-300 dark:border-gray-600 rounded-lg dark:bg-gray-800 dark:text-white"
            />
            <button
              type="submit"
              className="bg-blue-600 text-white py-2 px-4 rounded-lg hover:bg-blue-700 transition-colors"
            >
              Send Message
            </button>
          </form>
          <div className="mt-4 text-gray-700 dark:text-gray-300">
            <p>Email: oulongheng@gmail.com</p>
            <p>Phone: 0967761851</p>
            <p>LinkedIn: linkedin.com/in/oulong</p>
          </div>
        </section>
      </main>

      {/* Footer */}
      <footer className="bg-blue-600 dark:bg-gray-800 text-white py-6">
        <div className="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 flex justify-center gap-6">
          <a
            href="https://github.com/oulongheng0910/HTML"
            target="_blank"
            rel="noopener noreferrer"
            className="hover:text-blue-200 transition-colors"
          >
            GitHub
          </a>
          <a
            href="https://linkedin.com/in/yourusername"
            target="_blank"
            rel="noopener noreferrer"
            className="hover:text-blue-200 transition-colors"
          >
            LinkedIn
          </a>
          <a
            href="https://twitter.com/yourusername"
            target="_blank"
            rel="noopener noreferrer"
            className="hover:text-blue-200 transition-colors"
          >
            Twitter
          </a>
        </div>
      </footer>
    </div>
  );
}