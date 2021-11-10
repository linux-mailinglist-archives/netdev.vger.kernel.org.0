Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32B0E44BB6D
	for <lists+netdev@lfdr.de>; Wed, 10 Nov 2021 06:49:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230154AbhKJFvl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Nov 2021 00:51:41 -0500
Received: from inva021.nxp.com ([92.121.34.21]:36696 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229984AbhKJFvh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Nov 2021 00:51:37 -0500
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 3F4AF200C83;
        Wed, 10 Nov 2021 06:48:49 +0100 (CET)
Received: from aprdc01srsp001v.ap-rdc01.nxp.com (aprdc01srsp001v.ap-rdc01.nxp.com [165.114.16.16])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 064C5200AAA;
        Wed, 10 Nov 2021 06:48:49 +0100 (CET)
Received: from lsv03186.swis.in-blr01.nxp.com (lsv03186.swis.in-blr01.nxp.com [92.120.146.182])
        by aprdc01srsp001v.ap-rdc01.nxp.com (Postfix) with ESMTP id BD4CA183AC8B;
        Wed, 10 Nov 2021 13:48:47 +0800 (+08)
From:   Apeksha Gupta <apeksha.gupta@nxp.com>
To:     qiangqing.zhang@nxp.com, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-devel@linux.nxdi.nxp.com, LnxRevLi@nxp.com,
        sachin.saxena@nxp.com, hemant.agrawal@nxp.com, nipun.gupta@nxp.com,
        Apeksha Gupta <apeksha.gupta@nxp.com>
Subject: [PATCH 4/5] MAINTAINERS: add new file
Date:   Wed, 10 Nov 2021 11:18:37 +0530
Message-Id: <20211110054838.27907-5-apeksha.gupta@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211110054838.27907-1-apeksha.gupta@nxp.com>
References: <20211110054838.27907-1-apeksha.gupta@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For fec-uio driver, maintainers and fec_uio.c file added.

Signed-off-by: Sachin Saxena <sachin.saxena@nxp.com>
Signed-off-by: Apeksha Gupta <apeksha.gupta@nxp.com>
---
 MAINTAINERS | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index e93fdf73e383..2bfa9a3a91c4 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7460,6 +7460,12 @@ F:	drivers/net/ethernet/freescale/fec_phy.c
 F:	drivers/net/ethernet/freescale/fec_phy.h
 F:	drivers/net/ethernet/freescale/fec_ptp.c
 
+FREESCALE IMX / FEC-UIO DRIVER
+M:	Apeksha Gupta <apeksha.gupta@nxp.com>
+M:	Sachin Saxena <sachin.saxena@nxp.com>
+F:	Documentation/devicetree/bindings/net/fsl,fec-uio.yaml
+F:	drivers/net/ethernet/freescale/fec_uio.c
+
 FREESCALE IMX / MXC FRAMEBUFFER DRIVER
 M:	Sascha Hauer <s.hauer@pengutronix.de>
 R:	Pengutronix Kernel Team <kernel@pengutronix.de>
-- 
2.17.1

