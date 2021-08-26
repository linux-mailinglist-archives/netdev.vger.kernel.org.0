Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 556DA3F86E3
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 14:01:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242413AbhHZMB5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 08:01:57 -0400
Received: from smtp-relay-canonical-1.canonical.com ([185.125.188.121]:53182
        "EHLO smtp-relay-canonical-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242147AbhHZMB4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Aug 2021 08:01:56 -0400
Received: from localhost (1.general.cking.uk.vpn [10.172.193.212])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPSA id 726BA3F0FE;
        Thu, 26 Aug 2021 12:01:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1629979268;
        bh=KnpgV2xTLsJXZFsLZiu4Yqmo2tltx6SvFXsrlXiHOnQ=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type;
        b=kAjjLih9ZUaZ76EW+l4wJzEVvc0322mL3oyLbr6ZuG9kHQ9r4jUnYEAEBkvpZJcA+
         +86JI0HdnLBU9zwP8JIiYuPts0cHcYn8VmrAe+l+6AjxtXppeDP21Sa3HvYvQso6sx
         rciF/QWEGfmcIH4inZ81kExJraW+M5WvGRHidZMFuidDPxLgqQiZFLVVkgpbxMRHmm
         iWQZWvofIrADLAUTLSFTIJ4JDeW21D51Nl+JVMJNSwTLIJp1w/oBP3tTfv3AHJzC2c
         sCKh6wvpvUbb7enNdmDbIoCxrhxDFpdgNpqpEmNx+Fh5KrZwH4zrB4ReRYhUWEgewV
         dfB75zvy7j+Bw==
From:   Colin King <colin.king@canonical.com>
To:     Raju Rangoju <rajur@chelsio.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] cxgb4: clip_tbl: Fix spelling mistake "wont" -> "won't"
Date:   Thu, 26 Aug 2021 13:01:08 +0100
Message-Id: <20210826120108.12185-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

There are spelling mistakes in dev_err and dev_info messages. Fix them.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/ethernet/chelsio/cxgb4/clip_tbl.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/clip_tbl.c b/drivers/net/ethernet/chelsio/cxgb4/clip_tbl.c
index 163efab27e9b..5060d3998889 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/clip_tbl.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/clip_tbl.c
@@ -120,7 +120,7 @@ int cxgb4_clip_get(const struct net_device *dev, const u32 *lip, u8 v6)
 				write_unlock_bh(&ctbl->lock);
 				dev_err(adap->pdev_dev,
 					"CLIP FW cmd failed with error %d, "
-					"Connections using %pI6c wont be "
+					"Connections using %pI6c won't be "
 					"offloaded",
 					ret, ce->addr6.sin6_addr.s6_addr);
 				return ret;
@@ -133,7 +133,7 @@ int cxgb4_clip_get(const struct net_device *dev, const u32 *lip, u8 v6)
 	} else {
 		write_unlock_bh(&ctbl->lock);
 		dev_info(adap->pdev_dev, "CLIP table overflow, "
-			 "Connections using %pI6c wont be offloaded",
+			 "Connections using %pI6c won't be offloaded",
 			 (void *)lip);
 		return -ENOMEM;
 	}
-- 
2.32.0

