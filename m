Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0E892C1627
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 21:29:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732894AbgKWULi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 15:11:38 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:46985 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732857AbgKWULf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 15:11:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606162295;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=F0QukjO6aR8L02486bHDvbRpskA9uHaWcQNCmuPJS/k=;
        b=VgO7OPPDh+J9Aju6mkv28BkK24N4NOuqgNg8xLxZwBgoDHGJTQTD5p/VO8aOB5tSPXeIr1
        0Pndo2gTKMyPEs3/pH2RtGdn3nZf8flLtgEX189K23FNOTykws1JVY0lr4vBM/xaxqRbFM
        gOepisaaZeGQplyVEd+A48LJ7ZlY1/0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-114-UEZH4NIWPSio0SO7HzHi4A-1; Mon, 23 Nov 2020 15:11:30 -0500
X-MC-Unique: UEZH4NIWPSio0SO7HzHi4A-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 954A81084C84;
        Mon, 23 Nov 2020 20:11:29 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-112-111.rdu2.redhat.com [10.10.112.111])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BE40860877;
        Mon, 23 Nov 2020 20:11:28 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net-next 12/17] rxrpc: Fix example key name in a comment
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     dhowells@redhat.com, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date:   Mon, 23 Nov 2020 20:11:27 +0000
Message-ID: <160616228792.830164.7823721378419045454.stgit@warthog.procyon.org.uk>
In-Reply-To: <160616220405.830164.2239716599743995145.stgit@warthog.procyon.org.uk>
References: <160616220405.830164.2239716599743995145.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix an example of an rxrpc key name in a comment.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 net/rxrpc/key.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/rxrpc/key.c b/net/rxrpc/key.c
index 7e6d19263ce3..9631aa8543b5 100644
--- a/net/rxrpc/key.c
+++ b/net/rxrpc/key.c
@@ -5,7 +5,7 @@
  * Written by David Howells (dhowells@redhat.com)
  *
  * RxRPC keys should have a description of describing their purpose:
- *	"afs@CAMBRIDGE.REDHAT.COM>
+ *	"afs@example.com"
  */
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt


