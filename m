Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3150401C40
	for <lists+netdev@lfdr.de>; Mon,  6 Sep 2021 15:26:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242482AbhIFN0b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Sep 2021 09:26:31 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:20082 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241544AbhIFN03 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Sep 2021 09:26:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630934723;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FFpd6/N6m5lgoVk64+1SF9kAP2eThhXGNh0khWWyMZA=;
        b=FWmEzw3xOQS+iVyScGGxYdEuvyJPvAsm5cBm16p73WMeLGYD2VYFHfnvpfSZRWIM8a9Y0e
        iKxoHyXMI4zbT7pG280N0N76I+2UpTjgM269Ew94ZHH5ZIBmD+Uxzaaed/xKI18CumaUJC
        +uEwS3W2GYe2lRBE/j2cOHhaolgkus8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-63-nKGxhU-XNpu_oU6XHcLNPg-1; Mon, 06 Sep 2021 09:25:22 -0400
X-MC-Unique: nKGxhU-XNpu_oU6XHcLNPg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 51AD45139;
        Mon,  6 Sep 2021 13:25:21 +0000 (UTC)
Received: from localhost (unknown [10.39.194.203])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 005E8104328F;
        Mon,  6 Sep 2021 13:25:16 +0000 (UTC)
Date:   Mon, 6 Sep 2021 14:25:16 +0100
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
        "David S. Miller" <davem@davemloft.net>,
        Dexuan Cui <decui@microsoft.com>, linux-kernel@vger.kernel.org,
        Jorgen Hansen <jhansen@vmware.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH] MAINTAINERS: add VM SOCKETS (AF_VSOCK) entry
Message-ID: <YTYWvPheBop0j9NE@stefanha-x1.localdomain>
References: <20210906091159.66181-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="egTLbucVUnkLLRdY"
Content-Disposition: inline
In-Reply-To: <20210906091159.66181-1-sgarzare@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--egTLbucVUnkLLRdY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 06, 2021 at 11:11:59AM +0200, Stefano Garzarella wrote:
> Add a new entry for VM Sockets (AF_VSOCK) that covers vsock core,
> tests, and headers. Move some general vsock stuff from virtio-vsock
> entry into this new more general vsock entry.
>=20
> I've been reviewing and contributing for the last few years,
> so I'm available to help maintain this code.
>=20
> Cc: Dexuan Cui <decui@microsoft.com>
> Cc: Jorgen Hansen <jhansen@vmware.com>
> Cc: Stefan Hajnoczi <stefanha@redhat.com>
> Suggested-by: Michael S. Tsirkin <mst@redhat.com>
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> ---
>=20
> Dexuan, Jorgen, Stefan, would you like to co-maintain or
> be added as a reviewer?
>=20
> Thanks,
> Stefano
> ---
>  MAINTAINERS | 20 +++++++++++++-------
>  1 file changed, 13 insertions(+), 7 deletions(-)

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--egTLbucVUnkLLRdY
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmE2FrwACgkQnKSrs4Gr
c8jEZQf+Mfd2vZSV6MjdLRiIfXBITs3hKCU0gG5rAyPkHFG9iRC1FHnb9+2Sfdmn
w7Tr84qXtblshpZIT94PeEGboKkJnGrVsF84ddpq+TWwSQFlhpv+N/rT/wn/2Vz5
vcf5dAhkUt/bQb5/6X8JDAjf1SUDuiocPuCoQpbx4wP8XwsODH/bEAhtDaZsquMP
1/HDuG4tud/kaNJgbmvz7bpnqGJz9nt8m94FppYHUOBXPKuRIApKYfT8HYKBWUD9
keN6K0Hl/2382yZa0q/ExA+IsPKwgY2h5fDRxLzUykBqM5uJ1kwBKlVhk5NpPzcx
xdufFwlbUSQO2Ljm+b+w+mcX5A6FSw==
=iOz5
-----END PGP SIGNATURE-----

--egTLbucVUnkLLRdY--

