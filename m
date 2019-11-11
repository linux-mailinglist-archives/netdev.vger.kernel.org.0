Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC913F7387
	for <lists+netdev@lfdr.de>; Mon, 11 Nov 2019 13:03:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726965AbfKKMDS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 07:03:18 -0500
Received: from inva021.nxp.com ([92.121.34.21]:57436 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726843AbfKKMDR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Nov 2019 07:03:17 -0500
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 9D0FC2008D5;
        Mon, 11 Nov 2019 13:03:15 +0100 (CET)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 8FE96200608;
        Mon, 11 Nov 2019 13:03:15 +0100 (CET)
Received: from fsr-fed2164-101.ea.freescale.net (fsr-fed2164-101.ea.freescale.net [10.171.82.91])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 49D2D205FE;
        Mon, 11 Nov 2019 13:03:15 +0100 (CET)
From:   Madalin Bucur <madalin.bucur@nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     linux-doc@vger.kernel.org, corbet@lwn.net,
        Madalin Bucur <madalin.bucur@nxp.com>
Subject: [PATCH net-next 1/2] Documentation: networking: dpaa_eth: adjust buffer pool info
Date:   Mon, 11 Nov 2019 14:03:11 +0200
Message-Id: <1573473792-17797-2-git-send-email-madalin.bucur@nxp.com>
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

Recent changes in the dpaa_eth driver reduced the number of
buffer pools per interface from three to one.

Signed-off-by: Madalin Bucur <madalin.bucur@nxp.com>
---
 Documentation/networking/device_drivers/freescale/dpaa.txt | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/Documentation/networking/device_drivers/freescale/dpaa.txt b/Documentation/networking/device_drivers/freescale/dpaa.txt
index f88194f71c54..ad1044292073 100644
--- a/Documentation/networking/device_drivers/freescale/dpaa.txt
+++ b/Documentation/networking/device_drivers/freescale/dpaa.txt
@@ -129,9 +129,9 @@ CONFIG_AQUANTIA_PHY=y
 DPAA Ethernet Frame Processing
 ==============================
 
-On Rx, buffers for the incoming frames are retrieved from one of the three
-existing buffers pools. The driver initializes and seeds these, each with
-buffers of different sizes: 1KB, 2KB and 4KB.
+On Rx, buffers for the incoming frames are retrieved from the buffers found
+in the dedicated interface buffer pool. The driver initializes and seeds these
+with one page buffers.
 
 On Tx, all transmitted frames are returned to the driver through Tx
 confirmation frame queues. The driver is then responsible for freeing the
@@ -256,5 +256,5 @@ The driver also exports the following information in sysfs:
 	- the FQ IDs for each FQ type
 	/sys/devices/platform/dpaa-ethernet.0/net/<int>/fqids
 
-	- the IDs of the buffer pools in use
+	- the ID of the buffer pool in use
 	/sys/devices/platform/dpaa-ethernet.0/net/<int>/bpids
-- 
2.1.0

