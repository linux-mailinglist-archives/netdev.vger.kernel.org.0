Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A96D41C189F
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 16:57:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730437AbgEAOsO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 10:48:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:52646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729352AbgEAOpI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 May 2020 10:45:08 -0400
Received: from mail.kernel.org (ip5f5ad5c5.dynamic.kabel-deutschland.de [95.90.213.197])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 13CC324959;
        Fri,  1 May 2020 14:45:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588344305;
        bh=pgEeloihUJtDW9NEkL6jmFDK/ZInSPDNQO7niKknL3E=;
        h=From:To:Cc:Subject:Date:From;
        b=SVEs1VMhjyuHELBkXcF4/1fWlbsaS7MgiAohJ3ePux485XSRhFIw+LT9CMyjWvZFi
         ihz7fPrKmb/CyIscv5iZo1ghZ6L6por1RndA5qbcxiN/hqpCEtOv80OoyKzd7LfsEg
         e5L/qaobT9VXcglAQbs4CKkx5QoFsFVnzoG5mfmc=
Received: from mchehab by mail.kernel.org with local (Exim 4.92.3)
        (envelope-from <mchehab@kernel.org>)
        id 1jUWuT-00FCcS-77; Fri, 01 May 2020 16:45:01 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Samuel Chessman <chessman@tux.org>, netdev@vger.kernel.org,
        Andrew Hendry <andrew.hendry@gmail.com>,
        Zorik Machulsky <zorik@amazon.com>,
        Sean Tranchetti <stranche@codeaurora.org>,
        Igor Russkikh <irusskikh@marvell.com>,
        Jon Mason <jdmason@kudzu.us>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        linux-x25@vger.kernel.org, Wei Liu <wei.liu@kernel.org>,
        linux-hyperv@vger.kernel.org, Kalle Valo <kvalo@codeaurora.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        David Ahern <dsahern@kernel.org>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Ishizaki Kou <kou.ishizaki@toshiba.co.jp>,
        Joerg Reuter <jreuter@yaina.de>,
        Saeed Bishara <saeedb@amazon.com>,
        Shrijeet Mukherjee <shrijeet@gmail.com>,
        Netanel Belgazal <netanel@amazon.com>,
        Stanislav Yakovlev <stas.yakovlev@gmail.com>,
        Guy Tzalik <gtzalik@amazon.com>,
        Maxim Krasnyansky <maxk@qti.qualcomm.com>,
        Arthur Kiyanovski <akiyano@amazon.com>,
        linux-wireless@vger.kernel.org, linux-hams@vger.kernel.org,
        linux-parisc@vger.kernel.org,
        Steffen Klassert <klassert@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Stephen Hemminger <sthemmin@microsoft.com>
Subject: [PATCH 00/37]net: manually convert files to ReST format - part 3 (final)
Date:   Fri,  1 May 2020 16:44:22 +0200
Message-Id: <cover.1588344146.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

That's the third part (and the final one) of my work to convert the networking
text files into ReST. it is based on linux-next next-20200430 branch.

The full series (including those ones) are at:

	https://git.linuxtv.org/mchehab/experimental.git/log/?h=net-docs

The  built output documents, on html format is at:

	https://www.infradead.org/~mchehab/kernel_docs/networking/


