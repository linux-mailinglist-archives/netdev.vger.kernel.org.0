Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68CA9295479
	for <lists+netdev@lfdr.de>; Wed, 21 Oct 2020 23:50:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2506451AbgJUVuD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Oct 2020 17:50:03 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:57519 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2443049AbgJUVuC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Oct 2020 17:50:02 -0400
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20201021214944euoutp0212afd1c3023f15ec312303f7a9e9d49c~AIE2CGFxZ1593215932euoutp02N
        for <netdev@vger.kernel.org>; Wed, 21 Oct 2020 21:49:44 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20201021214944euoutp0212afd1c3023f15ec312303f7a9e9d49c~AIE2CGFxZ1593215932euoutp02N
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1603316984;
        bh=gwwjrxfgxaNZsPGAiCkyHWUSc8RJJJ8snj/08cO1Z50=;
        h=From:To:Cc:Subject:Date:References:From;
        b=ozp4klCXkl7Gjss4dc07kUvbFALqFiu5fSzC3ap7KgTUxw84rsSexKscCKwbdkE/i
         I8oqMdgDzoqF68cYnacbp1qSVN6hoa0/LooKdBklS/8e1iuf4Z4ROBdRVXjbmx8wLb
         G4sP91JxuqQA/18bnPoPjq7WONz31MQ43+pdLNEc=
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20201021214930eucas1p2b04707283fdede67307472138e90bbea~AIEpPsHsR2056620566eucas1p29;
        Wed, 21 Oct 2020 21:49:30 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges3new.samsung.com (EUCPMTA) with SMTP id DE.8C.06318.AECA09F5; Wed, 21
        Oct 2020 22:49:30 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20201021214930eucas1p1cf406b35bbe4b643db287643e4a5b85b~AIEotzf4G2857528575eucas1p1j;
        Wed, 21 Oct 2020 21:49:30 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20201021214930eusmtrp296fba8512128bc2a40ca96c9d81700b6~AIEotDWwj0512505125eusmtrp2Z;
        Wed, 21 Oct 2020 21:49:30 +0000 (GMT)
X-AuditID: cbfec7f5-371ff700000018ae-c2-5f90aceafb82
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id 34.69.06314.AECA09F5; Wed, 21
        Oct 2020 22:49:30 +0100 (BST)
