Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A91D62C175A
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 22:11:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730904AbgKWVIN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 16:08:13 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:39419 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730721AbgKWVIK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 16:08:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606165689;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JgitgtgcGISLoMc82FoNi/Rf5APfZkhmz4liERzOLZQ=;
        b=NIzlq1TfdwJIlqRyxWs6qy4rXzD4QTWbUESJSfvZjKHcJpIoVWUzIp7e1olR04NQr5OGO2
        QBp+ydqIWOy9VSD8wZBa3vsRpmRuAfL3z9m0Wwq5r9cGsS8lOB6HsUMjIXyyXO56HlHQPe
        NKJFszer6Xmv1CmNp0/2AO5+0wD8ioQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-367-d7GEwBrOPm6YGEZ70a0RsQ-1; Mon, 23 Nov 2020 16:08:04 -0500
X-MC-Unique: d7GEwBrOPm6YGEZ70a0RsQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 51FDA5212;
        Mon, 23 Nov 2020 21:08:03 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-112-111.rdu2.redhat.com [10.10.112.111])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3FC355C1BB;
        Mon, 23 Nov 2020 21:08:02 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <d0d1edf746b8f50ca8897478a5e76a006e5d36ed.camel@perches.com>
References: <d0d1edf746b8f50ca8897478a5e76a006e5d36ed.camel@perches.com> <160616220405.830164.2239716599743995145.stgit@warthog.procyon.org.uk> <160616230898.830164.7298470680786861832.stgit@warthog.procyon.org.uk>
To:     Joe Perches <joe@perches.com>
Cc:     dhowells@redhat.com, netdev@vger.kernel.org,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 15/17] rxrpc: Organise connection security to use a union
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <832868.1606165681.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date:   Mon, 23 Nov 2020 21:08:01 +0000
Message-ID: <832869.1606165681@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Joe Perches <joe@perches.com> wrote:

> It seems no other follow-on patch in the series uses this nameless union=
.

There will be a follow on series.  Either this:

	https://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git/log=
/?h=3Drxrpc-rxgk


or this:

	https://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git/log=
/?h=3Dcrypto-krb5

Depending on whether I pull the kerberos bits out into the crypto/ directo=
ry
so that it can be shared with sunrpc and maybe cifs.  Discussions are ongo=
ing
on that.

David

