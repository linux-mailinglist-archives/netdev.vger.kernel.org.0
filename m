Return-Path: <netdev+bounces-5718-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 97182712878
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 16:34:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 50A932818B3
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 14:34:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D633F18B0E;
	Fri, 26 May 2023 14:31:55 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB4193C0A9
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 14:31:55 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C71A8E57
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 07:31:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685111502;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CKSB6Rx2bx1fJ9JqD5rxOprNdt4epz1O6h3wMG9pSn8=;
	b=gyWfqspAL2ukHovRqjqfYBKvjbjf4Z5NXpE7tGcOUhBhgNT12RmRqg7riY+ZYCoZB8OcPr
	4YAFUHsc45EaxRWXOVLCKA7SEVVKQWYdRK7LWrnoQRcVORqwF+OEW/5it30o2P+xv7T2GD
	QKqvJgRNr/YVbSEYw6LSp1gDSgR6hnQ=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-25-jLnS6QVHOfGVhUBPQMxYFw-1; Fri, 26 May 2023 10:31:25 -0400
X-MC-Unique: jLnS6QVHOfGVhUBPQMxYFw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0AC7B3855561;
	Fri, 26 May 2023 14:31:25 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.39.192.68])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 25EEC140E95D;
	Fri, 26 May 2023 14:31:23 +0000 (UTC)
From: David Howells <dhowells@redhat.com>
To: netdev@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
	David Ahern <dsahern@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Jens Axboe <axboe@kernel.dk>,
	linux-crypto@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH net-next 5/8] crypto: af_alg: Indent the loop in af_alg_sendmsg()
Date: Fri, 26 May 2023 15:31:01 +0100
Message-Id: <20230526143104.882842-6-dhowells@redhat.com>
In-Reply-To: <20230526143104.882842-1-dhowells@redhat.com>
References: <20230526143104.882842-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Put the loop in af_alg_sendmsg() into an if-statement to indent it to make
the next patch easier to review as that will add another branch to handle
MSG_SPLICE_PAGES to the if-statement.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Herbert Xu <herbert@gondor.apana.org.au>
cc: "David S. Miller" <davem@davemloft.net>
cc: Eric Dumazet <edumazet@google.com>
cc: Jakub Kicinski <kuba@kernel.org>
cc: Paolo Abeni <pabeni@redhat.com>
cc: Jens Axboe <axboe@kernel.dk>
cc: Matthew Wilcox <willy@infradead.org>
cc: linux-crypto@vger.kernel.org
cc: netdev@vger.kernel.org
---
 crypto/af_alg.c | 50 +++++++++++++++++++++++++------------------------
 1 file changed, 26 insertions(+), 24 deletions(-)

diff --git a/crypto/af_alg.c b/crypto/af_alg.c
index 8a35f1364ac3..17ecaae50af7 100644
--- a/crypto/af_alg.c
+++ b/crypto/af_alg.c
@@ -1030,35 +1030,37 @@ int af_alg_sendmsg(struct socket *sock, struct msghdr *msg, size_t size,
 		if (sgl->cur)
 			sg_unmark_end(sg + sgl->cur - 1);
 
-		do {
-			struct page *pg;
-			unsigned int i = sgl->cur;
+		if (1 /* TODO check MSG_SPLICE_PAGES */) {
+			do {
+				struct page *pg;
+				unsigned int i = sgl->cur;
 
-			plen = min_t(size_t, len, PAGE_SIZE);
+				plen = min_t(size_t, len, PAGE_SIZE);
 
-			pg = alloc_page(GFP_KERNEL);
-			if (!pg) {
-				err = -ENOMEM;
-				goto unlock;
-			}
+				pg = alloc_page(GFP_KERNEL);
+				if (!pg) {
+					err = -ENOMEM;
+					goto unlock;
+				}
 
-			sg_assign_page(sg + i, pg);
+				sg_assign_page(sg + i, pg);
 
-			err = memcpy_from_msg(page_address(sg_page(sg + i)),
-					      msg, plen);
-			if (err) {
-				__free_page(sg_page(sg + i));
-				sg_assign_page(sg + i, NULL);
-				goto unlock;
-			}
+				err = memcpy_from_msg(page_address(sg_page(sg + i)),
+						      msg, plen);
+				if (err) {
+					__free_page(sg_page(sg + i));
+					sg_assign_page(sg + i, NULL);
+					goto unlock;
+				}
 
-			sg[i].length = plen;
-			len -= plen;
-			ctx->used += plen;
-			copied += plen;
-			size -= plen;
-			sgl->cur++;
-		} while (len && sgl->cur < MAX_SGL_ENTS);
+				sg[i].length = plen;
+				len -= plen;
+				ctx->used += plen;
+				copied += plen;
+				size -= plen;
+				sgl->cur++;
+			} while (len && sgl->cur < MAX_SGL_ENTS);
+		}
 
 		if (!size)
 			sg_mark_end(sg + sgl->cur - 1);


