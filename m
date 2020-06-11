Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A002B1F6CD4
	for <lists+netdev@lfdr.de>; Thu, 11 Jun 2020 19:31:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726862AbgFKRbZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jun 2020 13:31:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:55126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726456AbgFKRbW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Jun 2020 13:31:22 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 69168206DC;
        Thu, 11 Jun 2020 17:31:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591896681;
        bh=epLQgqCCMc6g1QYTcRx4btVzFPqkswzQq6HCNv/Cr0w=;
        h=From:To:Cc:Subject:Date:From;
        b=Wu+mvDVGlt+H6q8Luh56yvCDixD1TYQ3yL15SgameEEFRlK8lofNDRiwYq5n4vvGk
         niPR3E2FnttBTBCyIOzgobd6m/EjJBs4ny6qweVc8ZNzv5sUeBuLvPCLP9535tu/fd
         qHm01tLg583ZWmwE3sQyMb8IG5iEsBon68Fcub+U=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-doc@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [RFC 0/8] net: organize driver docs by device type
Date:   Thu, 11 Jun 2020 10:30:02 -0700
Message-Id: <20200611173010.474475-1-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi!

This series finishes off what I started in
commit b255e500c8dc ("net: documentation: build a directory structure for drivers").
The objective is to de-clutter our documentation folder so folks
have a chance of finding relevant info. I _think_ I got all the
driver docs from the main documentation directory this time around.

While doing this I realized that many of them are of limited relevance
these days, so I went ahead and sliced the drivers directory by
technology. Those feeling nostalgic are free to dive into the FDDI,
ATM etc. docs, but for most Ethernet is what we care about.

