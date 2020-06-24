Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D1C020722F
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 13:35:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403769AbgFXLfB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 07:35:01 -0400
Received: from inva020.nxp.com ([92.121.34.13]:48508 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389446AbgFXLey (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Jun 2020 07:34:54 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 74BA71A021B;
        Wed, 24 Jun 2020 13:34:52 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 68B951A01F2;
        Wed, 24 Jun 2020 13:34:52 +0200 (CEST)
Received: from fsr-ub1864-126.ea.freescale.net (fsr-ub1864-126.ea.freescale.net [10.171.82.212])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 3BE4A2047A;
        Wed, 24 Jun 2020 13:34:52 +0200 (CEST)
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next 5/5] dpaa2-eth: fix misspelled function parameters in dpni_[set/get]_taildrop
Date:   Wed, 24 Jun 2020 14:34:21 +0300
Message-Id: <20200624113421.17360-6-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200624113421.17360-1-ioana.ciornei@nxp.com>
References: <20200624113421.17360-1-ioana.ciornei@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Two of the function parameters (qtype and index) were misspelled in the
associated descriptions of dpni_[set/get]_taildrop which led to sparse
warnings. Fix this by using the exact same names as present in the
function definition.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 drivers/net/ethernet/freescale/dpaa2/dpni.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpni.c b/drivers/net/ethernet/freescale/dpaa2/dpni.c
index 6b479ba66465..426100607854 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpni.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpni.c
@@ -1558,10 +1558,10 @@ int dpni_get_statistics(struct fsl_mc_io *mc_io,
  * @cmd_flags:	Command flags; one or more of 'MC_CMD_FLAG_'
  * @token:	Token of DPNI object
  * @cg_point:	Congestion point
- * @q_type:	Queue type on which the taildrop is configured.
+ * @qtype:	Queue type on which the taildrop is configured.
  *		Only Rx queues are supported for now
  * @tc:		Traffic class to apply this taildrop to
- * @q_index:	Index of the queue if the DPNI supports multiple queues for
+ * @index:	Index of the queue if the DPNI supports multiple queues for
  *		traffic distribution. Ignored if CONGESTION_POINT is not 0.
  * @taildrop:	Taildrop structure
  *
@@ -1602,10 +1602,10 @@ int dpni_set_taildrop(struct fsl_mc_io *mc_io,
  * @cmd_flags:	Command flags; one or more of 'MC_CMD_FLAG_'
  * @token:	Token of DPNI object
  * @cg_point:	Congestion point
- * @q_type:	Queue type on which the taildrop is configured.
+ * @qtype:	Queue type on which the taildrop is configured.
  *		Only Rx queues are supported for now
  * @tc:		Traffic class to apply this taildrop to
- * @q_index:	Index of the queue if the DPNI supports multiple queues for
+ * @index:	Index of the queue if the DPNI supports multiple queues for
  *		traffic distribution. Ignored if CONGESTION_POINT is not 0.
  * @taildrop:	Taildrop structure
  *
-- 
2.25.1

