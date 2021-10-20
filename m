Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DA3F435294
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 20:24:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231130AbhJTS0p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 14:26:45 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:18274 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230308AbhJTS0o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Oct 2021 14:26:44 -0400
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20211020182428euoutp01e6ed370cfcfb8b558a715c1fd28bca94~v0FiOX8P31602816028euoutp01c
        for <netdev@vger.kernel.org>; Wed, 20 Oct 2021 18:24:28 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20211020182428euoutp01e6ed370cfcfb8b558a715c1fd28bca94~v0FiOX8P31602816028euoutp01c
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1634754268;
        bh=zqQIO3sX4SllQevxjHEgnXnobPF9hUFWnPjUb9D35jw=;
        h=From:To:Cc:Subject:Date:References:From;
        b=vQGEnWid9wzJSsf4GFzY+E0uhxFQHvpUYevNwkBDVBpGw4NRixmydn2nWE8pgezYl
         azVAuA0p2HqPaTQAMiBRAQNju89O5yUPvNQrb7rWN54phXzVSBtKqjVu/h2P1gq3E0
         T+Vu3EbH9jPCIVBO0x9LJabPdNFtVAtyd/Fc+lYo=
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20211020182427eucas1p23f2bcb6bc7f84e8a456ad1eded74884d~v0FhuRlU13157331573eucas1p2P;
        Wed, 20 Oct 2021 18:24:27 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges3new.samsung.com (EUCPMTA) with SMTP id 73.FD.56448.BDE50716; Wed, 20
        Oct 2021 19:24:27 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20211020182427eucas1p1f8409613d882d8247bc3c014c8219b84~v0Fg3y0ia1474514745eucas1p1E;
        Wed, 20 Oct 2021 18:24:27 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20211020182427eusmtrp214fe8a471a7bbd72cd7afc8331ed302e~v0Fg27Et22160521605eusmtrp2b;
        Wed, 20 Oct 2021 18:24:27 +0000 (GMT)
X-AuditID: cbfec7f5-d53ff7000002dc80-c8-61705edbcb39
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id 33.29.20981.ADE50716; Wed, 20
        Oct 2021 19:24:26 +0100 (BST)
