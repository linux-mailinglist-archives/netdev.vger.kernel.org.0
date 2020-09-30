Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 411B327F5DF
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 01:20:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731566AbgI3XT4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 19:19:56 -0400
Received: from ozlabs.org ([203.11.71.1]:59925 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730403AbgI3XTz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Sep 2020 19:19:55 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4C1sfd0L84z9sTR;
        Thu,  1 Oct 2020 09:19:52 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1601507993;
        bh=OIAJhvosYONrmxQrsi+CEPwe6nw/aOJMqgYPe6BWFdk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=NtccRb2wvH4UCinr8jW5UR12Fi52FJmly/NrGaynt8abINLqNdrT34Nm6TetN0GpG
         8GM/I4RJPMa2Bh5BAed/DaP6ITIRtrozLHEqLCPM4sAkqgkeRI5t1Obkxuksg5Zacb
         nJHovoz9WAK/CDZOzuL2JPCApW/bJRg9odyifec4X2JdY1rlnRT4wfpUhXxO+krGDV
         TABq984zhb8GXZ1bhvk8xRfx1D630d7nZAbRtWVJcrJAd0WmAeVtL6JXfGuKPgbIHI
         K8X0uSHqOIXMdCX2rHEDg8kmmcUepTOQ7xETc+74IJaz+AnmqTQyP5F+BtyzVzPogB
         DM+YYDlLfZw6w==
Date:   Thu, 1 Oct 2020 09:19:52 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Vadym Kochan <vadym.kochan@plvision.eu>
Cc:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Taehee Yoo <ap420073@gmail.com>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the net-next tree
Message-ID: <20201001091952.49ceab4b@canb.auug.org.au>
In-Reply-To: <20200930230605.GB13107@plvision.eu>
References: <20200929130446.0c2630d2@canb.auug.org.au>
        <20201001080916.1f006d72@canb.auug.org.au>
        <20200930230605.GB13107@plvision.eu>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/p_6XChFQO1elAhNErT=6saL";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/p_6XChFQO1elAhNErT=6saL
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Vadym,

On Thu, 1 Oct 2020 02:06:05 +0300 Vadym Kochan <vadym.kochan@plvision.eu> w=
rote:
>
> On Thu, Oct 01, 2020 at 08:09:16AM +1000, Stephen Rothwell wrote:
> > Hi all,
> >  =20
> [CUT]
> >=20
> > I am still getting this build failure ...
> >=20
> > --  =20
>=20
> I just 've checked linux-next/master and it builds fine at least with my =
custom
> config, do/how I need to handle this case ?

If you take the net-next tree alone and do an x86_64 allmodconfig
build, it currently fails, right?

> I see the changes you applied already in linux-next/master.

Linux-next builds fine because it contains the fix patch I posted (I
added it to the net-next merge).  It needs to be explicitly fixed in the
net-next tree either using my patch or something more correct (if
necessary).
--=20
Cheers,
Stephen Rothwell

--Sig_/p_6XChFQO1elAhNErT=6saL
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl91EpgACgkQAVBC80lX
0Gzo4gf9GV840cUgukh13fKFRl7r/Z37AA6f+lVuWF58wPwlysIE5MKDQhvHw3x8
8r24WRusB+aqm94hKinXAo2CHk8NOn2rzrzRUfU1O9+VRvdhrNR+Q5JWbCrwB/NA
6rWwfajU6JB4+Bsg6MA1KShGJq1X9FDXtoDAXy9mpkOPl2EiA3zUonsNdWkdHmV8
+NFDKDkicHFTD8ZZvZ4iqduXNfy5Da3EkBySiNq3Bkn+8smX91/hc9eyoxOEMjej
XHnALgVeEpTTARqncVuudHJxOLJsENcFAJqz0j/AifxN8eByzAT84jr+GGEioEco
Gw9Ykg4RFAYzjjZ6eOJGAkCy2Uj58A==
=jRYQ
-----END PGP SIGNATURE-----

--Sig_/p_6XChFQO1elAhNErT=6saL--
