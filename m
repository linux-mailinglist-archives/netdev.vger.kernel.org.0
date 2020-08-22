Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D14C424EA4E
	for <lists+netdev@lfdr.de>; Sun, 23 Aug 2020 01:16:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728638AbgHVXQU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Aug 2020 19:16:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727115AbgHVXQR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Aug 2020 19:16:17 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AA7DC061573;
        Sat, 22 Aug 2020 16:16:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=oZca3cfPefz8CGKkkEbxyq++GJ96gqnIcPIfu0aj+Lg=; b=v92yRORrBlvUGSYhfw522OGem4
        5L95YcMNmQfxLqgC8md6/0yVszAbuqg9SrDRrJg2K2Vlce4MrlRJ3uQyZCSacnErwCjDkB3+/qz7W
        ezA6N2l//6uDLRaqKzDMiy6xdHEoYWpeCBB3z8baFpqv9A27O8Oil26PWmW+XrYVZucaVV/71pc3n
        J8V5n1OZDhzF3jIfQUYQyY+QpOv59LTybafJbgouuYWyj79X6USd2uK5yEGHIoHcWAO5HBE0WhbuO
        EpRM027Iu3Wt2ZJjHh/XuKzpsXOhpBQYcq03h0yrK59RvG0SiH6eJax4QtJAFvU3bszvqIId3qfta
        sKTaiK4g==;
Received: from [2601:1c0:6280:3f0::19c2] (helo=smtpauth.infradead.org)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k9ckB-0006VD-58; Sat, 22 Aug 2020 23:16:15 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     netdev@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        linux-sctp@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 3/7] net: sctp: bind_addr.c: delete duplicated word
Date:   Sat, 22 Aug 2020 16:15:57 -0700
Message-Id: <20200822231601.32125-4-rdunlap@infradead.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200822231601.32125-1-rdunlap@infradead.org>
References: <20200822231601.32125-1-rdunlap@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Drop the repeated word "of".

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Vlad Yasevich <vyasevich@gmail.com>
Cc: Neil Horman <nhorman@tuxdriver.com>
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: linux-sctp@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
---
 net/sctp/bind_addr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20200731.orig/net/sctp/bind_addr.c
+++ linux-next-20200731/net/sctp/bind_addr.c
@@ -505,7 +505,7 @@ int sctp_in_scope(struct net *net, const
 		return 0;
 	/*
 	 * For INIT and INIT-ACK address list, let L be the level of
-	 * of requested destination address, sender and receiver
+	 * requested destination address, sender and receiver
 	 * SHOULD include all of its addresses with level greater
 	 * than or equal to L.
 	 *
