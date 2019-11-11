Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93B97F7388
	for <lists+netdev@lfdr.de>; Mon, 11 Nov 2019 13:03:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726978AbfKKMDT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 07:03:19 -0500
Received: from inva021.nxp.com ([92.121.34.21]:57452 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726810AbfKKMDS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Nov 2019 07:03:18 -0500
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 711F420093F;
        Mon, 11 Nov 2019 13:03:16 +0100 (CET)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 64C4220001D;
        Mon, 11 Nov 2019 13:03:16 +0100 (CET)
Received: from fsr-fed2164-101.ea.freescale.net (fsr-fed2164-101.ea.freescale.net [10.171.82.91])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 1ECDA205FE;
        Mon, 11 Nov 2019 13:03:16 +0100 (CET)
From:   Madalin Bucur <madalin.bucur@nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     linux-doc@vger.kernel.org, corbet@lwn.net,
        Madalin Bucur <madalin.bucur@nxp.com>
Subject: [PATCH net-next 2/2] Documentation: networking: dpaa_eth: adjust sysfs paths
Date:   Mon, 11 Nov 2019 14:03:12 +0200
Message-Id: <1573473792-17797-3-git-send-email-madalin.bucur@nxp.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1573473792-17797-1-git-send-email-madalin.bucur@nxp.com>
References: <1573473792-17797-1-git-send-email-madalin.bucur@nxp.com>
Content-Type: text/plain; charset="us-ascii"
Reply-to: madalin.bucur@nxp.com
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The sysfs paths changed, updating to the current ones.

Signed-off-by: Madalin Bucur <madalin.bucur@nxp.com>
---
 Documentation/networking/device_drivers/freescale/dpaa.txt | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/networking/device_drivers/freescale/dpaa.txt b/Documentation/networking/device_drivers/freescale/dpaa.txt
index ad1044292073..b06601ff9200 100644
--- a/Documentation/networking/device_drivers/freescale/dpaa.txt
+++ b/Documentation/networking/device_drivers/freescale/dpaa.txt
@@ -254,7 +254,7 @@ The following statistics are exported for each interface through ethtool:
 The driver also exports the following information in sysfs:
 
 	- the FQ IDs for each FQ type
-	/sys/devices/platform/dpaa-ethernet.0/net/<int>/fqids
+	/sys/devices/platform/soc/<addr>.fman/<addr>.ethernet/dpaa-ethernet.<id>/net/fm<nr>-mac<nr>/fqids
 
 	- the ID of the buffer pool in use
-	/sys/devices/platform/dpaa-ethernet.0/net/<int>/bpids
+	/sys/devices/platform/soc/<addr>.fman/<addr>.ethernet/dpaa-ethernet.<id>/net/fm<nr>-mac<nr>/bpids
-- 
2.1.0

