Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED27E3049C3
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 21:16:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727102AbhAZFXt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 00:23:49 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:40164 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729085AbhAYQzV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 11:55:21 -0500
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20210125165422euoutp0193541165cb3d0960418e968c3420f077~dh_Wtio061682716827euoutp01W
        for <netdev@vger.kernel.org>; Mon, 25 Jan 2021 16:54:22 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20210125165422euoutp0193541165cb3d0960418e968c3420f077~dh_Wtio061682716827euoutp01W
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1611593662;
        bh=D+3F7rEE3+9XcRlqap5qRSJcQi9jGi7LsZrW2rMX31s=;
        h=From:To:Cc:Subject:Date:References:From;
        b=unOLB9WR4+5zuJSW1ycopWjXK9/FpYbqQIbTXSnUTlw2ZPWtalFGmFxrcpuU3e+N8
         HPHoGRAN7CYqlKQysqnEY3QkfXKbN/m3Nrw7gtWs/PB6Nttvzu7Az+Jc+t/B+50/Np
         r9bKtsXgkKfuWA0P0VleBpQyGSMdhxo6X/FlQOcs=
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20210125165421eucas1p23d8b048160291efadec8e26c7f4f60b2~dh_WKQPDl0475704757eucas1p2B;
        Mon, 25 Jan 2021 16:54:21 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges1new.samsung.com (EUCPMTA) with SMTP id C3.E6.27958.DB7FE006; Mon, 25
        Jan 2021 16:54:21 +0000 (GMT)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20210125165421eucas1p21049ed87217b177c3711c7b5726bd085~dh_VvicLQ0474404744eucas1p2M;
        Mon, 25 Jan 2021 16:54:21 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20210125165421eusmtrp2d5461c9981472a90299b90666192941c~dh_VtuJ3E0209902099eusmtrp2C;
        Mon, 25 Jan 2021 16:54:21 +0000 (GMT)
X-AuditID: cbfec7f2-f15ff70000006d36-7d-600ef7bdf4ec
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id BA.D5.21957.CB7FE006; Mon, 25
        Jan 2021 16:54:20 +0000 (GMT)
Received: from localhost (unknown [106.120.51.46]) by eusmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20210125165420eusmtip2edaa26c1cdc930426ff1b2db4b20515c~dh_VcYsi72869128691eusmtip2B;
        Mon, 25 Jan 2021 16:54:20 +0000 (GMT)
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
Subject: [PATCH v11 0/3] AX88796C SPI Ethernet Adapter
Date:   Mon, 25 Jan 2021 17:54:03 +0100
Message-Id: <20210125165406.9692-1-l.stelmach@samsung.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Organization: Samsung R&D Institute Poland
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLKsWRmVeSWpSXmKPExsWy7djPc7p7v/MlGPzdI29x/u4hZouNM9az
        Wsw538JiMf/IOVaLRe9nsFpce3uH1aL/8Wtmi/PnN7BbXNjWx2px89AKRotNj6+xWlzeNYfN
        Ysb5fUwWh6buZbRYe+Quu8WxBWIWrXuPsDsIely+dpHZY8vKm0weO2fdZffYtKqTzWPzknqP
        nTs+M3n0bVnF6PF5k1wARxSXTUpqTmZZapG+XQJXxskNv9kLlulW/Dpyjr2BcZlyFyMnh4SA
        icT3pRuZuhi5OIQEVjBK3GmaCOV8YZSYPvUBE0iVkMBnRomD0/JgOg5faGWEiC9nlNh5MAHC
        fs4osfShBojNJuAo0b/0BCvIIBGBe8wS69sfMII4zAL7gBruTWEGqRIWMJP4MOcsG4jNIqAq
        8a7/K3sXIwcHr4CVxMX7nBDL5CXal28HK+EVEJQ4OfMJC4jNL6AlsabpOpjNDFTTvHU2M8h8
        CYHlnBJ3lv1jhGh2kWh4f44ZwhaWeHV8CzuELSPxf+d8JpBdEgL1EpMnmUH09jBKbJvzgwWi
        xlrizrlfbCA1zAKaEut36UOEHSVmrJjEDNHKJ3HjrSDECXwSk7ZNhwrzSnS0CUFUq0is698D
        NVBKovfVCkaIEg+JKVOVJjAqzkLy1ywkv8xCWLuAkXkVo3hqaXFuemqxYV5quV5xYm5xaV66
        XnJ+7iZGYIo7/e/4px2Mc1991DvEyMTBeIhRgoNZSYR3tx5PghBvSmJlVWpRfnxRaU5q8SFG
        aQ4WJXHeVbPXxAsJpCeWpGanphakFsFkmTg4pRqYFh95Z68md3nteeMfYe5+2edSlYvTg1S3
        FfauL38wLydirdVmpd0ySetn8mxovNhS6PqedUmDqI3lz/6NpfsX+hlNmZi88O3SvasSuXt3
        lerpRRT8lvBxYrRa0Ljm4ATV+wxPLWyvhq7f+3OS78sORWfuo651ETGXVOVWXfkQeq66IeDE
        VYU+hvIkrfo3Pw5q9mXFicZ/c7lxctocn6N5MWLx06SPCzGrGHFePWFocl9i+T6Hk3zHt55Q
        SW35tnvOPY68/EWZGVbTTK5OP/NZ+UTwtdkWvZoTgldkt0Z6T0sL9qqY57f2bfwmw3Tm8yeF
        VUqlljMcUzm9+MUK2T8/BGY/9VyS/Pm333JxLdvPSizFGYmGWsxFxYkAb4rrQuADAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJIsWRmVeSWpSXmKPExsVy+t/xe7p7vvMlGLzqs7E4f/cQs8XGGetZ
        Leacb2GxmH/kHKvFovczWC2uvb3DatH/+DWzxfnzG9gtLmzrY7W4eWgFo8Wmx9dYLS7vmsNm
        MeP8PiaLQ1P3MlqsPXKX3eLYAjGL1r1H2B0EPS5fu8jssWXlTSaPnbPusntsWtXJ5rF5Sb3H
        zh2fmTz6tqxi9Pi8SS6AI0rPpii/tCRVISO/uMRWKdrQwkjP0NJCz8jEUs/Q2DzWyshUSd/O
        JiU1J7MstUjfLkEv4+SG3+wFy3Qrfh05x97AuEy5i5GTQ0LAROLwhVbGLkYuDiGBpYwS26Ze
        ZOli5ABKSEmsnJsOUSMs8edaFxtEzVNGiee/vrODJNgEHCX6l55gBUmICLxhlmi695YdxGEW
        2Mcosf/oYrAqYQEziQ9zzrKB2CwCqhLv+r+yg2zgFbCSuHifE2KDvET78u1gJbwCghInZz4B
        O4JZQF1i/TwhkDC/gJbEmqbrLCA2M1B589bZzBMYBWYh6ZiF0DELSdUCRuZVjCKppcW56bnF
        hnrFibnFpXnpesn5uZsYgXG67djPzTsY5736qHeIkYmD8RCjBAezkgjvbj2eBCHelMTKqtSi
        /Pii0pzU4kOMpkAPTGSWEk3OByaKvJJ4QzMDU0MTM0sDU0szYyVx3q1z18QLCaQnlqRmp6YW
        pBbB9DFxcEo1MLmfamY+rtud+OD3eT7jEvmGH9bvNx9f8WRfE9crnol2E9Wiei4/a5i33LNF
        aGlyTc3KEu2FM8oDD/xPuiIzK0aNq9EpqNtyK+u2OrGLXl0qvWocgVt1Cu6Ze7ySNGVc5bz/
        0L4H0sE6P3fOVOtdcVVTLkDLc+68l98XbZg099cdLfPpWx9dcbx27c7sMzrbBT5/r+4Jjz71
        /OTijS/rfJYzFG/tSPVWzA2eG/g7Ve7i36UmCvPk/4nXOM9j8Fm4+LqF+B7vkAc1/yxMhd93
        sR5e1/XcnvkUu+t39W72Mpl7DE5c58+sfhiUx8v54PvnfqnYrBPZt8NOPfRRsjdadUDrka2+
        4bGX7eYhT665zlZiKc5INNRiLipOBAA+t0M4XAMAAA==
