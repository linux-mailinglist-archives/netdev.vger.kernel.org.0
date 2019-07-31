Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90BDA7CD49
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 21:58:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729286AbfGaT6M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 15:58:12 -0400
Received: from mout.kundenserver.de ([212.227.126.135]:37177 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728336AbfGaT6K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Jul 2019 15:58:10 -0400
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue012 [212.227.15.129]) with ESMTPA (Nemesis) id
 1N5CMP-1iJtxV2cYX-0119Cu; Wed, 31 Jul 2019 21:57:28 +0200
From:   Arnd Bergmann <arnd@arndb.de>
To:     soc@kernel.org, linux-arm-kernel@lists.infradead.org,
        Vladimir Zapolskiy <vz@mleia.com>,
        Sylvain Lemieux <slemieux.tyco@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Linus Walleij <linus.walleij@linaro.org>
Cc:     Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Guenter Roeck <linux@roeck-us.net>, linux-gpio@vger.kernel.org,
        netdev@vger.kernel.org, linux-serial@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-watchdog@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 00/14] ARM: move lpc32xx and dove to multiplatform
Date:   Wed, 31 Jul 2019 21:56:42 +0200
Message-Id: <20190731195713.3150463-1-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:1DhJgllZnoaEPYGs1RPUPXgQ/oF4uTuXo6cjjEDlbbMgcBjoaAv
 /4Gqy5waGt8kWlKhcISqSvbWy0PqMUozbeltyk8i/JLnrBG/MVV5i1YTE1nD7PThG9QNAmS
 9iyG0heOlxZNdw6cfYwcabbQ4ypVIGuPXXQgozREfFxzQ2zdx45uahc4xbAtdP9o5sKxvCC
 QICiay/kY46x1cxToEO+Q==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:mD1LaNfCPok=:FewDXWtPUyzX3X8MXpV7JW
 LaqXUelWhb8EMKM9tjVsXF3uv3rGnLUQLTL3SIhUo5xti4RrQb4v+7ZE9yZYkDT/kQUFglWBF
 lvLzinWKjjV6sSbqWJx4qfC9UWznfZPTYFC0lU7lQvUiwKDJFULnI39CJPnfNf8oV1md80F+/
 hRIBJf7UroozZKWXZBvCj6qhyUyZ/FiHCNNW2NDEdbLHw+RzE7exwMnGT1w0lIBEpoAGv2Dr0
 PBNGV7aQ6xzA0jg4iovZdBo/K95EQQ01IeAqK8r5l+nAyvyv2QvsAJQ14dqS5qi25TZ1HWgbW
 y4QfqDfSHyPqf/ou/tBXJfUqNTtkEHqRHevOyCywjUO6/+vmF0vXcTWkvwaAm4sGIptdKDXWf
 vtBI71SeOlShLuGqMsOjWNfuDgHE1L/lu7MthTfzB10WFgxJcNmRo4s9WeGLQ70M32rGTuxj0
 fSYfbzci3w+xK0+XnbveZhY0YH1dlePkcvm5RcBHfqcDSZeaxvZOEWZuQBdL5qA+OiCoOBHN/
 TXPne5Yf1BBWIvVnrwfM04RWKmQCqibG92YYGeZ5RbfG0SnyxVH9lpvMOdClQg6oaUfXe5PDO
 i0ClE84DAfmzelDecUQRNORb73/EiNmERpGmA3zwXKqxfIyWnfZ2quBv5cM9S7o9G+R4W+KSC
 gcyOjCbSLMmxXz5/jt8neKqYJ0JYW7vreycPeVeKJaw2+fgZVKgvFFPHKu2AnGnd6ZR49ZNAT
 gfRkW3tCbcUDHer3OPC2tLmSu8Ryf7Wm0PaGnw==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I revisited some older patches here, getting two of the remaining
ARM platforms to build with ARCH_MULTIPLATFORM like most others do.

In case of lpc32xx, I created a new set of patches, which seemed
easier than digging out what I did for an older release many
years ago.

For dove, the patches are basically what I had proposed back in
2015 when all other ARMv6/ARMv7 machines became part of a single
kernel build. I don't know what the state is mach-dove support is,
compared to the DT based support in mach-mvebu for the same
hardware. If they are functionally the same, we could also just
remove mach-dove rather than applying my patches.

I also created patches to remove the w90x900 and ks8695 platforms
that seem to have lost their last users a few years ago.
I will post them separately, but plan to apply them in the same
branch for linux-5.4 if there are no objections.

      Arnd

