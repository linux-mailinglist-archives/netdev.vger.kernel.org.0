Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E63432A9111
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 09:12:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726694AbgKFIMB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 03:12:01 -0500
Received: from m176115.mail.qiye.163.com ([59.111.176.115]:28271 "EHLO
        m176115.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726661AbgKFIMA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Nov 2020 03:12:00 -0500
Received: from vivo-HP-ProDesk-680-G4-PCI-MT.vivo.xyz (unknown [58.251.74.231])
        by m176115.mail.qiye.163.com (Hmail) with ESMTPA id ACE8866736E;
        Fri,  6 Nov 2020 16:11:56 +0800 (CST)
From:   Wang Qing <wangqing@vivo.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Stanislav Fomichev <sdf@google.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Yoshiki Komachi <komachi.yoshiki@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Wang Qing <wangqing@vivo.com>,
        Li RongQing <lirongqing@baidu.com>,
        Guillaume Nault <gnault@redhat.com>,
        Ariel Levkovich <lariel@mellanox.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net: core: fix spelling typo in flow_dissector.c
Date:   Fri,  6 Nov 2020 16:11:49 +0800
Message-Id: <1604650310-30432-1-git-send-email-wangqing@vivo.com>
X-Mailer: git-send-email 2.7.4
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZS1VLWVdZKFlBSE83V1ktWUFJV1kPCR
        oVCBIfWUFZGEpCGRlOGElPHh1DVkpNS09NTktISkxMS0JVEwETFhoSFyQUDg9ZV1kWGg8SFR0UWU
        FZT0tIVUpKS0hKQ1VLWQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6Kyo6STo*ST8fNx0eNFYXNRI8
        LSNPFCtVSlVKTUtPTU5LSEpDSk5PVTMWGhIXVQwaFRwKEhUcOw0SDRRVGBQWRVlXWRILWUFZTkNV
        SU5KVUxPVUlISllXWQgBWUFJSUlLNwY+
X-HM-Tid: 0a759c9cb6fb9373kuwsace8866736e
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

withing should be within.

Signed-off-by: Wang Qing <wangqing@vivo.com>
---
 net/core/flow_dissector.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
index e21950a..6f1adba
--- a/net/core/flow_dissector.c
+++ b/net/core/flow_dissector.c
@@ -48,7 +48,7 @@ void skb_flow_dissector_init(struct flow_dissector *flow_dissector,
 	memset(flow_dissector, 0, sizeof(*flow_dissector));
 
 	for (i = 0; i < key_count; i++, key++) {
-		/* User should make sure that every key target offset is withing
+		/* User should make sure that every key target offset is within
 		 * boundaries of unsigned short.
 		 */
 		BUG_ON(key->offset > USHRT_MAX);
-- 
2.7.4

