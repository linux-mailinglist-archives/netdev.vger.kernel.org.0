Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1EA61EF33F
	for <lists+netdev@lfdr.de>; Fri,  5 Jun 2020 10:37:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726217AbgFEIg5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jun 2020 04:36:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726134AbgFEIg4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Jun 2020 04:36:56 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ED0AC08C5C2;
        Fri,  5 Jun 2020 01:36:56 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id v19so7641779wmj.0;
        Fri, 05 Jun 2020 01:36:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=3nTFlmbzjc8v0pH7sZvwI+DHbaQtTE22skIrB/BBsac=;
        b=e67AZEdW7AQDvDVQqSMO75BKdN9sXsQ31mldbeM81dO6BOICEsD2O5FUbT6AtHWRGJ
         plZ42JBpABtAE0qkoYP0pTcrEnHaBdxBXb2TqXVeprtt7h0rkxNMPlsWlshIHPQvFC3f
         LIk3kKcIyHE4kbOCKEy+Oitwg1ku4027jK0wI2jYWVAMCSMdaqleuPGztuOKDBJFgF3y
         PERlNqsNtwYYDncipouKU3kMoPoxwbgfTlz5gslrVzJ43mHdWSUQM8/bTNCx6Z2/ENou
         BkMUs1ZqDNy3mRk9R2QVvQDdZt3IRrKyrNetY1lggLmAixWg09XWFx9nwpriBfYcF4b/
         gh5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=3nTFlmbzjc8v0pH7sZvwI+DHbaQtTE22skIrB/BBsac=;
        b=F6GBB2NeGXwtAwnRmBTaISpXi/032Rj2XA8Af0vVBSecZpeO3wXcu+x7R8oj9C8TFi
         fxE/nXwAGe7rzJPBkaxlPz5F8+5FemfjuzrcR5l5Gwi98ZP1Cyv09wRGKnIreWRXqUI8
         11oz5yPy6kjcKkBFf0CEssYcot9SBBlRNBMMhuFQ3yPw1wNM3nb97toFeKxVWkzpAt0M
         x/wj+SCGuvLu/a5kk+vlu6hwN9E0quZZIqO9M1J89VSKb7AGZ/f2U+HQgsDnODUFS8HN
         N1ezu5kXHqkXy8RV8rHM0ZbPNudJdjFBhfb4gEq+15JuRoErRmdDaIuwlSy/uA+n7W3w
         tVNg==
X-Gm-Message-State: AOAM5311e5x3EER1+oYc8AElRi0Fq0AKuT4xlyJ/X/R8WOhJB/wyYydN
        Ctj01UaVpGx5g69X20w/jX9KPGVh3N0=
X-Google-Smtp-Source: ABdhPJzD5hm7+HVTbJ0qq5buzfUjWSLLl36UEL8lKEkif51XgpXz2Frm5/M2WeUz/+7QwQtLTt0pgQ==
X-Received: by 2002:a1c:de82:: with SMTP id v124mr1554125wmg.89.1591346214788;
        Fri, 05 Jun 2020 01:36:54 -0700 (PDT)
Received: from localhost ([51.15.41.238])
        by smtp.gmail.com with ESMTPSA id r11sm11692035wre.25.2020.06.05.01.36.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Jun 2020 01:36:53 -0700 (PDT)
Date:   Fri, 5 Jun 2020 09:36:52 +0100
From:   Stefan Hajnoczi <stefanha@gmail.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
        Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>
Subject: Re: [PATCH RFC 12/13] vhost/vsock: switch to the buf API
Message-ID: <20200605083652.GC59410@stefanha-x1.localdomain>
References: <20200602130543.578420-1-mst@redhat.com>
 <20200602130543.578420-13-mst@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="O3RTKUHj+75w1tg5"
Content-Disposition: inline
In-Reply-To: <20200602130543.578420-13-mst@redhat.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--O3RTKUHj+75w1tg5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 02, 2020 at 09:06:22AM -0400, Michael S. Tsirkin wrote:
> A straight-forward conversion.
>=20
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>  drivers/vhost/vsock.c | 30 ++++++++++++++++++------------
>  1 file changed, 18 insertions(+), 12 deletions(-)

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--O3RTKUHj+75w1tg5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl7aBCQACgkQnKSrs4Gr
c8iqrgf/W5qzuVqOztDa26raKxGSK1HW1tigkHdgjm6LUcghCLUBNVTqklvPgnVt
8n0X/em12Ztmj43uNCuw0U+4ZpTZjibzwlvp4QnFw8nVsLtdMZIR9nAORPM/9Lbq
cihrvmGGikfHp5Rlj76nOnVODooOuQEI+S0ii+m5uKGEE3Y2z5n0LIh8j1p5Ms0k
Xr5j9JKZ5mHH9ZYA6c79KVPPn7k18+4H5aSr5GPr3gsrUR8jSJhUhub1H6tAwKoB
Tg+68nP4BA7Gcowm+QE22SwmmT1YEmjLKydYLH0bP2NewcRqh10Dw3DsV2fMU8BN
3LEoQfYetWn383ZxfvbNLNO8JCQ4wQ==
=D/8f
-----END PGP SIGNATURE-----

--O3RTKUHj+75w1tg5--
