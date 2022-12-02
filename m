Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C83F963FCAE
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 01:17:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232086AbiLBARD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 19:17:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232055AbiLBAQk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 19:16:40 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3C56CEFB6
        for <netdev@vger.kernel.org>; Thu,  1 Dec 2022 16:15:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669940140;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OVOQDiX6kbAmxrS487im8wmNPjye/rpt4SKfq1Eh8HI=;
        b=FMuB0re5VxkZ5+9md3/adHsKFwAY0xqW8vz0DWOBbAq3T7ieAwnAvcRwZ44KCQjyWHt0ac
        4kkklGyqYsUg+777+gKO6z2XBLDXnczfxnstE8HO3p5cQM8vnDyxQIJygNOT01eDM/aOGy
        DioOSqe6R6Hhhl6OsClw8yFUlYTLGo0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-388--Pue90sVPD-J5gzlpMqw2w-1; Thu, 01 Dec 2022 19:15:38 -0500
X-MC-Unique: -Pue90sVPD-J5gzlpMqw2w-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6F5EE833A06;
        Fri,  2 Dec 2022 00:15:38 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.36])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CAAD64A9257;
        Fri,  2 Dec 2022 00:15:37 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net-next 04/36] rxrpc: Remove decl for
 rxrpc_kernel_call_is_complete()
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org, dhowells@redhat.com,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Date:   Fri, 02 Dec 2022 00:15:35 +0000
Message-ID: <166994013501.1732290.762856304909773239.stgit@warthog.procyon.org.uk>
In-Reply-To: <166994010342.1732290.13771061038178613124.stgit@warthog.procyon.org.uk>
References: <166994010342.1732290.13771061038178613124.stgit@warthog.procyon.org.uk>
User-Agent: StGit/1.5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

rxrpc_kernel_call_is_complete() has been removed, so remove its declaration
too.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
---

 include/net/af_rxrpc.h |    1 -
 1 file changed, 1 deletion(-)

diff --git a/include/net/af_rxrpc.h b/include/net/af_rxrpc.h
index dc033f08191e..d5a5ae926380 100644
--- a/include/net/af_rxrpc.h
+++ b/include/net/af_rxrpc.h
@@ -66,7 +66,6 @@ int rxrpc_kernel_charge_accept(struct socket *, rxrpc_notify_rx_t,
 void rxrpc_kernel_set_tx_length(struct socket *, struct rxrpc_call *, s64);
 bool rxrpc_kernel_check_life(const struct socket *, const struct rxrpc_call *);
 u32 rxrpc_kernel_get_epoch(struct socket *, struct rxrpc_call *);
-bool rxrpc_kernel_call_is_complete(struct rxrpc_call *);
 void rxrpc_kernel_set_max_life(struct socket *, struct rxrpc_call *,
 			       unsigned long);
 


