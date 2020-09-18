Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 451AF26F531
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 06:36:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726670AbgIREfm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 00:35:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726596AbgIREfj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 00:35:39 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8B5AC061756
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 21:35:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=ZakyNADs4+MTnZkmyH6JGe0PQqiBzON5RV6ndadEjGQ=; b=HauoLpYqxB6OT3RaUpWNwGOPxm
        Y9jerMtcTF97sTjX3ijD8jmSWM45+YIRiWLbcB7p1Dol9RBDtC/avR8ylQj2IOjaeLZeh26GW5s3K
        4KEQj5NI5k0wUX/hlGld5VRol4DMAz1IaW/sBwcInOQbn77HvuJ8zb5d2ePBvvKSoacVNTC9HDDqw
        7IuJlTTsb+WE7kv9srVK27gfBw6ichsfiL0LzeLyuuwCEaR+z/nwc5ZlIEq1QCnW/DP2flE0007Zo
        09ERbUUcPU6BUyu4hbMQEpRUpfljWBXzOmVpJki4XCGuIO+UG48Xyv993PH73muObjK7NJk8GMf65
        iDMUCOzA==;
Received: from [2601:1c0:6280:3f0::19c2] (helo=smtpauth.infradead.org)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kJ87V-0003Ci-Oc; Fri, 18 Sep 2020 04:35:38 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     netdev@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Chas Williams <3chas3@gmail.com>,
        linux-atm-general@lists.sourceforge.net
Subject: [PATCH 6/7 net-next] net: atm: delete duplicated words
Date:   Thu, 17 Sep 2020 21:35:20 -0700
Message-Id: <20200918043521.17346-7-rdunlap@infradead.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200918043521.17346-1-rdunlap@infradead.org>
References: <20200918043521.17346-1-rdunlap@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Drop repeated words in net/atm/.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Chas Williams <3chas3@gmail.com>
Cc: linux-atm-general@lists.sourceforge.net
---
 net/atm/lec.c       |    2 +-
 net/atm/signaling.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- linux-next-20200917.orig/net/atm/lec.c
+++ linux-next-20200917/net/atm/lec.c
@@ -1070,7 +1070,7 @@ module_exit(lane_module_cleanup);
 /*
  * LANE2: 3.1.3, LE_RESOLVE.request
  * Non force allocates memory and fills in *tlvs, fills in *sizeoftlvs.
- * If sizeoftlvs == NULL the default TLVs associated with with this
+ * If sizeoftlvs == NULL the default TLVs associated with this
  * lec will be used.
  * If dst_mac == NULL, targetless LE_ARP will be sent
  */
--- linux-next-20200917.orig/net/atm/signaling.c
+++ linux-next-20200917/net/atm/signaling.c
@@ -52,7 +52,7 @@ static void modify_qos(struct atm_vcc *v
 			msg->type = as_okay;
 	}
 	/*
-	 * Should probably just turn around the old skb. But the, the buffer
+	 * Should probably just turn around the old skb. But then, the buffer
 	 * space accounting needs to follow the change too. Maybe later.
 	 */
 	while (!(skb = alloc_skb(sizeof(struct atmsvc_msg), GFP_KERNEL)))
