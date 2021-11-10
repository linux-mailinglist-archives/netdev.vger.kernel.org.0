Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C83744BB4F
	for <lists+netdev@lfdr.de>; Wed, 10 Nov 2021 06:36:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229810AbhKJFji (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Nov 2021 00:39:38 -0500
Received: from inva020.nxp.com ([92.121.34.13]:49660 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229751AbhKJFjc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Nov 2021 00:39:32 -0500
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 4B1E31A09AA;
        Wed, 10 Nov 2021 06:36:44 +0100 (CET)
Received: from aprdc01srsp001v.ap-rdc01.nxp.com (aprdc01srsp001v.ap-rdc01.nxp.com [165.114.16.16])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 135801A0D96;
        Wed, 10 Nov 2021 06:36:44 +0100 (CET)
Received: from lsv03186.swis.in-blr01.nxp.com (lsv03186.swis.in-blr01.nxp.com [92.120.146.182])
        by aprdc01srsp001v.ap-rdc01.nxp.com (Postfix) with ESMTP id C35CE183ACDD;
        Wed, 10 Nov 2021 13:36:42 +0800 (+08)
From:   Apeksha Gupta <apeksha.gupta@nxp.com>
To:     qiangqing.zhang@nxp.com, davem@davemloft.net, kuba@kernel.org,
        arnd@arndb.de
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-devel@linux.nxdi.nxp.com, LnxRevLi@nxp.com,
        sachin.saxena@nxp.com, hemant.agrawal@nxp.com, nipun.gupta@nxp.com,
        Apeksha Gupta <apeksha.gupta@nxp.com>
Subject: [PATCH 3/3] MAINTAINERS: added new files
Date:   Wed, 10 Nov 2021 11:06:17 +0530
Message-Id: <20211110053617.13497-4-apeksha.gupta@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211110053617.13497-1-apeksha.gupta@nxp.com>
References: <20211110053617.13497-1-apeksha.gupta@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

fec_phy.h and fec_phy.c files are added in net/fec branch.

Signed-off-by: Sachin Saxena <sachin.saxena@nxp.com>
Signed-off-by: Apeksha Gupta <apeksha.gupta@nxp.com>
---
 MAINTAINERS | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 3b79fd441dde..e93fdf73e383 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7456,6 +7456,8 @@ S:	Maintained
 F:	Documentation/devicetree/bindings/net/fsl,fec.yaml
 F:	drivers/net/ethernet/freescale/fec.h
 F:	drivers/net/ethernet/freescale/fec_main.c
+F:	drivers/net/ethernet/freescale/fec_phy.c
+F:	drivers/net/ethernet/freescale/fec_phy.h
 F:	drivers/net/ethernet/freescale/fec_ptp.c
 
 FREESCALE IMX / MXC FRAMEBUFFER DRIVER
-- 
2.17.1

