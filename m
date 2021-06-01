Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65F0B397C2D
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 00:07:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235097AbhFAWIk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 18:08:40 -0400
Received: from mail.netfilter.org ([217.70.188.207]:39566 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234950AbhFAWIV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Jun 2021 18:08:21 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id A2AFF64175;
        Wed,  2 Jun 2021 00:05:32 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 10/16] netfilter: reduce size of nf_hook_state on 32bit platforms
Date:   Wed,  2 Jun 2021 00:06:23 +0200
Message-Id: <20210601220629.18307-11-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210601220629.18307-1-pablo@netfilter.org>
References: <20210601220629.18307-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Reduce size from 28 to 24 bytes on 32bit platforms.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index f0f3a8354c3c..f161569fbe2f 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -65,8 +65,8 @@ struct nf_hook_ops;
 struct sock;
 
 struct nf_hook_state {
-	unsigned int hook;
-	u_int8_t pf;
+	u8 hook;
+	u8 pf;
 	struct net_device *in;
 	struct net_device *out;
 	struct sock *sk;
-- 
2.30.2

