Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8332C176E5F
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 06:06:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727459AbgCCFF6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 00:05:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:37762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727101AbgCCFFq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Mar 2020 00:05:46 -0500
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BF65024686;
        Tue,  3 Mar 2020 05:05:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583211946;
        bh=37aiOqU2Pi+F/KNrvLvzvlqiDqgS/d1hZNB4nLqmAL0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I1JvjNFlu/eC0VRVwCt6f30pN105DaQa4fgPoXWs+xFfky6w1TynNI/Fg929tSuO8
         3H/L3MoFhLyZukAEw5dEsPDQS7o2hnY8HEV6hWVRNmEwO8avsCuPEwyISLOlHnpBrT
         m3RgW6GG3BlkXNdfhepIzG+2cRfaKgQhlep6qX5k=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Jon Maloy <jmaloy@redhat.com>,
        Ying Xue <ying.xue@windriver.com>,
        GhantaKrishnamurthy MohanKrishna 
        <mohan.krishna.ghanta.krishnamurthy@ericsson.com>
Subject: [PATCH net 13/16] tipc: add missing attribute validation for MTU property
Date:   Mon,  2 Mar 2020 21:05:23 -0800
Message-Id: <20200303050526.4088735-14-kuba@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200303050526.4088735-1-kuba@kernel.org>
References: <20200303050526.4088735-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add missing attribute validation for TIPC_NLA_PROP_MTU
to the netlink policy.

Fixes: 901271e0403a ("tipc: implement configuration of UDP media MTU")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: Jon Maloy <jmaloy@redhat.com>
CC: Ying Xue <ying.xue@windriver.com>
CC: GhantaKrishnamurthy MohanKrishna <mohan.krishna.ghanta.krishnamurthy@ericsson.com>
---
 net/tipc/netlink.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/tipc/netlink.c b/net/tipc/netlink.c
index 7c35094c20b8..bb9862410e68 100644
--- a/net/tipc/netlink.c
+++ b/net/tipc/netlink.c
@@ -116,6 +116,7 @@ const struct nla_policy tipc_nl_prop_policy[TIPC_NLA_PROP_MAX + 1] = {
 	[TIPC_NLA_PROP_PRIO]		= { .type = NLA_U32 },
 	[TIPC_NLA_PROP_TOL]		= { .type = NLA_U32 },
 	[TIPC_NLA_PROP_WIN]		= { .type = NLA_U32 },
+	[TIPC_NLA_PROP_MTU]		= { .type = NLA_U32 },
 	[TIPC_NLA_PROP_BROADCAST]	= { .type = NLA_U32 },
 	[TIPC_NLA_PROP_BROADCAST_RATIO]	= { .type = NLA_U32 }
 };
-- 
2.24.1

