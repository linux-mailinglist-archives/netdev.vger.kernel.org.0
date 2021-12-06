Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18785468FE3
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 05:56:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231409AbhLFE7c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Dec 2021 23:59:32 -0500
Received: from inva020.nxp.com ([92.121.34.13]:49880 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229881AbhLFE7c (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 5 Dec 2021 23:59:32 -0500
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 07C1A1A11C8;
        Mon,  6 Dec 2021 05:56:03 +0100 (CET)
Received: from aprdc01srsp001v.ap-rdc01.nxp.com (aprdc01srsp001v.ap-rdc01.nxp.com [165.114.16.16])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id C41291A056F;
        Mon,  6 Dec 2021 05:56:02 +0100 (CET)
Received: from lsv03186.swis.in-blr01.nxp.com (lsv03186.swis.in-blr01.nxp.com [92.120.146.182])
        by aprdc01srsp001v.ap-rdc01.nxp.com (Postfix) with ESMTP id 9B51E183AC96;
        Mon,  6 Dec 2021 12:56:01 +0800 (+08)
From:   Apeksha Gupta <apeksha.gupta@nxp.com>
To:     qiangqing.zhang@nxp.com, netdev@vger.kernel.org, kuba@kernel.org,
        arnd@arndb.de
Cc:     linux-kernel@vger.kernel.org, linux-devel@linux.nxdi.nxp.com,
        LnxRevLi@nxp.com, sachin.saxena@nxp.com, hemant.agrawal@nxp.com,
        Apeksha Gupta <apeksha.gupta@nxp.com>
Subject: [PATCH v2 0/3] drivers/net: split FEC driver
Date:   Mon,  6 Dec 2021 10:25:33 +0530
Message-Id: <20211206045536.8690-1-apeksha.gupta@nxp.com>
X-Mailer: git-send-email 2.17.1
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series is to restructure the FEC (Fast Ethernet Controller)
driver. All PHY functionality moved from fec_main.c to separate files
fec_phy.h and fec_phy.c. By these changes FEC driver become more
flexible to work with other PHY drivers whenever required in future.

Patch 1 removed PHY functions from fec_main.c
Patch 2 introduce separate PHY files.
Patch 3 MAINTAINERS file updated.

Apeksha Gupta (3):
  fec_phy: add new PHY file
  fec_main: removed PHY functions
  MAINTAINERS: added new files

 MAINTAINERS                               |   2 +
 drivers/net/ethernet/freescale/Makefile   |   4 +-
 drivers/net/ethernet/freescale/fec_main.c | 371 +--------------------
 drivers/net/ethernet/freescale/fec_phy.c  | 376 ++++++++++++++++++++++
 drivers/net/ethernet/freescale/fec_phy.h  |  31 ++
 5 files changed, 416 insertions(+), 368 deletions(-)
 create mode 100644 drivers/net/ethernet/freescale/fec_phy.c
 create mode 100644 drivers/net/ethernet/freescale/fec_phy.h

-- 
2.17.1

