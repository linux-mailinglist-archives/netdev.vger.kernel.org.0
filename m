Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAA8C44BB4A
	for <lists+netdev@lfdr.de>; Wed, 10 Nov 2021 06:36:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229615AbhKJFjY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Nov 2021 00:39:24 -0500
Received: from inva020.nxp.com ([92.121.34.13]:49422 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229473AbhKJFjX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Nov 2021 00:39:23 -0500
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id C78661A0D96;
        Wed, 10 Nov 2021 06:36:35 +0100 (CET)
Received: from aprdc01srsp001v.ap-rdc01.nxp.com (aprdc01srsp001v.ap-rdc01.nxp.com [165.114.16.16])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 90CA61A09AA;
        Wed, 10 Nov 2021 06:36:35 +0100 (CET)
Received: from lsv03186.swis.in-blr01.nxp.com (lsv03186.swis.in-blr01.nxp.com [92.120.146.182])
        by aprdc01srsp001v.ap-rdc01.nxp.com (Postfix) with ESMTP id 50C99183ACCB;
        Wed, 10 Nov 2021 13:36:34 +0800 (+08)
From:   Apeksha Gupta <apeksha.gupta@nxp.com>
To:     qiangqing.zhang@nxp.com, davem@davemloft.net, kuba@kernel.org,
        arnd@arndb.de
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-devel@linux.nxdi.nxp.com, LnxRevLi@nxp.com,
        sachin.saxena@nxp.com, hemant.agrawal@nxp.com, nipun.gupta@nxp.com,
        Apeksha Gupta <apeksha.gupta@nxp.com>
Subject: [PATCH 0/3] drivers/net: split FEC driver
Date:   Wed, 10 Nov 2021 11:06:14 +0530
Message-Id: <20211110053617.13497-1-apeksha.gupta@nxp.com>
X-Mailer: git-send-email 2.17.1
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series split the FEC (Fast Ethernet Controller) driver.
All PHY functionality moved to separate files fec_phy.h and fec_phy.c
from fec_main.c.

Apeksha Gupta (3):
  fec_phy: add new PHY file
  fec_main: removed PHY functions
  MAINTAINERS: added new files

 MAINTAINERS                               |   2 +
 drivers/net/ethernet/freescale/Makefile   |   4 +-
 drivers/net/ethernet/freescale/fec_main.c | 495 +---------------------
 drivers/net/ethernet/freescale/fec_phy.c  | 495 ++++++++++++++++++++++
 drivers/net/ethernet/freescale/fec_phy.h  |  33 ++
 5 files changed, 537 insertions(+), 492 deletions(-)
 create mode 100644 drivers/net/ethernet/freescale/fec_phy.c
 create mode 100644 drivers/net/ethernet/freescale/fec_phy.h

-- 
2.17.1

