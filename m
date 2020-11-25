Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DCED2C3801
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 05:21:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727558AbgKYEUl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 23:20:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726330AbgKYEUl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Nov 2020 23:20:41 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1A1BC0613D4
        for <netdev@vger.kernel.org>; Tue, 24 Nov 2020 20:20:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=VJo6N6SdrcYVOYJCT6yq5tV1dGyg8dFba1gjt6zbIKg=; b=UPX545Qu14nqYkHZugehumoO6a
        24XZW4wq3OZ35OweonjlU46A1r0CSaAYW8mlMbQMEuRqdU4un8ItQTSiVoJZeue+YSNpoyr+xY+gP
        syibajJ10Jr4MnI8CoEp+HlJfw7jmJ2eOWrsmaAkUIwRamgRuUdAidL6R9mdByI6zZxQJ/M11Ihy4
        tZ35GGJ7SseGl4ljYJCz50zzjHvO4Pube0IQpZnP49rmdvs6nRoEHLBtx0FW4stSILpx/Odp5rHw0
        YC5P+6V+O+8i4/UJ4PRK9dnRgpIs5wKMt7uQn6V0QiKYBvA6e+3DK6oqVncHPFsBIh11GByrULRcP
        hjCI4uIQ==;
Received: from [2601:1c0:6280:3f0::cc1f] (helo=smtpauth.infradead.org)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1khmIF-0000SB-BM; Wed, 25 Nov 2020 04:20:35 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Jon Maloy <jmaloy@redhat.com>,
        Ying Xue <ying.xue@windriver.com>, netdev@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 03/10 net-next] net/tipc: fix bearer.c for kernel-doc
Date:   Tue, 24 Nov 2020 20:20:18 -0800
Message-Id: <20201125042026.25374-3-rdunlap@infradead.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201125042026.25374-1-rdunlap@infradead.org>
References: <20201125042026.25374-1-rdunlap@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
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
Cc: netdev@vger.kernel.org
Cc: tipc-discussion@lists.sourceforge.net
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
---
 net/tipc/bearer.c |   20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

--- linux-next-20201124.orig/net/tipc/bearer.c
+++ linux-next-20201124/net/tipc/bearer.c
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
