document.addEventListener('DOMContentLoaded', function() {
    const sections = [
        'whitepaper/sections/01-introduction',
        'whitepaper/sections/02-protocol-overview',
        'whitepaper/sections/03-token-economic-model',
        'whitepaper/sections/04-autonomous-agent-framework',
        'whitepaper/sections/05-utility-and-use-cases',
        'whitepaper/sections/06-governance-and-dao-layers',
        'whitepaper/sections/07-technical-architecture',
        'whitepaper/sections/08-roadmap-and-milestones',
        'whitepaper/sections/09-risk-and-mitigation',
        'whitepaper/sections/10-conclusion',
        'whitepaper/sections/appendices'
    ];

    // Get current path and clean it
    let currentPath = window.location.pathname;
    currentPath = currentPath.replace(/^\/|\/$/g, '');
    if (currentPath.includes('iamai')) {
        currentPath = currentPath.split('iamai/')[1];
    }

    const currentIndex = sections.indexOf(currentPath);

    if (currentIndex !== -1) {
        const nav = document.createElement('div');
        nav.className = 'section-nav';
        
        // Previous button
        if (currentIndex > 0) {
            const prev = document.createElement('a');
            prev.href = '/' + sections[currentIndex - 1];
            prev.className = 'nav-prev';
            prev.textContent = `← ${formatSectionName(sections[currentIndex - 1])}`;
            nav.appendChild(prev);
        }

        // Next button
        if (currentIndex < sections.length - 1) {
            const next = document.createElement('a');
            next.href = '/' + sections[currentIndex + 1];
            next.className = 'nav-next';
            next.textContent = `${formatSectionName(sections[currentIndex + 1])} →`;
            nav.appendChild(next);
        }

        const content = document.querySelector('.md-content__inner');
        if (content) {
            content.appendChild(nav);
        }
    }
});

// Define a function to format section names from paths
function formatSectionName(path) {
    const parts = path.split('/');
    let name = parts[parts.length - 1].replace(/\d+-/, '').replace(/-/g, ' ');
    name = name.charAt(0).toUpperCase() + name.slice(1);
    return name.replace(/\bdao\b/gi, 'DAO');
} 