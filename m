Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 775252C01BE
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 09:55:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727647AbgKWIyX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 03:54:23 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:35801 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726360AbgKWIyX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 03:54:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606121661;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=P8CGtKbmihjdsyd0p+Vdkg1jk8d6S8Wxkrx6dLJVykI=;
        b=Xxx9V0QToqPbvCky2OBs0EllAy9/8FoRMr0URLvl5JGySjcw8sBRDb8EDEcYMchWljEeKa
        ynh/83vzQC0yOb6n7L1vZsodw3bcR9sJPtQ5q8bmakry76LH7HQzrBJ9Xzh3FnVn9Q/Psf
        C2/KCOeY9RtOaXaHq7FnC0rP84kyocU=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-179-Yj-qrKnbNyKgJPkR7RoUSA-1; Mon, 23 Nov 2020 03:54:19 -0500
X-MC-Unique: Yj-qrKnbNyKgJPkR7RoUSA-1
Received: by mail-wm1-f70.google.com with SMTP id n19so1233877wmc.1
        for <netdev@vger.kernel.org>; Mon, 23 Nov 2020 00:54:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=P8CGtKbmihjdsyd0p+Vdkg1jk8d6S8Wxkrx6dLJVykI=;
        b=QmI0GA1rizz/6wUVfsm0Y2ZRSRPyH55pchichTNNXGdem0Kyspzx69ODOSWUvFSPNc
         vO4pT+1/hVBQPX2bLaZGj+pUFepZIvCfrEN40Z41khSSoy/KYxWdepjgdhpBw2WwYk0e
         HyyDOWMillBWifu7Ujo/l1L81QuNxT8OoRC4TUjBJYtbSjbyvGORtX0QZWXA5UoBfupW
         w2fyW0w099UrLVH2lo2MVqu6FV+CJmsuBZiQLnR109Y8hqwEY6sD1TEdLiEVDHqqaUif
         KD2LXc4Ex1oScon9C6O6eKVhj+fIYAjdCXRECrPWcRbqPpF73KuzYEh//2r0ETpTPBk5
         TvoA==
X-Gm-Message-State: AOAM531NyFlsEt5Jbs7TeF72PppWlImxJ9+P67cyF9zFF81OaLhant4g
        MuhV8xsTsYc3YReBl8YysPthS+/HQov5ISc1TxOXhyMAChgQilX334mZ6MuooB7L1ch+WObSSkL
        agYjW57ZQ+VZFdb/A
X-Received: by 2002:adf:e2c9:: with SMTP id d9mr29309944wrj.11.1606121658200;
        Mon, 23 Nov 2020 00:54:18 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzAvPOpcZwccjrURVoxu3LAWxhq91ZNi5t7X2R4USsynvncqS7wwTqgkqusW4u6MuhhlZ3+gQ==
X-Received: by 2002:adf:e2c9:: with SMTP id d9mr29309928wrj.11.1606121658005;
        Mon, 23 Nov 2020 00:54:18 -0800 (PST)
Received: from localhost ([151.66.8.153])
        by smtp.gmail.com with ESMTPSA id b14sm18424925wrq.47.2020.11.23.00.54.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2020 00:54:17 -0800 (PST)
Date:   Mon, 23 Nov 2020 09:54:13 +0100
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, brouer@redhat.com
Subject: Re: [PATCH net-next] net: page_pool: Add page_pool_put_page_bulk()
 to page_pool.rst
Message-ID: <20201123085413.GB2115@lore-desk>
References: <937ccc89a82302a06744bcb6d253f0e95651caa2.1605910519.git.lorenzo@kernel.org>
 <X7tteeAxhH9G0TwF@apalos.home>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="wq9mPyueHGvFACwf"
Content-Disposition: inline
In-Reply-To: <X7tteeAxhH9G0TwF@apalos.home>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--wq9mPyueHGvFACwf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Fri, Nov 20, 2020 at 11:19:34PM +0100, Lorenzo Bianconi wrote:
> > Introduce page_pool_put_page_bulk() entry into the API section of
> > page_pool.rst
> >=20
> > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > ---
> >  Documentation/networking/page_pool.rst | 8 ++++++++
> >  1 file changed, 8 insertions(+)
> >=20
> > diff --git a/Documentation/networking/page_pool.rst b/Documentation/net=
working/page_pool.rst
> > index 43088ddf95e4..e848f5b995b8 100644
> > --- a/Documentation/networking/page_pool.rst
> > +++ b/Documentation/networking/page_pool.rst
> > @@ -97,6 +97,14 @@ a page will cause no race conditions is enough.
> > =20
> >  * page_pool_get_dma_dir(): Retrieve the stored DMA direction.
> > =20
> > +* page_pool_put_page_bulk(): It tries to refill a bulk of count pages =
into the
>=20
> Tries to refill a number of pages sounds better?

ack, will fix it in v2

>=20
> > +  ptr_ring cache holding ptr_ring producer lock. If the ptr_ring is fu=
ll,
> > +  page_pool_put_page_bulk() will release leftover pages to the page al=
locator.
> > +  page_pool_put_page_bulk() is suitable to be run inside the driver NA=
PI tx
> > +  completion loop for the XDP_REDIRECT use case.
> > +  Please consider the caller must not use data area after running
>=20
> s/consider/note/

ack, will fix it in v2

Regards,
Lorenzo

>=20
> > +  page_pool_put_page_bulk(), as this function overwrites it.
> > +
> >  Coding examples
> >  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > =20
> > --=20
> > 2.28.0
> >=20
>=20
>=20
> Other than that=20
> Acked-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
>=20

--wq9mPyueHGvFACwf
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCX7t4swAKCRA6cBh0uS2t
rEdRAQCVPIR2Tcs/Fa+WQcCepBe7TMxrupYsmbpCNS5fCEL8FgEArBiGCIVuqnKn
uhWWawWZSr83cCwUT5wL/qGLAEkkWQU=
=ThC1
-----END PGP SIGNATURE-----

--wq9mPyueHGvFACwf--

