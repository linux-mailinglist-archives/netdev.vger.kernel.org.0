Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 727B02B047E
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 12:57:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728231AbgKLL4g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 06:56:36 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:36781 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728252AbgKLLvk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 06:51:40 -0500
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20201112115113euoutp018188d7819be26a1b864c389ef67661e4~GwGjYXc813261832618euoutp010
        for <netdev@vger.kernel.org>; Thu, 12 Nov 2020 11:51:13 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20201112115113euoutp018188d7819be26a1b864c389ef67661e4~GwGjYXc813261832618euoutp010
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1605181873;
        bh=Nr1kBMcXOOnVTauNxdoaW0t2tbm/z4Kaq30A0/2CSuA=;
        h=From:To:Cc:Subject:Date:References:From;
        b=V2GcAWEpoxlA1iw8kesKYrSQaZyo37MrCL/0LvOIqkakddDp/XJfztHFCWC5KWqwR
         P64oLFTLEJ/BXef1spYjJwr8tr+dFmMLcjbwJZxZD/jeWBw2B/SNTCEqAPAtEWGS7f
         u3R3BSvm/gBAg8noGzUBq9DEYStgLe50+a3sPwWM=
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20201112115108eucas1p1371c75403afdaec70ea4f3481de719a8~GwGeWGcmC1142211422eucas1p12;
        Thu, 12 Nov 2020 11:51:08 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges3new.samsung.com (EUCPMTA) with SMTP id 24.EF.45488.CA12DAF5; Thu, 12
        Nov 2020 11:51:08 +0000 (GMT)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20201112115107eucas1p1abe7589e6caffc579c22d39395f1efa0~GwGd6ODLg1142611426eucas1p1g;
        Thu, 12 Nov 2020 11:51:07 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20201112115107eusmtrp1ebb1b52f58c9afc2c19323d2c89a6f93~GwGd5Q8En1853418534eusmtrp1H;
        Thu, 12 Nov 2020 11:51:07 +0000 (GMT)
X-AuditID: cbfec7f5-c77ff7000000b1b0-c2-5fad21ac303a
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id DF.A7.16282.BA12DAF5; Thu, 12
        Nov 2020 11:51:07 +0000 (GMT)
