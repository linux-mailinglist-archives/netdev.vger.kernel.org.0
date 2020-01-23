Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6BBF146007
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 01:43:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726968AbgAWAno (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 19:43:44 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:52657 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725911AbgAWAno (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jan 2020 19:43:44 -0500
Received: from [82.43.126.140] (helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1iuQan-000694-7F; Thu, 23 Jan 2020 00:43:29 +0000
From:   Colin King <colin.king@canonical.com>
To:     Wensong Zhang <wensong@linux-vs.org>,
        Simon Horman <horms@verge.net.au>,
        Julian Anastasov <ja@ssi.bg>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        lvs-devel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ipvs: fix spelling mistake "to" -> "too"
Date:   Thu, 23 Jan 2020 00:43:28 +0000
Message-Id: <20200123004328.2833127-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

There is a spelling mistake in a IP_VS_ERR_RL message. Fix it.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 net/netfilter/ipvs/ip_vs_sync.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/ipvs/ip_vs_sync.c b/net/netfilter/ipvs/ip_vs_sync.c
index 8dc892a9dc91..605e0f68f8bd 100644
--- a/net/netfilter/ipvs/ip_vs_sync.c
+++ b/net/netfilter/ipvs/ip_vs_sync.c
@@ -1239,7 +1239,7 @@ static void ip_vs_process_message(struct netns_ipvs *ipvs, __u8 *buffer,
 
 			p = msg_end;
 			if (p + sizeof(s->v4) > buffer+buflen) {
-				IP_VS_ERR_RL("BACKUP, Dropping buffer, to small\n");
+				IP_VS_ERR_RL("BACKUP, Dropping buffer, too small\n");
 				return;
 			}
 			s = (union ip_vs_sync_conn *)p;
-- 
2.24.0

