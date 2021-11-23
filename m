Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D064D45A355
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 13:54:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236610AbhKWM5g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 07:57:36 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:48249 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235725AbhKWM5g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Nov 2021 07:57:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637672067;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zSBeYlFZ9tIzOUFtiUDS2YmhqY7uIJxs/7Wl4E4qfNM=;
        b=VoR9CQdACIloDI1jbuemrLwkOtSkL7ozwebVen9X8MFrYholFL67xb/4E0cJkptsEZQc5a
        Ya5pDNnmxscgSi6lAeeUxk5MBok2+mS0dYwvoNAx/msx+c+Ir7nXnSY3zvIwm+r3PuNKvt
        R2MhBI+y1sOH/QVzpiS0r/4QuDAr1G4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-41-i7zeWf8rOeyCoTdXX0-upw-1; Tue, 23 Nov 2021 07:54:26 -0500
X-MC-Unique: i7zeWf8rOeyCoTdXX0-upw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2321787950C;
        Tue, 23 Nov 2021 12:54:25 +0000 (UTC)
Received: from localhost (unknown [10.39.195.64])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AAE125DF5E;
        Tue, 23 Nov 2021 12:54:19 +0000 (UTC)
Date:   Tue, 23 Nov 2021 12:54:18 +0000
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        netdev@vger.kernel.org, Halil Pasic <pasic@linux.ibm.com>,
        kvm@vger.kernel.org, Asias He <asias@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH 0/2] vhost/vsock: fix used length and cleanup in
 vhost_vsock_handle_tx_kick()
Message-ID: <YZzketMjpZ+Pn9aA@stefanha-x1.localdomain>
References: <20211122163525.294024-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="127DMsQtX8lXRxGZ"
Content-Disposition: inline
In-Reply-To: <20211122163525.294024-1-sgarzare@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--127DMsQtX8lXRxGZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 22, 2021 at 05:35:23PM +0100, Stefano Garzarella wrote:
> This is a follow-up to Micheal's patch [1] and the discussion with Halil =
and
> Jason [2].
>=20
> I made two patches, one to fix the problem and one for cleanup. This shou=
ld
> simplify the backport of the fix because we've had the problem since
> vhost-vsock was introduced (v4.8) and that part has been touched a bit
> recently.
>=20
> Thanks,
> Stefano
>=20
> [1] https://lore.kernel.org/virtualization/20211122105822.onarsa4sydzxqyn=
u@steredhat/T/#t
> [2] https://lore.kernel.org/virtualization/20211027022107.14357-1-jasowan=
g@redhat.com/T/#t
>=20
> Stefano Garzarella (2):
>   vhost/vsock: fix incorrect used length reported to the guest
>   vhost/vsock: cleanup removing `len` variable
>=20
>  drivers/vhost/vsock.c | 8 ++------
>  1 file changed, 2 insertions(+), 6 deletions(-)
>=20
> --=20
> 2.31.1
>=20

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--127DMsQtX8lXRxGZ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmGc5HoACgkQnKSrs4Gr
c8ifrQf/c6D901ykYKUMEDHveFY4zXcj69oxyDMaGCumQCFh/XD4Oaj7yRcBZW/y
BdVkAHqsHa2rnkv5P4fWW0gk9JkZlk2eEmC/IaJsr2F1YdyF8VOMcpOPPGTDQQt1
MRxMr7VFZWcZDyxnntmdzYSuej1eHhriTz9VpM/hC8hklvoLavhSmYR1ZcsplnFp
KqO/RLiprEDWUDXXp1npmD8g+SIdBfMA/N6+2+ud/p94JRXk1+gfaB8kNnJOmsYc
25ygN1s1JyzJMkq+HWMe2EcZtIoZ3v0X5wLg/bMU4QssS/DjmiQ0El9MJY1O/iQh
jU9LGwY1MwTgrqVVZoNhYiepyT1ZFg==
=YxZO
-----END PGP SIGNATURE-----

--127DMsQtX8lXRxGZ--

