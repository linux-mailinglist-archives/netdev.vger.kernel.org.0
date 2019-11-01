Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D908BEBEDE
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 09:08:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730226AbfKAIIp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 04:08:45 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:56598 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730034AbfKAIIp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Nov 2019 04:08:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572595723;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=nMCDLKHK9p0Avwq2KQRi+OzRMAXn28q4vC8O9lcUbxU=;
        b=DkhRARDVKYCZY9ph/+HXiMZALXendSSUdIqBdWErKiLQ9aFcIU7XYWdgX6tGASig+3NEo8
        /eM8orthen8T3nBQ4mWkRrynY6cnM6YLTh+xQHIgJoOMW+jAfIY2L40AF4hL3/7oNZgI1X
        wU/KZM/WYNOhChtekD2UsmWHPhCIW/I=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-417-H9JeXlaaNb2a06NT9mVs0A-1; Fri, 01 Nov 2019 04:08:40 -0400
X-MC-Unique: H9JeXlaaNb2a06NT9mVs0A-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 81CF4800D49;
        Fri,  1 Nov 2019 08:08:38 +0000 (UTC)
Received: from localhost (ovpn-116-219.ams2.redhat.com [10.36.116.219])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DAE3260BEC;
        Fri,  1 Nov 2019 08:08:37 +0000 (UTC)
Date:   Fri, 1 Nov 2019 09:08:36 +0100
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     davem@davemloft.net, sunilmut@microsoft.com, willemb@google.com,
        sgarzare@redhat.com, ytht.net@gmail.com, arnd@arndb.de,
        tglx@linutronix.de, decui@microsoft.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] vsock: Simplify '__vsock_release()'
Message-ID: <20191101080836.GA4888@stefanha-x1.localdomain>
References: <20191031064741.4567-1-christophe.jaillet@wanadoo.fr>
MIME-Version: 1.0
In-Reply-To: <20191031064741.4567-1-christophe.jaillet@wanadoo.fr>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Mimecast-Spam-Score: 0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="tKW2IUtsqtDRztdT"
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--tKW2IUtsqtDRztdT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 31, 2019 at 07:47:41AM +0100, Christophe JAILLET wrote:
> Use '__skb_queue_purge()' instead of re-implementing it.
>=20
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
>  net/vmw_vsock/af_vsock.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)

Modulo the comment about double-underscore:

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--tKW2IUtsqtDRztdT
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl276AIACgkQnKSrs4Gr
c8hfmgf+INURpFV1u1GE48Cf2ihsC6QhHVe3MTzVVV3eQztp78fDvWBPuRqFZP7U
HjbZNkqJ92U4xAhO9Z+biLTYUKeLb1IIueXXUgZsrELr3zfdAL9fybIGln7c42Nx
yJvwDFHAbgT1fFlnoaYE22ZUeALajF/AiBdIjwoqWmRYN2iYDHjzZzncuoaEVjuN
RueUQUVdjdCLcIbAaLf460N2ksM511vXRJ8BjTSkQL6154steJgibuT2PwluMNhp
FKEIavD0NT/tjZRuS7IkmXl+ZTENDEPuUeRaRsxk9KXhG1/MlcyHGVhgdDvk5irL
BG3X708iLUI2gdg+CkotgwzgFMiT4A==
=C+k4
-----END PGP SIGNATURE-----

--tKW2IUtsqtDRztdT--

