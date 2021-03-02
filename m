Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D22632B390
	for <lists+netdev@lfdr.de>; Wed,  3 Mar 2021 05:19:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1449733AbhCCECr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 23:02:47 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:56314 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1575677AbhCBPYH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Mar 2021 10:24:07 -0500
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20210302152253euoutp028d8e6ae46bb08bf92d21e3abd37973b5~oj8wSFGOE0237402374euoutp02B
        for <netdev@vger.kernel.org>; Tue,  2 Mar 2021 15:22:53 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20210302152253euoutp028d8e6ae46bb08bf92d21e3abd37973b5~oj8wSFGOE0237402374euoutp02B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1614698573;
        bh=PDhPG6F2JVOl+FZBvVP4J+pRPm7llFINspDeIOQgnHY=;
        h=From:To:Cc:Subject:Date:References:From;
        b=vGNYz8UyGWvWw5L5cTv/Y4jJMKPd4YPL30sO7eqjUK66mH3VMhFjSpp3FfvFGEjRs
         H/+8SyfG2rKx3Vv2zBz9bSJHoVhqNHm8uyY1Es08M/PFVY4TZRTte8K6e1GeKjgh6a
         vufR0faXrOiZKUPo5azUqBbWfAGAs7OcVyKSLYRI=
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20210302152252eucas1p1d0da83111d0a87f9812957288da74a0c~oj8vidkpf2322423224eucas1p1W;
        Tue,  2 Mar 2021 15:22:52 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges2new.samsung.com (EUCPMTA) with SMTP id 59.BF.44805.C485E306; Tue,  2
        Mar 2021 15:22:52 +0000 (GMT)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20210302152251eucas1p130e8bf7bb2772ba46f0e5a2119f9be00~oj8vKI5I92322423224eucas1p1U;
        Tue,  2 Mar 2021 15:22:51 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20210302152251eusmtrp1c5814cd36da71e97f92b276c8ab2ad22~oj8vJaRgD1781617816eusmtrp14;
        Tue,  2 Mar 2021 15:22:51 +0000 (GMT)
X-AuditID: cbfec7f4-b37ff7000000af05-dc-603e584c9d40
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id 46.A2.21957.B485E306; Tue,  2
        Mar 2021 15:22:51 +0000 (GMT)
