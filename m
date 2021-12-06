Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2591E468FE8
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 05:56:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236159AbhLFE7l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Dec 2021 23:59:41 -0500
Received: from inva021.nxp.com ([92.121.34.21]:54382 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232609AbhLFE7i (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 5 Dec 2021 23:59:38 -0500
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 5B17C201258;
        Mon,  6 Dec 2021 05:56:09 +0100 (CET)
Received: from aprdc01srsp001v.ap-rdc01.nxp.com (aprdc01srsp001v.ap-rdc01.nxp.com [165.114.16.16])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 22558201253;
        Mon,  6 Dec 2021 05:56:09 +0100 (CET)
Received: from lsv03186.swis.in-blr01.nxp.com (lsv03186.swis.in-blr01.nxp.com [92.120.146.182])
        by aprdc01srsp001v.ap-rdc01.nxp.com (Postfix) with ESMTP id E8EAD183AC96;
        Mon,  6 Dec 2021 12:56:07 +0800 (+08)
From:   Apeksha Gupta <apeksha.gupta@nxp.com>
To:     qiangqing.zhang@nxp.com, netdev@vger.kernel.org, kuba@kernel.org,
        arnd@arndb.de
Cc:     linux-kernel@vger.kernel.org, linux-devel@linux.nxdi.nxp.com,
        LnxRevLi@nxp.com, sachin.saxena@nxp.com, hemant.agrawal@nxp.com,
        Apeksha Gupta <apeksha.gupta@nxp.com>
Subject: [PATCH v2 3/3] MAINTAINERS: added new files
Date:   Mon,  6 Dec 2021 10:25:36 +0530
Message-Id: <20211206045536.8690-4-apeksha.gupta@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211206045536.8690-1-apeksha.gupta@nxp.com>
References: <20211206045536.8690-1-apeksha.gupta@nxp.com>
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
index 7a2345ce8521..ad28877eaf10 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7577,6 +7577,8 @@ S:	Maintained
 F:	Documentation/devicetree/bindings/net/fsl,fec.yaml
 F:	drivers/net/ethernet/freescale/fec.h
 F:	drivers/net/ethernet/freescale/fec_main.c
+F:	drivers/net/ethernet/freescale/fec_phy.c
+F:	drivers/net/ethernet/freescale/fec_phy.h
 F:	drivers/net/ethernet/freescale/fec_ptp.c
 
 FREESCALE IMX / MXC FRAMEBUFFER DRIVER
-- 
2.17.1

