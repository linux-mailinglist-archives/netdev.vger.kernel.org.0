Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3ED6281BAE
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 21:22:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388406AbgJBTWV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 15:22:21 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:41116 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388452AbgJBTWT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Oct 2020 15:22:19 -0400
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20201002192216euoutp0192dc3b357e36c7355636e0bbace7bb57~6QzqgaGDu0903409034euoutp01B
        for <netdev@vger.kernel.org>; Fri,  2 Oct 2020 19:22:16 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20201002192216euoutp0192dc3b357e36c7355636e0bbace7bb57~6QzqgaGDu0903409034euoutp01B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1601666536;
        bh=IYHHMSIuIvAG3ZQLIyXdOdDpcQO7KMCrzj+TUh356q0=;
        h=From:To:Cc:Subject:Date:References:From;
        b=UG/0OwRRU7fTfplMBIcRqAgAtoV9/IRc7/u3Ic0d4f/yI8p/S4CZiAdnv2bBXoXpK
         uffWeGwj9EnsO8YNXW5Mr+Oc2NeGOFDfwdbb/b1sfXzalzrURJ/Qo/dPoB6UX7gm0T
         fosylOl9CJ+WiQQgwm4Fxk6FEO9P+vms6idFIy9Y=
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20201002192216eucas1p19865d73cc833792ed46ad5009a5c8fc9~6QzqBjom11168111681eucas1p1J;
        Fri,  2 Oct 2020 19:22:16 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges2new.samsung.com (EUCPMTA) with SMTP id B9.94.05997.7ED777F5; Fri,  2
        Oct 2020 20:22:16 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20201002192215eucas1p2c8f4a4bf8e411ed8ba75383fd58e85ac~6QzpibSem1780917809eucas1p2c;
        Fri,  2 Oct 2020 19:22:15 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20201002192215eusmtrp2ba9424a133c51180ddb26148a6daef25~6QzphqwKJ3070930709eusmtrp25;
        Fri,  2 Oct 2020 19:22:15 +0000 (GMT)
X-AuditID: cbfec7f4-65dff7000000176d-5d-5f777de74384
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id A0.54.06017.7ED777F5; Fri,  2
        Oct 2020 20:22:15 +0100 (BST)
Received: from localhost (unknown [106.120.51.46]) by eusmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20201002192215eusmtip2e80bf073e6134c5fe3753bd6016dbe29~6QzpVmV9N2142021420eusmtip2R;
        Fri,  2 Oct 2020 19:22:15 +0000 (GMT)
From:   =?UTF-8?q?=C5=81ukasz=20Stelmach?= <l.stelmach@samsung.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Kukjin Kim <kgene@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>, jim.cromie@gmail.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org
Cc:     =?UTF-8?q?Bart=C5=82omiej=20=C5=BBolnierkiewicz?= 
        <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        =?UTF-8?q?=C5=81ukasz=20Stelmach?= <l.stelmach@samsung.com>
