Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33C70438094
	for <lists+netdev@lfdr.de>; Sat, 23 Oct 2021 01:21:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232130AbhJVXXc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 19:23:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:40936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231928AbhJVXX3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Oct 2021 19:23:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C82456109E;
        Fri, 22 Oct 2021 23:21:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634944870;
        bh=JmujLODs90EQYkA6yxgqKOW5oFpOHbnZPFpbgJvwfaw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G5XQ2ghnnKGZfYIThyij4V3lbPxDIlmpAiNoUnAYl63+F3SvbtnYEKsrfNR0SZ2NC
         rcT2uGrhBIFLVXftVQ3dOJ0ey9VDmI/9LkrFWxZcK96Ggg5ISPuSQWBUQ5EP2kAtcL
         5o4BAulJB7pSIxgMTEbKNBMv4vursTZAnR39ROjK6poma/F7adBL6Twy2ub1SmGb4r
         Nn+M4vODi1LcFFSC3K/AcyUhZ5XAIiV8h1cl9fG83Y+pw7m/XXGRvpiZIjJxKp/agu
         Xx+/sKYlDlJgtsHSG1ftU7DAjm+g+aCmKnDs1NHWXjo7XqA+1YfcqBQ5pix4+jHHYi
         iVIhXogzSdYUg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 6/8] net: caif: get ready for const netdev->dev_addr
Date:   Fri, 22 Oct 2021 16:21:01 -0700
Message-Id: <20211022232103.2715312-7-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211022232103.2715312-1-kuba@kernel.org>
References: <20211022232103.2715312-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Get it ready for constant netdev->dev_addr.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/caif/caif_usb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/caif/caif_usb.c b/net/caif/caif_usb.c
index b02e1292f7f1..4be6b04879a1 100644
--- a/net/caif/caif_usb.c
+++ b/net/caif/caif_usb.c
@@ -81,7 +81,7 @@ static void cfusbl_ctrlcmd(struct cflayer *layr, enum caif_ctrlcmd ctrl,
 		layr->up->ctrlcmd(layr->up, ctrl, layr->id);
 }
 
-static struct cflayer *cfusbl_create(int phyid, u8 ethaddr[ETH_ALEN],
+static struct cflayer *cfusbl_create(int phyid, const u8 ethaddr[ETH_ALEN],
 				      u8 braddr[ETH_ALEN])
 {
 	struct cfusbl *this = kmalloc(sizeof(struct cfusbl), GFP_ATOMIC);
-- 
2.31.1

