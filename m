Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9CB0B87CDF
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 16:41:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406753AbfHIOlc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 10:41:32 -0400
Received: from mout.kundenserver.de ([212.227.126.133]:60337 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726157AbfHIOlb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 10:41:31 -0400
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue012 [212.227.15.129]) with ESMTPA (Nemesis) id
 1MkW10-1ibFNJ1O5W-00m6H3; Fri, 09 Aug 2019 16:40:55 +0200
From:   Arnd Bergmann <arnd@arndb.de>
To:     soc@kernel.org
Cc:     Vladimir Zapolskiy <vz@mleia.com>,
        Sylvain Lemieux <slemieux.tyco@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Guenter Roeck <linux@roeck-us.net>, linux-gpio@vger.kernel.org,
        netdev@vger.kernel.org, linux-serial@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-watchdog@vger.kernel.org
Subject: [PATCH v2 00/13] v2: ARM: move lpc32xx to multiplatform
Date:   Fri,  9 Aug 2019 16:40:26 +0200
Message-Id: <20190809144043.476786-1-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:EDVZmvF9arLwN7tfCBk9s4OVXP20FvpzsVOImPPefg+0CLYE69K
 gQAFFbE132roeOF6ToiNpoEiuz6MoXQQoc5ph+0VQSsr2DOk/xyOnFdZ2yMpZ8kHXXDBjmX
 A8C1gOPJ7TLLjUPO1DDoXFvV90K+Q0ox7QSuSMrwxO7Jb3D1G7p8BVK5xTzCRV9mr0GgrzD
 OwFVQkMOVFv8a5Cr1SW2Q==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:DPoVW4gPjGQ=:8tG2AyA6Pk3b3tvngr6K5k
 UMk3gPJV3BUtXv9nOJp7EvdBEwjSP1CtrdEXCNtEjUcawe0Pjf8Oy+Oz54J4+/x4CR/2rvHPa
 gpdlQvCpws7DVMLQkcUgXF5nXU3i3nqr3aQlv9+MQBVPsOeC/4KDgkmDIlZVkpN4ynr4u7ucB
 pu5WfQYm7lX8z2DvSWk7Jn/rSFxWFoWsN9AI3xUZs6pqAkjISwm7g1zj0r3DeZkxcnrFNH1IC
 Egz1Ue13UnEuIbxdnowFCmkpbfHazRhxw48ERNB90saDpeer/Sfiohh/EdYsJRhBmP3r4qGIs
 +hPd1B4v+tUWpAYpMDyNtJRuDSdY172Id6TFWwTfK2VuLkB9ao+/dWU4SVVvT+AlgJOv7mrag
 yxf03FHvK+XpX2qgcpa4cziL54bf9OI7XmWHKooibuT2eSYSJ6U7TKh1q5rLi0sM21XV5X9vo
 NoPD1teaUKJgXdmJzymvD8djLtwU5kyqACDEpfMdtI6Jz+NGrX4mbKeXFeREvcJy2hzyr3cHO
 tqwe/jezzuaak1my9LxlhwtyAkQsThdCtdGwZAEEHIwEfIIVldDpQcLW3O9CM/DuL7mzrW4MG
 QI+sI9RMaYFn11ATDc0BslmVI9Ed0tLk9mabp6wQUA8VioOBGUNQHUwI/Ach2uOPRo8wIWgEw
 4n28RI2aSzpaniC2eJhokOSjmOmfgSaC4kke4SvZJSNAMYdtJBvft9fpIWnThM9b34xRSoZTc
 hGLgRyCeKuJkOaJQNWoTa81HQn+8nkhKCeCXPw==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Version 2 contains some minor changes based on earlier feedback
and from the 0day build bot testing on other architectures. The
only patch that changed significantly is the one for the gpio driver.

I would suggest we merge this version into the soc tree directly
if there are no further concerns.

      Arnd

Arnd Bergmann (12):
  usb: ohci-nxp: enable compile-testing
  usb: udc: lpc32xx: allow compile-testing
  watchdog: pnx4008_wdt: allow compile-testing
  serial: lpc32xx_hs: allow compile-testing
  gpio: lpc32xx: allow building on non-lpc32xx targets
  net: lpc-enet: factor out iram access
  net: lpc-enet: move phy setup into platform code
  net: lpc-enet: fix printk format strings
  net: lpc-enet: allow compile testing
  serial: lpc32xx: allow compile testing
  ARM: lpc32xx: clean up header files
  ARM: lpc32xx: allow multiplatform build

kbuild test robot (1):
  net: lpc-enet: fix badzero.cocci warnings

 arch/arm/Kconfig                              |  17 +--
 arch/arm/configs/lpc32xx_defconfig            |   2 +
 arch/arm/mach-lpc32xx/Kconfig                 |  11 ++
 arch/arm/mach-lpc32xx/common.c                |  24 +++-
 arch/arm/mach-lpc32xx/common.h                |   1 -
 arch/arm/mach-lpc32xx/include/mach/board.h    |  15 ---
 .../mach-lpc32xx/include/mach/entry-macro.S   |  28 -----
 arch/arm/mach-lpc32xx/include/mach/hardware.h |  25 ----
 .../mach-lpc32xx/include/mach/uncompress.h    |  50 --------
 .../{include/mach/platform.h => lpc32xx.h}    |  18 ++-
 arch/arm/mach-lpc32xx/pm.c                    |   3 +-
 arch/arm/mach-lpc32xx/serial.c                |  33 ++++-
 arch/arm/mach-lpc32xx/suspend.S               |   3 +-
 drivers/gpio/Kconfig                          |   7 ++
 drivers/gpio/Makefile                         |   2 +-
 drivers/gpio/gpio-lpc32xx.c                   | 118 ++++++++++--------
 drivers/net/ethernet/nxp/Kconfig              |   2 +-
 drivers/net/ethernet/nxp/lpc_eth.c            |  45 +++----
 drivers/tty/serial/Kconfig                    |   3 +-
 drivers/tty/serial/lpc32xx_hs.c               |  37 +-----
 drivers/usb/gadget/udc/Kconfig                |   3 +-
 drivers/usb/gadget/udc/lpc32xx_udc.c          |   3 +-
 drivers/usb/host/Kconfig                      |   3 +-
 drivers/usb/host/ohci-nxp.c                   |  25 ++--
 drivers/watchdog/Kconfig                      |   2 +-
 drivers/watchdog/pnx4008_wdt.c                |   1 -
 include/linux/soc/nxp/lpc32xx-misc.h          |  33 +++++
 27 files changed, 242 insertions(+), 272 deletions(-)
 create mode 100644 arch/arm/mach-lpc32xx/Kconfig
 delete mode 100644 arch/arm/mach-lpc32xx/include/mach/board.h
 delete mode 100644 arch/arm/mach-lpc32xx/include/mach/entry-macro.S
 delete mode 100644 arch/arm/mach-lpc32xx/include/mach/hardware.h
 delete mode 100644 arch/arm/mach-lpc32xx/include/mach/uncompress.h
 rename arch/arm/mach-lpc32xx/{include/mach/platform.h => lpc32xx.h} (98%)
 create mode 100644 include/linux/soc/nxp/lpc32xx-misc.h

-- 
2.20.0

Cc: soc@kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: Vladimir Zapolskiy <vz@mleia.com>
Cc: Sylvain Lemieux <slemieux.tyco@gmail.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: linux-gpio@vger.kernel.org
Cc: netdev@vger.kernel.org
Cc: linux-serial@vger.kernel.org
Cc: linux-usb@vger.kernel.org
Cc: linux-watchdog@vger.kernel.org

