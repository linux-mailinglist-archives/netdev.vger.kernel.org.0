Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C98DB6FB63
	for <lists+netdev@lfdr.de>; Mon, 22 Jul 2019 10:36:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728509AbfGVIgp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jul 2019 04:36:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34850 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725989AbfGVIgp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Jul 2019 04:36:45 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id AA7ED85365;
        Mon, 22 Jul 2019 08:36:44 +0000 (UTC)
Received: from localhost (ovpn-117-250.ams2.redhat.com [10.36.117.250])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8EC2819D71;
        Mon, 22 Jul 2019 08:36:41 +0000 (UTC)
Date:   Mon, 22 Jul 2019 09:36:40 +0100
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        virtualization@lists.linux-foundation.org,
        Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH v4 2/5] vsock/virtio: reduce credit update messages
Message-ID: <20190722083640.GB24934@stefanha-x1.localdomain>
References: <20190717113030.163499-1-sgarzare@redhat.com>
 <20190717113030.163499-3-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="qlTNgmc+xy1dBmNv"
Content-Disposition: inline
In-Reply-To: <20190717113030.163499-3-sgarzare@redhat.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.25]); Mon, 22 Jul 2019 08:36:44 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--qlTNgmc+xy1dBmNv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 17, 2019 at 01:30:27PM +0200, Stefano Garzarella wrote:
> In order to reduce the number of credit update messages,
> we send them only when the space available seen by the
> transmitter is less than VIRTIO_VSOCK_MAX_PKT_BUF_SIZE.
>=20
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> ---
>  include/linux/virtio_vsock.h            |  1 +
>  net/vmw_vsock/virtio_transport_common.c | 16 +++++++++++++---
>  2 files changed, 14 insertions(+), 3 deletions(-)

It's an arbitrary limit but the risk of regressions is low since the
credit update traffic was so excessive:

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--qlTNgmc+xy1dBmNv
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl01dZgACgkQnKSrs4Gr
c8h/oQgAuTo0CerV6R9QtoxW4hcg6Tkq8sm7tBtXxSlRDhm5cvCYY3GKnhq1R/d0
Kg0hqcHUpqMsLT0yNza3j2F2USkvoxFm3wMgKijp5A0L15YVUQ+qZOwxVfBw9wDe
RXeY5bMyEHE5MFFtMfGDAiNyL1umrZ0Cy2RSYdzc+JhvZEkFyvwqE/za5PmXhofP
hF5u98zTLSjIxjxMAl7I7obkZIaJmU4A5XDUWwucqQm4wBP4QFQQqocM91RlQ7Gz
slJK7JiLWEpd2ka1VDVK9AfgE6R0dnT6tZ1r306NaG0moJmgts9gm3ETffKce8bn
OlHQa8PxT//6DYE3ghoFPTOpYxFqLw==
=G3Rg
-----END PGP SIGNATURE-----

--qlTNgmc+xy1dBmNv--
