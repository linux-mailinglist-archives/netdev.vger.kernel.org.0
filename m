Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0DB12141A9
	for <lists+netdev@lfdr.de>; Sat,  4 Jul 2020 00:42:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726715AbgGCWl3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jul 2020 18:41:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726415AbgGCWl2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jul 2020 18:41:28 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 295EDC061794;
        Fri,  3 Jul 2020 15:41:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=3immjcWU6Dl5EbU3oekN+THQaKhifogQrF4rzqf1vcY=; b=tag9iWYZ/1ZjktaNwyt+NguXxH
        OM56Suxy/syqkGTKqxA8N+X7zTsyfIaJditGt//3DLSoryzMAHgUrOQKgeScP/otYAjiP6BmXSe7b
        uslVrvtBDrJN4yjNZYBFHcoh7e8J8rtNdZ7ddejMZvSYCNSFWMlj0+VJP5LDSuBQ4FpDf/X4A7/Au
        6P53fRLh/Abpf4jlcJTKpV79lHStiSq1kSfNFccqXMSKFpAi+RDqa2qSDMYKOeeeHF6qNWCvgKxU+
        Qr2bJ6b227/IvF2750+eFYRyRh9wh9hFqK24jPmOfsxrtiohu+MEx+2+q9jTPfFAN7UeDZMvSGyP0
        5ZD/8r5A==;
Received: from [2601:1c0:6280:3f0::19c2] (helo=smtpauth.infradead.org)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jrUN2-0000A4-8H; Fri, 03 Jul 2020 22:41:24 +0000
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
Subject: [PATCH 1/7] Documentation: networking: arcnet: drop doubled word
Date:   Fri,  3 Jul 2020 15:41:09 -0700
Message-Id: <20200703224115.29769-2-rdunlap@infradead.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200703224115.29769-1-rdunlap@infradead.org>
References: <20200703224115.29769-1-rdunlap@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Drop the doubled word "to".

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: linux-doc@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org
---
 Documentation/networking/arcnet.rst |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20200701.orig/Documentation/networking/arcnet.rst
+++ linux-next-20200701/Documentation/networking/arcnet.rst
@@ -434,7 +434,7 @@ can set up your network then:
 	ifconfig arc0 insight
 	route add insight arc0
 	route add freedom arc0	/* I would use the subnet here (like I said
-					to to in "single protocol" above),
+					to in "single protocol" above),
 					but the rest of the subnet
 					unfortunately lies across the PPP
 					link on freedom, which confuses
