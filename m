Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 450C652F9B2
	for <lists+netdev@lfdr.de>; Sat, 21 May 2022 09:27:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241056AbiEUH1g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 May 2022 03:27:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354726AbiEUH1R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 May 2022 03:27:17 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 008425BD03
        for <netdev@vger.kernel.org>; Sat, 21 May 2022 00:27:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653118032;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wWP7xEjpOwg8ids+6r+D9zTeelTaC/A9uLuPxebtVZE=;
        b=i4MIclDtFueHsjvjpv1O+SUoTC1JmeDoclLDak6rqLs81zg2lJp3NaYAOtGDPFWnpILP4x
        Dg8hKltgU8G3fS7BszSic7oXTpb+xt2w1RzT8fMu+oF5ylS5NwWTMV9+gTblKMfbsCM+e4
        Wlgtb2pTfKgzwHp7UVHcnB4M+uaSb9w=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-111-jzMYw0VQO_-eQAt-_J5Nyw-1; Sat, 21 May 2022 03:27:09 -0400
X-MC-Unique: jzMYw0VQO_-eQAt-_J5Nyw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 88E8480013E;
        Sat, 21 May 2022 07:27:08 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.8])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 005E540D2820;
        Sat, 21 May 2022 07:27:06 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <20220520181522.42630ce9@kernel.org>
References: <20220520181522.42630ce9@kernel.org> <165306442115.34086.1818959430525328753.stgit@warthog.procyon.org.uk> <165306442878.34086.2437731947506679099.stgit@warthog.procyon.org.uk>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     dhowells@redhat.com, netdev@vger.kernel.org,
        Marc Dionne <marc.dionne@auristor.com>,
        Xin Long <lucien.xin@gmail.com>,
        Vadim Fedorenko <vfedorenko@novek.ru>,
        "David S. Miller" <davem@davemloft.net>,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net 1/6] rxrpc: Enable IPv6 checksums on transport socket
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <209507.1653118025.1@warthog.procyon.org.uk>
Date:   Sat, 21 May 2022 08:27:05 +0100
Message-ID: <209513.1653118025@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <kuba@kernel.org> wrote:

> This is already in net..
> pw build got gave up on this series.
> Could you resend just the other 5 patches?

Will do.

David

