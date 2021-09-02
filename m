Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 320D53FF6FF
	for <lists+netdev@lfdr.de>; Fri,  3 Sep 2021 00:17:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347547AbhIBWSq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 18:18:46 -0400
Received: from smtp-relay-canonical-0.canonical.com ([185.125.188.120]:60880
        "EHLO smtp-relay-canonical-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236148AbhIBWSq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Sep 2021 18:18:46 -0400
Received: from localhost (1.general.cking.uk.vpn [10.172.193.212])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPSA id E69C43F231;
        Thu,  2 Sep 2021 22:17:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1630621065;
        bh=rkLqk2H3cfzfe0pZb/HQsYkLLWbNkb74kYaENpGnHRs=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type;
        b=QxLVZAJ7jNAVxsh60jcOMAf1wJ28usLdkpHLTN2vJSNmfbkoz3bYfscZEWRXdCBjl
         yPTawrC59vBZtsPCJSYjNXRmPmjAwNmrhtv1sQ/67J3ioW5QvgoZ7qS8VPQHX/Szdr
         JX0eHQaGXmSoq97rdJmwbwpr4o5sHCRQF2K4u9dDaq0HbLwMpHywfjvKDCUwkk1DE0
         aXh5B7XZdDJH+cCqAd7mcHgr926MhbmlK87LpaiFooRfCy54VbZmBEN7R0qgaWaaaB
         i1GoBpMTbHAeRsUnoD5DhO7+wZbRLOk4QwESbo5BodLA7NR2fjYB+wmWSCyLDN/MGx
         PEfOPxsH4jcBw==
From:   Colin King <colin.king@canonical.com>
To:     Steffen Klassert <klassert@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: 3com: 3c59x: clean up inconsistent indenting
Date:   Thu,  2 Sep 2021 23:17:45 +0100
Message-Id: <20210902221745.56194-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

There is a statement that is not indented correctly, add in the
missing tab.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/ethernet/3com/3c59x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/3com/3c59x.c b/drivers/net/ethernet/3com/3c59x.c
index 17c16333a412..7b0ae9efc004 100644
--- a/drivers/net/ethernet/3com/3c59x.c
+++ b/drivers/net/ethernet/3com/3c59x.c
@@ -2786,7 +2786,7 @@ static void
 dump_tx_ring(struct net_device *dev)
 {
 	if (vortex_debug > 0) {
-	struct vortex_private *vp = netdev_priv(dev);
+		struct vortex_private *vp = netdev_priv(dev);
 		void __iomem *ioaddr = vp->ioaddr;
 
 		if (vp->full_bus_master_tx) {
-- 
2.32.0

