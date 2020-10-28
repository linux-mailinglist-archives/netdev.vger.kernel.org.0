Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 176CC29E1E3
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 03:04:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387469AbgJ2CES (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 22:04:18 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:60060 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727275AbgJ1Vkx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 17:40:53 -0400
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20201028214029euoutp025b05cd67b4414cc27d74fd7eb940d9f8~CRdw5KLrA2382923829euoutp02h
        for <netdev@vger.kernel.org>; Wed, 28 Oct 2020 21:40:29 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20201028214029euoutp025b05cd67b4414cc27d74fd7eb940d9f8~CRdw5KLrA2382923829euoutp02h
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1603921229;
        bh=wGXPKJVb69pqXKx2ZIgRaFvmKeW6gzHu0+eGvJQYRIQ=;
        h=From:To:Cc:Subject:Date:References:From;
        b=DStvbDMdFn1CC16wNBuUKgxy5ljQrBBdVp9n6GntBNflNxDQhI/FUoTPY3uS9Bqc6
         2TEWQnCx/26p6anb2TPmz79XtC4jrImbCclOGN5SXZ/LzGcnJfrfuSACV7nHvEoo7A
         zxbQ/wmWtJijtauurYUs3LlNhIKE7tK92aWVe2E0=
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20201028214018eucas1p1c7366cff1bed104e95a7926d5941091f~CRdm-pLh_2052320523eucas1p1V;
        Wed, 28 Oct 2020 21:40:18 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges1new.samsung.com (EUCPMTA) with SMTP id F0.8F.06456.245E99F5; Wed, 28
        Oct 2020 21:40:18 +0000 (GMT)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20201028214017eucas1p21a93b489acce80ff8a2fd1adfc9c1649~CRdl0RlxO2075420754eucas1p2h;
        Wed, 28 Oct 2020 21:40:17 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20201028214017eusmtrp20aa630ac5af1f94ca829c4a5eea6a5f4~CRdlzgVSt3218532185eusmtrp2i;
        Wed, 28 Oct 2020 21:40:17 +0000 (GMT)
X-AuditID: cbfec7f2-7efff70000001938-fd-5f99e5425717
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id 5F.8E.06314.F35E99F5; Wed, 28
        Oct 2020 21:40:15 +0000 (GMT)
Received: from localhost (unknown [106.120.51.46]) by eusmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20201028214015eusmtip23525b6aea39a22a94207c9a0fa86248f~CRdkAn-cQ2585225852eusmtip2c;
        Wed, 28 Oct 2020 21:40:15 +0000 (GMT)
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
Subject: [PATCH v4 0/5] AX88796C SPI Ethernet Adapter
Date:   Wed, 28 Oct 2020 22:40:07 +0100
Message-Id: <20201028214012.9712-1-l.stelmach@samsung.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Organization: Samsung R&D Institute Poland
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA02SfUhTYRTGe3fv3W7W9LosDxqTRl8KatIHb5+kFlyhP6IgIrA128UiN2PL
        WkVallnit6bbFAyztJEfrbWapsQyy0qnraxMK1IJFftaSSpZbtfI/55zzu95z3PgpQnJeyqA
        Pqg+wmnUigSZ0Iu0tow5QqMGDPIVDbmh2NFrJ/BNfS2FSx3nSFzW3E7h8i96CneN9FA4p2+Y
        wA5HnQh3WLMp/MZehbC5r4vCzvpSIdY7mgTYfqkR4ermXhFuubwApzU2izb7ss6uToK1XH8j
        YG3GXhFrNl0UsrcqUljbXZeAzbaYEOsyS7fTe7w2KLmEg0c5TfimfV4HJrvT0OFRqa4mtwKd
        RgbIQLNpYFZBd/VnQQbyoiVMFYIrdWkEX/xAMDBYJOILFwLLnfvon8VkMlD8oBJBY8vEtOUT
        gsmLDyg3JWQiIefqYw/lx7wjoDb9A3IXBNOEwPaukHBT85jVUFNZT7o1ySyBlx15Hi1m1oFl
        Ypjg9wVBeuUdId/3hVZDv4fxYULgRuorjyammLO3SzwxgPktgl8PGwS8eQtk3SqbDj4Phh5Z
        RLxeCH9sZVMMPaVToCB/De/NRGAt/UXyzHroaR8XuhmCCYba+nC+HQmDw4+FvNUbXo/48hG8
        Id9aTPBtMVw4L+HpxVCTc2/6wQDIGqqaDsOC8VoBkYsWGWccZpxxjPH/3suIMCF/Lkmriue0
        EWruWJhWodImqePD9ieqzGjq2z2dfPT9Lvr5PM6OGBrJ5oo73hrkEkpxVHtcZUdAEzI/cVTb
        070SsVJx/ASnSZRrkhI4rR0F0qTMX7yyfDBWwsQrjnCHOO4wp/k3FdCzA06jQJ/tAVTPrCHd
        l8gio+hjiTTIuS16zjNrcG6FevmyU/1LY4JpZerHjB2W1ogP9l3yct1a3bnR/uifK+cXJic3
        k05j7Isz6gwb94R7nTKm3P1A2D3YmUSRxTF7t4YgfHLiW976mjzD155x5f2N4216fV1WWn5T
        pmtnnNQiVoeOykjtAUVECKHRKv4CedJ48HIDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGIsWRmVeSWpSXmKPExsVy+t/xe7qOT2fGG1xfJ2dx/u4hZouNM9az
        Wsw538JiMf/IOVaLRe9nsFpce3uH1aL/8Wtmi/PnN7BbXNjWx2px89AKRotNj6+xWlzeNYfN
        Ysb5fUwWh6buZbRYe+Quu8WxBWIWrXuPsDsIely+dpHZY8vKm0weO2fdZffYtKqTzWPzknqP
        nTs+M3n0bVnF6PF5k1wAR5SeTVF+aUmqQkZ+cYmtUrShhZGeoaWFnpGJpZ6hsXmslZGpkr6d
        TUpqTmZZapG+XYJexr9brYwF3+Qq1k1YwtjAOFOii5GTQ0LARGLVqpmsXYxcHEICSxklJmy8
        z9LFyAGUkJJYOTcdokZY4s+1LjYQW0jgKaNE/9pyEJtNwFGif+kJsF4RgTfMEk333rKDOMwC
        +xgl9h9dzA5SJSxgKrFu+S4WEJtFQFXi6oWJYDavgJXElt+vmSE2yEu0L9/OBhEXlDg58wnY
        EcwC6hLr5wmBhPkFtCTWNF0Ha2UGKm/eOpt5AqPALCQdsxA6ZiGpWsDIvIpRJLW0ODc9t9hQ
        rzgxt7g0L10vOT93EyMwTrcd+7l5B+OljcGHGAU4GJV4eC/cnhkvxJpYVlyZe4hRgoNZSYTX
        6ezpOCHelMTKqtSi/Pii0pzU4kOMpkDvTGSWEk3OB6aQvJJ4Q1NDcwtLQ3Njc2MzCyVx3g6B
        gzFCAumJJanZqakFqUUwfUwcnFINjE2TPKslrVliNjNcshXbts3xpH3z/xULjm32s14u61qS
        1TxlxVfOVctFlnWd8BT+9OTZ9i0BTU7bN0Z89vji2LDn3dUJW5f9DVJxqPZh3xX+wGFH0JsP
        h2U+VwScuF3HM5sjiMFp3j2Gjz/Kxfk/9/PvZJmsFnPrYdCf3SGnz/za7V11/9/rO5ZKLMUZ
        iYZazEXFiQBr3XV56QIAAA==
X-CMS-MailID: 20201028214017eucas1p21a93b489acce80ff8a2fd1adfc9c1649
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20201028214017eucas1p21a93b489acce80ff8a2fd1adfc9c1649
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20201028214017eucas1p21a93b489acce80ff8a2fd1adfc9c1649
References: <CGME20201028214017eucas1p21a93b489acce80ff8a2fd1adfc9c1649@eucas1p2.samsung.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a driver for AX88796C Ethernet Adapter connected in SPI mode as
found on ARTIK5 evaluation board. The driver has been ported from a
v3.10.9 vendor kernel for ARTIK5 board.

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

Łukasz Stelmach (5):
  dt-bindings: vendor-prefixes: Add asix prefix
  dt-bindings: net: Add bindings for AX88796C SPI Ethernet Adapter
  net: ax88796c: ASIX AX88796C SPI Ethernet Adapter Driver
  ARM: dts: exynos: Add Ethernet to Artik 5 board
  ARM: defconfig: Enable ax88796c driver

 .../bindings/net/asix,ax88796c.yaml           |   69 +
 .../devicetree/bindings/vendor-prefixes.yaml  |    2 +
 MAINTAINERS                                   |    6 +
 arch/arm/boot/dts/exynos3250-artik5-eval.dts  |   29 +
 arch/arm/configs/exynos_defconfig             |    2 +
 arch/arm/configs/multi_v7_defconfig           |    2 +
 drivers/net/ethernet/Kconfig                  |    1 +
 drivers/net/ethernet/Makefile                 |    1 +
 drivers/net/ethernet/asix/Kconfig             |   22 +
 drivers/net/ethernet/asix/Makefile            |    6 +
 drivers/net/ethernet/asix/ax88796c_ioctl.c    |  197 +++
 drivers/net/ethernet/asix/ax88796c_ioctl.h    |   26 +
 drivers/net/ethernet/asix/ax88796c_main.c     | 1144 +++++++++++++++++
 drivers/net/ethernet/asix/ax88796c_main.h     |  578 +++++++++
 drivers/net/ethernet/asix/ax88796c_spi.c      |  111 ++
 drivers/net/ethernet/asix/ax88796c_spi.h      |   69 +
 16 files changed, 2265 insertions(+)
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
