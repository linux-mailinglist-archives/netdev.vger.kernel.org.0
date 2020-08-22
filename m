Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 837EC24EA44
	for <lists+netdev@lfdr.de>; Sun, 23 Aug 2020 01:14:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728515AbgHVXOI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Aug 2020 19:14:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728454AbgHVXOG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Aug 2020 19:14:06 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EC5BC061573
        for <netdev@vger.kernel.org>; Sat, 22 Aug 2020 16:14:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=AQKkkVjR6UlOMmTuk0bmVSARYGJQD8WUkNffq9263Ig=; b=09huZ4QuQms/HGGmKr8GiUaoMU
        eEWcvgiEbMYVD9vpcLxuy98HW1sJptUl6/lpX80smJBREON2ti7Fze5nc79fTLbm8X9QGyCUUOWf/
        olUQnoTFcT33Cne8c8r7L9+m4yj4IDKn+CN4uGjCu9cBwDh5TmlJCNfgKoD3OjaHY3FLhPY4imfmR
        QTuxdooQ4bgnZ65Ix5KtYcUfkIRafjaazbd0EYWcfX1D76F/n/RZjy3agoAONSHBrh8pwpfHAMapJ
        TmZssahddBVSFwjslp5N0tdS46a7EQoduoeiVNuvk03UDVNQ3eEItWF4UWWbeNEBIC1zh2ykLzjvd
        6J+hBPJA==;
Received: from [2601:1c0:6280:3f0::19c2] (helo=smtpauth.infradead.org)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k9ci3-0006Nf-Qz; Sat, 22 Aug 2020 23:14:04 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     netdev@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Marek Lindner <mareklindner@neomailbox.ch>,
        Simon Wunderlich <sw@simonwunderlich.de>,
        Antonio Quartulli <a@unstable.cc>,
        Sven Eckelmann <sven@narfation.org>,
        b.a.t.m.a.n@lists.open-mesh.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7/8] net: batman-adv: soft-interface.c: delete duplicated words
Date:   Sat, 22 Aug 2020 16:13:34 -0700
Message-Id: <20200822231335.31304-8-rdunlap@infradead.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200822231335.31304-1-rdunlap@infradead.org>
References: <20200822231335.31304-1-rdunlap@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Drop the repeated word "the" in two places.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Marek Lindner <mareklindner@neomailbox.ch>
Cc: Simon Wunderlich <sw@simonwunderlich.de>
Cc: Antonio Quartulli <a@unstable.cc>
Cc: Sven Eckelmann <sven@narfation.org>
Cc: b.a.t.m.a.n@lists.open-mesh.org
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
---
 net/batman-adv/soft-interface.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-next-20200731.orig/net/batman-adv/soft-interface.c
+++ linux-next-20200731/net/batman-adv/soft-interface.c
@@ -649,7 +649,7 @@ static void batadv_softif_destroy_vlan(s
 /**
  * batadv_interface_add_vid() - ndo_add_vid API implementation
  * @dev: the netdev of the mesh interface
- * @proto: protocol of the the vlan id
+ * @proto: protocol of the vlan id
  * @vid: identifier of the new vlan
  *
  * Set up all the internal structures for handling the new vlan on top of the
@@ -707,7 +707,7 @@ static int batadv_interface_add_vid(stru
 /**
  * batadv_interface_kill_vid() - ndo_kill_vid API implementation
  * @dev: the netdev of the mesh interface
- * @proto: protocol of the the vlan id
+ * @proto: protocol of the vlan id
  * @vid: identifier of the deleted vlan
  *
  * Destroy all the internal structures used to handle the vlan identified by vid
