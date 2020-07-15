Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEC2E220298
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 04:59:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728466AbgGOC7f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 22:59:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728400AbgGOC7e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 22:59:34 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F04AAC061755;
        Tue, 14 Jul 2020 19:59:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=ufO4lHePtrPPVz7YbFrezalftZMWhKJ1TX8oM3yPcfM=; b=gmucBQdEVlKk+FMDuRFc2mEwTR
        o+4TN/09L/t6Cxyz6d+u+bhuIvfhgVkPvFNtVJo1R5NYzcD0QGWImKFaNi4+y9xLDG8dbx0jOjYB9
        Tjyrv4dH8Wabjzjm7ivtYGDFU6s1OAA03oUZ42PUN2p68gDl4X8Xa0ekcPoeKJYzaP3JYBIsJKDtb
        Tw/Mc22M2CY8ViYA+URBZ3KZ+uP+v+n/TGOZ0P/OjGfKoCxLkCFkWidH2OdgalXOdXEpXphEQwAif
        RMfB4F4Qy1J621lA+kqt67s97KQhudP2NvqgCUyPIQvEzQICyBgvaRclsZuM06kt0mVVYbZeqtntD
        lnXVUmcw==;
Received: from [2601:1c0:6280:3f0::19c2] (helo=smtpauth.infradead.org)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jvXdr-0001FT-G8; Wed, 15 Jul 2020 02:59:32 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     linux-kernel@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH 07/13 net-next] net: caif: drop duplicate words in comments
Date:   Tue, 14 Jul 2020 19:59:08 -0700
Message-Id: <20200715025914.28091-7-rdunlap@infradead.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200715025914.28091-1-rdunlap@infradead.org>
References: <20200715025914.28091-1-rdunlap@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Drop doubled words "or" and "the" in several comments.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org
---
 include/net/caif/caif_layer.h         |    4 ++--
 include/uapi/linux/caif/caif_socket.h |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

--- linux-next-20200714.orig/include/net/caif/caif_layer.h
+++ linux-next-20200714/include/net/caif/caif_layer.h
@@ -156,7 +156,7 @@ struct cflayer {
 	 *  CAIF packets upwards in the stack.
 	 *	Packet handling rules:
 	 *	      - The CAIF packet (cfpkt) ownership is passed to the
-	 *		called receive function. This means that the the
+	 *		called receive function. This means that the
 	 *		packet cannot be accessed after passing it to the
 	 *		above layer using up->receive().
 	 *
@@ -184,7 +184,7 @@ struct cflayer {
 	 *	CAIF packet downwards in the stack.
 	 *	Packet handling rules:
 	 *	      - The CAIF packet (cfpkt) ownership is passed to the
-	 *		transmit function. This means that the the packet
+	 *		transmit function. This means that the packet
 	 *		cannot be accessed after passing it to the below
 	 *		layer using dn->transmit().
 	 *
--- linux-next-20200714.orig/include/uapi/linux/caif/caif_socket.h
+++ linux-next-20200714/include/uapi/linux/caif/caif_socket.h
@@ -169,7 +169,7 @@ struct sockaddr_caif {
  * @CAIFSO_LINK_SELECT:		Selector used if multiple CAIF Link layers are
  *				available. Either a high bandwidth
  *				link can be selected (CAIF_LINK_HIGH_BANDW) or
- *				or a low latency link (CAIF_LINK_LOW_LATENCY).
+ *				a low latency link (CAIF_LINK_LOW_LATENCY).
  *                              This option is of type __u32.
  *				Alternatively SO_BINDTODEVICE can be used.
  *
