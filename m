Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98FFB2A4939
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 16:17:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728523AbgKCPRc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 10:17:32 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:55164 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728392AbgKCPQF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 10:16:05 -0500
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20201103151547euoutp0145e6eaf8815cd86170c55ab21ffc803c~ECFlxD3-m2116921169euoutp01N
        for <netdev@vger.kernel.org>; Tue,  3 Nov 2020 15:15:47 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20201103151547euoutp0145e6eaf8815cd86170c55ab21ffc803c~ECFlxD3-m2116921169euoutp01N
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1604416547;
        bh=ZTba4AdOdPYDi8vp/FOZDz4jSiA/NsyY2ZVYuq+hr7Y=;
        h=From:To:Cc:Subject:Date:References:From;
        b=aiOk7NtNBnEk40ebb1TWKP0kqam6ump9r0oT/dTDEDLZZd7ukP8EioR0EqRkeLSKU
         nEeJTjfxj3OFgzhUgxwZqHpZHtjYBV+C2sk7V/0cZ9rw1WSZqN6WpIGlmg83Jjp5de
         3zR2cC/u7fqAmqPW7DTjbVeD2RW2pfZLKtkjMmeQ=
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20201103151539eucas1p2a2bbb79dc79d75f19dae42bd2ec83e62~ECFeHxH2l2454424544eucas1p2F;
        Tue,  3 Nov 2020 15:15:39 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges1new.samsung.com (EUCPMTA) with SMTP id 7A.BB.06456.B1471AF5; Tue,  3
        Nov 2020 15:15:39 +0000 (GMT)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20201103151538eucas1p2682c895caedc83638c9a99e7f307e42b~ECFdth0NI3058530585eucas1p2x;
        Tue,  3 Nov 2020 15:15:38 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20201103151538eusmtrp2c9ae7f00da49232c784f957f88b735e8~ECFdssTMG0549405494eusmtrp2e;
        Tue,  3 Nov 2020 15:15:38 +0000 (GMT)
X-AuditID: cbfec7f2-7efff70000001938-3b-5fa1741b3422
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id 0E.8D.06017.A1471AF5; Tue,  3
        Nov 2020 15:15:38 +0000 (GMT)
Received: from localhost (unknown [106.120.51.46]) by eusmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20201103151538eusmtip11380aae5dc705f13cbd7f4fea160e325~ECFdiKCUV0103701037eusmtip1O;
        Tue,  3 Nov 2020 15:15:38 +0000 (GMT)
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
Subject: [PATCH v5 0/5] AX88796C SPI Ethernet Adapter
Date:   Tue,  3 Nov 2020 16:15:31 +0100
Message-Id: <20201103151536.26472-1-l.stelmach@samsung.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Organization: Samsung R&D Institute Poland
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA01SWUwTURTldWY6Q7U4jI3eAEJsahSi4s6LKCDRZD4w0fhhggsWmODCZgso
        +sGmrRKhFlkrUdwC1gWoWAEBY4O4oFQFUVTcUIkIMYoYxLhQpkT+zj33nHfOTR5DcK8pD2ZH
        fJKgiVfHKqUy0trys22eZ9KpiAX6x67Y3m0jcHVxJYVL7QdIfLK5jcKnvxRTuHPgJYUNPZ8J
        bLdX0fihNZfCXbYKhC09nRRury+V4mJ7kwTbChoRvtTcTeOWsmn4YGMzHeLOt3c+Ivia810S
        vs7UTfMW82Epf+VsGl9XOyjhc2vMiB+0eK9jwmUrooXYHSmCxj9om2x7QWsLnVit2ntDN0Km
        o0KvbOTKALsEWnqvSrKRjOHYCgRVb384h+8IdCcyaHEYRPDk11c0bhka0kvFRTmC9udfnJZe
        BFn3+0mHSsquAsO5O5RjoWBfEVCpf4McA8E2Iah7lU84VFPZpdBrbKIdmGRnwXWTcYyXs4Hw
        4mYJKeb5gL78mlTk3eFuyfsxfgrrBxczn45hYlSTdfU44QgA9icNw+YMp3k1GNPtzuJToe92
        DS1iL/hbd3K0NzOK0+BY3jLRewSBtXTY6Q2El20jUoeGYH2hst5fpFfBBVMOKVrd4NmAu1jB
        DfKsRYRIy+GQjhPVKrhsaHA+6AE5fRXOMjzYDbXUUTTTNOEw04RjTP9zyxBhRtOFZG1cjKBd
        GC/sma9Vx2mT42PmRyXEWdDot2v9c/tbLRp6HGlDLIOUk+UhQlkER6lTtKlxNgQMoVTIQx+0
        buXk0erUfYImIUKTHCtobciTIZXT5YtPf9rCsTHqJGGXICQKmvGthHH1SEem+tCNHQkf+70j
        j6bOCtt8pYNzPVB/IzMqXGEMbthdVR00V+G2PGBN/7tIlzB9+gfT2g3yb/nVbO33UzN6nw3c
        8u8pMM/Wd27UuQQMsJbfVqMQNnJuk4HNl6n87uWXqIJ9zkzS6LiuXYtUf2w7AwvDpykqnxft
        n7OeW4kHd/pKPJWkdrt6oR+h0ar/AXdxEWtyAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGIsWRmVeSWpSXmKPExsVy+t/xu7pSJQvjDdZ917c4f/cQs8XGGetZ
        Leacb2GxmH/kHKvFovczWC2uvb3DatH/+DWzxfnzG9gtLmzrY7W4eWgFo8Wmx9dYLS7vmsNm
        MeP8PiaLQ1P3MlqsPXKX3eLYAjGL1r1H2B0EPS5fu8jssWXlTSaPnbPusntsWtXJ5rF5Sb3H
        zh2fmTz6tqxi9Pi8SS6AI0rPpii/tCRVISO/uMRWKdrQwkjP0NJCz8jEUs/Q2DzWyshUSd/O
        JiU1J7MstUjfLkEvY+rpY+wFG1Uq9rf9YmlgnCbTxcjJISFgIvH1aztbFyMXh5DAUkaJ45vW
        ADkcQAkpiZVz0yFqhCX+XOtiA7GFBJ4ySlxsMwSx2QQcJfqXnmAF6RUReMMs0XTvLTuIwyyw
        j1Fi/9HF7CBVwgKmEs8n7gOzWQRUJXbPmsgMYvMKWEvcPjiTBWKDvET78u1sEHFBiZMzn7CA
        HMEsoC6xfp4QSJhfQEtiTdN1sHJmoPLmrbOZJzAKzELSMQuhYxaSqgWMzKsYRVJLi3PTc4uN
        9IoTc4tL89L1kvNzNzEC43TbsZ9bdjB2vQs+xCjAwajEw+uQuiBeiDWxrLgy9xCjBAezkgiv
        09nTcUK8KYmVValF+fFFpTmpxYcYTYHemcgsJZqcD0wheSXxhqaG5haWhubG5sZmFkrivB0C
        B2OEBNITS1KzU1MLUotg+pg4OKUaGNfpKD/+ciq187bsevFJ4tlrL2XvdzgZeJb1tbPRuVVP
        r7xa2NzHv3nhzQL/8g0bLi1r4gzZsK7t46/f1nnb47v6jaWluFgM2BtNhb92RGYdW7BB7Vtd
        +RHFylf+D/XO1s3b0Obyt2zr1ZLSVWkJa3mNTWd84uu6W32yJWtjZ/96i4OTZX20ApVYijMS
        DbWYi4oTAVJOnwHpAgAA
