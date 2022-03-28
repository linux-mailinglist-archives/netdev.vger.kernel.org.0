Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35E764E95FC
	for <lists+netdev@lfdr.de>; Mon, 28 Mar 2022 13:57:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242031AbiC1L7J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Mar 2022 07:59:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241250AbiC1L7E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Mar 2022 07:59:04 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EBFFCD8B
        for <netdev@vger.kernel.org>; Mon, 28 Mar 2022 04:57:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648468643;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HRFRUKcMdD/p3LSc6/qBBnakB7BfN4JwTEDtAHV0SqM=;
        b=McThTSvO19k8ttjRTqeYebD3Ck0t/ZA6vZlotDKOeeMiIpREypnXT6caLuUxpaJuy917Yr
        0X6ZjIZfagX3WOxhVZR0IBS9k/HC4C+41hVb3mmjUzJI0Dl/Ms7dqPK/ac0C/IWu+qxSjt
        qvTwUqMxoEOXVpJld6LXQ74hMcOq4s4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-146-9R00gojhP4uvnAWFE0RhYA-1; Mon, 28 Mar 2022 07:57:17 -0400
X-MC-Unique: 9R00gojhP4uvnAWFE0RhYA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3E36E811E78;
        Mon, 28 Mar 2022 11:57:17 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 05E80C15D57;
        Mon, 28 Mar 2022 11:57:15 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <20220322162822.566705-1-butterflyhuangxx@gmail.com>
References: <20220322162822.566705-1-butterflyhuangxx@gmail.com>
To:     Xiaolong Huang <butterflyhuangxx@gmail.com>
Cc:     dhowells@redhat.com, marc.dionne@auristor.com, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, linux-afs@lists.infradead.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rxrpc: fix some null-ptr-deref bugs in server_key.c
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2579411.1648468635.1@warthog.procyon.org.uk>
Date:   Mon, 28 Mar 2022 12:57:15 +0100
Message-ID: <2579412.1648468635@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Xiaolong Huang <butterflyhuangxx@gmail.com> wrote:

> user@syzkaller:~$ ./rxrpc_preparse_s

Is there a syzbot report to reference for this?

David

