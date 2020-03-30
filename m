Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0353B1973BE
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 07:14:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728549AbgC3FOm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 01:14:42 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:60375 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727706AbgC3FOm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Mar 2020 01:14:42 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 48rLHF3cWmz9sPk;
        Mon, 30 Mar 2020 16:14:33 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1585545278;
        bh=4EEf/PratAIAfdAIaqM7alme3AOiAhBmkDtUjgsO4co=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=CP1Jse+MjIlJ6kW2s16fFcqC9sGpVidN9OEUbqfSM04WWsQ778wBmbXaogWxxubh0
         UllTMMGMi+68jyx7lRR/yg3cEHA/28YA1+cCXz6qoRMBlg6kqneL4rmdNOWCGwQ56o
         7UVP8kJ/L+Pm5mUsAm2ldMtXZmjmW6lobBKWWUFBn5KKDozZ6kVWCgVIA3xM7RfHei
         skV4FVyhyt8kaq5eKXO3GoLYRkxbph8ar0lIKsi65qbb5tZmSKQ0UwBENRJqmbz2p8
         VaI9dlWnN3OSNsB3SZTOCenqfSC2RctljWUe3L0UyCndRtXuppKMQx9uN/COXA3Fty
         grCwLo8a1lKzA==
Date:   Mon, 30 Mar 2020 16:14:31 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     akpm@linux-foundation.org, broonie@kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-next@vger.kernel.org, mhocko@suse.cz,
        mm-commits@vger.kernel.org,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>
Subject: Re: mmotm 2020-03-28-22-17 uploaded (staging/octeon/)
Message-ID: <20200330161431.60a37031@canb.auug.org.au>
In-Reply-To: <873495e9-d254-cb66-7a83-2517505a2b9b@infradead.org>
References: <20200329051805.kfaUSHrn4%akpm@linux-foundation.org>
        <873495e9-d254-cb66-7a83-2517505a2b9b@infradead.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/i7ee/j5=LxPeGDwdPn/49OA";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/i7ee/j5=LxPeGDwdPn/49OA
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi Randy,

On Sun, 29 Mar 2020 09:12:31 -0700 Randy Dunlap <rdunlap@infradead.org> wro=
te:
>
> On 3/28/20 10:18 PM, akpm@linux-foundation.org wrote:
> > The mm-of-the-moment snapshot 2020-03-28-22-17 has been uploaded to
> >=20
> >    http://www.ozlabs.org/~akpm/mmotm/
> >=20
> > mmotm-readme.txt says
> >=20
> > README for mm-of-the-moment:
> >=20
> > http://www.ozlabs.org/~akpm/mmotm/
> >=20
> > This is a snapshot of my -mm patch queue.  Uploaded at random hopefully
> > more than once a week.
> >=20
> > You will need quilt to apply these patches to the latest Linus release =
(5.x
> > or 5.x-rcY).  The series file is in broken-out.tar.gz and is duplicated=
 in
> > http://ozlabs.org/~akpm/mmotm/series =20
>=20
>=20
> on i386 or x86_64:
>=20
> ../drivers/staging/octeon/ethernet-tx.c: In function =E2=80=98cvm_oct_xmi=
t=E2=80=99:
> ../drivers/staging/octeon/ethernet-tx.c:358:2: error: implicit declaratio=
n of function =E2=80=98skb_reset_tc=E2=80=99; did you mean =E2=80=98skb_res=
erve=E2=80=99? [-Werror=3Dimplicit-function-declaration]
>   skb_reset_tc(skb);
>   ^~~~~~~~~~~~
>=20
> It looks like this inline function has been removed from
> <net/sch_generic.h>.
>=20
>=20
> Looks like it should be this change:
>=20
> -	skb_reset_tc(skb);
> +	skb_reset_redirect(skb);

I applied the above as a merge resolution patch for the staging tree
merge today, as the inline removal was a late change to Linus' tree.

--=20
Cheers,
Stephen Rothwell

--Sig_/i7ee/j5=LxPeGDwdPn/49OA
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl6BgDcACgkQAVBC80lX
0GyDuwgAhoSNIFnw3fBCuchmr1Y0lz9RtRLsQHPXWRBjpJbAmISNeVn4z3PgahRw
vdfhy0CWnykQStM1VTseZYIaU1g4+rWSSr++AMZMgOuXPk1W8a/TJtf7JsKL4694
UmigTCUgalnT/VpfHbLDf4M0PNC268KIJ6qVwCmxJ8/NIZmpVmzZj36C4icWJXC6
JrDh69whM4yqAoXBbNWh2u2vNNk5rUVk0OP6DiGpv0UTtzOH/lGr8lhTXyOATLZz
+cLG7vrdNZvqgBO3NLAVDj5fBxnJXUtoeuhnQNWL9ksprctNHcGR+/7HPK3QjJyr
KjR5AQiB+bZb51oYChE+4t9q0qPw7Q==
=aiv9
-----END PGP SIGNATURE-----

--Sig_/i7ee/j5=LxPeGDwdPn/49OA--
