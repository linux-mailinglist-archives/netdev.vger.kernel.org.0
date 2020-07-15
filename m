Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A87792212CB
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 18:45:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727913AbgGOQni (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 12:43:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726941AbgGOQnH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 12:43:07 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 566DCC061755;
        Wed, 15 Jul 2020 09:43:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=fhXbIAxOvLawpatfmd6lRi0iAaY9jxDHPqpleO//3Xk=; b=L4aE+Yg3g1NbIvla3uOY8nNuvv
        xHro/LRvFK2/1oCCYve7o20YWbymTbGUTb3U6vqrRMEQKc8zf6LCT7YbKi0iN7hnr55biodcie9+g
        0pftmi5/kQpan8J/DPjOGJMmohAANrK19Wv1ZB7vxwCRflQluT09FtXcAD7WOcsVe6aw8j4K2/l0F
        WsA6LanSiURbIVRjsEnD2lZsEeFjw+PdjFfxFRpTumFToHQUo6igYc2x9ZsIvt7nUwDR5L+7KUalY
        skYi/R+8rR+IIF2p2EkNiOM9l+wJ2yc71Kfc87zkutPDMy9WTV5ZyBiXr1bZ6JDTIjpftevy/8CuO
        wB7Pr/OQ==;
Received: from [2601:1c0:6280:3f0::19c2] (helo=smtpauth.infradead.org)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jvkUr-0000Bh-Gd; Wed, 15 Jul 2020 16:43:06 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     linux-kernel@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH 9/9 v2 net-next] net: ipv6: drop duplicate word in comment
Date:   Wed, 15 Jul 2020 09:42:46 -0700
Message-Id: <20200715164246.9054-9-rdunlap@infradead.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200715164246.9054-1-rdunlap@infradead.org>
References: <20200715164246.9054-1-rdunlap@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Drop the doubled word "by" in a comment.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org
---
v2: move wireless patches to a separate patch series, though this one
    is a new patch.

 include/linux/ipv6.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20200714.orig/include/linux/ipv6.h
+++ linux-next-20200714/include/linux/ipv6.h
@@ -223,7 +223,7 @@ struct ipv6_pinfo {
 
 	/*
 	 * Packed in 16bits.
-	 * Omit one shift by by putting the signed field at MSB.
+	 * Omit one shift by putting the signed field at MSB.
 	 */
 #if defined(__BIG_ENDIAN_BITFIELD)
 	__s16			hop_limit:9;
