Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C7C22F5282
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 19:43:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728534AbhAMSlZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 13:41:25 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:37571 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728422AbhAMSlY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 13:41:24 -0500
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20210113184042euoutp0184e7e07d3cbcb343b8ef198bc17032a9~Z3rx8tx_b0644406444euoutp01S
        for <netdev@vger.kernel.org>; Wed, 13 Jan 2021 18:40:42 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20210113184042euoutp0184e7e07d3cbcb343b8ef198bc17032a9~Z3rx8tx_b0644406444euoutp01S
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1610563242;
        bh=jTHnGna2FvAIzqNFyhpFj3qv6394hSgJoF8U9q2dYNg=;
        h=From:To:Cc:Subject:Date:References:From;
        b=W8RjPU53/KiiaLSrHVS+vcljVmOURyrWhisoZfnNpAVkdMtwZ/pcMZD1xgQb234LK
         5Enb17rWW0dCUF+AuOKcNP370KKQjNWkLNlFJe7Un7BXFsOO3wZ+2S+9SPqmcSrGCE
         PoWQnplmjrs3X6ZBboyfNFrb/iLN50cemZlvxu7o=
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20210113184042eucas1p148b43a2db6f6e19e290b1aa283027bf5~Z3rxYmFGQ1613716137eucas1p1L;
        Wed, 13 Jan 2021 18:40:42 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges1new.samsung.com (EUCPMTA) with SMTP id 28.99.27958.AAE3FFF5; Wed, 13
        Jan 2021 18:40:42 +0000 (GMT)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20210113184041eucas1p229fed83022249faf9fd333466370be83~Z3rw9gqSG1712517125eucas1p2b;
        Wed, 13 Jan 2021 18:40:41 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20210113184041eusmtrp1a6c5548c0a10702f1a1556c849e1c1ce~Z3rw8uwep2007620076eusmtrp1Q;
        Wed, 13 Jan 2021 18:40:41 +0000 (GMT)
X-AuditID: cbfec7f2-efdff70000006d36-33-5fff3eaa487a
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id 38.B7.16282.9AE3FFF5; Wed, 13
        Jan 2021 18:40:41 +0000 (GMT)