Jakub Kicinski (8):
  docs: networking: reorganize driver documentation again
  docs: networking: move z8530 to the hw driver section
  docs: networking: move baycom to the hw driver section
  docs: networking: move ray_cs to the hw driver section
  docs: networking: move remaining Ethernet driver docs to the hw
    section
  docs: networking: move AppleTalk / LocalTalk drivers to the hw driver
    section
  docs: networking: move ATM drivers to the hw driver section
  docs: networking: move FDDI drivers to the hw driver section

 .../devicetree/bindings/misc/fsl,qoriq-mc.txt |  2 +-
 .../{ => device_drivers/appletalk}/cops.rst   |  0
 .../device_drivers/appletalk/index.rst        | 19 +++++
 .../{ => device_drivers/appletalk}/ltpc.rst   |  0
 .../{ => device_drivers/atm}/cxacru-cf.py     |  0
 .../{ => device_drivers/atm}/cxacru.rst       |  0
 .../{ => device_drivers/atm}/fore200e.rst     |  0
 .../networking/device_drivers/atm/index.rst   | 20 ++++++
 .../{ => device_drivers/atm}/iphase.rst       |  0
 .../networking/device_drivers/cable/index.rst | 18 +++++
 .../device_drivers/{ => cable}/sb1000.rst     |  0
 .../device_drivers/cellular/index.rst         | 18 +++++
 .../{ => cellular}/qualcomm/rmnet.rst         |  0
 .../{ => ethernet}/3com/3c509.rst             |  0
 .../{ => ethernet}/3com/vortex.rst            |  2 -
 .../ethernet/altera}/altera_tse.rst           |  0
 .../{ => ethernet}/amazon/ena.rst             |  0
 .../{ => ethernet}/aquantia/atlantic.rst      |  0
 .../{ => ethernet}/chelsio/cxgb.rst           |  0
 .../{ => ethernet}/cirrus/cs89x0.rst          |  0
 .../{ => ethernet}/davicom/dm9000.rst         |  0
 .../{ => ethernet}/dec/de4x5.rst              |  0
 .../{ => ethernet}/dec/dmfe.rst               |  0
 .../{ => ethernet}/dlink/dl2k.rst             |  0
 .../{ => ethernet}/freescale/dpaa.rst         |  0
 .../freescale/dpaa2/dpio-driver.rst           |  6 +-
 .../freescale/dpaa2/ethernet-driver.rst       |  3 +-
 .../{ => ethernet}/freescale/dpaa2/index.rst  |  0
 .../freescale/dpaa2/mac-phy-support.rst       |  0
 .../freescale/dpaa2/overview.rst              |  0
 .../{ => ethernet}/freescale/gianfar.rst      |  0
 .../{ => ethernet}/google/gve.rst             |  0
 .../ethernet/huawei}/hinic.rst                |  0
 .../device_drivers/ethernet/index.rst         | 60 ++++++++++++++++
 .../{ => ethernet}/intel/e100.rst             |  0
 .../{ => ethernet}/intel/e1000.rst            |  0
 .../{ => ethernet}/intel/e1000e.rst           |  0
 .../{ => ethernet}/intel/fm10k.rst            |  0
 .../{ => ethernet}/intel/i40e.rst             |  0
 .../{ => ethernet}/intel/iavf.rst             |  0
 .../{ => ethernet}/intel/ice.rst              |  0
 .../{ => ethernet}/intel/igb.rst              |  0
 .../{ => ethernet}/intel/igbvf.rst            |  0
 .../{ => ethernet}/intel/ixgb.rst             |  0
 .../{ => ethernet}/intel/ixgbe.rst            |  0
 .../{ => ethernet}/intel/ixgbevf.rst          |  0
 .../{ => ethernet}/marvell/octeontx2.rst      |  0
 .../{ => ethernet}/mellanox/mlx5.rst          |  0
 .../{ => ethernet}/microsoft/netvsc.rst       |  0
 .../{ => ethernet}/neterion/s2io.rst          |  0
 .../{ => ethernet}/neterion/vxge.rst          |  0
 .../{ => ethernet}/netronome/nfp.rst          |  0
 .../{ => ethernet}/pensando/ionic.rst         |  0
 .../{ => ethernet}/smsc/smc9.rst              |  0
 .../{ => ethernet}/stmicro/stmmac.rst         |  0
 .../device_drivers/{ => ethernet}/ti/cpsw.rst |  0
 .../{ => ethernet}/ti/cpsw_switchdev.rst      |  0
 .../device_drivers/{ => ethernet}/ti/tlan.rst |  0
 .../{ => ethernet}/toshiba/spider_net.rst     |  0
 .../{ => device_drivers/fddi}/defza.rst       |  0
 .../networking/device_drivers/fddi/index.rst  | 19 +++++
 .../{ => device_drivers/fddi}/skfp.rst        |  0
 .../{ => device_drivers/hamradio}/baycom.rst  |  0
 .../device_drivers/hamradio/index.rst         | 19 +++++
 .../hamradio}/z8530drv.rst                    |  0
 .../networking/device_drivers/index.rst       | 56 +++------------
 .../networking/device_drivers/wan/index.rst   | 18 +++++
 .../{ => device_drivers/wan}/z8530book.rst    |  0
 .../networking/device_drivers/wifi/index.rst  | 20 ++++++
 .../{ => wifi}/intel/ipw2100.rst              |  0
 .../{ => wifi}/intel/ipw2200.rst              |  0
 .../{ => device_drivers/wifi}/ray_cs.rst      |  0
 Documentation/networking/index.rst            | 13 ----
 MAINTAINERS                                   | 70 +++++++++----------
 drivers/atm/Kconfig                           |  8 ++-
 drivers/net/Kconfig                           |  2 +-
 drivers/net/appletalk/Kconfig                 |  3 +-
 drivers/net/ethernet/3com/3c59x.c             |  4 +-
 drivers/net/ethernet/3com/Kconfig             |  4 +-
 drivers/net/ethernet/chelsio/Kconfig          |  2 +-
 drivers/net/ethernet/cirrus/Kconfig           |  2 +-
 drivers/net/ethernet/dec/tulip/Kconfig        |  4 +-
 drivers/net/ethernet/dlink/dl2k.c             | 10 +--
 drivers/net/ethernet/intel/Kconfig            | 24 +++----
 drivers/net/ethernet/neterion/Kconfig         |  4 +-
 drivers/net/ethernet/pensando/Kconfig         |  2 +-
 drivers/net/ethernet/smsc/Kconfig             |  4 +-
 drivers/net/ethernet/ti/Kconfig               |  2 +-
 drivers/net/ethernet/ti/tlan.c                |  2 +-
 drivers/net/fddi/Kconfig                      |  4 +-
 drivers/net/hamradio/Kconfig                  | 16 +++--
 drivers/net/hamradio/scc.c                    |  2 +-
 drivers/net/wireless/Kconfig                  |  3 +-
 drivers/net/wireless/intel/ipw2x00/Kconfig    |  4 +-
 drivers/net/wireless/intel/ipw2x00/ipw2100.c  |  2 +-
 95 files changed, 317 insertions(+), 154 deletions(-)
 rename Documentation/networking/{ => device_drivers/appletalk}/cops.rst (100%)
 create mode 100644 Documentation/networking/device_drivers/appletalk/index.rst
 rename Documentation/networking/{ => device_drivers/appletalk}/ltpc.rst (100%)
 rename Documentation/networking/{ => device_drivers/atm}/cxacru-cf.py (100%)
 rename Documentation/networking/{ => device_drivers/atm}/cxacru.rst (100%)
 rename Documentation/networking/{ => device_drivers/atm}/fore200e.rst (100%)
 create mode 100644 Documentation/networking/device_drivers/atm/index.rst
 rename Documentation/networking/{ => device_drivers/atm}/iphase.rst (100%)
 create mode 100644 Documentation/networking/device_drivers/cable/index.rst
 rename Documentation/networking/device_drivers/{ => cable}/sb1000.rst (100%)
 create mode 100644 Documentation/networking/device_drivers/cellular/index.rst
 rename Documentation/networking/device_drivers/{ => cellular}/qualcomm/rmnet.rst (100%)
 rename Documentation/networking/device_drivers/{ => ethernet}/3com/3c509.rst (100%)
 rename Documentation/networking/device_drivers/{ => ethernet}/3com/vortex.rst (99%)
 rename Documentation/networking/{ => device_drivers/ethernet/altera}/altera_tse.rst (100%)
 rename Documentation/networking/device_drivers/{ => ethernet}/amazon/ena.rst (100%)
 rename Documentation/networking/device_drivers/{ => ethernet}/aquantia/atlantic.rst (100%)
 rename Documentation/networking/device_drivers/{ => ethernet}/chelsio/cxgb.rst (100%)
 rename Documentation/networking/device_drivers/{ => ethernet}/cirrus/cs89x0.rst (100%)
 rename Documentation/networking/device_drivers/{ => ethernet}/davicom/dm9000.rst (100%)
 rename Documentation/networking/device_drivers/{ => ethernet}/dec/de4x5.rst (100%)
 rename Documentation/networking/device_drivers/{ => ethernet}/dec/dmfe.rst (100%)
 rename Documentation/networking/device_drivers/{ => ethernet}/dlink/dl2k.rst (100%)
 rename Documentation/networking/device_drivers/{ => ethernet}/freescale/dpaa.rst (100%)
 rename Documentation/networking/device_drivers/{ => ethernet}/freescale/dpaa2/dpio-driver.rst (97%)
 rename Documentation/networking/device_drivers/{ => ethernet}/freescale/dpaa2/ethernet-driver.rst (98%)
 rename Documentation/networking/device_drivers/{ => ethernet}/freescale/dpaa2/index.rst (100%)
 rename Documentation/networking/device_drivers/{ => ethernet}/freescale/dpaa2/mac-phy-support.rst (100%)
 rename Documentation/networking/device_drivers/{ => ethernet}/freescale/dpaa2/overview.rst (100%)
 rename Documentation/networking/device_drivers/{ => ethernet}/freescale/gianfar.rst (100%)
 rename Documentation/networking/device_drivers/{ => ethernet}/google/gve.rst (100%)
 rename Documentation/networking/{ => device_drivers/ethernet/huawei}/hinic.rst (100%)
 create mode 100644 Documentation/networking/device_drivers/ethernet/index.rst
 rename Documentation/networking/device_drivers/{ => ethernet}/intel/e100.rst (100%)
 rename Documentation/networking/device_drivers/{ => ethernet}/intel/e1000.rst (100%)
 rename Documentation/networking/device_drivers/{ => ethernet}/intel/e1000e.rst (100%)
 rename Documentation/networking/device_drivers/{ => ethernet}/intel/fm10k.rst (100%)
 rename Documentation/networking/device_drivers/{ => ethernet}/intel/i40e.rst (100%)
 rename Documentation/networking/device_drivers/{ => ethernet}/intel/iavf.rst (100%)
 rename Documentation/networking/device_drivers/{ => ethernet}/intel/ice.rst (100%)
 rename Documentation/networking/device_drivers/{ => ethernet}/intel/igb.rst (100%)
 rename Documentation/networking/device_drivers/{ => ethernet}/intel/igbvf.rst (100%)
 rename Documentation/networking/device_drivers/{ => ethernet}/intel/ixgb.rst (100%)
 rename Documentation/networking/device_drivers/{ => ethernet}/intel/ixgbe.rst (100%)
 rename Documentation/networking/device_drivers/{ => ethernet}/intel/ixgbevf.rst (100%)
 rename Documentation/networking/device_drivers/{ => ethernet}/marvell/octeontx2.rst (100%)
 rename Documentation/networking/device_drivers/{ => ethernet}/mellanox/mlx5.rst (100%)
 rename Documentation/networking/device_drivers/{ => ethernet}/microsoft/netvsc.rst (100%)
 rename Documentation/networking/device_drivers/{ => ethernet}/neterion/s2io.rst (100%)
 rename Documentation/networking/device_drivers/{ => ethernet}/neterion/vxge.rst (100%)
 rename Documentation/networking/device_drivers/{ => ethernet}/netronome/nfp.rst (100%)
 rename Documentation/networking/device_drivers/{ => ethernet}/pensando/ionic.rst (100%)
 rename Documentation/networking/device_drivers/{ => ethernet}/smsc/smc9.rst (100%)
 rename Documentation/networking/device_drivers/{ => ethernet}/stmicro/stmmac.rst (100%)
 rename Documentation/networking/device_drivers/{ => ethernet}/ti/cpsw.rst (100%)
 rename Documentation/networking/device_drivers/{ => ethernet}/ti/cpsw_switchdev.rst (100%)
 rename Documentation/networking/device_drivers/{ => ethernet}/ti/tlan.rst (100%)
 rename Documentation/networking/device_drivers/{ => ethernet}/toshiba/spider_net.rst (100%)
 rename Documentation/networking/{ => device_drivers/fddi}/defza.rst (100%)
 create mode 100644 Documentation/networking/device_drivers/fddi/index.rst
 rename Documentation/networking/{ => device_drivers/fddi}/skfp.rst (100%)
 rename Documentation/networking/{ => device_drivers/hamradio}/baycom.rst (100%)
 create mode 100644 Documentation/networking/device_drivers/hamradio/index.rst
 rename Documentation/networking/{ => device_drivers/hamradio}/z8530drv.rst (100%)
 create mode 100644 Documentation/networking/device_drivers/wan/index.rst
 rename Documentation/networking/{ => device_drivers/wan}/z8530book.rst (100%)
 create mode 100644 Documentation/networking/device_drivers/wifi/index.rst
 rename Documentation/networking/device_drivers/{ => wifi}/intel/ipw2100.rst (100%)
 rename Documentation/networking/device_drivers/{ => wifi}/intel/ipw2200.rst (100%)
 rename Documentation/networking/{ => device_drivers/wifi}/ray_cs.rst (100%)

-- 
2.26.2

