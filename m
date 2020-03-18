Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3BB0218A572
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 22:01:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728909AbgCRVBg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 17:01:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:57044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728550AbgCRU4M (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Mar 2020 16:56:12 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 78BD6208E4;
        Wed, 18 Mar 2020 20:56:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584564972;
        bh=I41Sg0VH3MhQ8yN+hre0/s5r5x55aDp8n7eIk54CK5g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZKcqu68YkTDmNVD9ND5YStTSlt5CY210v723K3ic1bSIlvH/w7PqUPKzVDbulmAyj
         19kCiTeFBgyK1/5ELeA3XH13GAagN6XKK6q4ebTsz1ZGVtlTJtsWy+EVO2UYdDGnvv
         VQzzG101XabGbJd3nHGLiuW5BCZMWNOyBSRrwRJM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 14/28] netfilter: nft_payload: add missing attribute validation for payload csum flags
Date:   Wed, 18 Mar 2020 16:55:41 -0400
Message-Id: <20200318205555.17447-14-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200318205555.17447-1-sashal@kernel.org>
References: <20200318205555.17447-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 9d6effb2f1523eb84516e44213c00f2fd9e6afff ]

Add missing attribute validation for NFTA_PAYLOAD_CSUM_FLAGS
to the netlink policy.

Fixes: 1814096980bb ("netfilter: nft_payload: layer 4 checksum adjustment for pseudoheader fields")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_payload.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netfilter/nft_payload.c b/net/netfilter/nft_payload.c
index e110b0ebbf58b..19446a89a2a81 100644
--- a/net/netfilter/nft_payload.c
+++ b/net/netfilter/nft_payload.c
@@ -121,6 +121,7 @@ static const struct nla_policy nft_payload_policy[NFTA_PAYLOAD_MAX + 1] = {
 	[NFTA_PAYLOAD_LEN]		= { .type = NLA_U32 },
 	[NFTA_PAYLOAD_CSUM_TYPE]	= { .type = NLA_U32 },
 	[NFTA_PAYLOAD_CSUM_OFFSET]	= { .type = NLA_U32 },
+	[NFTA_PAYLOAD_CSUM_FLAGS]	= { .type = NLA_U32 },
 };
 
 static int nft_payload_init(const struct nft_ctx *ctx,
-- 
2.20.1