Received: from localhost (unknown [106.120.51.46]) by eusmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20210113184041eusmtip24b95f294ae6f564d025b9acd33e1e350~Z3rwvNDyR1783017830eusmtip2P;
        Wed, 13 Jan 2021 18:40:41 +0000 (GMT)
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
Subject: [PATCH v10 0/3] AX88796C SPI Ethernet Adapter
Date:   Wed, 13 Jan 2021 19:40:25 +0100
Message-Id: <20210113184028.4433-1-l.stelmach@samsung.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Organization: Samsung R&D Institute Poland
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrAKsWRmVeSWpSXmKPExsWy7djPc7qr7P7HGzyczGVx/u4hZouNM9az
        Wsw538JiMf/IOVaLRe9nsFpce3uH1aL/8Wtmi/PnN7BbXNjWx2px89AKRotNj6+xWlzeNYfN
        Ysb5fUwWh6buZbRYe+Quu8WxBWIWrXuPsDsIely+dpHZY8vKm0weO2fdZffYtKqTzWPzknqP
        nTs+M3n0bVnF6PF5k1wARxSXTUpqTmZZapG+XQJXxoUFvgVPtSr6Or8yNzAuUOxi5OSQEDCR
        ePVwN3MXIxeHkMAKRoljPYdYIJwvjBJnp39gh3A+M0rsWbmXqYuRA6zl836o+HJGiZdPprFC
        OM8ZJb5cP8IEMpdNwFGif+kJsISIwD1mifXtDxhBHGaBfYwSO+9NYQapEhYwk9h8fSmYzSKg
        KtF44g6YzStgJfFkwlp2iAvlJdqXb2eDiAtKnJz5hAXE5hfQkljTdB3MZgaqad46G+wLCYHF
        nBKzlz1ggmh2kTh0+AvUIGGJV8e3QNkyEqcn97BA/FMvMXmSGURvD6PEtjk/WCBqrCXunPvF
        BlLDLKApsX6XPkTYUeLusinsEK18EjfeCkKcwCcxadt0Zogwr0RHmxBEtYrEuv49UAOlJHpf
        rWCEsD0kFt8+zjaBUXEWksdmIXlmFsLeBYzMqxjFU0uLc9NTiw3zUsv1ihNzi0vz0vWS83M3
        MQIT3el/xz/tYJz76qPeIUYmDsZDjBIczEoivEXdf+OFeFMSK6tSi/Lji0pzUosPMUpzsCiJ
        866avSZeSCA9sSQ1OzW1ILUIJsvEwSnVwOTcvEzllYT8j1cpnj1iYqLfZjw8fbDv+t2nh4vn
        Nh0yf1jqxmb8wTDuloyUf/TBwPWFTU4rXx757b9dWm3iZYtCoXD202LJsccYdkgFOm0693TL
        2ffam8NfP2M7t72wc83FFWuN9RnbmjK6ao7/f9xtYHqo1uCc4c2//470On5afur8aqHu81vv
        TdJbZmYXMjOv++XfhMTDqcUpgS2aWf+EkiQ49nQ6PE8/80JSYMoXHcaFX398XffdjaP/0/Ju
        m5PxNbm7rvxLW9Jt2dPKYDs5idnn6zJVZwHP2fFfl3x7f+dvy2++BU8vyXdvXXe44IPb0h39
        93zcbHmvCn9vPmb/vfeig6/a6Z+6C7YJnn6oxFKckWioxVxUnAgApnj38uMDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrOIsWRmVeSWpSXmKPExsVy+t/xe7or7f7HGzycqWNx/u4hZouNM9az
        Wsw538JiMf/IOVaLRe9nsFpce3uH1aL/8Wtmi/PnN7BbXNjWx2px89AKRotNj6+xWlzeNYfN
        Ysb5fUwWh6buZbRYe+Quu8WxBWIWrXuPsDsIely+dpHZY8vKm0weO2fdZffYtKqTzWPzknqP
        nTs+M3n0bVnF6PF5k1wAR5SeTVF+aUmqQkZ+cYmtUrShhZGeoaWFnpGJpZ6hsXmslZGpkr6d
        TUpqTmZZapG+XYJexoUFvgVPtSr6Or8yNzAuUOxi5OCQEDCR+LyfvYuRi0NIYCmjxPZDp5kg
        4lISK+emdzFyApnCEn+udbGB2EICTxklvv6wBbHZBBwl+peeYAXpFRF4wyzRdO8t2CBmgX2M
        EvuPLmYHqRIWMJPYfH0pM4jNIqAq0XjiDpjNK2Al8WTCWnaIDfIS7cu3s0HEBSVOznzCAnIE
        s4C6xPp5QiBhfgEtiTVN11lAbGag8uats5knMArMQtIxC6FjFpKqBYzMqxhFUkuLc9Nzi430
        ihNzi0vz0vWS83M3MQJjdNuxn1t2MK589VHvECMTB+MhRgkOZiUR3qLuv/FCvCmJlVWpRfnx
        RaU5qcWHGE2BPpjILCWanA9MEnkl8YZmBqaGJmaWBqaWZsZK4rwmR9bECwmkJ5akZqemFqQW
        wfQxcXBKNTC186+VzePbZP/vWDL//EB9112snwKNHwf3Lvx25VzR2tO7+0Vf3pawyPG225uc
        kfF4d9l98eCYxMTdl9xfcqsF2Z7Y5vCooW2zncU0m3VhRtemHr7AsTBOjqVG8dXMWS9i/mx/
        wRiTacYSuO3Zpm/Zxdd3VEQfWfVJxMvOIHrhZYekRY3qCeo8T0LOzPd4J3d9Vi7LGb9vDKvF
        lnII/9kSsOJKcpITa5Wh+Komh3VNy8P7Gd788nhlamQuWrFKesHm+LKmHRc0cue9qPlyVfZ2
        SO93b/fM9k+X3zPc/Kv288xqvrxDe7+aHDWUCM/eHp759LJ5Jous6JcPT0pMP6edmuU/I9X7
        eEp79x63471KLMUZiYZazEXFiQC5c1kGWgMAAA==
X-CMS-MailID: 20210113184041eucas1p229fed83022249faf9fd333466370be83
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20210113184041eucas1p229fed83022249faf9fd333466370be83
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20210113184041eucas1p229fed83022249faf9fd333466370be83
References: <CGME20210113184041eucas1p229fed83022249faf9fd333466370be83@eucas1p2.samsung.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a driver for AX88796C Ethernet Adapter connected in SPI mode as
found on ARTIK5 evaluation board. The driver has been ported from a
v3.10.9 vendor kernel for ARTIK5 board.

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
 drivers/net/ethernet/asix/ax88796c_main.c     | 1103 +++++++++++++++++
 drivers/net/ethernet/asix/ax88796c_main.h     |  558 +++++++++
 drivers/net/ethernet/asix/ax88796c_spi.c      |  115 ++
 drivers/net/ethernet/asix/ax88796c_spi.h      |   69 ++
 13 files changed, 2234 insertions(+)
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

