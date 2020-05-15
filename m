Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9AD41D53F2
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 17:14:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727111AbgEOPOW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 11:14:22 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:43523 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726730AbgEOPOV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 May 2020 11:14:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589555657;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4jFShFTg902A0q2PIFAj13bBAo+TkoHxdtSFzmSJaQc=;
        b=B8PkO8cLVVph/pN4dd3OZCiD6m3ovZaGaJOWfBZ+StZadTXIGXXz6Kc8OJqI4xXgRdbDLF
        gpI19S0HgO2Wop0X+9LiGznCSklVw/JiTjRedmd7OXpuIr+1pQSS/84mQvJWYxZmtVbL5A
        NMYg5s8AC5X1Mq9UFaQ7HCAfDCjKjCU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-472-LQVTQu0OPIyPDmXCi0pv9g-1; Fri, 15 May 2020 11:14:13 -0400
X-MC-Unique: LQVTQu0OPIyPDmXCi0pv9g-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 03A5684B8A0;
        Fri, 15 May 2020 15:14:10 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-112-95.rdu2.redhat.com [10.10.112.95])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D912F76E64;
        Fri, 15 May 2020 15:13:59 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <20200514102919.GA12680@lst.de>
References: <20200514102919.GA12680@lst.de> <20200513062649.2100053-30-hch@lst.de> <20200513062649.2100053-1-hch@lst.de> <3123534.1589375587@warthog.procyon.org.uk>
To:     Christoph Hellwig <hch@lst.de>
Cc:     dhowells@redhat.com, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        linux-nvme@lists.infradead.org, linux-sctp@vger.kernel.org,
        target-devel@vger.kernel.org, linux-afs@lists.infradead.org,
        drbd-dev@lists.linbit.com, linux-cifs@vger.kernel.org,
        rds-devel@oss.oracle.com, linux-rdma@vger.kernel.org,
        cluster-devel@redhat.com, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        linux-block@vger.kernel.org, ceph-devel@vger.kernel.org,
        linux-nfs@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netdev@vger.kernel.org, Vlad Yasevich <vyasevich@gmail.com>,
        linux-kernel@vger.kernel.org, Jon Maloy <jmaloy@redhat.com>,
        Ying Xue <ying.xue@windriver.com>, ocfs2-devel@oss.oracle.com
Subject: Re: [PATCH 29/33] rxrpc_sock_set_min_security_level
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <128581.1589555639.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date:   Fri, 15 May 2020 16:13:59 +0100
Message-ID: <128582.1589555639@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Christoph Hellwig <hch@lst.de> wrote:

> > Looks good - but you do need to add this to Documentation/networking/r=
xrpc.txt
> > also, thanks.
> =

> That file doesn't exist, instead we now have a
> cumentation/networking/rxrpc.rst in weird markup.

Yeah - that's only in net/next thus far.

> Where do you want this to be added, and with what text?  Remember I don'=
t
> really know what this thing does, I just provide a shortcut.

The document itself describes what each rxrpc sockopt does.  Just look for
RXRPC_MIN_SECURITY_LEVEL in there;-)

Anyway, see the attached.  This also fixes a couple of errors in the doc t=
hat
I noticed.

David
---
diff --git a/Documentation/networking/rxrpc.rst b/Documentation/networking=
/rxrpc.rst
index 5ad35113d0f4..68552b92dc44 100644
--- a/Documentation/networking/rxrpc.rst
+++ b/Documentation/networking/rxrpc.rst
@@ -477,7 +477,7 @@ AF_RXRPC sockets support a few socket options at the S=
OL_RXRPC level:
 	 Encrypted checksum plus packet padded and first eight bytes of packet
 	 encrypted - which includes the actual packet length.
 =

-     (c) RXRPC_SECURITY_ENCRYPTED
+     (c) RXRPC_SECURITY_ENCRYPT
 =

 	 Encrypted checksum plus entire packet padded and encrypted, including
 	 actual packet length.
@@ -578,7 +578,7 @@ A client would issue an operation by:
      This issues a request_key() to get the key representing the security
      context.  The minimum security level can be set::
 =

-	unsigned int sec =3D RXRPC_SECURITY_ENCRYPTED;
+	unsigned int sec =3D RXRPC_SECURITY_ENCRYPT;
 	setsockopt(client, SOL_RXRPC, RXRPC_MIN_SECURITY_LEVEL,
 		   &sec, sizeof(sec));
 =

@@ -1090,6 +1090,15 @@ The kernel interface functions are as follows:
      jiffies).  In the event of the timeout occurring, the call will be
      aborted and -ETIME or -ETIMEDOUT will be returned.
 =

+ (#) Apply the RXRPC_MIN_SECURITY_LEVEL sockopt to a socket from within i=
n the
+     kernel::
+
+       int rxrpc_sock_set_min_security_level(struct sock *sk,
+					     unsigned int val);
+
+     This specifies the minimum security level required for calls on this
+     socket.
+
 =

 Configurable Parameters
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
diff --git a/fs/afs/rxrpc.c b/fs/afs/rxrpc.c
index 7dfcbd58da85..e313dae01674 100644
--- a/fs/afs/rxrpc.c
+++ b/fs/afs/rxrpc.c
@@ -57,7 +57,7 @@ int afs_open_socket(struct afs_net *net)
 	srx.transport.sin6.sin6_port	=3D htons(AFS_CM_PORT);
 =

 	ret =3D rxrpc_sock_set_min_security_level(socket->sk,
-			RXRPC_SECURITY_ENCRYPT);
+						RXRPC_SECURITY_ENCRYPT);
 	if (ret < 0)
 		goto error_2;
 =

