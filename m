Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F37BB3E884B
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 04:53:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232384AbhHKCyO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 22:54:14 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:40022 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232359AbhHKCyM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Aug 2021 22:54:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628650429;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cIYkM1oceHUF5M5M7y6mDalGAS+icR1r20XWEpzseRI=;
        b=A45swsAiroGN/0JFdR5dRoN6AIUtbNoFJH5OonxgUAXIpgVqqjlD3o5nnthOFgj5og12q5
        hOR7ZvwujrD5Ohj6armRpAn3VYeqtfP+Fmbsfz0qxJF1QrOC3NaVvqSwnEkjjm7TAUMqfL
        H4fiM8CjbhSGMdvT46Xz36lCKtzwDGA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-93-ycdJX4G_Ny2rEXJnsXEP4A-1; Tue, 10 Aug 2021 22:53:45 -0400
X-MC-Unique: ycdJX4G_Ny2rEXJnsXEP4A-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BF9CB8799EC;
        Wed, 11 Aug 2021 02:53:42 +0000 (UTC)
Received: from jtoppins.rdu.csb (unknown [10.22.16.129])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 807F01B472;
        Wed, 11 Aug 2021 02:53:41 +0000 (UTC)
From:   Jonathan Toppins <jtoppins@redhat.com>
To:     netdev@vger.kernel.org, joe@perches.com, leon@kernel.org
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2 1/2] bonding: remove extraneous definitions from bonding.h
Date:   Tue, 10 Aug 2021 22:53:30 -0400
Message-Id: <1f0363ad94f08cb0d3303b402477a15e4c3b7864.1628650079.git.jtoppins@redhat.com>
In-Reply-To: <cover.1628650079.git.jtoppins@redhat.com>
References: <cover.1628650079.git.jtoppins@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
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
index 9f3fdc180c6c..15e083e18f75 100644
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
@@ -755,13 +750,6 @@ static inline int bond_get_targets_ip(__be32 *targets, __be32 ip)
 
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

