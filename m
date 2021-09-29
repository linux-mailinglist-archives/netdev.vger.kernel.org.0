Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDE4841C65E
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 16:09:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344398AbhI2OK5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 10:10:57 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:53827 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245433AbhI2OK4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 10:10:56 -0400
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20210929140913euoutp02989bfdabf9b029c93d174ad1ffd66625~pUDraUc7I3102631026euoutp02M
        for <netdev@vger.kernel.org>; Wed, 29 Sep 2021 14:09:13 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20210929140913euoutp02989bfdabf9b029c93d174ad1ffd66625~pUDraUc7I3102631026euoutp02M
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1632924553;
        bh=5iBilWNO3P+fklQ7Q2FmLDh2zdgIgVJM371EBVKWiBY=;
        h=From:To:Cc:Subject:Date:References:From;
        b=XYhGoYFCHZ8yxlRoE+3icMkncHVnxNUZYpZgrBNXf+WgqanUFhomxafaRbevZgUKV
         EHGh7fVu+s4VfhLeSQ7kqIGNUuMTsFKdBQZlHAM+c0xAuqMM6y1gRP1WAG5zYPZ7Mb
         t8W2Pgaxg8xnhj61ZCtd1dvaIBpoBtFupccG7tnw=
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20210929140912eucas1p25541d8a11ec79661c76b50efd6c85141~pUDqxCOgm1351713517eucas1p2n;
        Wed, 29 Sep 2021 14:09:12 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges3new.samsung.com (EUCPMTA) with SMTP id C1.A8.56448.88374516; Wed, 29
        Sep 2021 15:09:12 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20210929140912eucas1p2c3a4eac8b6fadd635aec3bbb44e8882e~pUDqTehIA1351613516eucas1p2w;
        Wed, 29 Sep 2021 14:09:12 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20210929140912eusmtrp159129c9cc7f1dfa78b42d6905a22eaae~pUDqSR_nR3235032350eusmtrp1p;
        Wed, 29 Sep 2021 14:09:12 +0000 (GMT)
X-AuditID: cbfec7f5-2e23aa800002dc80-0c-61547388eae3
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id 84.2D.31287.88374516; Wed, 29
        Sep 2021 15:09:12 +0100 (BST)
Received: from localhost (unknown [106.120.51.46]) by eusmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20210929140912eusmtip1f0092fea24473a5f7236a992c576bc91~pUDqC64Mc0338403384eusmtip1J;
        Wed, 29 Sep 2021 14:09:12 +0000 (GMT)
