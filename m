Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25E742CF16E
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 17:03:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730537AbgLDQD3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 11:03:29 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:26018 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726309AbgLDQD2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Dec 2020 11:03:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607097722;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DHcEujkTJrLzN53Yx5osScEnvJO5N+oiL4RoDLy3I/A=;
        b=cMQNonFda5n5WhRKk0dXDLOpj3VIeezAUZOyl9IkUsjm+HoGHTD/VX7bGVSMyBTyrIDRDG
        /xY2ezI7sFSNV0sJ4utMGpRn+urNfc1MjanmJ8GIoLXm17AQyXokTtLOlFERxDo58bw2wB
        9HMIzo9g/anz8fAPYa35Rl0gbsZMyfk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-426-TjTgdB_vORSjqc8GGRy9VA-1; Fri, 04 Dec 2020 11:01:58 -0500
X-MC-Unique: TjTgdB_vORSjqc8GGRy9VA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B163B87950C;
        Fri,  4 Dec 2020 16:01:56 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-116-67.rdu2.redhat.com [10.10.116.67])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9075A189B8;
        Fri,  4 Dec 2020 16:01:54 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <20201204154626.GA26255@fieldses.org>
References: <20201204154626.GA26255@fieldses.org> <2F96670A-58DC-43A6-A20E-696803F0BFBA@oracle.com> <160518586534.2277919.14475638653680231924.stgit@warthog.procyon.org.uk> <118876.1607093975@warthog.procyon.org.uk>
To:     Bruce Fields <bfields@fieldses.org>
Cc:     dhowells@redhat.com, Chuck Lever <chuck.lever@oracle.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        linux-crypto@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-afs@lists.infradead.org
Subject: Re: Why the auxiliary cipher in gss_krb5_crypto.c?
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <122996.1607097713.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date:   Fri, 04 Dec 2020 16:01:53 +0000
Message-ID: <122997.1607097713@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Bruce Fields <bfields@fieldses.org> wrote:

> > Reading up on CTS, I'm guessing the reason it's like this is that CTS =
is the
> > same as the non-CTS, except for the last two blocks, but the non-CTS o=
ne is
> > more efficient.
> =

> CTS is cipher-text stealing, isn't it?  I think it was Kevin Coffman
> that did that, and I don't remember the history.  I thought it was
> required by some spec or peer implementation (maybe Windows?) but I
> really don't remember.  It may predate git.  I'll dig around and see
> what I can find.

rfc3961 and rfc3962 specify CTS-CBC with AES.

David

