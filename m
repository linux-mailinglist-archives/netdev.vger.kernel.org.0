Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53C6B524FD3
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 16:19:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355211AbiELOTS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 10:19:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355212AbiELOTO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 10:19:14 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EC02A25B07C
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 07:19:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652365153;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=J3hhwwvd7i8ZsboyCPgx1CVlYlT643y3bRYSAwAfZlQ=;
        b=iK9zytlCfFbVKjyMvWxU+VoXAwaphQbMX5LzAZcwNRuitQ4b66VtGMleqp759gU+L4lgPH
        YNUDpu/tAsQ582C97Nvht7Huw4fieaxEtpCJBzT2ZKe/0bd2qcrTd38mPWt0WVfYSWra02
        Q46IWeKGc7Q2MkbgtaTLa05L3WNx784=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-554-2H6Nz98lOrKgG54X9QbGzw-1; Thu, 12 May 2022 10:19:11 -0400
X-MC-Unique: 2H6Nz98lOrKgG54X9QbGzw-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4911B811E78;
        Thu, 12 May 2022 14:19:11 +0000 (UTC)
Received: from renaissance-vector.redhat.com (unknown [10.39.192.139])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5505E416369;
        Thu, 12 May 2022 14:19:10 +0000 (UTC)
From:   Andrea Claudi <aclaudi@redhat.com>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@gmail.com
Subject: [PATCH RESEND iproute2 3/3] doc: fix 'infact' --> 'in fact' typo
Date:   Thu, 12 May 2022 16:18:48 +0200
Message-Id: <9c0e09743b41cd317631d844b164dfd513a9a06f.1652364969.git.aclaudi@redhat.com>
In-Reply-To: <cover.1652364969.git.aclaudi@redhat.com>
References: <cover.1652364969.git.aclaudi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Andrea Claudi <aclaudi@redhat.com>
---
 doc/actions/actions-general | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/doc/actions/actions-general b/doc/actions/actions-general
index 407a514c..a0074a58 100644
--- a/doc/actions/actions-general
+++ b/doc/actions/actions-general
@@ -72,7 +72,7 @@ action police mtu 4000 rate 1500kbit burst 90k
 2)In order to take advantage of some of the targets written by the
 iptables people, a classifier can have a packet being massaged by an
 iptable target. I have only tested with mangler targets up to now.
-(infact anything that is not in the mangling table is disabled right now)
+(in fact anything that is not in the mangling table is disabled right now)
 
 In terms of hooks:
 *ingress is mapped to pre-routing hook
-- 
2.35.3

