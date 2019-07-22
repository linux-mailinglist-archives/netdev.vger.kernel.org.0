Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E82E36FBBD
	for <lists+netdev@lfdr.de>; Mon, 22 Jul 2019 11:07:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728687AbfGVJHe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jul 2019 05:07:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56962 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725989AbfGVJHe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Jul 2019 05:07:34 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 44B6E308429D;
        Mon, 22 Jul 2019 09:07:34 +0000 (UTC)
Received: from localhost (ovpn-117-250.ams2.redhat.com [10.36.117.250])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8B9C45D71B;
        Mon, 22 Jul 2019 09:07:31 +0000 (UTC)
Date:   Mon, 22 Jul 2019 10:07:30 +0100
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        virtualization@lists.linux-foundation.org,
        Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH v4 5/5] vsock/virtio: change the maximum packet size
 allowed
Message-ID: <20190722090730.GE24934@stefanha-x1.localdomain>
References: <20190717113030.163499-1-sgarzare@redhat.com>
 <20190717113030.163499-6-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="Qz2CZ664xQdCRdPu"
Content-Disposition: inline
In-Reply-To: <20190717113030.163499-6-sgarzare@redhat.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.40]); Mon, 22 Jul 2019 09:07:34 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--Qz2CZ664xQdCRdPu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 17, 2019 at 01:30:30PM +0200, Stefano Garzarella wrote:
> Since now we are able to split packets, we can avoid limiting
> their sizes to VIRTIO_VSOCK_DEFAULT_RX_BUF_SIZE.
> Instead, we can use VIRTIO_VSOCK_MAX_PKT_BUF_SIZE as the max
> packet size.
>=20
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> ---
>  net/vmw_vsock/virtio_transport_common.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--Qz2CZ664xQdCRdPu
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl01fNIACgkQnKSrs4Gr
c8jlPwf+K8D7nnRfxW5Y5W22bqktswfcGjAt29NMC9KGkYjL0hM745Dg5G6LG8tD
FuJQqW0Daerwk5vC3b0d9iyF1MtAQlMCm4XhIEHi0aGS2blFtrra2M9IpTqnQ/t+
sGwMqmUWbCjBAFZQb1QNCgLXxwMXIabNCgSFY/cBsHMWyOKbTlTVaGstCA8Tp3RW
TKqUGWseTe9K1WQcX2el2klhhir+K+XMN4iIxmtJks7dRB6wci+G2JDKaYtjm6t3
0kdIjyRhhj4I4WOHq7vvZyHYAj0oT4odRHTKF8aNa+oUhoo8PHJ5VeHah3+wciCp
MDed3Aanbck3Tmyq/YcOBNMozk1KcQ==
=xu6B
-----END PGP SIGNATURE-----

--Qz2CZ664xQdCRdPu--
