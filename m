Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01B0624EA42
	for <lists+netdev@lfdr.de>; Sun, 23 Aug 2020 01:14:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728470AbgHVXOE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Aug 2020 19:14:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728413AbgHVXN7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Aug 2020 19:13:59 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E2BBC061573
        for <netdev@vger.kernel.org>; Sat, 22 Aug 2020 16:13:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=jN0keby5tgRTIpkJS5lSU+8rJVPstHTKjDGQectMSts=; b=QXmgoTrIZzmFgk6XzTEDSUzImZ
        MBxMZaBP/HJP5xUj/CrDZyf5RgTWRWFHQ3eUgN5Byur8aZYJ6WkcfiDA1pR1uN6jFPgoeaBllsjfa
        m5xJfck83p3f5dm3yo7xb/qDAwW9tvVCQ6XAhvxFRer3Y0pAkSzHs+XJ+fcgVw7mcVaVG0K8t7LRH
        I6kE1upj550VgrJj+0SPORrH3z2uHoJXlqM0jqfmbwo2LPDuJJHNAwogig5uJ4mzDZEesTQm6AEYP
        FS99uO0P74LYhs6lXGXF1draHsEQWVXF4YRO7mnonYPvkg3cR+G3idJ2kSv+nBv9hSdNzFn4IsiKH
        2L1Y4vLA==;
Received: from [2601:1c0:6280:3f0::19c2] (helo=smtpauth.infradead.org)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k9chx-0006Nf-8q; Sat, 22 Aug 2020 23:13:57 +0000
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
Subject: [PATCH 5/8] net: batman-adv: network-coding.c: fix duplicated word
Date:   Sat, 22 Aug 2020 16:13:32 -0700
Message-Id: <20200822231335.31304-6-rdunlap@infradead.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200822231335.31304-1-rdunlap@infradead.org>
References: <20200822231335.31304-1-rdunlap@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Change "is is" to "it is".

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Marek Lindner <mareklindner@neomailbox.ch>
Cc: Simon Wunderlich <sw@simonwunderlich.de>
Cc: Antonio Quartulli <a@unstable.cc>
Cc: Sven Eckelmann <sven@narfation.org>
Cc: b.a.t.m.a.n@lists.open-mesh.org
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
---
 net/batman-adv/network-coding.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20200731.orig/net/batman-adv/network-coding.c
+++ linux-next-20200731/net/batman-adv/network-coding.c
@@ -250,7 +250,7 @@ static void batadv_nc_path_put(struct ba
 /**
  * batadv_nc_packet_free() - frees nc packet
  * @nc_packet: the nc packet to free
- * @dropped: whether the packet is freed because is is dropped
+ * @dropped: whether the packet is freed because it is dropped
  */
 static void batadv_nc_packet_free(struct batadv_nc_packet *nc_packet,
 				  bool dropped)
