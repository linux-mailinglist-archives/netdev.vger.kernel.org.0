Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66B5B22029A
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 05:00:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728223AbgGOC7Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 22:59:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727898AbgGOC7X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 22:59:23 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A136C061755;
        Tue, 14 Jul 2020 19:59:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=JsZCksfFSkPmdruxu7XPoiapdR3dYCdo7nkKP/QG/oI=; b=iw7+j0YgiedOE/h0Z2sxSWHhl5
        dFFdD1/CpJAFCS26mG6GNdhKLqvyPoMx8/0QEN1WUtvxGN1k7TM5ICWfQRIb8WbXNvybT1CgwEQVl
        9SIss/LJa+khHq7b52fsRH+rXIO4+cZ24wVYnf5uIiOwuJit2WruLvZY1l1aC3Ju1vbyoJO0p4dLX
        yL36EjdRKkO/vo+FgSKw18dNfQaxlGHY8BR7BRDzMczQqWM0HCHZGtIZWiXDKxUVkNAS318kXl7z9
        xY06oXgIPYBgSd5gYg8Pab5ZlWthp1gzn6eHRev1Mr9sptsEN9xLMBLmwzievZFU1LwewyVMHi1Ti
        nc31yC3g==;
Received: from [2601:1c0:6280:3f0::19c2] (helo=smtpauth.infradead.org)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jvXdg-0001FT-Tt; Wed, 15 Jul 2020 02:59:21 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     linux-kernel@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH 02/13 net-next] net: wireless.h: drop duplicate word in comments
Date:   Tue, 14 Jul 2020 19:59:03 -0700
Message-Id: <20200715025914.28091-2-rdunlap@infradead.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200715025914.28091-1-rdunlap@infradead.org>
References: <20200715025914.28091-1-rdunlap@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Drop doubled word "threshold" in a comment.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org
---
 include/uapi/linux/wireless.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20200714.orig/include/uapi/linux/wireless.h
+++ linux-next-20200714/include/uapi/linux/wireless.h
@@ -914,7 +914,7 @@ union iwreq_data {
 	struct iw_param	sens;		/* signal level threshold */
 	struct iw_param	bitrate;	/* default bit rate */
 	struct iw_param	txpower;	/* default transmit power */
-	struct iw_param	rts;		/* RTS threshold threshold */
+	struct iw_param	rts;		/* RTS threshold */
 	struct iw_param	frag;		/* Fragmentation threshold */
 	__u32		mode;		/* Operation mode */
 	struct iw_param	retry;		/* Retry limits & lifetime */
