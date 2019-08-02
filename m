Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 147A37F85E
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 15:20:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393263AbfHBNUB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Aug 2019 09:20:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:58268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393219AbfHBNUA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Aug 2019 09:20:00 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 933EC2173E;
        Fri,  2 Aug 2019 13:19:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564751999;
        bh=9TxTll9Z0mfDh39XszPEil6aDryKKS/LmBELjU1miPg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d6IAOIxmXdl9bsz9n6pgaUDmAdOtB+4q5oEGkla1XpAPlY6nI5yA9gpcAf1OYVj+x
         mySlvLvMkWzyPvP6+St0/5wunIM0gH8nvi1hziZgAjPI4rxJFqtFDJYUTpNRq6s2L+
         Aso6LT/hRG1VH5ByYRTLWdYJ+o3fuUVpVXztYwis=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christian Hesse <mail@eworm.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 06/76] netfilter: nf_tables: fix module autoload for redir
Date:   Fri,  2 Aug 2019 09:18:40 -0400
Message-Id: <20190802131951.11600-6-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190802131951.11600-1-sashal@kernel.org>
References: <20190802131951.11600-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Christian Hesse <mail@eworm.de>

[ Upstream commit f41828ee10b36644bb2b2bfa9dd1d02f55aa0516 ]

Fix expression for autoloading.

Fixes: 5142967ab524 ("netfilter: nf_tables: fix module autoload with inet family")
Signed-off-by: Christian Hesse <mail@eworm.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_redir.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nft_redir.c b/net/netfilter/nft_redir.c
index 8487eeff5c0ec..43eeb1f609f13 100644
--- a/net/netfilter/nft_redir.c
+++ b/net/netfilter/nft_redir.c
@@ -291,4 +291,4 @@ module_exit(nft_redir_module_exit);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Arturo Borrero Gonzalez <arturo@debian.org>");
-MODULE_ALIAS_NFT_EXPR("nat");
+MODULE_ALIAS_NFT_EXPR("redir");
-- 
2.20.1

