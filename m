Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 665DBD3B10
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 10:27:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727198AbfJKI1T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Oct 2019 04:27:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40800 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726290AbfJKI1T (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Oct 2019 04:27:19 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 25DF7302C09B;
        Fri, 11 Oct 2019 08:27:19 +0000 (UTC)
Received: from localhost (unknown [10.36.118.32])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 91C105D9DC;
        Fri, 11 Oct 2019 08:27:15 +0000 (UTC)
Date:   Fri, 11 Oct 2019 09:27:14 +0100
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     Stefan Hajnoczi <stefanha@gmail.com>, netdev@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>, linux-hyperv@vger.kernel.org,
        Stephen Hemminger <sthemmin@microsoft.com>,
        kvm@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        Dexuan Cui <decui@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        "David S. Miller" <davem@davemloft.net>,
        Jorgen Hansen <jhansen@vmware.com>
Subject: Re: [RFC PATCH 07/13] vsock: handle buffer_size sockopts in the core
Message-ID: <20191011082714.GF12360@stefanha-x1.localdomain>
References: <20190927112703.17745-1-sgarzare@redhat.com>
 <20190927112703.17745-8-sgarzare@redhat.com>
 <20191009123026.GH5747@stefanha-x1.localdomain>
 <20191010093254.aluys4hpsfcepb42@steredhat>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="Y/WcH0a6A93yCHGr"
Content-Disposition: inline
In-Reply-To: <20191010093254.aluys4hpsfcepb42@steredhat>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.46]); Fri, 11 Oct 2019 08:27:19 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--Y/WcH0a6A93yCHGr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 10, 2019 at 11:32:54AM +0200, Stefano Garzarella wrote:
> On Wed, Oct 09, 2019 at 01:30:26PM +0100, Stefan Hajnoczi wrote:
> > On Fri, Sep 27, 2019 at 01:26:57PM +0200, Stefano Garzarella wrote:
> > Another issue is that this patch drops the VIRTIO_VSOCK_MAX_BUF_SIZE
> > limit that used to be enforced by virtio_transport_set_buffer_size().
> > Now the limit is only applied at socket init time.  If the buffer size
> > is changed later then VIRTIO_VSOCK_MAX_BUF_SIZE can be exceeded.  If
> > that doesn't matter, why even bother with VIRTIO_VSOCK_MAX_BUF_SIZE
> > here?
> >=20
>=20
> The .notify_buffer_size() should avoid this issue, since it allows the
> transport to limit the buffer size requested after the initialization.
>=20
> But again the min set by the user can not be respected and in the
> previous implementation we forced it to VIRTIO_VSOCK_MAX_BUF_SIZE.
>=20
> Now we don't limit the min, but we guarantee only that vsk->buffer_size
> is lower than VIRTIO_VSOCK_MAX_BUF_SIZE.
>=20
> Can that be an acceptable compromise?

I think so.

Setting buffer sizes was never tested or used much by userspace
applications that I'm aware of.  We should probably include tests for
changing buffer sizes in the test suite.

Stefan

--Y/WcH0a6A93yCHGr
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl2gPOIACgkQnKSrs4Gr
c8hnpAf/bZLlTd0r+EaHBLvVtn6u74O2zVoTaaQWQnOazMVH14CZaHHOu1c41TX7
Q0re/sK84wgqeIYkL3oZytOaV0XcGl6gisahwdaj2B0vFbihvsFYpvh7RDO3HQ68
w1qOfDkUS9sTi3UYClbO7gHJfF/29ekUBFgoscFN8DwmqhMZ0BmjlQbI5G7Bx/vb
BsykLfJ1+i+pjEwaf7OnJWjg/D/XEcMgWuwt3TDu4weM4m7URnromXRaunFLetC5
rq7dPRsobckPtCGqpZlg9p9YRqCfyVJKOd/by5XeJVT/0aC5fi0t/gHLBSwCpL3R
6nAoSm1TARBDHhE/TRKT7m4aV/5H3Q==
=76ga
-----END PGP SIGNATURE-----

--Y/WcH0a6A93yCHGr--