Mauro Carvalho Chehab (37):
  docs: networking: convert tuntap.txt to ReST
  docs: networking: convert udplite.txt to ReST
  docs: networking: convert vrf.txt to ReST
  docs: networking: convert vxlan.txt to ReST
  docs: networking: convert x25-iface.txt to ReST
  docs: networking: convert x25.txt to ReST
  docs: networking: convert xfrm_device.txt to ReST
  docs: networking: convert xfrm_proc.txt to ReST
  docs: networking: convert xfrm_sync.txt to ReST
  docs: networking: convert xfrm_sysctl.txt to ReST
  docs: networking: convert z8530drv.txt to ReST
  docs: networking: device drivers: convert 3com/3c509.txt to ReST
  docs: networking: device drivers: convert 3com/vortex.txt to ReST
  docs: networking: device drivers: convert amazon/ena.txt to ReST
  docs: networking: device drivers: convert aquantia/atlantic.txt to
    ReST
  docs: networking: device drivers: convert chelsio/cxgb.txt to ReST
  docs: networking: device drivers: convert cirrus/cs89x0.txt to ReST
  docs: networking: device drivers: convert davicom/dm9000.txt to ReST
  docs: networking: device drivers: convert dec/de4x5.txt to ReST
  docs: networking: device drivers: convert dec/dmfe.txt to ReST
  docs: networking: device drivers: convert dlink/dl2k.txt to ReST
  docs: networking: device drivers: convert freescale/dpaa.txt to ReST
  docs: networking: device drivers: convert freescale/gianfar.txt to
    ReST
  docs: networking: device drivers: convert intel/ipw2100.txt to ReST
  docs: networking: device drivers: convert intel/ipw2200.txt to ReST
  docs: networking: device drivers: convert microsoft/netvsc.txt to ReST
  docs: networking: device drivers: convert neterion/s2io.txt to ReST
  docs: networking: device drivers: convert neterion/vxge.txt to ReST
  docs: networking: device drivers: convert qualcomm/rmnet.txt to ReST
  docs: networking: device drivers: convert sb1000.txt to ReST
  docs: networking: device drivers: convert smsc/smc9.txt to ReST
  docs: networking: device drivers: convert ti/cpsw_switchdev.txt to
    ReST
  docs: networking: device drivers: convert ti/cpsw.txt to ReST
  docs: networking: device drivers: convert ti/tlan.txt to ReST
  docs: networking: device drivers: convert toshiba/spider_net.txt to
    ReST
  net: docs: add page_pool.rst to index.rst
  docs: networking: arcnet-hardware.rst: don't duplicate chapter names

 Documentation/networking/arcnet-hardware.rst  |   8 +-
 .../3com/{3c509.txt => 3c509.rst}             | 158 +++--
 .../3com/{vortex.txt => vortex.rst}           | 223 ++++---
 .../amazon/{ena.txt => ena.rst}               | 142 ++--
 .../aquantia/{atlantic.txt => atlantic.rst}   | 373 ++++++-----
 .../chelsio/{cxgb.txt => cxgb.rst}            | 183 ++++--
 .../cirrus/{cs89x0.txt => cs89x0.rst}         | 557 ++++++++--------
 .../davicom/{dm9000.txt => dm9000.rst}        |  24 +-
 .../dec/{de4x5.txt => de4x5.rst}              | 105 +--
 .../device_drivers/dec/{dmfe.txt => dmfe.rst} |  35 +-
 .../dlink/{dl2k.txt => dl2k.rst}              | 228 ++++---
 .../freescale/{dpaa.txt => dpaa.rst}          | 139 ++--
 .../freescale/{gianfar.txt => gianfar.rst}    |  21 +-
 .../networking/device_drivers/index.rst       |  24 +
 .../intel/{ipw2100.txt => ipw2100.rst}        | 242 ++++---
 .../intel/{ipw2200.txt => ipw2200.rst}        | 410 +++++++-----
 .../microsoft/{netvsc.txt => netvsc.rst}      |  57 +-
 .../device_drivers/neterion/s2io.rst          | 196 ++++++
 .../device_drivers/neterion/s2io.txt          | 141 ----
 .../neterion/{vxge.txt => vxge.rst}           |  60 +-
 .../qualcomm/{rmnet.txt => rmnet.rst}         |  43 +-
 .../networking/device_drivers/sb1000.rst      | 222 +++++++
 .../networking/device_drivers/sb1000.txt      | 207 ------
 .../networking/device_drivers/smsc/smc9.rst   |  49 ++
 .../networking/device_drivers/smsc/smc9.txt   |  42 --
 .../networking/device_drivers/ti/cpsw.rst     | 587 +++++++++++++++++
 .../networking/device_drivers/ti/cpsw.txt     | 541 ----------------
 ...{cpsw_switchdev.txt => cpsw_switchdev.rst} | 239 ++++---
 .../device_drivers/ti/{tlan.txt => tlan.rst}  |  73 ++-
 .../{spider_net.txt => spider_net.rst}        |  58 +-
 Documentation/networking/index.rst            |  12 +
 .../networking/{tuntap.txt => tuntap.rst}     | 200 +++---
 .../networking/{udplite.txt => udplite.rst}   | 175 ++---
 Documentation/networking/vrf.rst              | 451 +++++++++++++
 Documentation/networking/vrf.txt              | 418 ------------
 .../networking/{vxlan.txt => vxlan.rst}       |  33 +-
 .../{x25-iface.txt => x25-iface.rst}          |  10 +-
 Documentation/networking/{x25.txt => x25.rst} |   4 +
 .../{xfrm_device.txt => xfrm_device.rst}      |  33 +-
 .../{xfrm_proc.txt => xfrm_proc.rst}          |  31 +
 .../{xfrm_sync.txt => xfrm_sync.rst}          |  66 +-
 .../{xfrm_sysctl.txt => xfrm_sysctl.rst}      |   7 +
 .../networking/{z8530drv.txt => z8530drv.rst} | 609 +++++++++---------
 MAINTAINERS                                   |  30 +-
 drivers/net/Kconfig                           |   4 +-
 drivers/net/ethernet/3com/3c59x.c             |   4 +-
 drivers/net/ethernet/3com/Kconfig             |   2 +-
 drivers/net/ethernet/chelsio/Kconfig          |   2 +-
 drivers/net/ethernet/cirrus/Kconfig           |   2 +-
 drivers/net/ethernet/dec/tulip/Kconfig        |   4 +-
 drivers/net/ethernet/dlink/dl2k.c             |   2 +-
 drivers/net/ethernet/neterion/Kconfig         |   4 +-
 drivers/net/ethernet/smsc/Kconfig             |   4 +-
 drivers/net/ethernet/ti/Kconfig               |   2 +-
 drivers/net/ethernet/ti/tlan.c                |   2 +-
 drivers/net/hamradio/Kconfig                  |   4 +-
 drivers/net/hamradio/scc.c                    |   2 +-
 drivers/net/wireless/intel/ipw2x00/Kconfig    |   4 +-
 drivers/net/wireless/intel/ipw2x00/ipw2100.c  |   2 +-
 include/uapi/linux/if_x25.h                   |   2 +-
 net/x25/Kconfig                               |   4 +-
 61 files changed, 4175 insertions(+), 3341 deletions(-)
 rename Documentation/networking/device_drivers/3com/{3c509.txt => 3c509.rst} (68%)
 rename Documentation/networking/device_drivers/3com/{vortex.txt => vortex.rst} (72%)
 rename Documentation/networking/device_drivers/amazon/{ena.txt => ena.rst} (86%)
 rename Documentation/networking/device_drivers/aquantia/{atlantic.txt => atlantic.rst} (63%)
 rename Documentation/networking/device_drivers/chelsio/{cxgb.txt => cxgb.rst} (81%)
 rename Documentation/networking/device_drivers/cirrus/{cs89x0.txt => cs89x0.rst} (61%)
 rename Documentation/networking/device_drivers/davicom/{dm9000.txt => dm9000.rst} (92%)
 rename Documentation/networking/device_drivers/dec/{de4x5.txt => de4x5.rst} (78%)
 rename Documentation/networking/device_drivers/dec/{dmfe.txt => dmfe.rst} (68%)
 rename Documentation/networking/device_drivers/dlink/{dl2k.txt => dl2k.rst} (59%)
 rename Documentation/networking/device_drivers/freescale/{dpaa.txt => dpaa.rst} (79%)
 rename Documentation/networking/device_drivers/freescale/{gianfar.txt => gianfar.rst} (82%)
 rename Documentation/networking/device_drivers/intel/{ipw2100.txt => ipw2100.rst} (70%)
 rename Documentation/networking/device_drivers/intel/{ipw2200.txt => ipw2200.rst} (64%)
 rename Documentation/networking/device_drivers/microsoft/{netvsc.txt => netvsc.rst} (83%)
 create mode 100644 Documentation/networking/device_drivers/neterion/s2io.rst
 delete mode 100644 Documentation/networking/device_drivers/neterion/s2io.txt
 rename Documentation/networking/device_drivers/neterion/{vxge.txt => vxge.rst} (80%)
 rename Documentation/networking/device_drivers/qualcomm/{rmnet.txt => rmnet.rst} (73%)
 create mode 100644 Documentation/networking/device_drivers/sb1000.rst
 delete mode 100644 Documentation/networking/device_drivers/sb1000.txt
 create mode 100644 Documentation/networking/device_drivers/smsc/smc9.rst
 delete mode 100644 Documentation/networking/device_drivers/smsc/smc9.txt
 create mode 100644 Documentation/networking/device_drivers/ti/cpsw.rst
 delete mode 100644 Documentation/networking/device_drivers/ti/cpsw.txt
 rename Documentation/networking/device_drivers/ti/{cpsw_switchdev.txt => cpsw_switchdev.rst} (51%)
 rename Documentation/networking/device_drivers/ti/{tlan.txt => tlan.rst} (73%)
 rename Documentation/networking/device_drivers/toshiba/{spider_net.txt => spider_net.rst} (88%)
 rename Documentation/networking/{tuntap.txt => tuntap.rst} (58%)
 rename Documentation/networking/{udplite.txt => udplite.rst} (65%)
 create mode 100644 Documentation/networking/vrf.rst
 delete mode 100644 Documentation/networking/vrf.txt
 rename Documentation/networking/{vxlan.txt => vxlan.rst} (73%)
 rename Documentation/networking/{x25-iface.txt => x25-iface.rst} (96%)
 rename Documentation/networking/{x25.txt => x25.rst} (96%)
 rename Documentation/networking/{xfrm_device.txt => xfrm_device.rst} (92%)
 rename Documentation/networking/{xfrm_proc.txt => xfrm_proc.rst} (95%)
 rename Documentation/networking/{xfrm_sync.txt => xfrm_sync.rst} (82%)
 rename Documentation/networking/{xfrm_sysctl.txt => xfrm_sysctl.rst} (52%)
 rename Documentation/networking/{z8530drv.txt => z8530drv.rst} (57%)

-- 
2.25.4


