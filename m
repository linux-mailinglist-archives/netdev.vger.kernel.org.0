Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7882012DE2E
	for <lists+netdev@lfdr.de>; Wed,  1 Jan 2020 09:20:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727359AbgAAIUo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jan 2020 03:20:44 -0500
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:56955 "EHLO
        mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727194AbgAAIUR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jan 2020 03:20:17 -0500
X-IronPort-AV: E=Sophos;i="5.69,382,1571695200"; 
   d="scan'208";a="429578762"
Received: from palace.rsr.lip6.fr (HELO palace.lip6.fr) ([132.227.105.202])
  by mail2-relais-roc.national.inria.fr with ESMTP/TLS/AES128-SHA256; 01 Jan 2020 09:20:08 +0100
From:   Julia Lawall <Julia.Lawall@inria.fr>
To:     "J. Bruce Fields" <bfields@fieldses.org>
Cc:     kernel-janitors@vger.kernel.org,
        Chuck Lever <chuck.lever@oracle.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        "David S. Miller" <davem@davemloft.net>, linux-nfs@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 12/16] SUNRPC: constify copied structure
Date:   Wed,  1 Jan 2020 08:43:30 +0100
Message-Id: <1577864614-5543-13-git-send-email-Julia.Lawall@inria.fr>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1577864614-5543-1-git-send-email-Julia.Lawall@inria.fr>
References: <1577864614-5543-1-git-send-email-Julia.Lawall@inria.fr>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The empty_iov structure is only copied into another structure,
so make it const.

The opportunity for this change was found using Coccinelle.

Signed-off-by: Julia Lawall <Julia.Lawall@inria.fr>

---
 net/sunrpc/xdr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sunrpc/xdr.c b/net/sunrpc/xdr.c
index f3104be8ff5d..e5497dc2475b 100644
--- a/net/sunrpc/xdr.c
+++ b/net/sunrpc/xdr.c
@@ -1079,7 +1079,7 @@ void xdr_enter_page(struct xdr_stream *xdr, unsigned int len)
 }
 EXPORT_SYMBOL_GPL(xdr_enter_page);
 
-static struct kvec empty_iov = {.iov_base = NULL, .iov_len = 0};
+static const struct kvec empty_iov = {.iov_base = NULL, .iov_len = 0};
 
 void
 xdr_buf_from_iov(struct kvec *iov, struct xdr_buf *buf)

