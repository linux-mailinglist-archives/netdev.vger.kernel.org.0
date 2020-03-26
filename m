Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 870E01940AD
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 15:02:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727887AbgCZOBy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 10:01:54 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:56637 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727719AbgCZOBx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 10:01:53 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 296645C021B;
        Thu, 26 Mar 2020 10:01:52 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Thu, 26 Mar 2020 10:01:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=v3g2CdzFokCGY5lXFpwgfSZqItG74unPBRltKBrZo9o=; b=dMy7o8NN
        D05MFFArBTiXx+V3J77fUMkm38/r0lV18j1Mso5oK0K/2w/kqYV3f7uimKRyjUBl
        U68HW/ZRmKbOqcymS1VOLv3RMRb21vbU1KeW0h3pY0XaEL9CglhR94HtgRasE1Vu
        U2nVDj5DhfjwDw7x/njqY4WnuOTemLBFAXlA/zys5BGY2++yK/9FjJlH/qE6aD3r
        c6ElMwrGyd8Z0iwPqE2XZ7ShyWCG9vjPFH7tduMzdFhP4T9ttvxz/nDTAm5haSwi
        i7jUw/I+o2bJN/kGDxCOC7KXXjHui0CSpWcq7Q3oKgNM4V2kCv94VP9m/Rm22V0M
        urGDHBQN0n8+0g==
X-ME-Sender: <xms:0LV8XulmTwRGKDXBWS-UVnwwtAvvo3S2bxuXfthFs0BOB_NAkV4UMg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudehiedgheelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeejledrudekuddrudefvddrudeludenucevlhhushhtvg
    hrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhs
    tghhrdhorhhg
X-ME-Proxy: <xmx:0LV8XoxFESmzz36PQipHO7_pw7aVxD0xi3bNZb6PZkyJXckOeKqwuQ>
    <xmx:0LV8Xk25ruI1rFKQYRjDSn8GcveoJOYfzL5_T-oKXSb-cpkHQZebbA>
    <xmx:0LV8Xha41bTX4XBZhx64loVbC0-yZCjqxZlcp8OW1ZEyzfyndVHdpg>
    <xmx:0LV8Xn6Xn7fVjQ0A2g0LrPetum_97vnj5Qg3TrTbSfT40d2tdc4lbA>
Received: from splinter.mtl.com (bzq-79-181-132-191.red.bezeqint.net [79.181.132.191])
        by mail.messagingengine.com (Postfix) with ESMTPA id B8AB93069990;
        Thu, 26 Mar 2020 10:01:50 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        petrm@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 1/6] net: flow_offload.h: Fix a comment at flow_action_entry.mangle
Date:   Thu, 26 Mar 2020 16:01:09 +0200
Message-Id: <20200326140114.1393972-2-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200326140114.1393972-1-idosch@idosch.org>
References: <20200326140114.1393972-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@mellanox.com>

This field references FLOW_ACTION_PACKET_EDIT. Such action does not exist
though. Instead the field is used for FLOW_ACTION_MANGLE and _ADD.

Signed-off-by: Petr Machata <petrm@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 include/net/flow_offload.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index d06bf8d566ac..ff071eaede17 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -202,7 +202,8 @@ struct flow_action_entry {
 			__be16		proto;
 			u8		prio;
 		} vlan;
-		struct {				/* FLOW_ACTION_PACKET_EDIT */
+		struct {				/* FLOW_ACTION_MANGLE */
+							/* FLOW_ACTION_ADD */
 			enum flow_action_mangle_base htype;
 			u32		offset;
 			u32		mask;
-- 
2.24.1

