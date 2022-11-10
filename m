Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A20A62432B
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 14:27:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229447AbiKJN1O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 08:27:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229645AbiKJN1J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 08:27:09 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A08345EFBF
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 05:26:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668086771;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=r9ORuU0WsHleftbh/WBR7cP7Ve37V0XL+b9TNvayaUQ=;
        b=IrR4hwd0qeVydXhaJQTYL38dqK0cZ6BC+TaaRkyBMTxsxlY7lsHRuDf2C0Gfzd6zPvT5RM
        pmUn3buNZNo75ojQL6ki0P9rt4+rDaTrf/usPyMzJGzxSSLkZwf58TyyoXbl2RrHDAdWXS
        LIySCbvOn4S/rUbFjTGQBDUjM6CbseM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-176-d9xiGzzGOs24WbOX7BMBEw-1; Thu, 10 Nov 2022 08:26:06 -0500
X-MC-Unique: d9xiGzzGOs24WbOX7BMBEw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A1EB385A5A6;
        Thu, 10 Nov 2022 13:26:05 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.24])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 41386C154AB;
        Thu, 10 Nov 2022 13:26:04 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <CAPA1RqBF7u6posD9ozzaONmhoLnQACdYF8HdwDLjwYWDohyqvw@mail.gmail.com>
References: <CAPA1RqBF7u6posD9ozzaONmhoLnQACdYF8HdwDLjwYWDohyqvw@mail.gmail.com> <166807341463.2904467.10141806642379634063.stgit@warthog.procyon.org.uk>
To:     Hideaki Yoshifuji <hideaki.yoshifuji@miraclelinux.com>
Cc:     dhowells@redhat.com, netdev@vger.kernel.org,
        kernel test robot <lkp@intel.com>,
        Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org,
        yoshfuji@linux-ipv6.org
Subject: Re: [PATCH net-next] rxrpc: Fix missing IPV6 #ifdef
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3068303.1668086763.1@warthog.procyon.org.uk>
Date:   Thu, 10 Nov 2022 13:26:03 +0000
Message-ID: <3068304.1668086763@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hideaki Yoshifuji <hideaki.yoshifuji@miraclelinux.com> wrote:

> Because this introduces a missing return literally without
> CONFIG_AF_RXRPC_IPV6, I would prefer #ifdef / #else for the whole function.

They're both void functions, so actually, there's nothing to return.

David

