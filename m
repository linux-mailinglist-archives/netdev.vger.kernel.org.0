Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 299DA24EAAB
	for <lists+netdev@lfdr.de>; Sun, 23 Aug 2020 03:07:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726461AbgHWBHs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Aug 2020 21:07:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725767AbgHWBHs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Aug 2020 21:07:48 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B003C061573;
        Sat, 22 Aug 2020 18:07:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=qautpq+EnlVzvGbxgqXPsYXHCAdg5C0rCD589ZNQVsI=; b=i/xb51bh+44l8GLr89aIdqzfTl
        d1lwRILKNq+kq9KulSav1TYgnHA6yb+eWpS9XjWJMPb97UMkEFgt0Kt62da7ytfWoskEn9pBioGCD
        VnLvAqFrruSV0Reihvc59ccGAXnsjSiJbhNxfknEk2tKC4V4acglLjMf0TeozFmycV39zxAp9hM7k
        UXfjbQAYLnwJm4FoOM57IMsw1r6aeKjAr8ajZuAfdZayBgInz9UEkE7IPYa26EOqIooshfY5cCxGA
        Fly9EM9tv90BpBqNeOIEMCQb6LDkXBDvrO64pdrJRM4K8OWqYuudQGRdcv8YefzTpbT9dSif1iC28
        YyPFKX5Q==;
Received: from [2601:1c0:6280:3f0::19c2] (helo=smtpauth.infradead.org)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k9eU2-0005OW-M2; Sun, 23 Aug 2020 01:07:43 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     netdev@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Chuck Lever <chuck.lever@oracle.com>, linux-nfs@vger.kernel.org
Subject: [PATCH] net: sunrpc: delete repeated words
Date:   Sat, 22 Aug 2020 18:07:38 -0700
Message-Id: <20200823010738.4837-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Drop duplicate words in net/sunrpc/.
Also fix "Anyone" to be "Any one".

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Chuck Lever <chuck.lever@oracle.com>
Cc: linux-nfs@vger.kernel.org
---
 net/sunrpc/backchannel_rqst.c     |    2 +-
 net/sunrpc/xdr.c                  |    2 +-
 net/sunrpc/xprtrdma/svc_rdma_rw.c |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

--- linux-next-20200821.orig/net/sunrpc/backchannel_rqst.c
+++ linux-next-20200821/net/sunrpc/backchannel_rqst.c
@@ -111,7 +111,7 @@ out_free:
  * by the backchannel.  This function can be called multiple times
  * when creating new sessions that use the same rpc_xprt.  The
  * preallocated buffers are added to the pool of resources used by
- * the rpc_xprt.  Anyone of these resources may be used used by an
+ * the rpc_xprt.  Any one of these resources may be used by an
  * incoming callback request.  It's up to the higher levels in the
  * stack to enforce that the maximum number of session slots is not
  * being exceeded.
--- linux-next-20200821.orig/net/sunrpc/xdr.c
+++ linux-next-20200821/net/sunrpc/xdr.c
@@ -658,7 +658,7 @@ EXPORT_SYMBOL_GPL(xdr_reserve_space);
  * head, tail, and page lengths are adjusted to correspond.
  *
  * If this means moving xdr->p to a different buffer, we assume that
- * that the end pointer should be set to the end of the current page,
+ * the end pointer should be set to the end of the current page,
  * except in the case of the head buffer when we assume the head
  * buffer's current length represents the end of the available buffer.
  *
--- linux-next-20200821.orig/net/sunrpc/xprtrdma/svc_rdma_rw.c
+++ linux-next-20200821/net/sunrpc/xprtrdma/svc_rdma_rw.c
@@ -137,7 +137,7 @@ static int svc_rdma_rw_ctx_init(struct s
 }
 
 /* A chunk context tracks all I/O for moving one Read or Write
- * chunk. This is a a set of rdma_rw's that handle data movement
+ * chunk. This is a set of rdma_rw's that handle data movement
  * for all segments of one chunk.
  *
  * These are small, acquired with a single allocator call, and
