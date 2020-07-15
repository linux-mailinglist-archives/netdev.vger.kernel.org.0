Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B36D02212BA
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 18:43:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727775AbgGOQnV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 12:43:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726848AbgGOQnC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 12:43:02 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BC03C08C5DD;
        Wed, 15 Jul 2020 09:43:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=rVogcT426PGyLvoUNdTgr7VENg0eIIZYWQNj2Y9szTg=; b=UyT29T+CfhuGwocKjAuPAoT3Me
        urnys3Tm0QaAmf9KtBCldbm7CY70Azn/6Fq8iJ0uwagPj3nUXgFfAcuv0AjiNQoiXclXuYYOPM1iV
        uvdhIsHnC6yTuCRNBitmUEeBGSEA7MGSSpI/aTaCDhRFn/Asflurvq3mj61+C6CFYDJCHRLntkQCo
        UQX5DWe63beKLP18Xyy2pi4toP+5TRdBV4ZMiTvsTxCGRCresfEj0AHY5MXHAvVYXt3xRjwJ1MVWb
        QOe2WBixkjxtIqUkrIbJfSdyjqc6IphTUhNcD30QfPiLh2xlrdWA9PevSPiKM7RofqFBFMohDooeg
        dzYcs5hQ==;
Received: from [2601:1c0:6280:3f0::19c2] (helo=smtpauth.infradead.org)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jvkUm-0000Bh-7v; Wed, 15 Jul 2020 16:43:00 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     linux-kernel@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH 6/9 v2 net-next] net: dsa.h: drop duplicate word in comment
Date:   Wed, 15 Jul 2020 09:42:43 -0700
Message-Id: <20200715164246.9054-6-rdunlap@infradead.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200715164246.9054-1-rdunlap@infradead.org>
References: <20200715164246.9054-1-rdunlap@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Drop doubled word "to" in a comment.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org
---
v2: move wireless patches to a separate patch series.

 include/net/dsa.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20200714.orig/include/net/dsa.h
+++ linux-next-20200714/include/net/dsa.h
@@ -612,7 +612,7 @@ struct dsa_switch_ops {
 	 * MTU change functionality. Switches can also adjust their MRU through
 	 * this method. By MTU, one understands the SDU (L2 payload) length.
 	 * If the switch needs to account for the DSA tag on the CPU port, this
-	 * method needs to to do so privately.
+	 * method needs to do so privately.
 	 */
 	int	(*port_change_mtu)(struct dsa_switch *ds, int port,
 				   int new_mtu);
