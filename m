Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2B08262E7F
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 14:27:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729808AbgIIM03 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 08:26:29 -0400
Received: from m17618.mail.qiye.163.com ([59.111.176.18]:56657 "EHLO
        m17618.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730077AbgIIMXu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 08:23:50 -0400
X-Greylist: delayed 413 seconds by postgrey-1.27 at vger.kernel.org; Wed, 09 Sep 2020 08:23:05 EDT
Received: from vivo-HP-ProDesk-680-G4-PCI-MT.vivo.xyz (unknown [58.251.74.226])
        by m17618.mail.qiye.163.com (Hmail) with ESMTPA id 8D7FC4E13B0;
        Wed,  9 Sep 2020 20:12:55 +0800 (CST)
From:   Wang Qing <wangqing@vivo.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Wang Qing <wangqing@vivo.com>
Subject: [PATCH] net/netfilter: fix a typo for nf_conntrack_proto_dccp.c
Date:   Wed,  9 Sep 2020 20:12:44 +0800
Message-Id: <1599653567-27147-1-git-send-email-wangqing@vivo.com>
X-Mailer: git-send-email 2.7.4
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgYFAkeWUFZS1VLWVdZKFlBSE83V1ktWUFJV1kPCR
        oVCBIfWUFZGRhCH0wYQk9LSU8eVkpOQkJNTkhOTE1LSkxVEwETFhoSFyQUDg9ZV1kWGg8SFR0UWU
        FZT0tIVUpKS0hKQ1VKS0tZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6Nyo6Nhw4AT8oGh0jPQ0MFjdK
        EDAaCiJVSlVKTkJCTU5ITkxNT0hJVTMWGhIXVQwaFRwKEhUcOw0SDRRVGBQWRVlXWRILWUFZTkNV
        SU5KVUxPVUlJTVlXWQgBWUFKQkxMNwY+
X-HM-Tid: 0a7472c87cd49376kuws8d7fc4e13b0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Change the comment typo: "direcly" -> "directly".

Signed-off-by: Wang Qing <wangqing@vivo.com>
---
 net/netfilter/nf_conntrack_proto_dccp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conntrack_proto_dccp.c b/net/netfilter/nf_conntrack_proto_dccp.c
index b3f4a33..d9bb0ce
--- a/net/netfilter/nf_conntrack_proto_dccp.c
+++ b/net/netfilter/nf_conntrack_proto_dccp.c
@@ -340,7 +340,7 @@ dccp_state_table[CT_DCCP_ROLE_MAX + 1][DCCP_PKT_SYNCACK + 1][CT_DCCP_MAX + 1] =
 		 * sNO -> sIV		No connection
 		 * sRQ -> sIV		No connection
 		 * sRS -> sIV		No connection
-		 * sPO -> sOP -> sCG	Move direcly to CLOSING
+		 * sPO -> sOP -> sCG	Move directly to CLOSING
 		 * sOP -> sCG		Move to CLOSING
 		 * sCR -> sIV		Close after CloseReq is invalid
 		 * sCG -> sCG		Retransmit
-- 
2.7.4

