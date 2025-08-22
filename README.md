# Droidian Kali Phosh Image Builder

A comprehensive build system for creating Kali Linux mobile images based on Droidian with Phosh desktop environment and NetHunter Pro theming.

## Features

- **Full Kali Linux integration** with top penetration testing tools
- **Phosh mobile interface** optimized for touch devices
- **NetHunter Pro theming** with custom GTK themes, icons, and wallpapers
- **Droidian base** for Android device compatibility
- **Modern GPG key handling** to avoid deprecated apt-key warnings

## Prerequisites

- Debian/Ubuntu host system
- debos installed (`sudo apt install debos`)
- Internet connection for package downloads
- At least 10GB free disk space

## Installation

### Install debos
```bash
sudo apt update
sudo apt install debos
```

### Clone and Build
```bash
git clone <your-repo-url>
cd droidian-kali-phosh
sudo debos droidian-kali-phosh.yaml
```

## Build Options

You can customize the build with the following variables:

```bash
# Custom architecture (default: arm64)
sudo debos -t architecture:armhf droidian-kali-phosh.yaml

# Custom suite (default: bookworm)
sudo debos -t suite:bullseye droidian-kali-phosh.yaml

# Custom image name (default: droidian-kali-phosh.img)
sudo debos -t image:my-custom-image.img droidian-kali-phosh.yaml
```

## Project Structure

```
├── droidian-kali-phosh.yaml    # Main debos recipe
├── scripts/                    # Configuration scripts
│   ├── setup-system.sh        # Base system setup
│   ├── setup-kali.sh          # Kali Linux configuration
│   ├── setup-phosh.sh         # Mobile interface setup
│   └── setup-theming.sh       # NetHunter theming
├── overlays/                   # File overlays
│   └── usr/share/
│       ├── kali/              # Kali documentation
│       ├── themes/NetHunter-Pro/    # GTK themes
│       ├── icons/NetHunter-Pro/     # Icon themes
│       └── pixmaps/backgrounds/     # Wallpapers
└── README.md                   # This file
```

## Included Tools

### Kali Linux Tools
- Metasploit Framework
- Nmap
- Aircrack-ng
- Wireshark
- Burp Suite
- SQLMap
- John the Ripper
- Hashcat
- Hydra
- And many more...

### Mobile Applications
- Phosh (Mobile Shell)
- GNOME Calls
- Chatty (SMS/messaging)
- GNOME Contacts
- Firefox ESR
- Mobile Settings

## Default Credentials

- **Root user**: `root` / `toor`
- **Regular user**: `kali` / `kali`

## Troubleshooting

### GPG Key Issues
The build system now uses modern GPG key handling with `signed-by` attributes instead of deprecated `apt-key`. If you encounter GPG-related errors:

1. Ensure you have internet connectivity
2. Check that the GPG keyring directories exist
3. Verify the repository URLs are accessible

### Missing Dependencies
If you encounter missing package errors:

1. Update your host system: `sudo apt update && sudo apt upgrade`
2. Install additional build dependencies: `sudo apt install debootstrap qemu-user-static`

### Build Failures
For general build failures:

1. Run with verbose output: `sudo debos -v droidian-kali-phosh.yaml`
2. Check the logs for specific error messages
3. Ensure you have sufficient disk space (10GB minimum)

## Customization

### Adding NetHunter Themes
1. Place your NetHunter Pro GTK theme in `overlays/usr/share/themes/NetHunter-Pro/`
2. Place your NetHunter Pro icons in `overlays/usr/share/icons/NetHunter-Pro/`
3. Place wallpapers in `overlays/usr/share/pixmaps/backgrounds/nethunter/`

### Adding Custom Packages
Edit the package lists in `droidian-kali-phosh.yaml` under the respective `action: apt` sections.

### Modifying Configuration
Edit the scripts in the `scripts/` directory to customize system behavior.

## License

This project is open source. Individual components may have their own licenses.

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test the build
5. Submit a pull request

## Support

For issues specific to:
- **Droidian**: Visit [Droidian community](https://droidian.org)
- **Kali Linux**: Visit [Kali forums](https://forums.kali.org)
- **This build system**: Create an issue in this repository


### Build Issues
- Ensure sufficient disk space (16GB+)
- Run with sudo privileges
- Check internet connectivity for package downloads

### GPG Key Errors
- The fixed version handles GPG keys properly
- Keys are downloaded directly and added to trusted keyring
- No more "insecure memory" or "invalid OpenPGP data" warnings

### Theme Assets Missing
- Obtain official NetHunter Pro theme assets
- Place in correct overlay directories as documented
- Alternatively, create custom assets following NetHunter styling

### Device Compatibility
- Ensure device supports generic system images (GSI)
- Some devices may require specific adaptations
- Check Droidian device compatibility list

## Architecture Support

- **arm64** (default): Modern 64-bit ARM devices
- **armhf**: 32-bit ARM devices  
- Architecture specified via `-t architecture:ARCH` parameter

## Customization

### Adding Tools
Edit the Kali tools installation section in `droidian-kali-phosh.yaml`

### Theme Modifications
Update theme files in the `overlays/` directory structure

### Mobile Settings
Modify configuration scripts in `scripts/configure-mobile.sh`

### User Accounts
Adjust user creation section in the recipe file## Contributing

When contributing to this project:

1. Test builds on clean systems
2. Verify mobile interface functionality
3. Ensure NetHunter theming consistency
4. Document any new features or tools
5. Follow mobile-first design principles

## License

This project combines components from multiple sources:
- Droidian project (Apache 2.0)
- Kali Linux tools (various licenses)
- Custom scripts and configurations (MIT)

Refer to individual component licenses for specific terms.

## Support

For issues related to:
- **Droidian**: Check Droidian community forums
- **Kali Tools**: Refer to Kali Linux documentation
- **Device Compatibility**: Consult device-specific communities
- **NetHunter Theming**: Official NetHunter documentation

## Acknowledgments

- Droidian project for Android device Linux support
- Kali Linux team for security tools
- Offensive Security for NetHunter platform
- Phosh developers for mobile GNOME environment
- Community contributors and testers

---

**Note**: This is an unofficial build combining open-source components. For official NetHunter support, use official Offensive Security releases.