X-CMS-MailID: 20210125165421eucas1p21049ed87217b177c3711c7b5726bd085
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20210125165421eucas1p21049ed87217b177c3711c7b5726bd085
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20210125165421eucas1p21049ed87217b177c3711c7b5726bd085
References: <CGME20210125165421eucas1p21049ed87217b177c3711c7b5726bd085@eucas1p2.samsung.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a driver for AX88796C Ethernet Adapter connected in SPI mode as
found on ARTIK5 evaluation board. The driver has been ported from a
v3.10.9 vendor kernel for ARTIK5 board.

Changes in v11:
  - changed stat counters to 64-bit
  - replaced WARN_ON(!mutex_is_locked()) with lockdep_assert_held()
  - replaced ax88796c_free_skb_queue() with __skb_queue_purge()
  - added cancel_work_sync() for ax_work
  - removed unused fields of struct skb_data
  - replaced MAX() with max() from minmax.h

Changes in v10:
  - removed unused variable
 
Changes in v9:
  - used pskb_extend_head()
  - used ethtool private flags instead of tunables to switch SPI
    compression
  - changed
    - alloc_skb() to netdev_alloc(skb)
    - __pskb_trim() to pskb_trim()
  - removed:
    - chages to skb->truesize
    - unnecessary casting to short
    - return f() in a void function
    - IRQF_SHARED flags
    - unnecessary memset(0) of kzalloc()ed buffer
    - unused endiannes detection
    - unnecessary __packed attribute for some structures
  - added:
    - temporary variable in AX_WRITE/READ sequences
    - missin mutex_unlock() in error paths
  - axspi_read_reg() returns a constant value in case of an error
  
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
 drivers/net/ethernet/asix/ax88796c_ioctl.c    |  239 ++++
 drivers/net/ethernet/asix/ax88796c_ioctl.h    |   26 +
 drivers/net/ethernet/asix/ax88796c_main.c     | 1146 +++++++++++++++++
 drivers/net/ethernet/asix/ax88796c_main.h     |  568 ++++++++
 drivers/net/ethernet/asix/ax88796c_spi.c      |  115 ++
 drivers/net/ethernet/asix/ax88796c_spi.h      |   69 +
 13 files changed, 2287 insertions(+)
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