Received: from localhost (unknown [106.120.51.46]) by eusmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20210302152251eusmtip2fff3f36f2525c37b0e54456745f2bd87~oj8u8BoX91948819488eusmtip2h;
        Tue,  2 Mar 2021 15:22:51 +0000 (GMT)
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
Subject: [RESEND PATCH v11 0/3] AX88796C SPI Ethernet Adapter
Date:   Tue,  2 Mar 2021 16:22:47 +0100
Message-Id: <20210302152250.27113-1-l.stelmach@samsung.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Organization: Samsung R&D Institute Poland
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrPKsWRmVeSWpSXmKPExsWy7djPc7o+EXYJBlc/clmcv3uI2WLjjPWs
        FnPOt7BYzD9yjtVi0fsZrBbX3t5hteh//JrZ4vz5DewWF7b1sVrcPLSC0WLT42usFpd3zWGz
        mHF+H5PFoal7GS3WHrnLbnFsgZhF694j7A6CHpevXWT22LLyJpPHzll32T02repk89i8pN5j
        547PTB59W1YxenzeJBfAEcVlk5Kak1mWWqRvl8CV0fh3JUvBCd2KdevWsDQwHlDuYuTkkBAw
        kbh6fRlLFyMXh5DACkaJKRtWMkE4Xxglfp78ywjhfGaUaHuwnhWmpXvqC6iW5YwS/548g6p6
        zijxYeEqNpAqNgFHif6lJ1hBEiIC95gl1rc/AKtiFtjHKLHz3hRmkCphAVuJS4+nsHcxcnCw
        CKhKLGkTAQnzClhLzFrYwwaxTl6iffl2Noi4oMTJmU9YQGx+AS2JNU3XwWxmoJrmrbOZQeZL
        CCzmlHjx4xoTRLOLxI7jXxghbGGJV8e3sEPYMhKnJ/ewgOyVEKiXmDzJDKK3h1Fi25wfLBA1
        1hJ3zv1iA6lhFtCUWL9LH6LcUeLx1XgIk0/ixltBiAv4JCZtm84MEeaV6GgTgpihIrGufw/U
        PCmJ3lcrGCFKPCQmzcucwKg4C8lbs5C8Mgth6wJG5lWM4qmlxbnpqcVGeanlesWJucWleel6
        yfm5mxiBae70v+NfdjAuf/VR7xAjEwfjIUYJDmYlEV7xl7YJQrwpiZVVqUX58UWlOanFhxil
        OViUxHmTtqyJFxJITyxJzU5NLUgtgskycXBKNTAt2WjHoa4R4yvNN+NB2fbi339/erA8en4x
        oEMv/PG5xVX/9C19zD6dOdEbtTwobZcoby6r3+/n4ac1BKxNHr5rmPZ8su3nuK8CRu8e7d2S
        dVBR7cdWwW3zjJYujedm8rsmOyFqyZcJoduMYidPeboo+trNbo4SxVld29g02sqNIltWs/pP
        mR23Ms1007l9BXrlC7rvaUy82b1R2WLNwlqx/t4JPZIpYXdXcLAIn21Zvk937XPdxpVltpqW
        DD9edJUcOPXh7qlz5hcCfeelGK5iXR4S1f9YuezSiYmMSnKaU5M3vJWffHWnrPZfeW0ZizDR
        rWmKzrked+ouMpnb3pN9KmP2tHzyyv/SfkG7vQuUWIozEg21mIuKEwG1q6Q04gMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJIsWRmVeSWpSXmKPExsVy+t/xe7reEXYJBjd36Fmcv3uI2WLjjPWs
        FnPOt7BYzD9yjtVi0fsZrBbX3t5hteh//JrZ4vz5DewWF7b1sVrcPLSC0WLT42usFpd3zWGz
        mHF+H5PFoal7GS3WHrnLbnFsgZhF694j7A6CHpevXWT22LLyJpPHzll32T02repk89i8pN5j
        547PTB59W1YxenzeJBfAEaVnU5RfWpKqkJFfXGKrFG1oYaRnaGmhZ2RiqWdobB5rZWSqpG9n
        k5Kak1mWWqRvl6CX0fh3JUvBCd2KdevWsDQwHlDuYuTkkBAwkeie+oKli5GLQ0hgKaPEn/u3
        2bsYOYASUhIr56ZD1AhL/LnWxQZR85RR4lXrXEaQBJuAo0T/0hOsIAkRgTfMEk333rKDOMwC
        +xgl9h9dzA5SJSxgK3Hp8RSwqSwCqhJL2kRAwrwC1hKzFvawQWyQl2hfvp0NIi4ocXLmExaQ
        cmYBdYn184RAwvwCWhJrmq6zgNjMQOXNW2czT2AUmIWkYxZCxywkVQsYmVcxiqSWFuem5xYb
        6hUn5haX5qXrJefnbmIExum2Yz8372Cc9+qj3iFGJg7GQ4wSHMxKIrziL20ThHhTEiurUovy
        44tKc1KLDzGaAj0wkVlKNDkfmCjySuINzQxMDU3MLA1MLc2MlcR5t85dEy8kkJ5YkpqdmlqQ
        WgTTx8TBKdXAVBzQdimbg1X8rMfuExVap2c3HS06EPTrYNzKyefWlk1V8ZA5EB1metSKr+j8
        4oPHOwz/rfBJDPkrvDdz673ScLeCmBeFugv+P52Tuuv3t+CX8mwWnQ6fwrZvyrmdXVu5tnzj
        6ZC7m9+uLglZdfngAbV7glMLyw++Sdhkt+Psjz/5mmn6l5a9SUlqFxCU27fXZ+8cHde4sn2f
        FzBvnc1keFd5376la+LX627+uD+G/f/f1QeN7I+r+RnJ9v5nVhW/Y7SeYz6H96a7yndVNooU
        SWqJbJbo9Q9f/6Dd2P1NxYSzKnHcfAGR37d2fxf8pKTEetp81p7epT/zjb+lv+IXcbSMXNbv
        EMkobrmh6emPc0osxRmJhlrMRcWJAKgSJrlcAwAA
X-CMS-MailID: 20210302152251eucas1p130e8bf7bb2772ba46f0e5a2119f9be00
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20210302152251eucas1p130e8bf7bb2772ba46f0e5a2119f9be00
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20210302152251eucas1p130e8bf7bb2772ba46f0e5a2119f9be00
References: <CGME20210302152251eucas1p130e8bf7bb2772ba46f0e5a2119f9be00@eucas1p1.samsung.com>
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

