Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 883BD401C3D
	for <lists+netdev@lfdr.de>; Mon,  6 Sep 2021 15:26:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242137AbhIFNZt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Sep 2021 09:25:49 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:30793 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241543AbhIFNZs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Sep 2021 09:25:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630934682;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=KpGb85w8gQcgfPRHBY1c5nljJLmxAZ2B+i0uFEYG7dE=;
        b=UGubOZpXOssb+mphw+e/x4ioEX41YXdH/m7NRG0Q75CvRDO0BxukwSbPZ6i/7MV4Wjgzol
        m4zBvxk0fP0cblGA/8iZ/jMZf2jHxkKqiqElIlUKH8Unr6wY4GSZidqrKm1QpZEa61ASic
        Y8XAc/1hk4uznILXvVYqfynCOpPY9cA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-247-ZtEtZBdDPTGGlzYQ_rTNKw-1; Mon, 06 Sep 2021 09:24:40 -0400
X-MC-Unique: ZtEtZBdDPTGGlzYQ_rTNKw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 740D510054F6;
        Mon,  6 Sep 2021 13:24:39 +0000 (UTC)
Received: from localhost (unknown [10.39.194.203])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3C8835C22B;
        Mon,  6 Sep 2021 13:24:35 +0000 (UTC)
Date:   Mon, 6 Sep 2021 14:24:34 +0100
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
        "David S. Miller" <davem@davemloft.net>,
        Dexuan Cui <decui@microsoft.com>, linux-kernel@vger.kernel.org,
        Jorgen Hansen <jhansen@vmware.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH] MAINTAINERS: add VM SOCKETS (AF_VSOCK) entry
Message-ID: <YTYWkupSYR29IMuM@stefanha-x1.localdomain>
References: <20210906091159.66181-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="rgq6+WKf0E8dVAr9"
Content-Disposition: inline
In-Reply-To: <20210906091159.66181-1-sgarzare@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--rgq6+WKf0E8dVAr9
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

Please skip me for now. I'm available if you take an extended period of
time off and other special situations but don't have enough time to play
an active role.

Thanks,
Stefan

--rgq6+WKf0E8dVAr9
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmE2FpIACgkQnKSrs4Gr
c8h+dAgAgaznoT/gv3/pwLS4I0vUZFmrU8gfnCt9njexTIR3/p2nwq3kt6smttke
PxIsIDO9CuBUhktBZTOBQcm1CCMJ89uus3PzzpUEI/CxKLxupWW1ZSAjFVLDg1AR
KuRW9T5KW9lZKIwq++RLWMCAl+qu/kx6rxuD6opi7zpda6yTDL5i4EKov1Iq/yWL
MLeJDqcvTyEKsaR6eMuE+3uJpqVreZBns1hUpmJb3dql3JtKTQls08TIv/CCnmSw
KsOl2OIZ9m5c5XkJ2gY0ZkLU8UMpn4gqAEs/4M//WiA1jHb7OKEZwNB5HTHs6BOV
8RAAzszVVesp0VG0mrrFr3i5E7YC3g==
=0Br2
-----END PGP SIGNATURE-----

--rgq6+WKf0E8dVAr9--

