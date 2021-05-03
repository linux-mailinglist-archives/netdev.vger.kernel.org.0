Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7348A371F68
	for <lists+netdev@lfdr.de>; Mon,  3 May 2021 20:17:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229637AbhECSSF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 May 2021 14:18:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229590AbhECSSE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 May 2021 14:18:04 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14590C061763;
        Mon,  3 May 2021 11:17:11 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id y2so3284124plr.5;
        Mon, 03 May 2021 11:17:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=ucp+ihN6hQxRjYkxoaafJPKetZ1CYqMAuBiTi7jMjhA=;
        b=ZhF6lJuzR3JLR458T3ilx06rtxz9gP/PfEMWkwVyR+Qlq2G8G1nCJPiwzReEcA7hBn
         bD5DwPlpllPWhrV5E9WiUDbOtbXJyM+wnWS3nmQ0/oee7KOtovRCS3XzhziJB8SJNJo7
         7Or4fifn3qzjSO4qPIRELpdlI/SAblb3kRvQu0SLWMKLw1JE5l71a5mw//VbP30oRnZU
         JRQ9W5veZn38NoNqDO1Y8JdiW4bIrRiOkuQe4ebM455ukOeAnCzWSZuzthj6E9qiaj5H
         J6xybguZjLxItAJb7Gfw4ktPozr5n4A+ji0vVyxDIm6r8N2WT4uBR3cnSYoRApizxEln
         iaCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=ucp+ihN6hQxRjYkxoaafJPKetZ1CYqMAuBiTi7jMjhA=;
        b=Te7+HPaDdY61UFNE19aAcNhBEbsOXNNN95OGOsIaA/Mk+NUGTEj6ohuttLUx01pIXv
         x0JBbenbNyU27eWHzBzOZI8/OZfgiEHuz8qj5uah3BMDrY5IxaB/ozJ2+xM902vksRQ7
         mcvr6IztLaRa++uoHajS7C5CfhNF+H8hsg0DztwndJncgRoAatEvdSfkMMa2seyD0F7d
         aSJfv9j4XYrqVySrx4AqNrwqJbO4bL/kLur+7gOLphYUSL8WVKCpPsUlvQFZFuOCpVdL
         IspDqdKUrQmJH5ZRSJ2b0csY49heZ5oU75mv4YQl31hA3fdd862fwD0uUMkhwExPvr9C
         bN+g==
X-Gm-Message-State: AOAM5321jUpYrA6wlm8tqhVTOqaSon5RrIdjldBXv+YCO64pGyOxqP98
        vFHa/hlfrrm/X8KF1lExa7Y=
X-Google-Smtp-Source: ABdhPJwo/bOQcrq1AHdmQkPm9m99u5hnC1pnoyiZy0MSQYs45OW7juak/uN7/d2bbcxrzTtlr9PjTw==
X-Received: by 2002:a17:902:a415:b029:e7:137b:ef9c with SMTP id p21-20020a170902a415b02900e7137bef9cmr21786958plq.28.1620065830593;
        Mon, 03 May 2021 11:17:10 -0700 (PDT)
Received: from localhost ([157.45.98.61])
        by smtp.gmail.com with ESMTPSA id g16sm9954666pfu.45.2021.05.03.11.17.09
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 03 May 2021 11:17:10 -0700 (PDT)
Date:   Mon, 3 May 2021 23:47:06 +0530
From:   Shubhankar Kuranagatti <shubhankarvk@gmail.com>
To:     pshelar@ovn.org
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        dev@openvswitch.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: openswitch: flow_netlink.c: Fix indentation errors
Message-ID: <20210503181706.vd5onvgptqd7squ2@kewl-virtual-machine>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: NeoMutt/20171215
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Every subsequent line starts with a * of block comment
The closing */ is shifted to a new line
New line added after declaration
The repeasted word 'is' is omitted from comment block
This is done to maintain code uniformity

Signed-off-by: Shubhankar Kuranagatti <shubhankarvk@gmail.com>
---
 net/openvswitch/flow_netlink.c | 24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

