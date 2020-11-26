Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9706D2C5039
	for <lists+netdev@lfdr.de>; Thu, 26 Nov 2020 09:21:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732143AbgKZITx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Nov 2020 03:19:53 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:32147 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727496AbgKZITw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Nov 2020 03:19:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606378790;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=z+p2GprWbi/If7VTS8JWkfE6Lqw1+SLhZ1FsmVKk/Hc=;
        b=XILHxQQdJN9277AtKKKoy7XhCNIBNFGoYdgoYhfLLp7w4uAbZgqqlCoA33DCUy/P5o0S2f
        WfX9VsKRK58vSLCI1srY41tNzlfz7bcYHY4PbdK3WF0APWyoGzJkvlxunaot3UtkFFSecR
        LRihEiV9WiODAf7SYIPXFGBljhHJZiQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-582-xR60jiNjNfyAZn5VXKFC7A-1; Thu, 26 Nov 2020 03:19:46 -0500
X-MC-Unique: xR60jiNjNfyAZn5VXKFC7A-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8742D8143EB;
        Thu, 26 Nov 2020 08:19:44 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-112-111.rdu2.redhat.com [10.10.112.111])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7CCF95D6AC;
        Thu, 26 Nov 2020 08:19:42 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <20201126063303.GA18366@gondor.apana.org.au>
References: <20201126063303.GA18366@gondor.apana.org.au> <160518586534.2277919.14475638653680231924.stgit@warthog.procyon.org.uk>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     dhowells@redhat.com, bfields@fieldses.org,
        trond.myklebust@hammerspace.com, linux-crypto@vger.kernel.org,
        linux-afs@lists.infradead.org, linux-cifs@vger.kernel.org,
        linux-nfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 00/18] crypto: Add generic Kerberos library
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1976718.1606378781.1@warthog.procyon.org.uk>
Date:   Thu, 26 Nov 2020 08:19:41 +0000
Message-ID: <1976719.1606378781@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Herbert Xu <herbert@gondor.apana.org.au> wrote:

> > Here's my first cut at a generic Kerberos crypto library in the kernel so
> > that I can share code between rxrpc and sunrpc (and cifs?).
> 
> I can't find the bit where you are actually sharing this code with
> sunrpc, am I missing something?

I haven't done that yet.  Sorry, I should've been more explicit with what I
was after.  I was wanting to find out if the nfs/nfsd people are okay with
this (and if there are any gotchas I should know about - it turns out, if I
understand it correctly, the relevant code may being being rewritten a bit
anyway).

And from you, I was wanting to find out if you're okay with an interface of
this kind in crypto/ where the code is just used directly - or whether I'll
be required to wrap it up in the autoloading, module-handling mechanisms.

David

