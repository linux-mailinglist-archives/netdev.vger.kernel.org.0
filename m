Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D74A02D75FA
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 13:48:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405934AbgLKMro (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Dec 2020 07:47:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:42248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405546AbgLKMrH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Dec 2020 07:47:07 -0500
Date:   Fri, 11 Dec 2020 12:46:18 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607690786;
        bh=rkttQWduCMBKi17aoUzt0DsTYkZJR+MX7IWA7cdUVlY=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=Wbd8BaKYWgSUm9ty67USyQu4EjUKRzdy6YjVH0FETXoCEeUDamCUvt9WvMsADb79R
         kLvuP/SScl3IAHOIpFnnVSQeSaDHYS9uBHTtcMRCi2xODd7jaa9gg0vPe4PgDjid+j
         d4lnRL5wtlHE3rePA6i6eXlQB6jhy0bN1CynleEDkxJqAVqkBgI0s5TKaow4zDO9xw
         GttO3wLOVATAj94V9l1S2VolDJSnWSjgB3IUzUIy59UT2G18gR5rYeoqBQf/AnfOLa
         Uzt6K+E+08P24PaoYBtE/F0uL2fkgKuwd25J0ULzAfmy3yJExlOmtxRLN+PwlWBvU7
         RiC/t/WFWzrkw==
From:   Mark Brown <broonie@kernel.org>
To:     Shuah Khan <skhan@linuxfoundation.org>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Shuah Khan <shuah@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Daniel Diaz <daniel.diaz@linaro.org>,
        Veronika Kabatova <vkabatov@redhat.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Guillaume Tucker <guillaume.tucker@collabora.com>,
        Kevin Hilman <khilman@baylibre.com>
Subject: Re: [PATCH] selftests: Skip BPF seftests by default
Message-ID: <20201211124618.GA4929@sirena.org.uk>
References: <20201210185233.28091-1-broonie@kernel.org>
 <20201210191103.kfrna27kv3xwnshr@ast-mbp>
 <7e0ca62b-ff63-7d26-355f-c49e98a0ef36@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="+QahgC5+KEYLbs62"
Content-Disposition: inline
In-Reply-To: <7e0ca62b-ff63-7d26-355f-c49e98a0ef36@linuxfoundation.org>
X-Cookie: Nostalgia isn't what it used to be.
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--+QahgC5+KEYLbs62
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Dec 10, 2020 at 04:41:33PM -0700, Shuah Khan wrote:
> On 12/10/20 12:11 PM, Alexei Starovoitov wrote:

> > I'm fine with this, but I'd rather make an obvious second step right away
> > and move selftests/bpf into a different directory.

> Why is this an obvious second step? If people want to run bpf, they can
> build and run. How does moving it out of selftests directory help? It
> would become harder on users that want to run the test.

> I don't support moving bpf out of selftests directory in the interest
> of Linux kernel quality and validation.

> Let's think big picture and kernel community as a whole.

Yeah, I don't see an obvious motivation for doing that either - what
problem does it solve?  For people running suites it's helpful to have
fewer testsuites and test infrastructures to integrate with.  The work
needed for the dependencies is going to be the same no matter where we
put the tests and moving out of the shared infrastructure creates some
additional work.

--+QahgC5+KEYLbs62
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl/TahoACgkQJNaLcl1U
h9AeWAf9ETlD7tAR85BtW0lTAL404AkYwyQwy58k/IFF4jFPDEH0PKZYsir8nv1G
ef5ojZDrbjgGBZapTuDUm8GOEk24aZgBCSGoJuCz+Y0W5hmo08bModX1kYy33q9T
0XU4nNm5sHH5lvNsDQInHXoREI7W6da5c29aQlgu/x5EElIlXsZYdqPFYgTnV4PI
+YRzKyFo5tfa3sJmjcDCv64d05OWxV339vXdRttSu6qAqp3EzzvAlW+8eMvXY0DR
V5nRvBmbjg7ZzTGie2IOmGvOZIgV1TKLm8heJ+tdClLZbZ2b7BDeYFpT2CDPkPXg
LUFaeZk7RaKcU4IHztLDHKmlgxTUYQ==
=GnSs
-----END PGP SIGNATURE-----

--+QahgC5+KEYLbs62--