diff --git a/net/openvswitch/flow_netlink.c b/net/openvswitch/flow_netlink.c
index fd1f809e9bc1..b774d93860ab 100644
--- a/net/openvswitch/flow_netlink.c
+++ b/net/openvswitch/flow_netlink.c
@@ -156,7 +156,8 @@ static bool match_validate(const struct sw_flow_match *match,
 	u64 mask_allowed = key_attrs;  /* At most allow all key attributes */
 
 	/* The following mask attributes allowed only if they
-	 * pass the validation tests. */
+	 * pass the validation tests.
+	 */
 	mask_allowed &= ~((1 << OVS_KEY_ATTR_IPV4)
 			| (1 << OVS_KEY_ATTR_CT_ORIG_TUPLE_IPV4)
 			| (1 << OVS_KEY_ATTR_IPV6)
@@ -2019,6 +2020,7 @@ static int __ovs_nla_put_key(const struct sw_flow_key *swkey,
 				goto nla_put_failure;
 	} else {
 		u16 upper_u16;
+
 		upper_u16 = !is_mask ? 0 : 0xffff;
 
 		if (nla_put_u32(skb, OVS_KEY_ATTR_IN_PORT,
@@ -2060,11 +2062,11 @@ static int __ovs_nla_put_key(const struct sw_flow_key *swkey,
 
 		if (swkey->eth.type == htons(ETH_P_802_2)) {
 			/*
-			* Ethertype 802.2 is represented in the netlink with omitted
-			* OVS_KEY_ATTR_ETHERTYPE in the flow key attribute, and
-			* 0xffff in the mask attribute.  Ethertype can also
-			* be wildcarded.
-			*/
+			 * Ethertype 802.2 is represented in the netlink with omitted
+			 * OVS_KEY_ATTR_ETHERTYPE in the flow key attribute, and
+			 * 0xffff in the mask attribute.  Ethertype can also
+			 * be wildcarded.
+			 */
 			if (is_mask && output->eth.type)
 				if (nla_put_be16(skb, OVS_KEY_ATTR_ETHERTYPE,
 							output->eth.type))
@@ -2329,7 +2331,8 @@ static void __ovs_nla_free_flow_actions(struct rcu_head *head)
 }
 
 /* Schedules 'sf_acts' to be freed after the next RCU grace period.
- * The caller must hold rcu_read_lock for this to be sensible. */
+ * The caller must hold rcu_read_lock for this to be sensible.
+ */
 void ovs_nla_free_flow_actions_rcu(struct sw_flow_actions *sf_acts)
 {
 	call_rcu(&sf_acts->rcu, __ovs_nla_free_flow_actions);
@@ -2446,6 +2449,7 @@ static int validate_and_copy_sample(struct net *net, const struct nlattr *attr,
 	memset(attrs, 0, sizeof(attrs));
 	nla_for_each_nested(a, attr, rem) {
 		int type = nla_type(a);
+
 		if (!type || type > OVS_SAMPLE_ATTR_MAX || attrs[type])
 			return -EINVAL;
 		attrs[type] = a;
@@ -3184,13 +3188,14 @@ static int __ovs_nla_copy_actions(struct net *net, const struct nlattr *attr,
 
 		case OVS_ACTION_ATTR_POP_MPLS: {
 			__be16  proto;
+
 			if (vlan_tci & htons(VLAN_CFI_MASK) ||
 			    !eth_p_mpls(eth_type))
 				return -EINVAL;
 
 			/* Disallow subsequent L2.5+ set actions and mpls_pop
 			 * actions once the last MPLS label in the packet is
-			 * is popped as there is no check here to ensure that
+			 * popped as there is no check here to ensure that
 			 * the new eth type is valid and thus set actions could
 			 * write off the end of the packet or otherwise corrupt
 			 * it.
@@ -3255,7 +3260,8 @@ static int __ovs_nla_copy_actions(struct net *net, const struct nlattr *attr,
 
 		case OVS_ACTION_ATTR_PUSH_ETH:
 			/* Disallow pushing an Ethernet header if one
-			 * is already present */
+			 * is already present
+			 */
 			if (mac_proto != MAC_PROTO_NONE)
 				return -EINVAL;
 			mac_proto = MAC_PROTO_ETHERNET;
-- 
2.17.1

