Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BB5342A420
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 14:14:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236339AbhJLMQ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 08:16:26 -0400
Received: from inva021.nxp.com ([92.121.34.21]:51824 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236332AbhJLMQ0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Oct 2021 08:16:26 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id A4E35201E22;
        Tue, 12 Oct 2021 14:14:23 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id A2729201E11;
        Tue, 12 Oct 2021 14:14:23 +0200 (CEST)
Received: from fsr-ub1864-126.ea.freescale.net (fsr-ub1864-126.ea.freescale.net [10.171.82.212])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 51CF220309;
        Tue, 12 Oct 2021 14:14:23 +0200 (CEST)
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     claudiu.manoil@nxp.com, vladimir.oltean@nxp.com,
        netdev@vger.kernel.org, Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next] net: enetc: include ip6_checksum.h for csum_ipv6_magic
Date:   Tue, 12 Oct 2021 15:13:58 +0300
Message-Id: <20211012121358.16641-1-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.17.1
Reply-to: ioana.ciornei@nxp.com
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For those architectures which do not define_HAVE_ARCH_IPV6_CSUM, we need
to include ip6_checksum.h which provides the csum_ipv6_magic() function.

Fixes: fb8629e2cbfc ("net: enetc: add support for software TSO")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 drivers/net/ethernet/freescale/enetc/enetc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index 09193b478ab3..3ae4f49a9055 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -7,6 +7,7 @@
 #include <linux/udp.h>
 #include <linux/vmalloc.h>
 #include <linux/ptp_classify.h>
+#include <net/ip6_checksum.h>
 #include <net/pkt_sched.h>
 #include <net/tso.h>
 
-- 
2.17.1