Arnd Bergmann (14):
  usb: ohci-nxp: enable compile-testing
  usb: udc: lpc32xx: allow compile-testing
  watchdog: pnx4008_wdt: allow compile-testing
  serial: lpc32xx_hs: allow compile-testing
  gpio: lpc32xx: allow building on non-lpc32xx targets
  net: lpc-enet: factor out iram access
  net: lpc-enet: move phy setup into platform code
  net: lpc-enet: allow compile testing
  serial: lpc32xx: allow compile testing
  ARM: lpc32xx: clean up header files
  ARM: lpc32xx: allow multiplatform build
  ARM: dove: clean up mach/*.h headers
  ARM: orion/mvebu: unify debug-ll virtual addresses
  ARM: dove: multiplatform support

 arch/arm/Kconfig                              | 33 +---------
 arch/arm/Kconfig.debug                        |  5 +-
 arch/arm/configs/dove_defconfig               |  2 +
 arch/arm/configs/lpc32xx_defconfig            |  1 +
 arch/arm/mach-dove/Kconfig                    | 16 +++--
 arch/arm/mach-dove/Makefile                   |  2 +
 .../{include/mach => }/bridge-regs.h          |  4 +-
 arch/arm/mach-dove/cm-a510.c                  |  3 +-
 arch/arm/mach-dove/common.c                   |  4 +-
 arch/arm/mach-dove/dove-db-setup.c            |  2 +-
 arch/arm/mach-dove/{include/mach => }/dove.h  | 14 ++---
 arch/arm/mach-dove/include/mach/hardware.h    | 19 ------
 arch/arm/mach-dove/include/mach/uncompress.h  | 36 -----------
 arch/arm/mach-dove/irq.c                      |  5 +-
 arch/arm/mach-dove/{include/mach => }/irqs.h  |  2 -
 arch/arm/mach-dove/mpp.c                      |  2 +-
 arch/arm/mach-dove/pcie.c                     |  4 +-
 arch/arm/mach-dove/{include/mach => }/pm.h    |  4 +-
 arch/arm/mach-lpc32xx/Kconfig                 | 11 ++++
 arch/arm/mach-lpc32xx/common.c                | 24 +++++--
 arch/arm/mach-lpc32xx/common.h                |  1 -
 arch/arm/mach-lpc32xx/include/mach/board.h    | 15 -----
 .../mach-lpc32xx/include/mach/entry-macro.S   | 28 ---------
 arch/arm/mach-lpc32xx/include/mach/hardware.h | 25 --------
 .../mach-lpc32xx/include/mach/uncompress.h    | 50 ---------------
 .../{include/mach/platform.h => lpc32xx.h}    | 18 +++++-
 arch/arm/mach-lpc32xx/pm.c                    |  3 +-
 arch/arm/mach-lpc32xx/serial.c                | 33 +++++++++-
 arch/arm/mach-lpc32xx/suspend.S               |  3 +-
 arch/arm/mach-mv78xx0/mv78xx0.h               |  4 +-
 arch/arm/mach-orion5x/orion5x.h               |  4 +-
 drivers/gpio/Kconfig                          |  8 +++
 drivers/gpio/Makefile                         |  2 +-
 drivers/gpio/gpio-lpc32xx.c                   | 63 ++++++++++++-------
 drivers/net/ethernet/nxp/Kconfig              |  2 +-
 drivers/net/ethernet/nxp/lpc_eth.c            | 30 +++------
 drivers/tty/serial/Kconfig                    |  3 +-
 drivers/tty/serial/lpc32xx_hs.c               | 37 ++---------
 drivers/usb/gadget/udc/Kconfig                |  3 +-
 drivers/usb/gadget/udc/lpc32xx_udc.c          |  2 -
 drivers/usb/host/Kconfig                      |  3 +-
 drivers/usb/host/ohci-nxp.c                   | 25 +++++---
 drivers/watchdog/Kconfig                      |  2 +-
 drivers/watchdog/pnx4008_wdt.c                |  1 -
 include/linux/soc/nxp/lpc32xx-misc.h          | 33 ++++++++++
 45 files changed, 246 insertions(+), 345 deletions(-)
 rename arch/arm/mach-dove/{include/mach => }/bridge-regs.h (96%)
 rename arch/arm/mach-dove/{include/mach => }/dove.h (95%)
 delete mode 100644 arch/arm/mach-dove/include/mach/hardware.h
 delete mode 100644 arch/arm/mach-dove/include/mach/uncompress.h
 rename arch/arm/mach-dove/{include/mach => }/irqs.h (98%)
 rename arch/arm/mach-dove/{include/mach => }/pm.h (97%)
 create mode 100644 arch/arm/mach-lpc32xx/Kconfig
 delete mode 100644 arch/arm/mach-lpc32xx/include/mach/board.h
 delete mode 100644 arch/arm/mach-lpc32xx/include/mach/entry-macro.S
 delete mode 100644 arch/arm/mach-lpc32xx/include/mach/hardware.h
 delete mode 100644 arch/arm/mach-lpc32xx/include/mach/uncompress.h
 rename arch/arm/mach-lpc32xx/{include/mach/platform.h => lpc32xx.h} (98%)
 create mode 100644 include/linux/soc/nxp/lpc32xx-misc.h

-- 
2.20.0

