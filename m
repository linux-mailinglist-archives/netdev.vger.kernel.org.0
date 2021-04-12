Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F9CE35D323
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 00:31:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343764AbhDLWb2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 18:31:28 -0400
Received: from mail.netfilter.org ([217.70.188.207]:50468 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239551AbhDLWb0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Apr 2021 18:31:26 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 7193463E49;
        Tue, 13 Apr 2021 00:30:42 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 2/7] netfilter: conntrack: do not print icmpv6 as unknown via /proc
Date:   Tue, 13 Apr 2021 00:30:54 +0200
Message-Id: <20210412223059.20841-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210412223059.20841-1-pablo@netfilter.org>
References: <20210412223059.20841-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

/proc/net/nf_conntrack shows icmpv6 as unknown.

Fixes: 09ec82f5af99 ("netfilter: conntrack: remove protocol name from l4proto struct")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_standalone.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index 0ee702d374b0..c6c0cb465664 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -266,6 +266,7 @@ static const char* l4proto_name(u16 proto)
 	case IPPROTO_GRE: return "gre";
 	case IPPROTO_SCTP: return "sctp";
 	case IPPROTO_UDPLITE: return "udplite";
+	case IPPROTO_ICMPV6: return "icmpv6";
 	}
 
 	return "unknown";
-- 
2.20.1