X-CMS-MailID: 20201103151538eucas1p2682c895caedc83638c9a99e7f307e42b
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20201103151538eucas1p2682c895caedc83638c9a99e7f307e42b
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20201103151538eucas1p2682c895caedc83638c9a99e7f307e42b
References: <CGME20201103151538eucas1p2682c895caedc83638c9a99e7f307e42b@eucas1p2.samsung.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a driver for AX88796C Ethernet Adapter connected in SPI mode as
found on ARTIK5 evaluation board. The driver has been ported from a
v3.10.9 vendor kernel for ARTIK5 board.

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

Łukasz Stelmach (5):
  dt-bindings: vendor-prefixes: Add asix prefix
  dt-bindings: net: Add bindings for AX88796C SPI Ethernet Adapter
  net: ax88796c: ASIX AX88796C SPI Ethernet Adapter Driver
  ARM: dts: exynos: Add Ethernet to Artik 5 board
  ARM: defconfig: Enable ax88796c driver

 .../bindings/net/asix,ax88796c.yaml           |   73 ++
 .../devicetree/bindings/vendor-prefixes.yaml  |    2 +
 MAINTAINERS                                   |    6 +
 arch/arm/boot/dts/exynos3250-artik5-eval.dts  |   29 +
 arch/arm/configs/exynos_defconfig             |    2 +
 arch/arm/configs/multi_v7_defconfig           |    2 +
 drivers/net/ethernet/Kconfig                  |    1 +
 drivers/net/ethernet/Makefile                 |    1 +
 drivers/net/ethernet/asix/Kconfig             |   35 +
 drivers/net/ethernet/asix/Makefile            |    6 +
 drivers/net/ethernet/asix/ax88796c_ioctl.c    |  235 ++++
 drivers/net/ethernet/asix/ax88796c_ioctl.h    |   26 +
 drivers/net/ethernet/asix/ax88796c_main.c     | 1132 +++++++++++++++++
 drivers/net/ethernet/asix/ax88796c_main.h     |  561 ++++++++
 drivers/net/ethernet/asix/ax88796c_spi.c      |  109 ++
 drivers/net/ethernet/asix/ax88796c_spi.h      |   70 +
 include/uapi/linux/ethtool.h                  |    1 +
 net/ethtool/common.c                          |    1 +
 18 files changed, 2292 insertions(+)
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

