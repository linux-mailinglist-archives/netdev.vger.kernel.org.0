Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C0252141A1
	for <lists+netdev@lfdr.de>; Sat,  4 Jul 2020 00:41:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726806AbgGCWla (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jul 2020 18:41:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726427AbgGCWla (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jul 2020 18:41:30 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07537C061794;
        Fri,  3 Jul 2020 15:41:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=obxLkjmOHvOTOOWRKqfpoCcGv9pmbak2DrPOtPfRpHw=; b=LV2jdmlBNzyxevIX4+rynpCF5f
        9mOjTXckkG3GZLdBMHk1hCU0/moqQnaTbsKGd+B9unOfRtMoKglpLRljZnKwk0eQZrrMjukq61oUc
        HIpPNxvq3OqAkzeLQaw7W/ahdo28waYqRWt0Kt2kO03ZqtjCewaB6JJTXgU6NpiGU4ayT/eGD01lr
        ASEeogln6n1WqhaVsXqC0pVIPbo6NVdh0zPRotyWT5cnzkLjYPn7rWZFjVe8zlXAH7naXgJKgMrof
        pvrEYbb3NCb/BD+pA2jw01H0E4np5bKTPNcA/hF2m6DasDlhEIyUfpFjdZk3XaLbixfxxtglK/zEe
        DiFQYYow==;
Received: from [2601:1c0:6280:3f0::19c2] (helo=smtpauth.infradead.org)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jrUN6-0000A4-0L; Fri, 03 Jul 2020 22:41:28 +0000
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
Subject: [PATCH 2/7] Documentation: networking: ax25: drop doubled word
Date:   Fri,  3 Jul 2020 15:41:10 -0700
Message-Id: <20200703224115.29769-3-rdunlap@infradead.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200703224115.29769-1-rdunlap@infradead.org>
References: <20200703224115.29769-1-rdunlap@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Drop the doubled word "and".

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: linux-doc@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-hams@vger.kernel.org
---
 Documentation/networking/ax25.rst |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20200701.orig/Documentation/networking/ax25.rst
+++ linux-next-20200701/Documentation/networking/ax25.rst
@@ -6,7 +6,7 @@ AX.25
 
 To use the amateur radio protocols within Linux you will need to get a
 suitable copy of the AX.25 Utilities. More detailed information about
-AX.25, NET/ROM and ROSE, associated programs and and utilities can be
+AX.25, NET/ROM and ROSE, associated programs and utilities can be
 found on http://www.linux-ax25.org.
 
 There is an active mailing list for discussing Linux amateur radio matters
