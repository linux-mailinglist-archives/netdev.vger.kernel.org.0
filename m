Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 209A939B66A
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 12:02:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230134AbhFDKDs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 06:03:48 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:54804 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229625AbhFDKDr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Jun 2021 06:03:47 -0400
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20210604100200euoutp0148f3b09d59e870f292eb813ef8edd5b2~FWNbTLLdM1917119171euoutp01b
        for <netdev@vger.kernel.org>; Fri,  4 Jun 2021 10:02:00 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20210604100200euoutp0148f3b09d59e870f292eb813ef8edd5b2~FWNbTLLdM1917119171euoutp01b
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1622800920;
        bh=vZ3KKLqiiZzrxCeZZfN5tDXvbOSiP5vGVtWjdHoKGyQ=;
        h=From:To:Cc:Subject:Date:References:From;
        b=eIvFk+VOK21WyUtntEBqXHbnmTIsuJa1jX5qwa97S9UtT3ikR3dSuelCC77S5Oc7o
         WQIKyB4xdZimrqWLLknQEbBd7DycuwZngy1A/yyQf97H7SweLInzI7eq09z0djMzTN
         rah6owpKaqlRaEDp6+zBk1fHlmZXnNLDhu7+voMA=
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20210604100159eucas1p19bf3ad2927ddeb47578291dd13e14e95~FWNayKr2D0267702677eucas1p1K;
        Fri,  4 Jun 2021 10:01:59 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges1new.samsung.com (EUCPMTA) with SMTP id D5.7D.09452.71AF9B06; Fri,  4
        Jun 2021 11:01:59 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20210604100159eucas1p15d9bb617c9a25a19bd929153e82e4f48~FWNaQBHwR0267702677eucas1p1H;
        Fri,  4 Jun 2021 10:01:59 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20210604100159eusmtrp146da1bfd7e04db67e0c5025a67593b6d~FWNaPInZc1837518375eusmtrp1I;
        Fri,  4 Jun 2021 10:01:59 +0000 (GMT)
X-AuditID: cbfec7f2-ab7ff700000024ec-fa-60b9fa1762ea
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id E8.AC.08696.71AF9B06; Fri,  4
        Jun 2021 11:01:59 +0100 (BST)
