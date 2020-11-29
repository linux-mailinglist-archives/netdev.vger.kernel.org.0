Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C21352C7A9D
	for <lists+netdev@lfdr.de>; Sun, 29 Nov 2020 19:34:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728440AbgK2Sdq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Nov 2020 13:33:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725830AbgK2Sdl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Nov 2020 13:33:41 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 669D9C0613D3
        for <netdev@vger.kernel.org>; Sun, 29 Nov 2020 10:33:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=8SHLUZUGVeU3G1KnQGuqw4ldWQixmb84ZDGBve16OSg=; b=D7KLN/WU/J8EZ4js4BPQe1GhL7
        VNmodV5+HcXUhyfmjN3a1iMzH0fsWp9Q+uUgf+0Gl5cZH9CrvxmSaSApP5m+WD43CcA6VCWMt9E1b
        eNCuguUIqz/ig9rPku8WQnSoOZeVpkReflzv6xseKn2TXvOOMBAnCDCtyG7G5ihEIVioEqexBObFo
        DZqe3Hyjs3Serh2hgg332VJ/KKogssc66blY+xq9BODkL5/NJ+qBt/ExVDm8Fd5RTd3v6PqN1XGYa
        4vXNx2HMIEKpp4IivPNOlj8Sn0wcBUHNZsZpCeXbDmJ81Gwz2TXluFMJTd0DVpbVZUkYFRk28XWvn
        42RfSgVA==;
Received: from [2601:1c0:6280:3f0::cc1f] (helo=smtpauth.infradead.org)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kjRVK-00011y-W0; Sun, 29 Nov 2020 18:32:59 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     netdev@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Jon Maloy <jmaloy@redhat.com>,
        Ying Xue <ying.xue@windriver.com>,
        tipc-discussion@lists.sourceforge.net,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 03/10 net-next v2] net/tipc: fix bearer.c for kernel-doc
Date:   Sun, 29 Nov 2020 10:32:42 -0800
Message-Id: <20201129183251.7049-2-rdunlap@infradead.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201129183251.7049-1-rdunlap@infradead.org>
References: <20201129183251.7049-1-rdunlap@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix kernel-doc warnings in bearer.c:

../net/tipc/bearer.c:77: warning: Function parameter or member 'name' not described in 'tipc_media_find'
../net/tipc/bearer.c:91: warning: Function parameter or member 'type' not described in 'media_find_id'
../net/tipc/bearer.c:105: warning: Function parameter or member 'buf' not described in 'tipc_media_addr_printf'
../net/tipc/bearer.c:105: warning: Function parameter or member 'len' not described in 'tipc_media_addr_printf'
../net/tipc/bearer.c:105: warning: Function parameter or member 'a' not described in 'tipc_media_addr_printf'
../net/tipc/bearer.c:174: warning: Function parameter or member 'net' not described in 'tipc_bearer_find'
../net/tipc/bearer.c:174: warning: Function parameter or member 'name' not described in 'tipc_bearer_find'
../net/tipc/bearer.c:238: warning: Function parameter or member 'net' not described in 'tipc_enable_bearer'
../net/tipc/bearer.c:238: warning: Function parameter or member 'name' not described in 'tipc_enable_bearer'
../net/tipc/bearer.c:238: warning: Function parameter or member 'disc_domain' not described in 'tipc_enable_bearer'
../net/tipc/bearer.c:238: warning: Function parameter or member 'prio' not described in 'tipc_enable_bearer'
../net/tipc/bearer.c:238: warning: Function parameter or member 'attr' not described in 'tipc_enable_bearer'
../net/tipc/bearer.c:350: warning: Function parameter or member 'net' not described in 'tipc_reset_bearer'
../net/tipc/bearer.c:350: warning: Function parameter or member 'b' not described in 'tipc_reset_bearer'
../net/tipc/bearer.c:374: warning: Function parameter or member 'net' not described in 'bearer_disable'
../net/tipc/bearer.c:374: warning: Function parameter or member 'b' not described in 'bearer_disable'
../net/tipc/bearer.c:462: warning: Function parameter or member 'net' not described in 'tipc_l2_send_msg'
../net/tipc/bearer.c:479: warning: Function parameter or member 'net' not described in 'tipc_l2_send_msg'

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Jon Maloy <jmaloy@redhat.com>
Cc: Ying Xue <ying.xue@windriver.com>
Cc: tipc-discussion@lists.sourceforge.net
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
---
v2: rebase to current net-next

 net/tipc/bearer.c |   20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

--- net-next.orig/net/tipc/bearer.c
+++ net-next/net/tipc/bearer.c
@@ -72,6 +72,7 @@ static int tipc_l2_rcv_msg(struct sk_buf
 
 /**
  * tipc_media_find - locates specified media object by name
+ * @name: name to locate
  */
 struct tipc_media *tipc_media_find(const char *name)
 {
@@ -86,6 +87,7 @@ struct tipc_media *tipc_media_find(const
 
 /**
  * media_find_id - locates specified media object by type identifier
+ * @type: type identifier to locate
  */
 static struct tipc_media *media_find_id(u8 type)
 {
@@ -100,6 +102,9 @@ static struct tipc_media *media_find_id(
 
 /**
  * tipc_media_addr_printf - record media address in print buffer
+ * @buf: output buffer
+ * @len: output buffer size remaining
+ * @a: input media address
  */
 int tipc_media_addr_printf(char *buf, int len, struct tipc_media_addr *a)
 {
@@ -166,6 +171,8 @@ static int bearer_name_validate(const ch
 
 /**
  * tipc_bearer_find - locates bearer object with matching bearer name
+ * @net: the applicable net namespace
+ * @name: bearer name to locate
  */
 struct tipc_bearer *tipc_bearer_find(struct net *net, const char *name)
 {
@@ -228,6 +235,11 @@ void tipc_bearer_remove_dest(struct net
 
 /**
  * tipc_enable_bearer - enable bearer with the given name
+ * @net: the applicable net namespace
+ * @name: bearer name to enable
+ * @disc_domain: bearer domain
+ * @prio: bearer priority
+ * @attr: nlattr array
  */
 static int tipc_enable_bearer(struct net *net, const char *name,
 			      u32 disc_domain, u32 prio,
@@ -342,6 +354,8 @@ rejected:
 
 /**
  * tipc_reset_bearer - Reset all links established over this bearer
+ * @net: the applicable net namespace
+ * @b: the target bearer
  */
 static int tipc_reset_bearer(struct net *net, struct tipc_bearer *b)
 {
@@ -363,7 +377,9 @@ void tipc_bearer_put(struct tipc_bearer
 }
 
 /**
- * bearer_disable
+ * bearer_disable - disable this bearer
+ * @net: the applicable net namespace
+ * @b: the bearer to disable
  *
  * Note: This routine assumes caller holds RTNL lock.
  */
@@ -434,6 +450,7 @@ int tipc_enable_l2_media(struct net *net
 }
 
 /* tipc_disable_l2_media - detach TIPC bearer from an L2 interface
+ * @b: the target bearer
  *
  * Mark L2 bearer as inactive so that incoming buffers are thrown away
  */
@@ -450,6 +467,7 @@ void tipc_disable_l2_media(struct tipc_b
 
 /**
  * tipc_l2_send_msg - send a TIPC packet out over an L2 interface
+ * @net: the associated network namespace
  * @skb: the packet to be sent
  * @b: the bearer through which the packet is to be sent
  * @dest: peer destination address
