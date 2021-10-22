Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88B17437C50
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 19:55:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233933AbhJVR6H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 13:58:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:48130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233900AbhJVR6G (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Oct 2021 13:58:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5023A61246;
        Fri, 22 Oct 2021 17:55:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634925348;
        bh=JmujLODs90EQYkA6yxgqKOW5oFpOHbnZPFpbgJvwfaw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JGJXlz8oGuc90CokbnDooFarytjqEhZipjyBWc5GUoNvCy0utGY6nK8FxOpsA/S4y
         Oe2+QkGbmZtuWsA1s6lPuGQge4p0LXlsVYY6e7aqAX7OCEwrg9mXuHvgYyJbxSjhno
         kxGAFstzzBV7ubTMQQhHI05B7Hm8F9hldocmdLHBk4Ul8nFktHs9GNrf70ImaH1igr
         VkaqdF7rYt7i4E65WYqK8T+VOl5jjCNDQXMwulZXCxMCXMKZ6Y4EBnxcaDGRNvlEHu
         5zX29wIMDSDKe6w3+zgYxxdGHup/JCeNuGC1AiEY+Hu5jt8x8AehXX+q8urYZ21h/9
         TQ/RKs4GNhusQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 6/8] net: caif: get ready for const netdev->dev_addr
Date:   Fri, 22 Oct 2021 10:55:41 -0700
Message-Id: <20211022175543.2518732-7-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211022175543.2518732-1-kuba@kernel.org>
References: <20211022175543.2518732-1-kuba@kernel.org>
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

