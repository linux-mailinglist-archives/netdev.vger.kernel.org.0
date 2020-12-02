Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 011A42CC917
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 22:48:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728499AbgLBVsP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 16:48:15 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:35655 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726309AbgLBVsO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 16:48:14 -0500
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20201202214722euoutp0117159f510b4b74dd46eddb7c72d886eb~NBIw7y9nI1760717607euoutp01L
        for <netdev@vger.kernel.org>; Wed,  2 Dec 2020 21:47:22 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20201202214722euoutp0117159f510b4b74dd46eddb7c72d886eb~NBIw7y9nI1760717607euoutp01L
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1606945642;
        bh=F4WpgkgZS9YZMduRIt/gpbIZzkvDXHrFXvAqW+afTyw=;
        h=From:To:Cc:Subject:Date:References:From;
        b=UCBYgksqlZtZcXS6s0e2LGC7gAjdJBrpCQ+aF3r6kMYaJLNvJi9OoCmQzvrSgvHEZ
         73TQXe5B1JflCPX1fcBPlfsagSDos2/qOdhUc008SWV9QXpimzUkbxFYVkNc8t4D4p
         fkHg+Qn8eoPJZdUFoju4U3YNO+Z2Nocmr7wTeTeQ=
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20201202214712eucas1p17e1efbdfde2a82d87506b52e0e79ace5~NBInUWABK2962729627eucas1p1k;
        Wed,  2 Dec 2020 21:47:12 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges1new.samsung.com (EUCPMTA) with SMTP id 52.8C.27958.F5B08CF5; Wed,  2
        Dec 2020 21:47:11 +0000 (GMT)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20201202214711eucas1p15c135e19e371890891c38dcf50c86eb2~NBImucwxm0134901349eucas1p1a;
        Wed,  2 Dec 2020 21:47:11 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20201202214711eusmtrp28ee9c511dc25fa617ba59e3ca0d5ea33~NBImtmZvP2287322873eusmtrp2O;
        Wed,  2 Dec 2020 21:47:11 +0000 (GMT)
X-AuditID: cbfec7f2-efdff70000006d36-f6-5fc80b5fd6ff
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id 0E.2E.21957.F5B08CF5; Wed,  2
        Dec 2020 21:47:11 +0000 (GMT)
Received: from localhost (unknown [106.120.51.46]) by eusmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20201202214711eusmtip16a730c2e8365759d6c685d5b5c819215~NBImez5bY1804018040eusmtip1f;
        Wed,  2 Dec 2020 21:47:11 +0000 (GMT)
From:   =?UTF-8?q?=C5=81ukasz=20Stelmach?= <l.stelmach@samsung.com>
To:     Andrew Lunn <andrew@lunn.ch>, jim.cromie@gmail.com,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Kukjin Kim <kgene@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Cc:     =?UTF-8?q?Bart=C5=82omiej=20=C5=BBolnierkiewicz?= 
        <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        =?UTF-8?q?=C5=81ukasz=20Stelmach?= <l.stelmach@samsung.com>
