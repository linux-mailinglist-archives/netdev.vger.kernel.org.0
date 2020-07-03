Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 027CC2141C4
	for <lists+netdev@lfdr.de>; Sat,  4 Jul 2020 00:43:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726989AbgGCWl5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jul 2020 18:41:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726953AbgGCWlu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jul 2020 18:41:50 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49CB4C061794;
        Fri,  3 Jul 2020 15:41:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=TAp3JUpjIiZsCTuD68uTFJYctH0j2Yfl3aOkxNVpu7Q=; b=RJu03bKQuPnLQmqq/UbgVU06J8
        zyAPPrOYy8P+OOwmfWIGItapl8m2nbK7JxET098GzJwpM3IMoLUb8g1fioN+AB76/Oqk8HDpdnC8s
        psRJQuhlRWWGD8XLWMZ7JfggCW2fO794OUTk77eAicYjpIsEEDFNlwP25RkssjsOGwGZjXYNJpr5d
        eB1E05MhwwIY4sO3p50F2hJcJGtcq3cReftgUaTnv7pVuU8SMWtAET0CA0avhTb/4NQO3AyBkJxVv
        +A9RSbSH87bDmoLcgoL9L4MsE5X0W2BS2qcllV1NFdTqT+WUwG+gIy6UawYFfkSmqtxI8CAXeWutu
        5rxW9i2w==;
Received: from [2601:1c0:6280:3f0::19c2] (helo=smtpauth.infradead.org)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jrUNQ-0000A4-Gr; Fri, 03 Jul 2020 22:41:49 +0000
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
Subject: [PATCH 7/7] Documentation: networking: rxrpc: drop doubled word
Date:   Fri,  3 Jul 2020 15:41:15 -0700
Message-Id: <20200703224115.29769-8-rdunlap@infradead.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200703224115.29769-1-rdunlap@infradead.org>
References: <20200703224115.29769-1-rdunlap@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Drop the doubled word "have".

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: linux-doc@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>
Cc: linux-afs@lists.infradead.org
---
 Documentation/networking/rxrpc.rst |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20200701.orig/Documentation/networking/rxrpc.rst
+++ linux-next-20200701/Documentation/networking/rxrpc.rst
@@ -186,7 +186,7 @@ About the AF_RXRPC driver:
      time [tunable] after the last connection using it discarded, in case a new
      connection is made that could use it.
 
- (#) A client-side connection is only shared between calls if they have have
+ (#) A client-side connection is only shared between calls if they have
      the same key struct describing their security (and assuming the calls
      would otherwise share the connection).  Non-secured calls would also be
      able to share connections with each other.
