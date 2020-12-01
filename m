Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 276052C9C3C
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 10:18:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390309AbgLAJO1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 04:14:27 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:39938 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390218AbgLAJOP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 04:14:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606813969;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=eVUUIWic4nOa387L60cGysm2Laqcqcvtu32GbAKq69E=;
        b=JZN1grQKU5vuHRVDWLM4eqzYX4FppLeeiarQ8H2lcQA4J/lBYIwrbir6XVRAt4oFL0T3DR
        1G5KT+pCEgES+ERMCQhBQhKUlXNJXIwyiZadttVA6AYf/MLSsHagAaTkY7Q3j0w+LJ/L3B
        jBkLHEAvF+6iL+1qGr50Sh6s7668G5s=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-566-Mk-s11hRO_68q1f7Vo2ONA-1; Tue, 01 Dec 2020 04:12:47 -0500
X-MC-Unique: Mk-s11hRO_68q1f7Vo2ONA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 04BD110151E3;
        Tue,  1 Dec 2020 09:12:46 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-112-159.rdu2.redhat.com [10.10.112.159])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3C7B718996;
        Tue,  1 Dec 2020 09:12:44 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <20201201084638.GA27937@gondor.apana.org.au>
References: <20201201084638.GA27937@gondor.apana.org.au> <20201127050701.GA22001@gondor.apana.org.au> <20201126063303.GA18366@gondor.apana.org.au> <160518586534.2277919.14475638653680231924.stgit@warthog.procyon.org.uk> <1976719.1606378781@warthog.procyon.org.uk> <4035245.1606812273@warthog.procyon.org.uk>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     dhowells@redhat.com, bfields@fieldses.org,
        trond.myklebust@hammerspace.com, linux-crypto@vger.kernel.org,
        linux-afs@lists.infradead.org, linux-cifs@vger.kernel.org,
        linux-nfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 00/18] crypto: Add generic Kerberos library
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <4036796.1606813958.1@warthog.procyon.org.uk>
Date:   Tue, 01 Dec 2020 09:12:38 +0000
Message-ID: <4036797.1606813958@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Herbert Xu <herbert@gondor.apana.org.au> wrote:

> Couldn't you just change the output sg to include the offset?

That depends on whether the caller has passed it elsewhere for some other
parallel purpose, but I think I'm going to have to go down that road and
restore it afterwards.

David

