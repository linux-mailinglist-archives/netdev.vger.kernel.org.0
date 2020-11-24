Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12DF22C253D
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 13:05:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733274AbgKXMDy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 07:03:54 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:51385 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733263AbgKXMDx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Nov 2020 07:03:53 -0500
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20201124120341euoutp0260e2988c491aec1de58053550c94be6c~KcA3RkjfD2523225232euoutp02g
        for <netdev@vger.kernel.org>; Tue, 24 Nov 2020 12:03:41 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20201124120341euoutp0260e2988c491aec1de58053550c94be6c~KcA3RkjfD2523225232euoutp02g
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1606219421;
        bh=YJwwZT+jo9L5l/xiseHfV1MXYo4KzfpXBbVtn/uCpjc=;
        h=From:To:Cc:Subject:Date:References:From;
        b=dDgJuwr4OXrSE3xfFIjK7IAK76ScXaGtHhC1hGCULBsDhVKpJCj6MzauvYLgkGVnQ
         DUlNlm12ZR+ZLkWf6/SjixER73OYqrhaqridOL7d/nxi5RPnSu20560RbdieSQvJdm
         EANXMh7ceSMlDwmTst0Jh6F44f4cZM2wK7RwkcGo=
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20201124120336eucas1p20b2948b5ae5c334c6455edfd5298d094~KcAyaa3XK2294422944eucas1p23;
        Tue, 24 Nov 2020 12:03:36 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges1new.samsung.com (EUCPMTA) with SMTP id BD.63.27958.896FCBF5; Tue, 24
        Nov 2020 12:03:36 +0000 (GMT)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20201124120336eucas1p20710fdff8434428ea0f011b02249b8a8~KcAyC17_U2906629066eucas1p2f;
        Tue, 24 Nov 2020 12:03:36 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20201124120336eusmtrp24e22f53027c87a0b435f61585d6d876f~KcAyAjuEz3019630196eusmtrp2T;
        Tue, 24 Nov 2020 12:03:36 +0000 (GMT)
X-AuditID: cbfec7f2-efdff70000006d36-5d-5fbcf6987d4d
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id 58.2C.16282.796FCBF5; Tue, 24
        Nov 2020 12:03:35 +0000 (GMT)