Subject: [PATCH v8 0/3] AX88796C SPI Ethernet Adapter
Date:   Wed,  2 Dec 2020 22:47:06 +0100
Message-Id: <20201202214709.16192-1-l.stelmach@samsung.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Organization: Samsung R&D Institute Poland
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrAKsWRmVeSWpSXmKPExsWy7djPc7rx3CfiDe5us7A4f/cQs8XGGetZ
        Leacb2GxmH/kHKvFovczWC2uvb3DatH/+DWzxfnzG9gtLmzrY7W4eWgFo8Wmx9dYLS7vmsNm
        MeP8PiaLQ1P3MlqsPXKX3eLYAjGL1r1H2B0EPS5fu8jssWXlTSaPnbPusntsWtXJ5rF5Sb3H
        zh2fmTz6tqxi9Pi8SS6AI4rLJiU1J7MstUjfLoEr4/Oy22wFP1UrfrS9Ymtg3CLbxcjJISFg
        ItE+ZztzFyMXh5DACkaJX2dPs0E4Xxglzp1Zxg5SJSTwmVFi0psQmI7zW3ewQBQtZ5RYPfkJ
        K4TznFFi96xPYB1sAo4S/UtPgCVEBO4xS6xvf8AI4jAL7GOU2HlvCjNIlbCAqcSklu9gNouA
        qsTZw30sIDavgLVE27O1rBD75CXal29ng4gLSpyc+QSshl9AS2JN03UwmxmopnnrbLAvJAQW
        c0qcm7OSHaLZRaLn+WEWCFtY4tXxLVBxGYn/O+czdTFyANn1EpMnmUH09jBKbJvzA6reWuLO
        uV9sIDXMApoS63fpQ5Q7SixfmQ1h8knceCsIcQGfxKRt05khwrwSHW1CEDNUJNb174GaJyXR
        +2oFI4TtIfH/93b2CYyKs5D8NQvJL7MQ1i5gZF7FKJ5aWpybnlpsmJdarlecmFtcmpeul5yf
        u4kRmOhO/zv+aQfj3Fcf9Q4xMnEwHmKU4GBWEuFl+XckXog3JbGyKrUoP76oNCe1+BCjNAeL
        kjjvqtlr4oUE0hNLUrNTUwtSi2CyTBycUg1M5rM650iv7gh30b9yVGgS46KOpOqZ5/7EHC3/
        1iEz7+ecix+DM93EmhY3flpSfrxwRuv9PTHNMpPOPFC2+tH/yHi78r73ry/HKiwt2ZzNtJtv
        Z7KbleGk8/t+MYYub3ostz6YefZHXWu/PyWLr1jwmwtPeXK7XXrLSgHNuWEB5VH32M0Xiz/+
        LaCx++Pvw3n6HzMntszIfFaxsti65G5zcJcKx5auO7bL/nDb23Aarq6OzYjaoiKtFtz14sLs
        C5Kvp+n9ebzxgcaRj9L/L6UcnOUyy3PhxQmvHH+uujHBXfVY+pzYZQ0fAn91tdnV/58s1bBx
        ik7mM7nJbQp7y2er1/3albh7+slJxW+09aanPlRiKc5INNRiLipOBADcJsC04wMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJIsWRmVeSWpSXmKPExsVy+t/xu7rx3CfiDZ7vELI4f/cQs8XGGetZ
        Leacb2GxmH/kHKvFovczWC2uvb3DatH/+DWzxfnzG9gtLmzrY7W4eWgFo8Wmx9dYLS7vmsNm
        MeP8PiaLQ1P3MlqsPXKX3eLYAjGL1r1H2B0EPS5fu8jssWXlTSaPnbPusntsWtXJ5rF5Sb3H
        zh2fmTz6tqxi9Pi8SS6AI0rPpii/tCRVISO/uMRWKdrQwkjP0NJCz8jEUs/Q2DzWyshUSd/O
        JiU1J7MstUjfLkEv4/Oy22wFP1UrfrS9Ymtg3CLbxcjJISFgInF+6w4WEFtIYCmjxJluty5G
        DqC4lMTKuekQJcISf651sXUxcgGVPGWUmP5hGSNIgk3AUaJ/6QlWkISIwBtmiaZ7b9lBHGaB
        fYwS+48uZgepEhYwlZjU8p0ZxGYRUJU4e7gPbBuvgLVE27O1rBAr5CXal29ng4gLSpyc+YQF
        5ApmAXWJ9fOEQML8AloSa5qug7UyA5U3b53NPIFRYBaSjlkIHbOQVC1gZF7FKJJaWpybnlts
        qFecmFtcmpeul5yfu4kRGKfbjv3cvINx3quPeocYmTgYDzFKcDArifCy/DsSL8SbklhZlVqU
        H19UmpNafIjRFOiDicxSosn5wESRVxJvaGZgamhiZmlgamlmrCTOu3XumnghgfTEktTs1NSC
        1CKYPiYOTqkGJuZllh3m88rf7pDc8uBoVOwT4Wt9ZWyC/2ddq/3CnyKfdipHb9Kn+fu3RX3g
        PxFT+Ghdj0k/d2vaQZeksttsP8VaxFZWX42Ov8FxLni7z9uYDBljk8y1/XMNFM7tldP1Enhk
        1xh1qU8q4QirmjK78/nPGxVUvBvSSq7V6c9as2nB1uZ9qX8MZr1oyGqTWPggzs/5a87D/Vuj
        XvWteFRvGfJZVk8+7BjXL9XX/X2l+Qdvnotb1OC7g6ElNzTL/+23T0blT/e9PlP7h22dWEC2
        6RaGZ+vOGrK29H1/vubwsrWHOMoW5kqFHgp+ZxLwwPHzzGXGd2+4rrKrPZFy8N8kOy/prt6L
        T1y/fZ63bltPqRJLcUaioRZzUXEiAKSeBmxcAwAA
X-CMS-MailID: 20201202214711eucas1p15c135e19e371890891c38dcf50c86eb2
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20201202214711eucas1p15c135e19e371890891c38dcf50c86eb2
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20201202214711eucas1p15c135e19e371890891c38dcf50c86eb2
References: <CGME20201202214711eucas1p15c135e19e371890891c38dcf50c86eb2@eucas1p1.samsung.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a driver for AX88796C Ethernet Adapter connected in SPI mode as
found on ARTIK5 evaluation board. The driver has been ported from a
v3.10.9 vendor kernel for ARTIK5 board.

