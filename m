Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6ECAF621F11
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 23:21:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230158AbiKHWU7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 17:20:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230156AbiKHWUQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 17:20:16 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C53A22B32
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 14:19:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667945952;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SEx8WgWQW1BHK9KEUvEqYgtHv7htEGTlOK4bwyXGUzU=;
        b=OFRvxjIn1ELlWYHPHu9fbF+Osd9v8eqte/LTJxtI+RQyKWX54wN33G9K7pdIpdk0voGgCN
        xmKuOBTxqzuF58lQgu+N81ZTlskmkD4O9sAPXY3xGNqwUGk+ffgPBpzeIbbfQoq24OJj80
        L+Etj7rgEZLrO8Ssibw7va0D4q2Qcok=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-385-Mg-7U673O_KkJ7M2KC1MSA-1; Tue, 08 Nov 2022 17:19:10 -0500
X-MC-Unique: Mg-7U673O_KkJ7M2KC1MSA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 066B1299E74F;
        Tue,  8 Nov 2022 22:19:10 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.37.22])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7D224111F3C7;
        Tue,  8 Nov 2022 22:19:09 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net-next 12/26] rxrpc: Remove unnecessary header inclusions
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     dhowells@redhat.com, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date:   Tue, 08 Nov 2022 22:19:08 +0000
Message-ID: <166794594883.2389296.6859165662534028720.stgit@warthog.procyon.org.uk>
In-Reply-To: <166794587113.2389296.16484814996876530222.stgit@warthog.procyon.org.uk>
References: <166794587113.2389296.16484814996876530222.stgit@warthog.procyon.org.uk>
User-Agent: StGit/1.5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove a bunch of unnecessary header inclusions.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
---

 net/rxrpc/input.c |   14 --------------
 1 file changed, 14 deletions(-)

diff --git a/net/rxrpc/input.c b/net/rxrpc/input.c
index 7810b7d4f871..59a0b8aee2a2 100644
--- a/net/rxrpc/input.c
+++ b/net/rxrpc/input.c
@@ -7,20 +7,6 @@
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
-#include <linux/module.h>
-#include <linux/net.h>
-#include <linux/skbuff.h>
-#include <linux/errqueue.h>
-#include <linux/udp.h>
-#include <linux/in.h>
-#include <linux/in6.h>
-#include <linux/icmp.h>
-#include <linux/gfp.h>
-#include <net/sock.h>
-#include <net/af_rxrpc.h>
-#include <net/ip.h>
-#include <net/udp.h>
-#include <net/net_namespace.h>
 #include "ar-internal.h"
 
 static void rxrpc_proto_abort(const char *why,


