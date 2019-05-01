Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1983110477
	for <lists+netdev@lfdr.de>; Wed,  1 May 2019 06:18:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726194AbfEAESL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 May 2019 00:18:11 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:37330 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726040AbfEAESD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 May 2019 00:18:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
        Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=uD5G/3Ylfut7SE7dEBujtwtcbbCE6R/GJvomAesaTIc=; b=smvUBNjBqiM2DETAyX8GYySlf
        PnY/DX1TVc5Vx8T2/EFkhuDndNvOJAQw93Wa+EWEIXuqIMb1tOOHueK99CKd8Kin11R9BmZqQh/Sg
        KHo5Iy/CDvzNanv5hvv+ut7oWs/VKhhLGVAtbSA2RzNYqv3xoySw881cb0qgG2xs0CjJ2bAhVR7gL
        rD0uS+FfmpYHAAtQ0XRsVj+u0Z4Ds6m+B8GjvuHRTP24TzAFfcnvbKcu6OOc7fQ5R6SHZmIB1w/8Q
        CRp90QBjj+pdkJXPewHo/8BM0Dsv3//jwYMZcV2ZMtjhQcmbXHXFLuUBUoa+fg2Xp0wfVRuVdNY1E
        /q6Gv8UMQ==;
Received: from willy by bombadil.infradead.org with local (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hLggz-0002GV-A9; Wed, 01 May 2019 04:18:01 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     davem@davemloft.net
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>, hch@lst.de,
        netdev@vger.kernel.org
Subject: [PATCH 3/5] net: Include bvec.h in skbuff.h
Date:   Tue, 30 Apr 2019 21:17:55 -0700
Message-Id: <20190501041757.8647-5-willy@infradead.org>
X-Mailer: git-send-email 2.14.5
In-Reply-To: <20190501041757.8647-1-willy@infradead.org>
References: <20190501041757.8647-1-willy@infradead.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>

Add the dependency now, even though we're not using the bio_vec yet.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 include/linux/skbuff.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 9c6193a57241..bc416e5886f4 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -18,6 +18,7 @@
 #include <linux/compiler.h>
 #include <linux/time.h>
 #include <linux/bug.h>
+#include <linux/bvec.h>
 #include <linux/cache.h>
 #include <linux/rbtree.h>
 #include <linux/socket.h>
-- 
2.20.1

