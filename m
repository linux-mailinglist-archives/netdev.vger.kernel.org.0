Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FD7A422330
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 12:14:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233738AbhJEKQY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 06:16:24 -0400
Received: from mail-wr1-f45.google.com ([209.85.221.45]:38682 "EHLO
        mail-wr1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233290AbhJEKQW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Oct 2021 06:16:22 -0400
Received: by mail-wr1-f45.google.com with SMTP id u18so36405237wrg.5
        for <netdev@vger.kernel.org>; Tue, 05 Oct 2021 03:14:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version;
        bh=KyftH5zZ1zl5EzN7r4AOQPMAcjl40eUrWTPzMR8sB2A=;
        b=iFD6mbcDvZqYsyPJcAUSHF2Ow5/6xRoCdc+9ROsSZwnmVNkzQB0bfDcjaewRxMrpVR
         rcwSqNP3BQPyCo7b8nXg81qU+jZhrTkEjxa2Of1iPvCiF8Qh/cvJNTx04G6jBsYc5LM4
         B9i82L8z5G7jBCGR6rrUJsfNcpbzeOB9YxvAuO6roKGC4FOub0UXQEO26Gl4KN5EqxtP
         kUcdhLqEVodlJSTO+t3Z9AgqIFswm7Dj/uLYjN7yYeepm8HOGZfe6V6lyT64hzbYdzo+
         CjFdV1GXUKWPFWH7OXkOV2vntczbqhzYLUHcTImEnMHSNFJnYaRgor7ivr681YzsrnsZ
         hneQ==
X-Gm-Message-State: AOAM530QFec9afKUkn+jryCkpa9F+bFhIfhc+3Ya4t3fWVlbdP6nk+AE
        CFQ1UtmO+U+RzrUfOeg/Csw=
X-Google-Smtp-Source: ABdhPJxrbV2q3d/ocjmvvOpXwHJtBxtjV2vMKUSUXeWqpWXhLg9knYWK7ql4qaLcen6ITuIE5Eqqyg==
X-Received: by 2002:a5d:4d0e:: with SMTP id z14mr5678856wrt.239.1633428871112;
        Tue, 05 Oct 2021 03:14:31 -0700 (PDT)
Received: from localhost ([137.220.125.106])
        by smtp.gmail.com with ESMTPSA id c15sm17295789wrs.19.2021.10.05.03.14.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Oct 2021 03:14:30 -0700 (PDT)
Message-ID: <f7063f77acf9707a36989276b52be76350e1152f.camel@debian.org>
Subject: Re: [PATCH iproute2 v2 0/3] configure: add support for libdir and
From:   Luca Boccassi <bluca@debian.org>
To:     Andrea Claudi <aclaudi@redhat.com>, netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@gmail.com
Date:   Tue, 05 Oct 2021 11:14:29 +0100
In-Reply-To: <cover.1633369677.git.aclaudi@redhat.com>
References: <cover.1633369677.git.aclaudi@redhat.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-4vo2URvpAO6MiyTHSU9g"
User-Agent: Evolution 3.38.3-1+plugin 
MIME-Version: 1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--=-4vo2URvpAO6MiyTHSU9g
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2021-10-04 at 21:50 +0200, Andrea Claudi wrote:
> This series add support for the libdir parameter in iproute2 configure
> system. The idea is to make use of the fact that packaging systems may
> assume that 'configure' comes from autotools allowing a syntax similar
> to the autotools one, and using it to tell iproute2 where the distro
> expects to find its lib files.
>=20
> Patch 1 introduces support for the --param=3Dvalue style on current
> params, for uniformity.
>=20
> Patch 2 add the --prefix option, that may be used by some packaging
> systems when calling the configure script.
>=20
> Patch 3 add the --libdir option to the configure script, and also drops
> the static LIBDIR var from the Makefile.
>=20
> Changelog:
> ----------
> v1 -> v2
> =C2=A0=C2=A0- consolidate '--param value' and '--param=3Dvalue' use cases=
, as
> =C2=A0=C2=A0=C2=A0=C2=A0suggested by David Ahern.
> =C2=A0=C2=A0- Added patch 2 to manage the --prefix option, used by the De=
bian
> =C2=A0=C2=A0=C2=A0=C2=A0packaging system, as reported by Luca Boccassi, a=
nd use it when
> =C2=A0=C2=A0=C2=A0=C2=A0setting lib directory.
>=20
> Andrea Claudi (3):
> =C2=A0=C2=A0configure: support --param=3Dvalue style
> =C2=A0=C2=A0configure: add the --prefix option
> =C2=A0=C2=A0configure: add the --libdir option
>=20
> =C2=A0Makefile  |  7 +++---
> =C2=A0configure | 72 +++++++++++++++++++++++++++++++++++++++++++++++-----=
---
> =C2=A02 files changed, 66 insertions(+), 13 deletions(-)

Series-tested-by: Luca Boccassi <bluca@debian.org>

--=20
Kind regards,
Luca Boccassi

--=-4vo2URvpAO6MiyTHSU9g
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCSqx93EIPGOymuRKGv37813JB4FAmFcJYUACgkQKGv37813
JB6TZhAAvoHuW6xVRgdDoTEvhhmEWq5rww+uAJMP0Cik9PyM+xXPybAunXK0mt4Q
YUymKuKGYWAm5ylko6GiZnHs2dZmxJEBW39o8hfdfq9apDqD8x1BJ7Wt+TJhZOm1
jSct2q7zieviqJVIvZ+dhz8oUpsrPGsASQZ5Fn6HOEqPApJkAwbJS0X3D3DNQMj4
T9IL5l2oHg6g6PgfBahjauudZviL40XAzROF7mLOrpJUH0wJi5A6YsR43+1Hdbj4
TfKIyX2H8+zk/Q8VjwFzQRTEpqMdc4cDhIQQn53hjvmps3/t4p45dZROZm5gQUtw
Zdqn/TnhO5iMUMrGCeSGleRvYDY/a815vPvlqfi2TAAhraEiTKQvwivzRPqkx/oy
0r4UWb3/6BTJz9nLQYUOPZ7xq697BwFE/Yf9EISZfRlNC0nGjYmwNVYdvc5S31Hd
7pO1vcE/CcPIz/w13GAT/6aEu2wzZiFKF48H1LEcRXpDptq1979ZpsuhIHZbsWzR
0MAXqSjRngbxFfopG5ao2EqVqhMRVsrJCRauQF6WchYznont5bOr2nQx+c/KXIPC
IFZadiLKsumhOkobRtJWkJCVc7JETUtyznezpzbQzq7OgVgq5oKo2vGPj9Ve7zYf
YRuwxJoCkEAG2cUVYjbWC8sxtmQ3a0y1OFQs2dEpjzOvsys6xWU=
=Up3g
-----END PGP SIGNATURE-----

--=-4vo2URvpAO6MiyTHSU9g--