Changes in v8:
  - fixed the entry in MAINTAINERS
  - removed unnecessary netif_err()
  - changed netif_rx() to netif_rx_ni() for code running in a process
    context
  - added explicit type casting for ~BIT()

Changes in v7:
  - removed duplicate code
  - moved a constant buffer definition away from a header file

Changes in v6:
  - fixed typos in Kconfig
  - checked argument value in ax88796c_set_tunable
  - updated tags in commit messages

Changes in v5:
  - coding style (local variable declarations)
  - added spi0 node in the DT binding example and removed
    interrupt-parent
  - removed comp module parameter
  - added CONFIG_SPI_AX88796C_COMPRESSION option to set the initial
    state of SPI compression
  - introduced new ethtool tunable "spi-compression" to controll SPI
    transfer compression
  - removed unused fields in struct ax88796c_device
  - switched from using buffers allocated on stack for SPI transfers
    to DMA safe ones embedded in struct ax_spi and allocated with
    kmalloc()

Changes in v4:
  - fixed compilation problems in asix,ax88796c.yaml and in
  ax88796c_main.c introduced in v3

Changes in v3:
  - modify vendor-prefixes.yaml in a separate patch
  - fix several problems in the dt binding
    - removed unnecessary descriptions and properties
    - changed the order of entries
    - fixed problems with missing defines in the example
  - change (1 << N) to BIT(N), left a few (0 << N)
  - replace ax88796c_get_link(), ax88796c_get_link_ksettings(),
    ax88796c_set_link_ksettings(), ax88796c_nway_reset(),
    ax88796c_set_mac_address() with appropriate kernel functions.
  - disable PHY auto-polling in MAC and use PHYLIB to track the state
    of PHY and configure MAC
  - propagate return values instead of returning constants in several
    places
  - add WARN_ON() for unlocked mutex
  - remove local work queue and use the system_wq
  - replace phy_connect_direct() with phy_connect() and move
    devm_register_netdev() to the end of ax88796c_probe()
    (Unlike phy_connect_direct() phy_connect() does not crash if the
    network device isn't registered yet.)
  - remove error messages on ENOMEM
  - move free_irq() to the end of ax88796c_close() to avoid race
    condition
  - implement flow-control

Changes in v2:
  - use phylib
  - added DT bindings
  - moved #includes to *.c files
  - used mutex instead of a semaphore for locking
  - renamed some constants
  - added error propagation for several functions
  - used ethtool for dumping registers
  - added control over checksum offloading
  - remove vendor specific PM
  - removed macaddr module parameter and added support for reading a MAC
    address from platform data (e.g. DT)
  - removed dependency on SPI from NET_VENDOR_ASIX
  - added an entry in the MAINTAINERS file
  - simplified logging with appropriate netif_* and netdev_* helpers
  - lots of style fixes

Łukasz Stelmach (3):
  dt-bindings: vendor-prefixes: Add asix prefix
  dt-bindings: net: Add bindings for AX88796C SPI Ethernet Adapter
  net: ax88796c: ASIX AX88796C SPI Ethernet Adapter Driver

 .../bindings/net/asix,ax88796c.yaml           |   73 ++
 .../devicetree/bindings/vendor-prefixes.yaml  |    2 +
 MAINTAINERS                                   |    6 +
 drivers/net/ethernet/Kconfig                  |    1 +
 drivers/net/ethernet/Makefile                 |    1 +
 drivers/net/ethernet/asix/Kconfig             |   35 +
 drivers/net/ethernet/asix/Makefile            |    6 +
 drivers/net/ethernet/asix/ax88796c_ioctl.c    |  221 ++++
 drivers/net/ethernet/asix/ax88796c_ioctl.h    |   26 +
 drivers/net/ethernet/asix/ax88796c_main.c     | 1127 +++++++++++++++++
 drivers/net/ethernet/asix/ax88796c_main.h     |  561 ++++++++
 drivers/net/ethernet/asix/ax88796c_spi.c      |  112 ++
 drivers/net/ethernet/asix/ax88796c_spi.h      |   69 +
 include/uapi/linux/ethtool.h                  |    1 +
 net/ethtool/common.c                          |    1 +
 15 files changed, 2242 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/asix,ax88796c.yaml
 create mode 100644 drivers/net/ethernet/asix/Kconfig
 create mode 100644 drivers/net/ethernet/asix/Makefile
 create mode 100644 drivers/net/ethernet/asix/ax88796c_ioctl.c
 create mode 100644 drivers/net/ethernet/asix/ax88796c_ioctl.h
 create mode 100644 drivers/net/ethernet/asix/ax88796c_main.c
 create mode 100644 drivers/net/ethernet/asix/ax88796c_main.h
 create mode 100644 drivers/net/ethernet/asix/ax88796c_spi.c
 create mode 100644 drivers/net/ethernet/asix/ax88796c_spi.h

-- 
2.26.2

