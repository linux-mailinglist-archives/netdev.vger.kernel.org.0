Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 505C4225344
	for <lists+netdev@lfdr.de>; Sun, 19 Jul 2020 20:08:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726582AbgGSSIH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jul 2020 14:08:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725783AbgGSSIG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jul 2020 14:08:06 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AB06C0619D2;
        Sun, 19 Jul 2020 11:08:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=SMAflqxFtKYvuD/zNrCkVtSVEznXOD/fPTYx9a9ZcGA=; b=R2KFV6MARlfZUI+VwU95iCtpCv
        DEpw61ck68Bj2iDvNLtjtOGefOSxGYMqK1sB79Ef4zg/Gz63yLDqAFZHNhrO9MweTdTBFW8uw+mDs
        TK5sUYhvvwYJWrPLw9jkjH4KZHHAa+Bp5SlxoIEXN1XMVQ70LrvIn0oP8gqDaosYKvqQsNyKm6DKc
        YHyjxonvh9+iCf0lo3PsMU8JIT2nSL3yEu17oXka5UR44eXwOBPyDnDtI4sqdEudhYRKEnzN/GxQZ
        UsHWK1XZ02Gzk5cxwQH6PJ5nrKbWcJmpspczsWuvNfh4n/Be0P/lRi2lHmq4OehSs4AW6SF8JVYil
        wZlMUaFQ==;
Received: from [2601:1c0:6280:3f0::19c2] (helo=smtpauth.infradead.org)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jxDjH-00069e-VO; Sun, 19 Jul 2020 18:08:04 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     linux-kernel@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH] net: atm: lec_arpc.h: delete duplicated word
Date:   Sun, 19 Jul 2020 11:08:01 -0700
Message-Id: <20200719180801.11913-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Delete the doubled word "the" in a comment.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org
---
 net/atm/lec_arpc.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20200717.orig/net/atm/lec_arpc.h
+++ linux-next-20200717/net/atm/lec_arpc.h
@@ -44,7 +44,7 @@ struct lec_arp_table {
 	u8 *tlvs;
 	u32 sizeoftlvs;			/*
 					 * LANE2: Each MAC address can have TLVs
-					 * associated with it.  sizeoftlvs tells the
+					 * associated with it.  sizeoftlvs tells
 					 * the length of the tlvs array
 					 */
 	struct sk_buff_head tx_wait;	/* wait queue for outgoing packets */
