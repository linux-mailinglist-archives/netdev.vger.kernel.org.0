Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 792963E32FB
	for <lists+netdev@lfdr.de>; Sat,  7 Aug 2021 05:31:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230422AbhHGDba (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Aug 2021 23:31:30 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:49818 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230344AbhHGDb2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Aug 2021 23:31:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628307071;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1GPVvs1yoqBSBjZUGINHsGdiiToWdyqKwx+nEq67PUs=;
        b=IAAf7OrBlY+h+VrNilGs9kbG91r9uRTrtzQUco9/06cGHIBpZ7kkFkI8mN+IWrUmouHfrS
        1kx76B3B1saXwOdCPV48z+1Ez36NlC2ewN3ovWc2o2G0WJI1zJ+z2IY4Xt/T7R42kSrndC
        vjYyPWTlxFsa6IPl6rLdJh2s3+fHwU4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-292-Y7fME_fQNbepwMSLLhtWyw-1; Fri, 06 Aug 2021 23:31:10 -0400
X-MC-Unique: Y7fME_fQNbepwMSLLhtWyw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 101A7180FCC5;
        Sat,  7 Aug 2021 03:31:09 +0000 (UTC)
Received: from jtoppins.rdu.csb (unknown [10.22.8.31])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E17F119C59;
        Sat,  7 Aug 2021 03:31:07 +0000 (UTC)
From:   Jonathan Toppins <jtoppins@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 1/2] bonding: remove extraneous definitions from bonding.h
Date:   Fri,  6 Aug 2021 23:30:54 -0400
Message-Id: <88916c847e85e726f8fa93ff60dccadcf02b3d6e.1628306392.git.jtoppins@redhat.com>
In-Reply-To: <cover.1628306392.git.jtoppins@redhat.com>
References: <cover.1628306392.git.jtoppins@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

All of the symbols either only exist in bond_options.c or nowhere at
all. These symbols were verified to not exist in the code base by
using `git grep` and their removal was verified by compiling bonding.ko.

Signed-off-by: Jonathan Toppins <jtoppins@redhat.com>
---
 include/net/bonding.h | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/include/net/bonding.h b/include/net/bonding.h
index 46df47004803..2ff4ac65bbe3 100644
--- a/include/net/bonding.h
+++ b/include/net/bonding.h
@@ -150,11 +150,6 @@ struct bond_params {
 	u8 ad_actor_system[ETH_ALEN + 2];
 };
 
-struct bond_parm_tbl {
-	char *modename;
-	int mode;
-};
-
 struct slave {
 	struct net_device *dev; /* first - useful for panic debug */
 	struct bonding *bond; /* our master */
@@ -754,13 +749,6 @@ static inline int bond_get_targets_ip(__be32 *targets, __be32 ip)
 
 /* exported from bond_main.c */
 extern unsigned int bond_net_id;
-extern const struct bond_parm_tbl bond_lacp_tbl[];
-extern const struct bond_parm_tbl xmit_hashtype_tbl[];
-extern const struct bond_parm_tbl arp_validate_tbl[];
-extern const struct bond_parm_tbl arp_all_targets_tbl[];
-extern const struct bond_parm_tbl fail_over_mac_tbl[];
-extern const struct bond_parm_tbl pri_reselect_tbl[];
-extern struct bond_parm_tbl ad_select_tbl[];
 
 /* exported from bond_netlink.c */
 extern struct rtnl_link_ops bond_link_ops;
-- 
2.27.0

