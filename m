Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7FD8613901
	for <lists+netdev@lfdr.de>; Mon, 31 Oct 2022 15:33:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231524AbiJaOdB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 10:33:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231237AbiJaOc5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 10:32:57 -0400
Received: from mail.draketalley.com (mail.draketalley.com [3.213.214.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6671F58F;
        Mon, 31 Oct 2022 07:32:55 -0700 (PDT)
Received: from pop-os.lan (cpe-74-72-139-32.nyc.res.rr.com [74.72.139.32])
        by mail.draketalley.com (Postfix) with ESMTPSA id 9613655DD1;
        Mon, 31 Oct 2022 14:25:30 +0000 (UTC)
From:   drake@draketalley.com
To:     Manish Chopra <manishc@marvell.com>, GR-Linux-NIC-Dev@marvell.com,
        Coiby Xu <coiby.xu@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, linux-staging@lists.linux.dev
Cc:     linux-kernel@vger.kernel.org, Drake Talley <drake@draketalley.com>
Subject: [PATCH 1/3] staging: qlge: Separate multiple assignments
Date:   Mon, 31 Oct 2022 10:25:14 -0400
Message-Id: <20221031142516.266704-2-drake@draketalley.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221031142516.266704-1-drake@draketalley.com>
References: <20221031142516.266704-1-drake@draketalley.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,SPF_HELO_SOFTFAIL,
        T_SPF_PERMERROR autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Drake Talley <drake@draketalley.com>

Adhere to coding style.

Reported by checkpatch:

> CHECK: multiple assignments should be avoided
> #4088: FILE: drivers/staging/qlge/qlge_main.c:4088

> CHECK: multiple assignments should be avoided
> #4108: FILE: drivers/staging/qlge/qlge_main.c:4108:

Signed-off-by: Drake Talley <drake@draketalley.com>
---
 drivers/staging/qlge/qlge_main.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/qlge_main.c
index 1ead7793062a..8c1fdd8ebba0 100644
--- a/drivers/staging/qlge/qlge_main.c
+++ b/drivers/staging/qlge/qlge_main.c
@@ -4085,7 +4085,12 @@ static struct net_device_stats *qlge_get_stats(struct net_device
 	int i;
 
 	/* Get RX stats. */
-	pkts = mcast = dropped = errors = bytes = 0;
+	pkts = 0;
+	mcast = 0;
+	dropped = 0;
+	errors = 0;
+	bytes = 0;
+
 	for (i = 0; i < qdev->rss_ring_count; i++, rx_ring++) {
 		pkts += rx_ring->rx_packets;
 		bytes += rx_ring->rx_bytes;
@@ -4100,7 +4105,10 @@ static struct net_device_stats *qlge_get_stats(struct net_device
 	ndev->stats.multicast = mcast;
 
 	/* Get TX stats. */
-	pkts = errors = bytes = 0;
+	pkts = 0;
+	errors = 0;
+	bytes = 0;
+
 	for (i = 0; i < qdev->tx_ring_count; i++, tx_ring++) {
 		pkts += tx_ring->tx_packets;
 		bytes += tx_ring->tx_bytes;
-- 
2.34.1