Subject: [PATCH v2 0/4] AX88796C SPI Ethernet Adapter
Date:   Fri,  2 Oct 2020 21:22:06 +0200
Message-Id: <20201002192210.19967-1-l.stelmach@samsung.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Organization: Samsung R&D Institute Poland
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA02Se0gUcRDH+93u3q3S2XqaDlpKR0IZqZXJQlEZBovRg+qfCh9XLmr54tZn
        Ulo+SinNU0vPS81MzXx7nZ6o4GU+EL1U1CyNUME3FCaYhHbnKvnfZ2a+M98ZGBKTjBA2ZGBI
        OCsPkQVJhaa4puOP/vDM/Sgfl0IPWj+uw+janGqCVukTcbqgvY+ghxfHCDp9ch6j9foaEf1Z
        k0bQo7oyRNdNDhP0YJNKSOfoWwW0LrsF0ZXt4yK6o9CKTmppF52hmMHhfoxRvxsVMFrluIip
        K08RMvXFcYy2cUnApKnLEbNUZ3eZvGF60o8NCoxk5c6nfE0DSprtw15ZRj9MnsHi0eSuVGRC
        AuUKBVWlyMgSqgzBL/WdVGRq4N8IJmsThXywhODrgALb6siqb0N8oRRBpvqjiA+mESyXFRNG
        lZByh/S3XYSxYElpMFioL8KNAUa1ItB+z9qYZUEdB0X3a4GRccoBhiZycSOLqROgepMk5P3s
        4XFpg5DPm0N37tSGZhflCBWPRjYYM2gSPuRhRgOglkWw0DC7uawHFM804jxbwFynWsTzHljX
        FhiMSQPHQabCje99ikCjWtnUn4CxvlWhUYNRB6G6yZlPu8NQRi/Gt5rBl0VzfgUzUGhebqbF
        8CRZwqv3Q1V68+ZAG3g2V4Z4ZqB/9JPgOdqn3HaYctsxyv++hQgrR9ZsBBfsz3JHQ9goJ04W
        zEWE+DvdDg2uQ4Z361nr/N2Imv7e0iGKRNKdYtIlykdCyCK5mGAdAhKTWorP9vZ4S8R+sph7
        rDzURx4RxHI6ZEviUmvxsaJZLwnlLwtn77JsGCvfqgpIE5t45O8+faXlZHzfQHZvIn7xZ37q
        2PJUQlaqdx6qisvMrxIwsZrzfjYKleWap5VZ46p25ceD906V53wvLB3Qre0Ir/DcezNHm9HB
        7p7Ot/W87nG/03eAkqz4np6IijmU5lDvGpuSy0W3eV16cW29xMtNnJPUNdv/rQahlfmuObuh
        4qtSnAuQHXHE5JzsH8ZlCDJqAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrIIsWRmVeSWpSXmKPExsVy+t/xe7rPa8vjDZrOSFmcv3uI2WLjjPWs
        FnPOt7BYzD9yjtXi2ts7rBb9j18zW5w/v4Hd4sK2PlaLm4dWMFpsenyN1eLyrjlsFjPO72Oy
        ODR1L6PF2iN32S2OLRCzaN17hN1BwOPytYvMHltW3mTy2DnrLrvHplWdbB6bl9R77Nzxmcmj
        b8sqRo/Pm+QCOKL0bIryS0tSFTLyi0tslaINLYz0DC0t9IxMLPUMjc1jrYxMlfTtbFJSczLL
        Uov07RL0MpbtkS+YK1LR2PaCuYHxMX8XIyeHhICJxJTNBxm7GLk4hASWMkpM3riMrYuRAygh
        JbFybjpEjbDEn2tdbBA1TxklTr05zgSSYBNwlOhfeoIVJCEicIhZ4tuTMywgDrPAPkaJ/UcX
        s4NUCQuYSkw6uRCsg0VAVeLqo5ksIDavgLXEnMWtbBAr5CXal29ng4gLSpyc+YQF5ApmAXWJ
        9fOEQML8AloSa5qug7UyA5U3b53NPIFRYBaSjlkIHbOQVC1gZF7FKJJaWpybnltspFecmFtc
        mpeul5yfu4kRGJ3bjv3csoOx613wIUYBDkYlHl4Og/J4IdbEsuLK3EOMEhzMSiK8TmdPxwnx
        piRWVqUW5ccXleakFh9iNAV6ZyKzlGhyPjBx5JXEG5oamltYGpobmxubWSiJ83YIHIwREkhP
        LEnNTk0tSC2C6WPi4JRqYHTvTTBUu23MmW1wb6uCPTcnz87FQu8bln+L28f4QeTYM82CtW+O
        fL/+P/zFBoWN/VfMmJOdPiXxzis/8+K7r+EFyeuS+/elFb8L89p+5/C1vz07rmh/iC796/fS
        jNfSObDj93yXpX/0OOX2ZcxfxfnFdu6r8IedBd8PPfA/OE9i8gfdrr1vCqWUWIozEg21mIuK
        EwEo139k5AIAAA==
X-CMS-MailID: 20201002192215eucas1p2c8f4a4bf8e411ed8ba75383fd58e85ac
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20201002192215eucas1p2c8f4a4bf8e411ed8ba75383fd58e85ac
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20201002192215eucas1p2c8f4a4bf8e411ed8ba75383fd58e85ac
References: <CGME20201002192215eucas1p2c8f4a4bf8e411ed8ba75383fd58e85ac@eucas1p2.samsung.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a driver for AX88796C Ethernet Adapter connected in SPI mode as
found on ARTIK5 evaluation board. The driver has been ported from a
v3.10.9 vendor kernel for ARTIK5 board.

-- 
Łukasz Stelmach (4):
  dt-bindings: net: Add bindings for AX88796C SPI Ethernet Adapter
  net: ax88796c: ASIX AX88796C SPI Ethernet Adapter Driver
  ARM: dts: exynos: Add Ethernet to Artik 5 board
  ARM: defconfig: Enable ax88796c driver

 .../bindings/net/asix,ax88796c-spi.yaml       |   76 ++
 MAINTAINERS                                   |    6 +
 arch/arm/boot/dts/exynos3250-artik5-eval.dts  |   21 +
 arch/arm/configs/exynos_defconfig             |    2 +
 arch/arm/configs/multi_v7_defconfig           |    2 +
 drivers/net/ethernet/Kconfig                  |    1 +
 drivers/net/ethernet/Makefile                 |    1 +
 drivers/net/ethernet/asix/Kconfig             |   21 +
 drivers/net/ethernet/asix/Makefile            |    6 +
 drivers/net/ethernet/asix/ax88796c_ioctl.c    |  238 ++++
 drivers/net/ethernet/asix/ax88796c_ioctl.h    |   26 +
 drivers/net/ethernet/asix/ax88796c_main.c     | 1072 +++++++++++++++++
 drivers/net/ethernet/asix/ax88796c_main.h     |  575 +++++++++
 drivers/net/ethernet/asix/ax88796c_spi.c      |  111 ++
 drivers/net/ethernet/asix/ax88796c_spi.h      |   69 ++
 15 files changed, 2227 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/asix,ax88796c-spi.yaml
 create mode 100644 drivers/net/ethernet/asix/Kconfig
 create mode 100644 drivers/net/ethernet/asix/Makefile
 create mode 100644 drivers/net/ethernet/asix/ax88796c_ioctl.c
 create mode 100644 drivers/net/ethernet/asix/ax88796c_ioctl.h
 create mode 100644 drivers/net/ethernet/asix/ax88796c_main.c
 create mode 100644 drivers/net/ethernet/asix/ax88796c_main.h
 create mode 100644 drivers/net/ethernet/asix/ax88796c_spi.c
 create mode 100644 drivers/net/ethernet/asix/ax88796c_spi.h

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
-- 
2.26.2