Received: from localhost (unknown [106.120.51.46]) by eusmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20211020182426eusmtip29f8543fa97b8199a7d2614c8bfcb3781~v0FgmHmpT3020430204eusmtip2D;
        Wed, 20 Oct 2021 18:24:26 +0000 (GMT)
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
Subject: [PATCH net-next v17 0/3] AX88796C SPI Ethernet Adapter
Date:   Wed, 20 Oct 2021 20:24:19 +0200
Message-Id: <20211020182422.362647-1-l.stelmach@samsung.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Organization: Samsung R&D Institute Poland
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrEKsWRmVeSWpSXmKPExsWy7djPc7q34woSDR4dN7I4f/cQs8XGGetZ
        Leacb2GxmH/kHKvFovczWC2uvb3DatH/+DWzxfnzG9gtLmzrY7W4eWgFo8Wmx9dYLS7vmsNm
        MeP8PiaLQ1P3MlqsPXKX3eLYAjGL1r1H2B0EPS5fu8jssWXlTSaPnbPusntsWtXJ5rF5Sb3H
        zh2fmTz6tqxi9Pi8SS6AI4rLJiU1J7MstUjfLoEr48byL+wFP00qTt6cwNzAuEGzi5GTQ0LA
        ROL85AXMXYxcHEICKxglbmyfzQrhfGGUOP7nNAuE85lRYsrsA6wwLf/PL4BKLGeU+D+5Ear/
        OaPE80/PmUCq2AQcJfqXngCbJSJwj1ni07HjbCAOs8A+Romd96Ywg1QJC9hLfLn6C2wui4Cq
        xPx528C6eQVsJHbeOcEIsU9eou36dEaIuKDEyZlPWEBsfgEtiTVN18FsZqCa5q2zwc6QEFjO
        KfFzaT8zRLOLxLp7d1kgbGGJV8e3sEPYMhL/d84HWsYBZNdLTJ5kBtHbwyixbc4PqHpriTvn
        frGB1DALaEqs36UPEXaUmLDoLStEK5/EjbeCECfwSUzaNp0ZIswr0dEmBFGtIrGufw/UQCmJ
        3lcroL7ykGj+3sY4gVFxFpLHZiF5ZhbC3gWMzKsYxVNLi3PTU4uN81LL9YoTc4tL89L1kvNz
        NzECk93pf8e/7mBc8eqj3iFGJg7GQ4wSHMxKIry7K/IThXhTEiurUovy44tKc1KLDzFKc7Ao
        ifPu2romXkggPbEkNTs1tSC1CCbLxMEp1cDkuM1876OzVwIMTyZp7Sj17Zj46/a/7/lsqUdm
        Sm9hcX/f7vEoy7aysaTuxayulI8PdSSmVEl2mq92+5+VmpLurvdjub2qguhfh1MPlHUKFzHe
        CmJ77HXk/Lc5h5aH1vybU95U88JFdd0qv4f5oZdZONzMctQ0JjBN3hWtdYFfKrMlSeH2Vbl9
        nUvYXacstipboTulUtFpwv60cj+/0z8MGlO6enti7t3IjRNQSfJK2nxz4hwvsduPOE3ynfdV
        p/i+vfnQ45a+/a+t/6csdE1IVH7bLaUctCpEMkCwW1aFpzmzQnvttjJfv3RVnXlL1fzmauzT
        StSq6553zsT7UXnyhJ0Rlts77Mo/bBB+rMRSnJFoqMVcVJwIAJvQ9eXlAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJIsWRmVeSWpSXmKPExsVy+t/xe7q34goSDVbPMbQ4f/cQs8XGGetZ
        Leacb2GxmH/kHKvFovczWC2uvb3DatH/+DWzxfnzG9gtLmzrY7W4eWgFo8Wmx9dYLS7vmsNm
        MeP8PiaLQ1P3MlqsPXKX3eLYAjGL1r1H2B0EPS5fu8jssWXlTSaPnbPusntsWtXJ5rF5Sb3H
        zh2fmTz6tqxi9Pi8SS6AI0rPpii/tCRVISO/uMRWKdrQwkjP0NJCz8jEUs/Q2DzWyshUSd/O
        JiU1J7MstUjfLkEv48byL+wFP00qTt6cwNzAuEGzi5GTQ0LAROL/+QUsXYxcHEICSxkltlx4
        x97FyAGUkJJYOTcdokZY4s+1LjaImqeMEheOLmEDSbAJOEr0Lz3BCmKLCLxhlvjZKwVSxCyw
        j1Fi/9HF7CAJYQF7iS9Xf4EVsQioSsyft40JxOYVsJHYeecEI8QGeYm269MZIeKCEidnPmEB
        OYJZQF1i/TwhkDC/gJbEmqbrLCA2M1B589bZzBMYBWYh6ZiF0DELSdUCRuZVjCKppcW56bnF
        RnrFibnFpXnpesn5uZsYgXG67djPLTsYV776qHeIkYmD8RCjBAezkgjv7or8RCHelMTKqtSi
        /Pii0pzU4kOMpkAfTGSWEk3OByaKvJJ4QzMDU0MTM0sDU0szYyVxXpMja+KFBNITS1KzU1ML
        Uotg+pg4OKUamBIvzrhTPHFJgQDj0oSysy58h8q+5H49KyG/ofNW5ZH/a0/8feYlct568feV
        D5q+M907c7F6osCCZXccI2dN9NJawOx+WUCT03J1lKO6q8kp99LHs+eJlLezTvtueMrD9vsu
        KTOdlOfWa9nfzzG4ms1+4ZNM2L/Mt5dLGZwcnz5Ob0w3UL+zR9ZCSWCvF19XeOxc6RnqF7/f
        2u3oznlp+bJJf8JSytjPvEgPTvM5dNRzx4uulp+PCk4najY9feddK+LUFb67+ERvh/TOZXI9
        J09leTu4/uzK88h2eneJ70PxlYin100qXyUcMtE7VV9y/6n84ltu+VnTT4sKvKuNjJpicaq3
        97/M6eef9jQppSqxFGckGmoxFxUnAgBpohjYXAMAAA==
X-CMS-MailID: 20211020182427eucas1p1f8409613d882d8247bc3c014c8219b84
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20211020182427eucas1p1f8409613d882d8247bc3c014c8219b84
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20211020182427eucas1p1f8409613d882d8247bc3c014c8219b84
References: <CGME20211020182427eucas1p1f8409613d882d8247bc3c014c8219b84@eucas1p1.samsung.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a driver for AX88796C Ethernet Adapter connected in SPI mode as
found on ARTIK5 evaluation board. The driver has been ported from a
v3.10.9 vendor kernel for ARTIK5 board.

Changes in v17:
  - marked no_regs_list as const
  - added myself as MODULE_AUTHOR()
  - rearranged locking in ax88796c_close() to prevent race condition in
    case ax88796c_work() wakes the queue after trasmission.

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
  - introduced new ethtool tunable "spi-compression" to control SPI
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
 drivers/net/ethernet/asix/ax88796c_main.c     | 1163 +++++++++++++++++
 drivers/net/ethernet/asix/ax88796c_main.h     |  568 ++++++++
 drivers/net/ethernet/asix/ax88796c_spi.c      |  115 ++
 drivers/net/ethernet/asix/ax88796c_spi.h      |   69 +
 13 files changed, 2304 insertions(+)
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