From:   =?UTF-8?q?=C5=81ukasz=20Stelmach?= <l.stelmach@samsung.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        jim.cromie@gmail.com, Heiner Kallweit <hkallweit1@gmail.com>,
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
Subject: [PATCH net-next v16 0/3] AX88796C SPI Ethernet Adapter
Date:   Wed, 29 Sep 2021 16:08:51 +0200
Message-Id: <20210929140854.28535-1-l.stelmach@samsung.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Organization: Samsung R&D Institute Poland
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrEKsWRmVeSWpSXmKPExsWy7djPc7odxSGJBhP36lucv3uI2WLjjPWs
        FnPOt7BYzD9yjtVi0fsZrBbX3t5hteh//JrZ4vz5DewWF7b1sVrcPLSC0WLT42usFpd3zWGz
        mHF+H5PFoal7GS3WHrnLbnFsgZhF694j7A6CHpevXWT22LLyJpPHzll32T02repk89i8pN5j
        547PTB59W1YxenzeJBfAEcVlk5Kak1mWWqRvl8CVsb6jga1gr0nF4iWPWRoY/2p0MXJySAiY
        SLRemcbYxcjFISSwglHi+Y2pbBDOF0aJhRdfMkM4nxklTl6aywLT0tM4E6plOVDV8sWsEM5z
        RonuvzeYQKrYBBwl+peeAEuICNxjlvh07DjYYGaBfYwSO+9NYQapEhawl5jwZA87iM0ioCpx
        dM8WsB28AtYSt5ons0Psk5douz6dESIuKHFy5hOwGn4BLYk1TdfBbGagmuats8GOlRCYzynx
        /EwXG0Szi8Sxu41QtrDEq+NboIbKSJye3APUzAFk10tMnmQG0dvDKLFtzg+oR60l7pz7xQZS
        wyygKbF+lz5E2FFiwZvzjBCtfBI33gpCnMAnMWnbdGaIMK9ER5sQRLWKxLr+PVADpSR6X61g
        hLA9JH5Ous0ygVFxFpLHZiF5ZhbC3gWMzKsYxVNLi3PTU4uN81LL9YoTc4tL89L1kvNzNzEC
        k93pf8e/7mBc8eqj3iFGJg7GQ4wSHMxKIrw/xIMThXhTEiurUovy44tKc1KLDzFKc7AoifPu
        2romXkggPbEkNTs1tSC1CCbLxMEp1cAUnODWIN2t97Fv1vRg28C1Ez5ZHzZNLPwwoX5P0H3N
        uW7li09bWj6+vI/9TERB6eXcR1m/auckZM2Lml57fBPD85lX5y5JFDM8H8jSOddpUtLdpXOk
        d/PLNUXKqVcmz5Dk1yy6MafhVsxsg5gPX++8zjsZcTY5oNg95LjwxH15YpsLY0TEOhSL86Of
        Vthx25yVe3ZUYB8P65krk1wSdx75kcY5YUPSvIqzQoe+pK/okagKmm7idSD0pfG71lbPowlP
        s1zWlrb2h9vsvfx9pRi74BMzh/jXMX2xYi/v5vQ/2L2Ej2marlWV4TnHFVnf3jwM7f4iX3Yi
        9Ia+/Yank+re6t6bWc+hvurWpfRTe7cpsRRnJBpqMRcVJwIAPEF5HuUDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJIsWRmVeSWpSXmKPExsVy+t/xu7odxSGJBpceC1mcv3uI2WLjjPWs
        FnPOt7BYzD9yjtVi0fsZrBbX3t5hteh//JrZ4vz5DewWF7b1sVrcPLSC0WLT42usFpd3zWGz
        mHF+H5PFoal7GS3WHrnLbnFsgZhF694j7A6CHpevXWT22LLyJpPHzll32T02repk89i8pN5j
        547PTB59W1YxenzeJBfAEaVnU5RfWpKqkJFfXGKrFG1oYaRnaGmhZ2RiqWdobB5rZWSqpG9n
        k5Kak1mWWqRvl6CXsb6jga1gr0nF4iWPWRoY/2p0MXJySAiYSPQ0zmTsYuTiEBJYyijxqPkU
        SxcjB1BCSmLl3HSIGmGJP9e62CBqnjJKTO6ewAqSYBNwlOhfegLMFhF4wyzxs1cKpIhZYB+j
        xP6ji9lBEsIC9hITnuwBs1kEVCWO7tnCAmLzClhL3GqezA6xQV6i7fp0Roi4oMTJmU/AjmAW
        UJdYP08IJMwvoCWxpuk6WCszUHnz1tnMExgFZiHpmIXQMQtJ1QJG5lWMIqmlxbnpucWGesWJ
        ucWleel6yfm5mxiBcbrt2M/NOxjnvfqod4iRiYPxEKMEB7OSCO8P8eBEId6UxMqq1KL8+KLS
        nNTiQ4ymQB9MZJYSTc4HJoq8knhDMwNTQxMzSwNTSzNjJXHerXPXxAsJpCeWpGanphakFsH0
        MXFwSjUwxZ6xfMEtG/hZIH75mbZPXgdnz2TlsfD/kPP2yfZJL9on7E838NGaKyTUGxG8gpOz
        r19u49Wl67VWCuZ4cFvuCrJ+uSPs1qRZokKH/mc0njG3kltR6ryL8+D3LJGydYs6tvG+KDli
        e0JuUpbThP8dXc/K95+J2cT3t22e0e+rjQuf75HWqJU+PlPt9mN+tf1xIbd3qe9x+XHnCbtw
        ocSMQ65GB72XL2xK6mdb8FJ4Y/L9gH8mJ/9v4tGzfPpV30DLLyQubMqH3aKKjxNetj/RVb9c
        0uTWtv0te45oXQhHp3zmij0HS8yOHygS1JI7cqcj5cuEdJFXFfo58Xu3rvYVnenXsLjqUNOZ
        6mtNUUFCSizFGYmGWsxFxYkA7Pr42FwDAAA=
X-CMS-MailID: 20210929140912eucas1p2c3a4eac8b6fadd635aec3bbb44e8882e
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20210929140912eucas1p2c3a4eac8b6fadd635aec3bbb44e8882e
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20210929140912eucas1p2c3a4eac8b6fadd635aec3bbb44e8882e
References: <CGME20210929140912eucas1p2c3a4eac8b6fadd635aec3bbb44e8882e@eucas1p2.samsung.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a driver for AX88796C Ethernet Adapter connected in SPI mode as
found on ARTIK5 evaluation board. The driver has been ported from a
v3.10.9 vendor kernel for ARTIK5 board.

Dear David and Jakub, since the driver, despite minor fixes, has
been mostly stable for the past few versions, how do you see the
chances of merging it?

Changes in v16:
  - rebased onto net-next 5.15-rc2 (7fec4d39198b)

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
2.30.2

