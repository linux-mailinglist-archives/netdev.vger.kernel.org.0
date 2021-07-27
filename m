Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D90A3D7238
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 11:43:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236138AbhG0Jne (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 05:43:34 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:59611 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235950AbhG0Jnc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 05:43:32 -0400
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20210727094331euoutp0146cc4dcec53cf1bb9ff2d18def972bce~VnJa0o6U01691416914euoutp01S
        for <netdev@vger.kernel.org>; Tue, 27 Jul 2021 09:43:31 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20210727094331euoutp0146cc4dcec53cf1bb9ff2d18def972bce~VnJa0o6U01691416914euoutp01S
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1627379011;
        bh=Dtrq29VY/2TjbyC6nggbrf8kmghWjyjBq/HFm/fAsZU=;
        h=From:To:Cc:Subject:Date:References:From;
        b=CweXAzvqFEA5zovzBCDtvLo4JQ2O5w78hYTYhRPAEblz6p0kNrmuvLqmDdObcQaWy
         jUjAP07cnCuCZHfKMCawlI/KUDy2FM1ovlkB09ROqfQimWckT5fDkyoQhdufcyZOoO
         UFOzGXf+nw/kS1rc822Fwy+VxB6cfImMNg5kvuZs=
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20210727094330eucas1p2d29edc0ec1d5014cff1103f65d32f1c3~VnJaK-MH73249832498eucas1p2v;
        Tue, 27 Jul 2021 09:43:30 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges3new.samsung.com (EUCPMTA) with SMTP id 5E.60.56448.245DFF06; Tue, 27
        Jul 2021 10:43:30 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20210727094330eucas1p11f9927c305e4cf4a2d5eda067c7a5a46~VnJZsoP0x1958219582eucas1p1U;
        Tue, 27 Jul 2021 09:43:30 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20210727094330eusmtrp23169e0afbff45cb974e3631b3f755c37~VnJZrbCiV2985629856eusmtrp2_;
        Tue, 27 Jul 2021 09:43:30 +0000 (GMT)
X-AuditID: cbfec7f5-d53ff7000002dc80-2b-60ffd542be15
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id 26.05.20981.245DFF06; Tue, 27
        Jul 2021 10:43:30 +0100 (BST)
Received: from localhost (unknown [106.120.51.46]) by eusmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20210727094329eusmtip2730d4842120e33c3a321a7a52e78ea06~VnJZZReg22043020430eusmtip2x;
        Tue, 27 Jul 2021 09:43:29 +0000 (GMT)
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
Subject: [PATCH net-next v15 0/3] AX88796C SPI Ethernet Adapter
Date:   Tue, 27 Jul 2021 11:43:22 +0200
Message-Id: <20210727094325.9189-1-l.stelmach@samsung.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Organization: Samsung R&D Institute Poland
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrIKsWRmVeSWpSXmKPExsWy7djP87pOV/8nGFz/pm5x/u4hZouNM9az
        Wsw538JiMf/IOVaLRe9nsFpce3uH1aL/8Wtmi/PnN7BbXNjWx2px89AKRotNj6+xWlzeNYfN
        Ysb5fUwWh6buZbRYe+Quu8WxBWIWrXuPsDsIely+dpHZY8vKm0weO2fdZffYtKqTzWPzknqP
        nTs+M3n0bVnF6PF5k1wARxSXTUpqTmZZapG+XQJXxpcf+5gKbhpVbFue28B4Ur2LkZNDQsBE
        4uKDh6xdjFwcQgIrGCVebJnMBuF8YZRYsb4XyvnMKNG1cC4zTMuBLZ+gWpYzSvxdOY8RwnnO
        KPHk9gV2kCo2AUeJ/qUnwKpEBO4xS6xvfwBWxSywj1Fi570pYLOEBewlPl44DdbBIqAq0fv+
        BRuIzStgJTHr7k82iH3yEu3Lt0PFBSVOznzCAmLzC2hJrGm6DmYzA9U0b53NDLJAQmAxp8Si
        d6vYIZpdJA48uc4IYQtLvDq+BSouI/F/53ymLkYOILteYvIkM4jeHkaJbXN+sEDUWEvcOfeL
        DaSGWUBTYv0ufYiwo8Th+dOYIVr5JG68FYQ4gU9i0rbpUGFeiY42IYhqFYl1/XugBkpJ9L5a
        AXWMh8SxzvfsExgVZyF5bBaSZ2Yh7F3AyLyKUTy1tDg3PbXYOC+1XK84Mbe4NC9dLzk/dxMj
        MNWd/nf86w7GFa8+6h1iZOJgPMQowcGsJMLrsOJ3ghBvSmJlVWpRfnxRaU5q8SFGaQ4WJXHe
        XVvXxAsJpCeWpGanphakFsFkmTg4pRqY6v0mSC+yOPnflqVa0/2dg33CIo/1f74lvvt5LHfn
        Hp+UTad3vdJdaDFdIv7KQi2Z6OT6K8+u/2ANfGh+Pdvup0WKusdSk4tLl5ZYacWbP+K9V9kw
        5S973AubNdX1p8+tN485k8M5U4Cv+2ncqWjJtC8mTb8tj7LrKtV+nPgnrovzecvhlsd8vXp3
        pH46ychpaUdJKPbqbL18780XBb+0DSJ3s/jb+IW6XpzYaxhjO2HO7CNHvjA4sB7KfHlvB7+N
        oqe2QYhe/2rrTqlGliOFU8R1eQ6fmfnca9bVDxziL8Lbf1Q83lr91tcl8Fe6XuPNynzX0+sP
        N0XvifLa8G05Q0mcwErts3H/c82nyoQosRRnJBpqMRcVJwIAzQYlP+QDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJIsWRmVeSWpSXmKPExsVy+t/xe7pOV/8nGPw+zGJx/u4hZouNM9az
        Wsw538JiMf/IOVaLRe9nsFpce3uH1aL/8Wtmi/PnN7BbXNjWx2px89AKRotNj6+xWlzeNYfN
        Ysb5fUwWh6buZbRYe+Quu8WxBWIWrXuPsDsIely+dpHZY8vKm0weO2fdZffYtKqTzWPzknqP
        nTs+M3n0bVnF6PF5k1wAR5SeTVF+aUmqQkZ+cYmtUrShhZGeoaWFnpGJpZ6hsXmslZGpkr6d
        TUpqTmZZapG+XYJexpcf+5gKbhpVbFue28B4Ur2LkZNDQsBE4sCWT6xdjFwcQgJLGSUOnP/G
        0sXIAZSQklg5Nx2iRljiz7UuNoiap4wS33dPZwVJsAk4SvQvPQHWLCLwhlmi6d5bdhCHWWAf
        o8T+o4vZQaqEBewlPl44DWazCKhK9L5/wQZi8wpYScy6+5MNYoW8RPvy7VBxQYmTM5+AXcEs
        oC6xfp4QSJhfQEtiTdN1FhCbGai8eets5gmMArOQdMxC6JiFpGoBI/MqRpHU0uLc9NxiI73i
        xNzi0rx0veT83E2MwDjdduznlh2MK1991DvEyMTBeIhRgoNZSYTXYcXvBCHelMTKqtSi/Pii
        0pzU4kOMpkAfTGSWEk3OByaKvJJ4QzMDU0MTM0sDU0szYyVxXpMja+KFBNITS1KzU1MLUotg
        +pg4OKUamBImL/Dcsr9h7e+M9V73ErPDNA6Hq54885azVrn26iRnLZ1b8mynXiitWO9wesrc
        DTq/5vy9y9v+9i+fjb06a8zeUFv5U2eF3rDx+agrL5qke93i3Zv44lvxUYoCDOnLNztLbtK5
        VNAbt3iG2h5ppz3v7nvuvfjbcpfD0k1Fb6zNvHV3v2C++qX7UMbh313Nczmq85XU/571yawJ
        5P6cpNDpq/7jnO0T+UUFZz6eOHSWZ+Le909L0va989qSErhK3Y7x2et+Ru7/38/4ylyvLfnU
        cL/Rw1yId0+NRjJP8oep03f3dGVMq63gClmipTXtxgafYzevzhNMCMkz6Hk0QXZOuOVepccC
        Bj0ep2aUlyqxFGckGmoxFxUnAgB6ZYXHXAMAAA==
X-CMS-MailID: 20210727094330eucas1p11f9927c305e4cf4a2d5eda067c7a5a46
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20210727094330eucas1p11f9927c305e4cf4a2d5eda067c7a5a46
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20210727094330eucas1p11f9927c305e4cf4a2d5eda067c7a5a46
References: <CGME20210727094330eucas1p11f9927c305e4cf4a2d5eda067c7a5a46@eucas1p1.samsung.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a driver for AX88796C Ethernet Adapter connected in SPI mode as
found on ARTIK5 evaluation board. The driver has been ported from a
v3.10.9 vendor kernel for ARTIK5 board.

Changes in v15:
  - rebased onto net-next 5.14-rc2 (268ca4129d8d)
  - added explicit cast of le16_to_cpus() argument to u16*
    (reported by: kernel test robot <lkp@intel.com>)
  - removed invalid and superfluous call to u64_stats_init()
    (reported by: Jakub Kicinski <kuba@kernel.org>)
  
Changes in v14:
  - rebased onto net-next 5.14-rc1 (0d6835ffe50c)

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
 drivers/net/ethernet/asix/ax88796c_main.c     | 1148 +++++++++++++++++
 drivers/net/ethernet/asix/ax88796c_main.h     |  568 ++++++++
 drivers/net/ethernet/asix/ax88796c_spi.c      |  115 ++
 drivers/net/ethernet/asix/ax88796c_spi.h      |   69 +
 13 files changed, 2289 insertions(+)
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

