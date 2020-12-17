Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E43FD2DD0E0
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 12:54:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728313AbgLQLyp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Dec 2020 06:54:45 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:36748 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728085AbgLQLyk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Dec 2020 06:54:40 -0500
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20201217115347euoutp0156d2461e371b2a8e8071c4381af9f2bd~RftyO8WAz0524105241euoutp01E
        for <netdev@vger.kernel.org>; Thu, 17 Dec 2020 11:53:47 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20201217115347euoutp0156d2461e371b2a8e8071c4381af9f2bd~RftyO8WAz0524105241euoutp01E
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1608206027;
        bh=4D2ygLyKzRgVS3qMV6DdZglnSQ/S2hR8DaD1xUTXRi4=;
        h=From:To:Cc:Subject:Date:References:From;
        b=cZfDTpSjhffRhm3UATDRD3DR+c6JS1p48bYE/77/wq0aL+QQu+SBPENWyrmGTEROi
         weD5weeeQbd1F4fPzrKN/jNy0P0YAvLgna2xVCDu7O0XuJXMQEK0CwKwTthC8qVBhZ
         zE7EF9wA10OvFkhiJLf+L5MFaaE7gBLJaJweeovU=
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20201217115342eucas1p1d5d62b7427344c38dbfb412eefe110fe~RfttPt56a2472224722eucas1p1p;
        Thu, 17 Dec 2020 11:53:42 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges3new.samsung.com (EUCPMTA) with SMTP id E3.9D.45488.6C64BDF5; Thu, 17
        Dec 2020 11:53:42 +0000 (GMT)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20201217115341eucas1p11b7d1ffe89f9411223523eb5b5da170a~RftsvOzBf2279122791eucas1p14;
        Thu, 17 Dec 2020 11:53:41 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20201217115341eusmtrp15bdad5cf09e0acf0a90e16fc45493a28~RftsuYjNc2059420594eusmtrp1z;
        Thu, 17 Dec 2020 11:53:41 +0000 (GMT)
X-AuditID: cbfec7f5-c5fff7000000b1b0-bb-5fdb46c6060a
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id 56.A7.21957.5C64BDF5; Thu, 17
        Dec 2020 11:53:41 +0000 (GMT)
