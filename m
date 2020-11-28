Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61FF92C7447
	for <lists+netdev@lfdr.de>; Sat, 28 Nov 2020 23:19:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387582AbgK1Vtn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Nov 2020 16:49:43 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:46715 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732905AbgK1SJs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Nov 2020 13:09:48 -0500
Received: by mail-wr1-f67.google.com with SMTP id g14so9099088wrm.13
        for <netdev@vger.kernel.org>; Sat, 28 Nov 2020 10:09:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version;
        bh=PV3D5sr6gVHO7dQ/PXecWF/9f3yKEhq5Bw6Wv/M3CFI=;
        b=SVRZ/zL1FmP7VCQIQMyI3xZ31n9DSghK15sHOJz0l++m3VyFPK/raN5jaQ2NrlKh5O
         EeQ4zYfEGxMcNR0IZSo3lJHk320vrqprx6BlnJ3YG/1Mhy/RHb3aSHkyiIJW5w+5gEWA
         TcH36kjCLNa/JrNspPJcPkDWLPyPWLTTLqr82FPsu4iLqpI4Sbczwj1lAtRHjJQTP4Jw
         Xuuuqjv94dBA4JpS7ptQo7FHnbCt+H3o8pod8Zds3tLG6+jduaTdsAmdIwkrskP6f7P/
         coyk0dTF9nKlxIF5Kx3GBdoQv87EIMm+I20n/zU6mpTigUBYU36ga3kVOaEThBvkgThw
         BIqQ==
X-Gm-Message-State: AOAM5309Z2EmxBxts5+JP3Vu6LEZJkT8CsovnBylDRq8i6ATpEOtlDQv
        DjkQg0wgreo+ynU0zN3STI2buyLHGw91sw==
X-Google-Smtp-Source: ABdhPJwawWEORp46pWD+nzYcexjnVTRLQu4cPtH1mdnOvficVf7jL6VfZBhXOnZAO0cg1GlQeRvKMA==
X-Received: by 2002:adf:dd0e:: with SMTP id a14mr17969514wrm.36.1606577101377;
        Sat, 28 Nov 2020 07:25:01 -0800 (PST)
Received: from localhost ([2a01:4b00:f419:6f00:e2db:6a88:4676:d01b])
        by smtp.gmail.com with ESMTPSA id s13sm20193828wrt.80.2020.11.28.07.25.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Nov 2020 07:25:00 -0800 (PST)
Message-ID: <535423bfff9908f126c967de57f21b1ae6d0f546.camel@debian.org>
Subject: Re: [PATCH iproute2 v2] tc/mqprio: json-ify output
From:   Luca Boccassi <bluca@debian.org>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org
Date:   Sat, 28 Nov 2020 15:24:56 +0000
In-Reply-To: <20201128122148.6904-1-bluca@debian.org>
References: <20201127152625.61874-1-bluca@debian.org>
         <20201128122148.6904-1-bluca@debian.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-yzS4WVJDt7nUZ+y9Lh80"
User-Agent: Evolution 3.38.1-2 
MIME-Version: 1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--=-yzS4WVJDt7nUZ+y9Lh80
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2020-11-28 at 12:21 +0000, Luca Boccassi wrote:
> As reported by a Debian user, mqprio output in json mode is
> invalid:
>=20
> {
> =C2=A0=C2=A0=C2=A0=C2=A0 "kind": "mqprio",
> =C2=A0=C2=A0=C2=A0=C2=A0 "handle": "8021:",
> =C2=A0=C2=A0=C2=A0=C2=A0 "dev": "enp1s0f0",
> =C2=A0=C2=A0=C2=A0=C2=A0 "root": true,
> =C2=A0=C2=A0=C2=A0=C2=A0 "options": { tc 2 map 0 0 0 1 0 1 0 0 0 0 0 0 0 =
0 0 0
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 queues:(0:3) (4:7)
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 mode:channel
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 shaper:dcb}
> }
>=20
> json-ify it, while trying to maintain the same formatting
> for standard output.
>=20
> https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D972784
>=20
> Reported-by: Rom=C3=A9o GINON <romeo.ginon@ilexia.com>
> Signed-off-by: Luca Boccassi <bluca@debian.org>
> ---
> v1: I do not have hardware where I can configure mqprio, so I can't
> really
> test this apart from compiling it. Stephen and David, do you have
> machines
> where you can quickly check that this works as expected? Thanks!
>=20
> v2: the original reporter tested the patch and reported this is the
> new output:
>=20
> {
> =C2=A0=C2=A0=C2=A0 "kind": "mqprio",
> =C2=A0=C2=A0=C2=A0 "handle": "8001:",
> =C2=A0=C2=A0=C2=A0 "root": true,
> =C2=A0=C2=A0=C2=A0 "options": {
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 "tc": 2,
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 "map": [ 0,0,0,1,0,1,0,0,0,0,0=
,0,0,0,0,0 ],
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 "queues": [
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 "": [ =
0,3 ],
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 "": [ =
4,7 ] ],
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 "mode": "channel",
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 "shaper": "dcb"
> =C2=A0=C2=A0=C2=A0 }
> }
>=20
> Changed in v2 to make the inner queues arrays anonymous
> ("" -> NULL for open/close_json_array)
>=20
> Still would appreciate testing from someone else who has hardware
> that supports this feature and can enable this, as I am flying blind.

The reporter confirmed the json output is now valid with this patch on
the debian bug report.

--=20
Kind regards,
Luca Boccassi

--=-yzS4WVJDt7nUZ+y9Lh80
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEE6g0RLAGYhL9yp9G8SylmgFB4UWIFAl/Ca8gACgkQSylmgFB4
UWLeLQgAqJels8ACdFKXkBHXuB9kM1zOF2XMrifOdqpS8CVlm9/wX9tIwo6JTZJz
JNUt0LnVi/PPXQydCUWkq5MC7RuZ2yLmb+zvLL70aBLo7zIQgRHWyrnpwPMmJxiA
v6b/WDti4MjKlMuQOF4DcGJUiPim1kB6eVn2u9qm8UoXGu+FAWXicbcexbId7iaU
2DlV0lyDFFhZsHQbmhcJn0aIb68ibCIQA8PlFeX9mt1O97iIADZYC8t+Mk7qfayM
CM6pqZfNStmnrpx9eiOjVyzT6ARn0T9vLcyjU6Pg6mGtYeI+e2BSWBWSe3gnGEzL
aOURpX4mZ97qwLYQGli5Q1atS42jTw==
=UT2M
-----END PGP SIGNATURE-----

--=-yzS4WVJDt7nUZ+y9Lh80--
