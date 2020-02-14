Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88FAF15F350
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 19:21:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403840AbgBNSKg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 13:10:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:33038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731310AbgBNPxl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Feb 2020 10:53:41 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1960924681;
        Fri, 14 Feb 2020 15:53:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581695621;
        bh=sYHwINYDTcWh7EmWRxPDfsVNBX9NO+F8ciF4WJXac0s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nCDL2vIjCQVogsFEwXmXnaxtBn6/Vj/rvuZXdz6+i2Ls9EBBNhDzXqPVMc9nFpJ9W
         nCaK+Cc4ufg2xOLo0hht+1wqoYG7+orVKHQfkPS2PXM+9aVr39ccgyYWBN7Qc9iTrV
         iUuWDQOdOvh7U838wdEzczAZkfOkQo9NWkeWypq8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xin Long <lucien.xin@gmail.com>,
        Simon Horman <simon.horman@netronome.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 220/542] netfilter: nft_tunnel: add the missing ERSPAN_VERSION nla_policy
Date:   Fri, 14 Feb 2020 10:43:32 -0500
Message-Id: <20200214154854.6746-220-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214154854.6746-1-sashal@kernel.org>
References: <20200214154854.6746-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>

[ Upstream commit 0705f95c332081036d85f26691e9d3cd7d901c31 ]

ERSPAN_VERSION is an attribute parsed in kernel side, nla_policy
type should be added for it, like other attributes.

Fixes: af308b94a2a4 ("netfilter: nf_tables: add tunnel support")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Reviewed-by: Simon Horman <simon.horman@netronome.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_tunnel.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nft_tunnel.c b/net/netfilter/nft_tunnel.c
index 5284fcf16be73..f8d2919cf9fdc 100644
--- a/net/netfilter/nft_tunnel.c
+++ b/net/netfilter/nft_tunnel.c
@@ -248,8 +248,9 @@ static int nft_tunnel_obj_vxlan_init(const struct nlattr *attr,
 }
 
 static const struct nla_policy nft_tunnel_opts_erspan_policy[NFTA_TUNNEL_KEY_ERSPAN_MAX + 1] = {
+	[NFTA_TUNNEL_KEY_ERSPAN_VERSION]	= { .type = NLA_U32 },
 	[NFTA_TUNNEL_KEY_ERSPAN_V1_INDEX]	= { .type = NLA_U32 },
-	[NFTA_TUNNEL_KEY_ERSPAN_V2_DIR]	= { .type = NLA_U8 },
+	[NFTA_TUNNEL_KEY_ERSPAN_V2_DIR]		= { .type = NLA_U8 },
 	[NFTA_TUNNEL_KEY_ERSPAN_V2_HWID]	= { .type = NLA_U8 },
 };
 
-- 
2.20.1