Received: from localhost (unknown [106.120.51.46]) by eusmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20201124120335eusmtip24e15a81771d0f07ac6f51fb462b078a8~KcAxxIb9h2324723247eusmtip2U;
        Tue, 24 Nov 2020 12:03:35 +0000 (GMT)
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
Subject: [PATCH v7 0/3] AX88796C SPI Ethernet Adapter
Date:   Tue, 24 Nov 2020 13:03:27 +0100
Message-Id: <20201124120330.32445-1-l.stelmach@samsung.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Organization: Samsung R&D Institute Poland
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA02ScUwbVRzHfb1ee63rOA7CfikLakUTZmRsc+ZFiA4z421/LIvGmDhjrd2l
        4GhLrjCZVSFujJUIxTFi6cpKzJYyYDCg1pXBZi7NYA64IQ3CWIkyjY6NgSuwSUaVchj33+f9
        3uf7fr9f8iiCGSK1VL6liOMthgKdQi0PXPlbfNG12KPPqltOxWJEIHCHq53EHvGIHHtDQyT+
        dtZF4tGZmyR23rpDYFE8r8TXA9UkHheaEO68NUrikW6PArvESzIs1PUifC4UUeIrjSm4vDek
        3JHIjowOE6z/7LiMDbojSraz2aFgu06XssELURlb7W9GbLQzbS/1njpnP1eQf5DjN7/6oTpv
        xDFLFp5KL+mqe0SWoaqNlYiigH4JgkvmSqSiGLoJwdRwaSVSr/A8gvO9N+TSRRSBUFMY57jf
        1RGWS5IPgbftISFJfyC4N5gQZwWdC84z/WRcSqYnCWiv+AXFDwR9CUFw8sRqIoneDtW3KxVx
        ltPPgbNvdLWuobPhesRBSO2eggrf9wqpnghX639bHSmB3gStX/68ysSKc/i7k0S8AdA+Ffhq
        Hq2Fd4IrWENKnATTfX6lxBvhn6BXJu1fCrXHX5ayXyEIeB7KJScbbg4tKeIOQWdAe/dmqZwL
        HT/eXYuuh7GZRGmE9XA88A0hlTVw7Cgj2enQ5uxZe1ALVdNNSGIWnANLqAY9435sMfdjy7j/
        79uIiGa0gSu2mU2cbYuF+yTTZjDbii2mTKPV3IlWvty1WN/9C6hh+q9MAckoJCCgCF2ypjwt
        qGc0+w2HPuV4q54vLuBsAkql5LoNmuaTrXqGNhmKuAMcV8jx/93KKJW2TPaan8nVaYus3sOx
        O+1jZwKH+C/qI+ktI/YU70KMHzv2Qg7f8Mrrb5WZco05Hye1bC0hH+x7fmEs3FZvf/9g2u45
        ZIzlmcL4oqkryniemOQvltxYzDZ6wl8LhqdTfE2f+7aFMokdE2838leFy6knfkh/c+/Wqdmj
        5AHZk6o9DxZ2/T4ZSiiwVn0wH1Wr8q0TYvmRCud4w74/S7pbY9fW1WZRJrO79SNx4lwt86xl
        V8o90ZN6Nznbbndr55y9PegnP6Nv6/ecTosM4uCcEF46u2fxs+V1Wb+Wzrx737F9Z1HGXEPG
        Gy0Ddmpq2Lf8Tv9ujX3b7UGHccAy0DFvHbqco5Pb8gxbNhG8zfAv8w4qdeEDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFIsWRmVeSWpSXmKPExsVy+t/xe7rTv+2JN1h72sbi/N1DzBYbZ6xn
        tZhzvoXFYv6Rc6wWi97PYLW49vYOq0X/49fMFufPb2C3uLCtj9Xi5qEVjBabHl9jtbi8aw6b
        xYzz+5gsDk3dy2ix9shddotjC8QsWvceYXcQ9Lh87SKzx5aVN5k8ds66y+6xaVUnm8fmJfUe
        O3d8ZvLo27KK0ePzJrkAjig9m6L80pJUhYz84hJbpWhDCyM9Q0sLPSMTSz1DY/NYKyNTJX07
        m5TUnMyy1CJ9uwS9jMud71kL5qlUbJ76h7WBsVemi5GTQ0LARGLzxissXYxcHEICSxkllq14
        yt7FyAGUkJJYOTcdokZY4s+1LjaImqeMEvPXP2EESbAJOEr0Lz3BCpIQEXjDLNF07y07iMMs
        sI9RYv/RxewgVcICphJ9L0HaOTlYBFQl+o9fYwaxeQWsJS7c7WSGWCEv0b58OxtEXFDi5Mwn
        LCBXMAuoS6yfJwQS5hfQkljTdJ0FxGYGKm/eOpt5AqPALCQdsxA6ZiGpWsDIvIpRJLW0ODc9
        t9hIrzgxt7g0L10vOT93EyMwUrcd+7llB+PKVx/1DjEycTAeYpTgYFYS4W2V2xkvxJuSWFmV
        WpQfX1Sak1p8iNEU6IOJzFKiyfnAVJFXEm9oZmBqaGJmaWBqaWasJM5rcmRNvJBAemJJanZq
        akFqEUwfEwenVAOT9pQD4fuOcLKbd3dfyO1muTah0SJm3dVFmoob/OZY+gesW8ko/WdHyZSY
        twf3+T65f/9HB4NGsmy5T10yh4x/rPWDqBPuEU+esJv5nssTmHDMXmSyfYXXpoU25YFhSjsW
        r1nRWRQYfPE0t5a8UMrd9YcbnZ6XPHxkKL4+/F61871H0Ztefs+U/RuylIHn6cp/L3Nkn7sL
        SGs+376zzF/+0meN03d5bVRfnrJNvX5komLNin7jfFZlto4PsYGXHu9mSb8VeSHo1oqJFdvY
        1r6VN200P6bdahljznXoknJO48eJLT/L1t0s6Dd+LsmbH/nz8I18pc2BMt4+Vy/rCpqknNB7
        8rrm6m6HjI93o72VWIozEg21mIuKEwETPcPxXQMAAA==
X-CMS-MailID: 20201124120336eucas1p20710fdff8434428ea0f011b02249b8a8
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20201124120336eucas1p20710fdff8434428ea0f011b02249b8a8
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20201124120336eucas1p20710fdff8434428ea0f011b02249b8a8
References: <CGME20201124120336eucas1p20710fdff8434428ea0f011b02249b8a8@eucas1p2.samsung.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a driver for AX88796C Ethernet Adapter connected in SPI mode as
found on ARTIK5 evaluation board. The driver has been ported from a
v3.10.9 vendor kernel for ARTIK5 board.

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
 drivers/net/ethernet/asix/ax88796c_ioctl.c    |  221 ++++
 drivers/net/ethernet/asix/ax88796c_ioctl.h    |   26 +
 drivers/net/ethernet/asix/ax88796c_main.c     | 1132 +++++++++++++++++
 drivers/net/ethernet/asix/ax88796c_main.h     |  561 ++++++++
 drivers/net/ethernet/asix/ax88796c_spi.c      |  112 ++
 drivers/net/ethernet/asix/ax88796c_spi.h      |   69 +
 include/uapi/linux/ethtool.h                  |    1 +
 net/ethtool/common.c                          |    1 +
 15 files changed, 2247 insertions(+)
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

