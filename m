Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17243461B5C
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 16:51:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237194AbhK2PzC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 10:55:02 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:44646 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1343739AbhK2PxB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 10:53:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638200983;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=Jtr3jrUl1kdlts+szSQalJvedwwiZxPLLCvURTQaKtc=;
        b=K9YxFaCA+ToACCCiDlfncvq/9/q+pb8MvXGnEVySiclbZqX6lT/yoYC0Tugc8U+H7cs7mX
        D1FecFlwJC9B+9RwmCdsqcfrUkhMDwb9IbZh8T9V4Fimn4w1e8oZsPQbTo6l03UsJuneUt
        Sn0atYrZNLDN5mvoBtpOZzQ0W+tHmxY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-109-mGFGE7uQPomKLNRwZNADNQ-1; Mon, 29 Nov 2021 10:49:42 -0500
X-MC-Unique: mGFGE7uQPomKLNRwZNADNQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 219F819251B0;
        Mon, 29 Nov 2021 15:49:41 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.25])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 02F0319724;
        Mon, 29 Nov 2021 15:49:39 +0000 (UTC)
Subject: [PATCH net 0/2] rxrpc: Leak fixes
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     linux-afs@lists.infradead.org,
        Marc Dionne <marc.dionne@auristor.com>,
        Eiichi Tsukata <eiichi.tsukata@nutanix.com>,
        dhowells@redhat.com, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date:   Mon, 29 Nov 2021 15:49:39 +0000
Message-ID: <163820097905.226370.17234085194655347888.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Here are a couple of fixes for leaks in AF_RXRPC:

 (1) Fix a leak of rxrpc_peer structs in rxrpc_look_up_bundle().

 (2) Fix a leak of rxrpc_local structs in rxrpc_lookup_peer().

The patches are tagged here:

	git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git
	rxrpc-fixes-20211129

and can also be found on the following branch:

	http://git.kernel.org/cgit/linux/kernel/git/dhowells/linux-fs.git/log/?h=rxrpc-fixes

David
---
Eiichi Tsukata (2):
      rxrpc: Fix rxrpc_peer leak in rxrpc_look_up_bundle()
      rxrpc: Fix rxrpc_local leak in rxrpc_lookup_peer()


 net/rxrpc/peer_object.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)


