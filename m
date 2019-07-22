Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E24006FB9F
	for <lists+netdev@lfdr.de>; Mon, 22 Jul 2019 10:53:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728528AbfGVIx3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jul 2019 04:53:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56386 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725989AbfGVIx2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Jul 2019 04:53:28 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 69A6D30BC57D;
        Mon, 22 Jul 2019 08:53:28 +0000 (UTC)
Received: from localhost (ovpn-117-250.ams2.redhat.com [10.36.117.250])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9A4E65DA2E;
        Mon, 22 Jul 2019 08:53:25 +0000 (UTC)
Date:   Mon, 22 Jul 2019 09:53:19 +0100
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        virtualization@lists.linux-foundation.org,
        Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH v4 3/5] vsock/virtio: fix locking in
 virtio_transport_inc_tx_pkt()
Message-ID: <20190722085319.GC24934@stefanha-x1.localdomain>
References: <20190717113030.163499-1-sgarzare@redhat.com>
 <20190717113030.163499-4-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="Clx92ZfkiYIKRjnr"
Content-Disposition: inline
In-Reply-To: <20190717113030.163499-4-sgarzare@redhat.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.49]); Mon, 22 Jul 2019 08:53:28 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--Clx92ZfkiYIKRjnr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 17, 2019 at 01:30:28PM +0200, Stefano Garzarella wrote:
> fwd_cnt and last_fwd_cnt are protected by rx_lock, so we should use
> the same spinlock also if we are in the TX path.
>=20
> Move also buf_alloc under the same lock.
>=20
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> ---
>  include/linux/virtio_vsock.h            | 2 +-
>  net/vmw_vsock/virtio_transport_common.c | 4 ++--
>  2 files changed, 3 insertions(+), 3 deletions(-)

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--Clx92ZfkiYIKRjnr
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl01eX8ACgkQnKSrs4Gr
c8jE7AgAs5N6O7elzpZi4u/g75m8dfsiRpiyEG+NXL6ahFUWKw98b80S/q2RNHZR
udZDGbmyVjnwH1pok2YnjdwcqCq515JelqAdv7CdhhzzRZdwiHGMQh8uqHYDfzGZ
R2V0hSJAiSG21HxP+RBG6VoWCoBUeQU/vce3jkYsxT6F64tUqeqxJd/C+AcRHOKk
dxxTmtn2NdRRs6Hofl5nW0ulYG/wxRRtN3dTf+V/FKkXLYv1197AD0+JXZnTRw2s
159FbLvqqdFzBGt2HORUTR+7aTcBuILeDuLW8gJT6JrFF2MIw1B0VaSB0Lbv0mN6
tuZAmnZlcurH5zz8i5XOJ5mugHY72w==
=VeGT
-----END PGP SIGNATURE-----

--Clx92ZfkiYIKRjnr--
