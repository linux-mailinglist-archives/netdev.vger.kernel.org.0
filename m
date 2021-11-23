Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E86345A333
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 13:49:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237332AbhKWMww (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 07:52:52 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:55760 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237229AbhKWMwp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Nov 2021 07:52:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637671777;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=qq9RCNwYaWXQoI/gd2Bb1y62RmVls2Lwj4nIew3gKLU=;
        b=UtfPsgN+ZmAPzBs5OnxbiT+UzEa46D1H9aUYaaxFPaDMZojnHgULSo4dRvTqaWqK3QNjBp
        2o3WdDzlmXMjrUSgBVNaV2RgP8CRNIghjK6uRjiaB90cuEXG5kGv2FlaCUC451YywTQk2F
        Dm7lVUrBEPHfryceR6l/deYL+wdkY9Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-540-nsYRZ2KOM_2sPYaJknSsCg-1; Tue, 23 Nov 2021 07:49:33 -0500
X-MC-Unique: nsYRZ2KOM_2sPYaJknSsCg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0F55A87953E;
        Tue, 23 Nov 2021 12:49:32 +0000 (UTC)
Received: from localhost (unknown [10.39.195.64])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C74FC5F4E0;
        Tue, 23 Nov 2021 12:49:22 +0000 (UTC)
Date:   Tue, 23 Nov 2021 12:49:21 +0000
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     linux-kernel@vger.kernel.org, Halil Pasic <pasic@linux.ibm.com>,
        Jason Wang <jasowang@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        f.hetzelt@tu-berlin.de, david.kaplan@amd.com,
        konrad.wilk@oracle.com
Subject: Re: [PATCH] vsock/virtio: suppress used length validation
Message-ID: <YZzjUbM+LE0dwsIi@stefanha-x1.localdomain>
References: <20211122093036.285952-1-mst@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="CQhna4TCfJN2pG2B"
Content-Disposition: inline
In-Reply-To: <20211122093036.285952-1-mst@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--CQhna4TCfJN2pG2B
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 22, 2021 at 04:32:01AM -0500, Michael S. Tsirkin wrote:
> It turns out that vhost vsock violates the virtio spec
> by supplying the out buffer length in the used length
> (should just be the in length).
> As a result, attempts to validate the used length fail with:
> vmw_vsock_virtio_transport virtio1: tx: used len 44 is larger than in buf=
len 0
>=20
> Since vsock driver does not use the length fox tx and
> validates the length before use for rx, it is safe to
> suppress the validation in virtio core for this driver.
>=20
> Reported-by: Halil Pasic <pasic@linux.ibm.com>
> Fixes: 939779f5152d ("virtio_ring: validate used buffer length")
> Cc: "Jason Wang" <jasowang@redhat.com>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>  net/vmw_vsock/virtio_transport.c | 1 +
>  1 file changed, 1 insertion(+)

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--CQhna4TCfJN2pG2B
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmGc41EACgkQnKSrs4Gr
c8h1hgf/VSC+i/I53x1gWPlapZR23ESGCMVD+7wgM6NTPM5rT+nqyAaq5IPNn9AH
08hZcOtgsKB2hi0yjlqQHhwFfOmsqF/OoEW/iQRkmNfXbNolhpdVojNOGGiKYPyF
BJuI4BLniogr840wowG1cv0QYb2sfhOSRa+Lpm4YcC8+tvB2b8qgIPnAdj24e7Xc
vuAUwNFrWcLImHqdDc/mhI5Tanz32oQn2WWFjJ4SdHK4f0KCnXZbs3dVqAI1BbEw
Ryiy0Y8rBXeO1iOzk+HMiIw+msPkRxJbdqB+7bujClo15eNYZucU9NZuaM8j6ylJ
4/7+vFLiTMW4FaM+59sh925HLVglUA==
=NGnu
-----END PGP SIGNATURE-----

--CQhna4TCfJN2pG2B--