Received: from localhost (unknown [106.120.51.46]) by eusmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20210604100159eusmtip2323c33dc6bc62e74cdd43ad222fd5ab6~FWNZ-Jkm02310823108eusmtip2W;
        Fri,  4 Jun 2021 10:01:58 +0000 (GMT)
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
Subject: [PATCH net-next v13 0/3] AX88796C SPI Ethernet Adapter
Date:   Fri,  4 Jun 2021 12:01:45 +0200
Message-Id: <20210604100148.17177-1-l.stelmach@samsung.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Organization: Samsung R&D Institute Poland
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrIKsWRmVeSWpSXmKPExsWy7djPc7riv3YmGKy7qWNx/u4hZouNM9az
        Wsw538JiMf/IOVaLRe9nsFpce3uH1aL/8Wtmi/PnN7BbXNjWx2px89AKRotNj6+xWlzeNYfN
        Ysb5fUwWh6buZbRYe+Quu8WxBWIWrXuPsDsIely+dpHZY8vKm0weO2fdZffYtKqTzWPzknqP
        nTs+M3n0bVnF6PF5k1wARxSXTUpqTmZZapG+XQJXxo7Z3SwFz/QrFs65ydzAuEi1i5GTQ0LA
        ROLVkwusXYxcHEICKxglZh3dywbhfGGUmPlvL1TmM6PEvV1/mboYOcBaWheqQMSXM0ocW7MK
        quM5o8Tr7XdZQeayCThK9C89AdYtInCPWWJ9+wNGEIdZYB+jxM57U5hBqoQF7CWuvVsJ1sEi
        oCoxde9NRhCbV8Ba4mrLBxaIC+Ul2pdvZ4OIC0qcnPkELM4voCWxpuk6mM0MVNO8dTYzyAIJ
        geWcEi+2PmCDaHaRmDJ/BjOELSzx6vgWdghbRuL05B4WiH/qJSZPMoPo7WGU2DbnB9Ria4k7
        536xgdQwC2hKrN+lDxF2lDj1biobRCufxI23ghAn8ElM2jadGSLMK9HRJgRRrSKxrn8P1EAp
        id5XKxghbA+JnS17mCcwKs5C8tgsJM/MQti7gJF5FaN4amlxbnpqsWFearlecWJucWleul5y
        fu4mRmCqO/3v+KcdjHNffdQ7xMjEwXiIUYKDWUmEd4/ajgQh3pTEyqrUovz4otKc1OJDjNIc
        LErivKtmr4kXEkhPLEnNTk0tSC2CyTJxcEo1MEWe8KjQLJfKCF0h9KJvSWVJlhGbz81jmjfX
        z8r0j/JmPX22s3ZawcmXp3uevXHnll08K154Y13K+67aPzyBT5srHxgn/Zq66PT7Py+vcb85
        GaT0J2Vn9+1ZUQsiX2SIZ7UuTJmutcRWSfR9l/DKCna7BTZKe9/uPPnfzP3Ppsjvgkvl/HtN
        tti7yBS6OlpN8dyYezww+k3QI+mCfVGLrlXu3XhPU1n4avoM3i/mP0IXd2peP6/Y3JspI7CR
        /bbwbWtzAd3ejxLdz+MtYx77X9J4p16273P2u4g96kdKP7v8Yi37MWXR6XmPOxbHbltUffrT
        2buLJJhf8nI+W779icirFfV6Xc2BGz3Cv1y5cU+JpTgj0VCLuag4EQCRhCAK5AMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJIsWRmVeSWpSXmKPExsVy+t/xe7riv3YmGMyayWVx/u4hZouNM9az
        Wsw538JiMf/IOVaLRe9nsFpce3uH1aL/8Wtmi/PnN7BbXNjWx2px89AKRotNj6+xWlzeNYfN
        Ysb5fUwWh6buZbRYe+Quu8WxBWIWrXuPsDsIely+dpHZY8vKm0weO2fdZffYtKqTzWPzknqP
        nTs+M3n0bVnF6PF5k1wAR5SeTVF+aUmqQkZ+cYmtUrShhZGeoaWFnpGJpZ6hsXmslZGpkr6d
        TUpqTmZZapG+XYJexo7Z3SwFz/QrFs65ydzAuEi1i5GDQ0LARKJ1oUoXIxeHkMBSRokf/96y
        QcSlJFbOTe9i5AQyhSX+XOtig6h5yijx9O0zNpAEm4CjRP/SE6wgCRGBN8wSTffesoM4zAL7
        GCX2H13MDlIlLGAvce3dSlYQm0VAVWLq3puMIDavgLXE1ZYPLBAr5CXal29ng4gLSpyc+YQF
        5ApmAXWJ9fOEQML8AloSa5qug5UzA5U3b53NPIFRYBaSjlkIHbOQVC1gZF7FKJJaWpybnlts
        pFecmFtcmpeul5yfu4kRGKfbjv3csoNx5auPeocYmTgYDzFKcDArifDuUduRIMSbklhZlVqU
        H19UmpNafIjRFOiDicxSosn5wESRVxJvaGZgamhiZmlgamlmrCTOa3JkTbyQQHpiSWp2ampB
        ahFMHxMHp1QDE9Oc7pYluzie7TOuWbX0Q7jH2anPhGZf+RV0O/iixdx5pyI6851KOq7IhTDM
        /SsxLXvrP48g04jOI9mGuSYiPI9O5e19Y3F530kWUW/OvSlLNSO1Fwtw8XlJM1zfHKh6rezY
        hx7XoH3TeoLZ24V0287M23cx5sPs+Jjecrb0Rx9PrzD+vHSK2cVvSsECUSLHFrtsMtZx+Tf3
        ePZxi9YJT5fJ3Xkw+fei4K328f17J/358Kz41sOte1W5p9mYX5RX5FiwcWcIl3Dn9b7bkZ5z
        M18Vb3jOs9H1qXzX3Qdc7ccdL38V3fnlzh/eL34PJukt3OUsw847U1ZS1CpmluCqqyGLgyd3
        eU/f45u1680+rTYlluKMREMt5qLiRADNQmdWXAMAAA==
X-CMS-MailID: 20210604100159eucas1p15d9bb617c9a25a19bd929153e82e4f48
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20210604100159eucas1p15d9bb617c9a25a19bd929153e82e4f48
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20210604100159eucas1p15d9bb617c9a25a19bd929153e82e4f48
References: <CGME20210604100159eucas1p15d9bb617c9a25a19bd929153e82e4f48@eucas1p1.samsung.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a driver for AX88796C Ethernet Adapter connected in SPI mode as
found on ARTIK5 evaluation board. The driver has been ported from a
v3.10.9 vendor kernel for ARTIK5 board.

Changes in v13:
  - rebased onto net-next (ebbf5fcb94a7)
  - minor fix: use u64_stats_update_{begin_irqsave,end_irqrestore}
  - minor fix: initialize the syncp lock

Changes in v12:
  - rebased to net-next-5.13
  - added missing spaces after commas
  - corrected indentation

Changes in v11:
  - changed stat counters to 64-bit
  - replaced WARN_ON(!mutex_is_locked()) with lockdep_assert_held()
  - replaced ax88796c_free_skb_queue() with __skb_queue_purge()
  - added cancel_work_sync() for ax_work
  - removed unused fields of struct skb_data
  - replaced MAX() with max() from minmax.h
  - rebased to net-next (resend)

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
 drivers/net/ethernet/asix/ax88796c_main.c     | 1149 +++++++++++++++++
 drivers/net/ethernet/asix/ax88796c_main.h     |  568 ++++++++
 drivers/net/ethernet/asix/ax88796c_spi.c      |  115 ++
 drivers/net/ethernet/asix/ax88796c_spi.h      |   69 +
 13 files changed, 2290 insertions(+)
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