Received: from localhost (unknown [106.120.51.46]) by eusmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20201217115341eusmtip18f3cfb9d9d963a0a62be134aeccd8147~Rftsfwbxv2868728687eusmtip1b;
        Thu, 17 Dec 2020 11:53:41 +0000 (GMT)
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
Subject: [PATCH v9 0/3] AX88796C SPI Ethernet Adapter
Date:   Thu, 17 Dec 2020 12:53:27 +0100
Message-Id: <20201217115330.28431-1-l.stelmach@samsung.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Organization: Samsung R&D Institute Poland
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrIKsWRmVeSWpSXmKPExsWy7djP87rH3G7HG9xqFbQ4f/cQs8XGGetZ
        Leacb2GxmH/kHKvFovczWC2uvb3DatH/+DWzxfnzG9gtLmzrY7W4eWgFo8Wmx9dYLS7vmsNm
        MeP8PiaLQ1P3MlqsPXKX3eLYAjGL1r1H2B0EPS5fu8jssWXlTSaPnbPusntsWtXJ5rF5Sb3H
        zh2fmTz6tqxi9Pi8SS6AI4rLJiU1J7MstUjfLoErY99SsYLNWhWrrraxNjD+Uehi5OSQEDCR
        uPRgG1sXIxeHkMAKRolnN48yQzhfGCXe/F0JlfnMKDHr6QMWmJb7TxexQiSWM0rcf76HEcJ5
        zijx8x2Iw8nBJuAo0b/0BFiViMA9Zon17Q/AqpgF9jFK7Lw3hRmkSljAVOLhr/+sIDaLgKrE
        owubwHbwClhL7D5+gwlin7xE+/LtbBBxQYmTM5+A1fALaEmsaboOZjMD1TRvnQ12uYTAYk6J
        Kz9/M0M0u0js/g7RLCEgLPHq+BZ2CFtG4vTkHqBmDiC7XmLyJDOI3h5GiW1zfkA9ai1x59wv
        NpAaZgFNifW79CHCjhInd/9jgmjlk7jxVhDiBD6JSdumM0OEeSU62oQgqlUk1vXvgRooJdH7
        agUjhO0hsXLtf+YJjIqzkDw2C8kzsxD2LmBkXsUonlpanJueWmycl1quV5yYW1yal66XnJ+7
        iRGY6k7/O/51B+OKVx/1DjEycTAeYpTgYFYS4U04cDNeiDclsbIqtSg/vqg0J7X4EKM0B4uS
        OO+urWvihQTSE0tSs1NTC1KLYLJMHJxSDUzV97btnFeyweGd7KSnN88lel3WeWCdGjYxyJmv
        MUGk696T17ys7yc71UnYzzZn/RVzMmepg/N5hh1VOl5LRA8Z9Uuo/47pX7+2lXdCxO3PR5Wq
        V320W8cqpLF8yo7pL1n/K7i+2lmbbHs5ft/qOtfQF0uPLlW+/3b2WfflxtcuukxxL+2WZDTf
        NGvrIpMFu+5vqIr5eZ9ZymtvqsBypqsTfmu/P1u2xL/wYNqr7Og4k8utb8W1ryq4TGLSiem+
        cpLN/mPE007baXIq3LP3Cm/XWmTHGr9CSXnyUuFHy5c/UtNf3a566Zati+Se0Je7D08Ke/wp
        3jZD9m93fe2clk2LVq/0Lb3zzddK5tf32a+eKLEUZyQaajEXFScCACgvTMvkAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJIsWRmVeSWpSXmKPExsVy+t/xu7pH3W7HG3Q80LQ4f/cQs8XGGetZ
        Leacb2GxmH/kHKvFovczWC2uvb3DatH/+DWzxfnzG9gtLmzrY7W4eWgFo8Wmx9dYLS7vmsNm
        MeP8PiaLQ1P3MlqsPXKX3eLYAjGL1r1H2B0EPS5fu8jssWXlTSaPnbPusntsWtXJ5rF5Sb3H
        zh2fmTz6tqxi9Pi8SS6AI0rPpii/tCRVISO/uMRWKdrQwkjP0NJCz8jEUs/Q2DzWyshUSd/O
        JiU1J7MstUjfLkEvY99SsYLNWhWrrraxNjD+Uehi5OSQEDCRuP90EWsXIxeHkMBSRok7T7az
        dDFyACWkJFbOTYeoEZb4c62LDaLmKaPEm3NrGUESbAKOEv1LT4A1iwi8YZZouveWHcRhFtjH
        KLH/6GJ2kCphAVOJh7/+s4LYLAKqEo8ubGIBsXkFrCV2H7/BBLFCXqJ9+XY2iLigxMmZT8Cu
        YBZQl1g/TwgkzC+gJbGm6TpYKzNQefPW2cwTGAVmIemYhdAxC0nVAkbmVYwiqaXFuem5xYZ6
        xYm5xaV56XrJ+bmbGIFxuu3Yz807GOe9+qh3iJGJg/EQowQHs5IIb8KBm/FCvCmJlVWpRfnx
        RaU5qcWHGE2BPpjILCWanA9MFHkl8YZmBqaGJmaWBqaWZsZK4rxb566JFxJITyxJzU5NLUgt
        gulj4uCUamDameDnWH3i0O56N76dsnO8bt3gcSt5X/p2f0FRrYr3Tq2Q3wnuvyc/dJU4EqvL
        fG/v09zkgt9xL+QEUzlkq6o/fVsuyWW7zf52fF+Dd+GSk5sOJYY9TeuxifqY/HfxZ5mrzotk
        pF4/j1Hoty1JXV6xs7t2/rPZRTLCn+4UMEn3Pfzu8u5l/MpFzKWtZ7sDtNlOHnN6fO+B1dYC
        dmbBCDbV19fF5lttregqDLqjcH39n8LwyKDX7yZPDlvNeWiB0cv/M1jP32yN36j4qZRHYu55
        rw3FJaXJtVEfnu3V6p7rbblv+kWWS55WxVMNPGa035ReKj+1/cbLSC6rcz9Pf/Hrl+Dr5jae
        KLJgrb6ExF0lluKMREMt5qLiRACpdZ35XAMAAA==
X-CMS-MailID: 20201217115341eucas1p11b7d1ffe89f9411223523eb5b5da170a
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20201217115341eucas1p11b7d1ffe89f9411223523eb5b5da170a
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20201217115341eucas1p11b7d1ffe89f9411223523eb5b5da170a
References: <CGME20201217115341eucas1p11b7d1ffe89f9411223523eb5b5da170a@eucas1p1.samsung.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a driver for AX88796C Ethernet Adapter connected in SPI mode as
found on ARTIK5 evaluation board. The driver has been ported from a
v3.10.9 vendor kernel for ARTIK5 board.

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
 drivers/net/ethernet/asix/ax88796c_main.c     | 1105 +++++++++++++++++
 drivers/net/ethernet/asix/ax88796c_main.h     |  558 +++++++++
 drivers/net/ethernet/asix/ax88796c_spi.c      |  115 ++
 drivers/net/ethernet/asix/ax88796c_spi.h      |   69 +
 13 files changed, 2236 insertions(+)
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

