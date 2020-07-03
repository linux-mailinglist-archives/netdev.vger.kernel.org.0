Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD2D22141A6
	for <lists+netdev@lfdr.de>; Sat,  4 Jul 2020 00:41:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726914AbgGCWlk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jul 2020 18:41:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726427AbgGCWlh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jul 2020 18:41:37 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61F71C061794;
        Fri,  3 Jul 2020 15:41:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=MI/O3E9XMLkq0MsmM0yGtfQqYn/d33U+QIgI7LbgU/U=; b=T1mqaOG6l4OLdsD93ur1bn2JcZ
        rRwUfjAJJ6WfsULBszOTXiVnpURQ4/k+PwaHPmaK7JrIyDG17l6PA9PTT4uspxcaqaYFgImDQcNKt
        nE8vqSRDVjD/kAWcCHVPb2yGvW57iFIkeDmGMKzGz7lRM+GA7uU/+ocXHrQb6lX+kkz4x74qtmxwL
        ZBgNpHZg2xfIv8HfcvvA9lmRX63269Xm2PT3Tw6zW7gNHAKNZ2LdX1r0NLq1A/PNSaI3UymBwOAwF
        GfAENWBRuQw0cKIEMQCDPymKL/C8waD4aMH+hbR48NwatouDJiO92BIRLg8nMHJPEgagVsRx917B8
        UHGn5jtA==;
Received: from [2601:1c0:6280:3f0::19c2] (helo=smtpauth.infradead.org)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jrUND-0000A4-KN; Fri, 03 Jul 2020 22:41:36 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     linux-kernel@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Ralf Baechle <ralf@linux-mips.org>, linux-hams@vger.kernel.org,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-can@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        David Howells <dhowells@redhat.com>,
        linux-afs@lists.infradead.org
Subject: [PATCH 4/7] Documentation: networking: dsa: drop doubled word
Date:   Fri,  3 Jul 2020 15:41:12 -0700
Message-Id: <20200703224115.29769-5-rdunlap@infradead.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200703224115.29769-1-rdunlap@infradead.org>
References: <20200703224115.29769-1-rdunlap@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Drop the doubled word "in".

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: linux-doc@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Vivien Didelot <vivien.didelot@gmail.com>
Cc: Florian Fainelli <f.fainelli@gmail.com>
---
 Documentation/networking/dsa/dsa.rst |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20200701.orig/Documentation/networking/dsa/dsa.rst
+++ linux-next-20200701/Documentation/networking/dsa/dsa.rst
@@ -95,7 +95,7 @@ Ethernet switch.
 Networking stack hooks
 ----------------------
 
-When a master netdev is used with DSA, a small hook is placed in in the
+When a master netdev is used with DSA, a small hook is placed in the
 networking stack is in order to have the DSA subsystem process the Ethernet
 switch specific tagging protocol. DSA accomplishes this by registering a
 specific (and fake) Ethernet type (later becoming ``skb->protocol``) with the