Received: from localhost (unknown [106.120.51.46]) by eusmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20201021214930eusmtip21f5d911bee91a8bab67933a9fa891fe5~AIEoj7gXE0505105051eusmtip2o;
        Wed, 21 Oct 2020 21:49:30 +0000 (GMT)
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
Subject: [PATCH v3 0/5] AX88796C SPI Ethernet Adapter
Date:   Wed, 21 Oct 2020 23:49:05 +0200
Message-Id: <20201021214910.20001-1-l.stelmach@samsung.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Organization: Samsung R&D Institute Poland
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA02SeUhUURTGu/PmLYlTz1HyYGE5VqDghhkXDCkTekVQFIgYpmM+l3JjxiUl
        UNLUxNSsyGxIMU0Tl1IzFZ10MrUsxxb3NY2sCSsybbeceSP53++e8333OwcOQ0hHSSsmLDKG
        V0TKw2WUibih80evg64y19+5+6Yr1o5rCHw3v4bEKm2qGBd29JK4+FM+iQfmxkicM/OBwFrt
        HRr3NWSTeFhTjnDtzACJXzarKJyvVYuw5korwlUd4zTuLNqAz7V20LvNuJcDzwmu/vawiGsq
        GKe52orzFFdXksQ1Nc6LuOz6CsTN11ofZnxNdgXx4WFxvMLJI8Ak9NZiQnSK9emMwQ4qGakt
        M9FaBtgdkK4bpPUsZcsRfCtzFvgrgpHFvZnIZJnnEfxRz4tXDCMvSkmhUYYg9W+J0T2LIG/I
        W88UuwdySrsNIgt2goCa9CmkfxCsGkHTxGVCrzJn3WC6ONngFrPboGu81RAhYd0h79ckJcRt
        hvSy+5RQN4PH194YNOtZe6g8O2hgYlmTcu86oQ8A9gcNVUtLxlm9oDLtPS2wOei66o28Cf42
        FYoyEbPMSXApb6fgzULQoPpu9LrDWO9PSq8hWDuoaXYSynvgQdkIIVjXwdCcmTDCOshruGos
        SyAjTSqot0J1TovxQyu4oCtHAnNQ1TZH5yKbglWLFaxapuB/bhEiKpAlH6uMCOGVrpF8vKNS
        HqGMjQxxPBEVUYuWT65nqWuhEal/B2oQyyCZqeTzwVx/KSmPUyZEaBAwhMxC4vms57hUEiRP
        SOQVUf6K2HBeqUEbGbHMUuJa/N5PyobIY/hTPB/NK1a6ImatVTJSpLZken3pPPLoULu9xtb3
        zfnSydxQyZbK6UPuFqFv7Ux9qh3WePq4Dets6mbpsKNBD7P7nZ7GZ/m8a/945phbYMCTNr+u
        /bOy0ZgAxoeSebp7Jk68XkhOfBTc7b1vKt6jP7iPiz1w0sU2yWUuxeaT6mKdXyq3/VWzavHa
        w4sZH27MysTKULmLPaFQyv8BPuhlfm4DAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKIsWRmVeSWpSXmKPExsVy+t/xe7qv1kyIN5j1QsDi/N1DzBYbZ6xn
        tZhzvoXFYv6Rc6wWi97PYLW49vYOq0X/49fMFufPb2C3uLCtj9Xi5qEVjBabHl9jtbi8aw6b
        xYzz+5gsDk3dy2ix9shddotjC8QsWvceYXcQ9Lh87SKzx5aVN5k8ds66y+6xaVUnm8fmJfUe
        O3d8ZvLo27KK0ePzJrkAjig9m6L80pJUhYz84hJbpWhDCyM9Q0sLPSMTSz1DY/NYKyNTJX07
        m5TUnMyy1CJ9uwS9jGXfKgua5So6rh9ha2DcJ97FyMkhIWAicevSUlYQW0hgKaPE9XPpXYwc
        QHEpiZVz0yFKhCX+XOti62LkAip5yiixZH8rI0iCTcBRon/pCVaQhIjAG2aJpntv2UEcZoF9
        jBL7jy5mB6kSFjCVeLSoAcxmEVCVOH53LwuIzStgLTHp9302iBXyEu3Lt7NBxAUlTs58wgJy
        BbOAusT6eUIgYX4BLYk1TdfBWpmBypu3zmaewCgwC0nHLISOWUiqFjAyr2IUSS0tzk3PLTbU
        K07MLS7NS9dLzs/dxAiM0m3Hfm7ewXhpY/AhRgEORiUe3g8+E+KFWBPLiitzDzFKcDArifA6
        nT0dJ8SbklhZlVqUH19UmpNafIjRFOidicxSosn5wASSVxJvaGpobmFpaG5sbmxmoSTO2yFw
        MEZIID2xJDU7NbUgtQimj4mDU6qB0XjnZv0p9dcWH2fa6v7q7a3sEu3vmSwvN+fEyDz6/S9l
        3iO70/fmWjBHuqya0fI680NHc72bTrFo+sZpPKFbc5xPv9H+k5dk1d1+5+55br05xhG9pb4m
        1aVS+6XMpy7p3aI0jY9hdnf8zbWr1rT5FJY57XQJDV9kVrdhQyv3PROhoFubz504osRSnJFo
        qMVcVJwIANX6vZPoAgAA
X-CMS-MailID: 20201021214930eucas1p1cf406b35bbe4b643db287643e4a5b85b
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20201021214930eucas1p1cf406b35bbe4b643db287643e4a5b85b
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20201021214930eucas1p1cf406b35bbe4b643db287643e4a5b85b
References: <CGME20201021214930eucas1p1cf406b35bbe4b643db287643e4a5b85b@eucas1p1.samsung.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a driver for AX88796C Ethernet Adapter connected in SPI mode as
found on ARTIK5 evaluation board. The driver has been ported from a
v3.10.9 vendor kernel for ARTIK5 board.

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
 drivers/net/ethernet/asix/ax88796c_ioctl.h    |   27 +
 drivers/net/ethernet/asix/ax88796c_main.c     | 1144 +++++++++++++++++
 drivers/net/ethernet/asix/ax88796c_main.h     |  578 +++++++++
 drivers/net/ethernet/asix/ax88796c_spi.c      |  111 ++
 drivers/net/ethernet/asix/ax88796c_spi.h      |   69 +
 16 files changed, 2266 insertions(+)
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