Received: from localhost (unknown [106.120.51.46]) by eusmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20201112115107eusmtip22400c01805f616fa3f7272a32760a950~GwGdoaLco1181211812eusmtip2k;
        Thu, 12 Nov 2020 11:51:07 +0000 (GMT)
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
Subject: [PATCH v6 0/5] AX88796C SPI Ethernet Adapter
Date:   Thu, 12 Nov 2020 12:51:01 +0100
Message-Id: <20201112115106.16224-1-l.stelmach@samsung.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Organization: Samsung R&D Institute Poland
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrPKsWRmVeSWpSXmKPExsWy7djPc7prFNfGG3xcx2dx/u4hZouNM9az
        Wsw538JiMf/IOVaLRe9nsFpce3uH1aL/8Wtmi/PnN7BbXNjWx2px89AKRotNj6+xWlzeNYfN
        Ysb5fUwWh6buZbRYe+Quu8WxBWIWrXuPsDsIely+dpHZY8vKm0weO2fdZffYtKqTzWPzknqP
        nTs+M3n0bVnF6PF5k1wARxSXTUpqTmZZapG+XQJXRtfdY0wFO1QrDs66xdTA+Femi5GTQ0LA
        RGLulvlsXYxcHEICKxglWvfNYoVwvjBKHFuxjR3C+cwocffJYSCHA6zlU78RRHw5o8S2lduh
        Op4zSvx+9ooRZC6bgKNE/9ITYAkRgXvMEuvbHzCCOMwC+xgldt6bwgxSJSxgKtG9aBITiM0i
        oCrRuuYhWDevgLXEj1mzWSEulJdoX76dDSIuKHFy5hMWEJtfQEtiTdN1MJsZqKZ562xmkAUS
        Aos5JZ7uXcQCcauLROucYog5whKvjm9hh7BlJE5P7oEqqZeYPMkMorUH6J05P1ggaqwl7pz7
        xQZSwyygKbF+lz5E2FHi0ooXzBCtfBI33gpCXMAnMWnbdKgwr0RHmxBEtYrEuv49UAOlJHpf
        rWCEKPGQ6HjgMYFRcRaSt2YheWUWwtoFjMyrGMVTS4tz01OLjfNSy/WKE3OLS/PS9ZLzczcx
        AtPc6X/Hv+5gXPHqo94hRiYOxkOMEhzMSiK8yg5r4oV4UxIrq1KL8uOLSnNSiw8xSnOwKInz
        7toKlBJITyxJzU5NLUgtgskycXBKNTDNyOpIUrtjvbWVsV/jmPLVev/QEum7fIvUs/acm1d9
        Pezjui3mkXv9ZJkiLWz3/Z7TPJOLa+lSxqJ/joX77rqfPXjn5vPXeyP3MR5+MaFuau27H/ZH
        ZhxYdujjM7sbNg+dBeP17zxzuJPNuvW40QXzd1dWShhMYPaWVeA8Evu/TE3j+MzaTw3LJoUo
        Hdg0T8ew9XO9wtHre9w+Hbn13frkhxStuWHSzbfu5ng6PNp3b2OKnPZ/pdzpd1tiN3p19l2r
        fvXl4rf5ipPi/54Sqb5rwcP/vNX/z17baU+ZVK4WPrpSkW/d2xs5IbrlsPdpyfcHdZjjOKco
        zeT1apny9cOhK6fePuuMmrO1Sa1F/cXxdCWW4oxEQy3mouJEAA3xnN/iAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJIsWRmVeSWpSXmKPExsVy+t/xe7qrFdfGG3S+07Y4f/cQs8XGGetZ
        Leacb2GxmH/kHKvFovczWC2uvb3DatH/+DWzxfnzG9gtLmzrY7W4eWgFo8Wmx9dYLS7vmsNm
        MeP8PiaLQ1P3MlqsPXKX3eLYAjGL1r1H2B0EPS5fu8jssWXlTSaPnbPusntsWtXJ5rF5Sb3H
        zh2fmTz6tqxi9Pi8SS6AI0rPpii/tCRVISO/uMRWKdrQwkjP0NJCz8jEUs/Q2DzWyshUSd/O
        JiU1J7MstUjfLkEvo+vuMaaCHaoVB2fdYmpg/CvTxcjBISFgIvGp36iLkYtDSGApo8Siqy3M
        EHEpiZVz07sYOYFMYYk/17rYIGqeMkrsbNzNCJJgE3CU6F96ghUkISLwhlmi6d5bdhCHWWAf
        o8T+o4vZQaqEBUwluhdNYgKxWQRUJVrXPATr5hWwlvgxazYrxAp5ifbl29kg4oISJ2c+YQG5
        gllAXWL9PCGQML+AlsSapussIDYzUHnz1tnMExgFZiHpmIXQMQtJ1QJG5lWMIqmlxbnpucVG
        esWJucWleel6yfm5mxiBcbrt2M8tOxhXvvqod4iRiYPxEKMEB7OSCK+yw5p4Id6UxMqq1KL8
        +KLSnNTiQ4ymQB9MZJYSTc4HJoq8knhDMwNTQxMzSwNTSzNjJXFekyNATQLpiSWp2ampBalF
        MH1MHJxSDUxZJ8Mm57v/WPNNVPOA+rnPL5KfB6x7Wm2Qd/f3xsVKs3/vXfMmfeoSVt7g7nsK
        jqZ8Su07svYd22EsZ/m7pHC9fWWSZ/tRF/WrHw6tO97Rsqd17adW06xApelBUU/8Fro/CGFL
        zKlubduzj+nNrtTiBS85KmO36n9oZ5lrL8DF4Z3qZftrSeod5fWvdHM6NXLeXLWM1YheZCxz
        Yv18BRNtoyP/TxjG/jWcs/hv8ZvdLB9FbT3b5oXYJJZeOGeXWub2/vPKX40/nqX9uPNKO/hD
        pO/zBY57Vl/QrTm0UappSuoX6Zvd376Yzp8mOHXVFR/BxtNh1stdWLT/m0//PJ3dZKLT5bii
        2c+vHEn2/7RaiaU4I9FQi7moOBEAXVqGQFwDAAA=
X-CMS-MailID: 20201112115107eucas1p1abe7589e6caffc579c22d39395f1efa0
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20201112115107eucas1p1abe7589e6caffc579c22d39395f1efa0
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20201112115107eucas1p1abe7589e6caffc579c22d39395f1efa0
References: <CGME20201112115107eucas1p1abe7589e6caffc579c22d39395f1efa0@eucas1p1.samsung.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a driver for AX88796C Ethernet Adapter connected in SPI mode as
found on ARTIK5 evaluation board. The driver has been ported from a
v3.10.9 vendor kernel for ARTIK5 board.

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
 drivers/net/ethernet/asix/ax88796c_ioctl.c    |  237 ++++
 drivers/net/ethernet/asix/ax88796c_ioctl.h    |   26 +
 drivers/net/ethernet/asix/ax88796c_main.c     | 1132 +++++++++++++++++
 drivers/net/ethernet/asix/ax88796c_main.h     |  561 ++++++++
 drivers/net/ethernet/asix/ax88796c_spi.c      |  109 ++
 drivers/net/ethernet/asix/ax88796c_spi.h      |   70 +
 include/uapi/linux/ethtool.h                  |    1 +
 net/ethtool/common.c                          |    1 +
 18 files changed, 2294 insertions(+)
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

