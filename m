Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46B2A6FBB9
	for <lists+netdev@lfdr.de>; Mon, 22 Jul 2019 11:06:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728661AbfGVJGh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jul 2019 05:06:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45386 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725989AbfGVJGh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Jul 2019 05:06:37 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B40D2307D88C;
        Mon, 22 Jul 2019 09:06:36 +0000 (UTC)
Received: from localhost (ovpn-117-250.ams2.redhat.com [10.36.117.250])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C788010027B9;
        Mon, 22 Jul 2019 09:06:33 +0000 (UTC)
Date:   Mon, 22 Jul 2019 10:06:32 +0100
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        virtualization@lists.linux-foundation.org,
        Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH v4 4/5] vhost/vsock: split packets to send using multiple
 buffers
Message-ID: <20190722090632.GD24934@stefanha-x1.localdomain>
References: <20190717113030.163499-1-sgarzare@redhat.com>
 <20190717113030.163499-5-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="BI5RvnYi6R4T2M87"
Content-Disposition: inline
In-Reply-To: <20190717113030.163499-5-sgarzare@redhat.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.48]); Mon, 22 Jul 2019 09:06:36 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--BI5RvnYi6R4T2M87
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 17, 2019 at 01:30:29PM +0200, Stefano Garzarella wrote:
> If the packets to sent to the guest are bigger than the buffer
> available, we can split them, using multiple buffers and fixing
> the length in the packet header.
> This is safe since virtio-vsock supports only stream sockets.
>=20
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> ---
>  drivers/vhost/vsock.c                   | 66 ++++++++++++++++++-------
>  net/vmw_vsock/virtio_transport_common.c | 15 ++++--
>  2 files changed, 60 insertions(+), 21 deletions(-)

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--BI5RvnYi6R4T2M87
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl01fJgACgkQnKSrs4Gr
c8iGEAf8Djr/PEoFhNeRcB4nTbEZ0yqI9J0bTIg+5JPeRIwVuw8VN0SNdYcbUn4x
8z5Ze/MQcXrji7cU3OHBfNC0aTebpQ7odl8Fh+0Ge74z8CGT4fjTHgVVuFXcGOdw
oO0lLxNBn1PEZG3GziU7v1nnOOQMP7p1uedmMBNm1eRJztxOFGIfbl7eQzGYE0/0
UvnT0EbbiIaqcN151Db4L94rvRASIhKQSvk/Vx9lM6kKFzjJml2dO/pirzJvwyg7
ToYEINcqb5vJibA/uV9zXiaQPIuAi4HNSrXWXXvCyPZycd4MsISdRQSig44VmT3P
bkhomEAvwsqdfMfALjPSRENrlVKkhg==
=9pnw
-----END PGP SIGNATURE-----

--BI5RvnYi6R4T2M87--
