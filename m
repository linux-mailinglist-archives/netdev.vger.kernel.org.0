Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 941E8EFF97
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 15:23:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389276AbfKEOW7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 09:22:59 -0500
Received: from bilbo.ozlabs.org ([203.11.71.1]:52223 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389238AbfKEOW7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Nov 2019 09:22:59 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 476sML30Mcz9sNx;
        Wed,  6 Nov 2019 01:22:54 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1572963775;
        bh=tKE0unT97Mgi0G6lcUeqkq6Frke/9A5fPrYnSHBwf2o=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=UxD6NHXgO4Btb/r6S9VisX/YD2A1lOK2IuGyh9N/fjGktkTAWS4w5muojbcCGdIlK
         7yfa2E0TcWbKZ/wQtxX5VKb+DP82nhdaYwLcUHJbY5dKQMztVQF86JGwKsSI8TrodU
         W4SkjgFwtNtX5uvmN4O4+awUgmXaMTZaDF/JPh8m6xXnUHHrNazuSk2Q3dClBHlvbr
         yqoRVNx8wehZep3hKm5apGeCO0YCr2pXvus5gWcRms2kPCbCAqPlg7r2uc+07+75zS
         Dh/SB7nxzSKQT4jgHIANwGkY4s5TibFDv/BeZHqnClMW3QNcsMlObjsATMlJ/HCQ2h
         x4/a6A6E/vqHg==
Date:   Wed, 6 Nov 2019 01:22:51 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the net-next tree
Message-ID: <20191106012251.5bfc5e92@canb.auug.org.au>
In-Reply-To: <20191105135054.GA7189@lunn.ch>
References: <20191105195341.666c4a3a@canb.auug.org.au>
        <20191105135054.GA7189@lunn.ch>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/fD6AAWwQM+5dF0afKAc.40g";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/fD6AAWwQM+5dF0afKAc.40g
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

On Tue, 5 Nov 2019 14:50:54 +0100 Andrew Lunn <andrew@lunn.ch> wrote:
>
> On Tue, Nov 05, 2019 at 07:53:41PM +1100, Stephen Rothwell wrote:
> >=20
> > After merging the net-next tree, today's linux-next build (powepc
> > ppc44x_defconfig) failed like this:
> >=20
> >=20

Sorry about leaving the error out :-(

> > Caused by commit
> >=20
> >   0c65b2b90d13 ("net: of_get_phy_mode: Change API to solve int/unit war=
nings")
> >=20
> > I applied the following patch, but there is probably a nicer and more
> > complete way to fix this. =20
>=20
> I just received the 0-day about this. I did not know David had merged
> it!
>=20
> What you have works. So:
>=20
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
>=20
> The nicer way is a bit bigger. Is this too big to go in via you?
> Should i submit it via netdev, and you can drop your fix once this
> arrives?

via Dave, thanks.

--=20
Cheers,
Stephen Rothwell

--Sig_/fD6AAWwQM+5dF0afKAc.40g
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl3BhbsACgkQAVBC80lX
0GwF7wf+NyXeqLnnor8kxF9m3WHuOzQzyTVxUgi8CrgYF+WYmt9rbuCzG6HyfM0P
/T/xTaTigKc+j9d6Nv9KoXF03Mvm7/zmEnhi5c1SsCbecmozveeoxdbPNuNkq7yt
nFKsIdR3rd6xaj0YfJQgDpYzYmG/wfjwWwXGq5EVg/2CJxrMpyjMuppBcSVxLSQx
P6JTkfPEH2pD5fuibkexox40ubqiX0U6ugUL+7MUXWvbCxy9swtkhbTGJucNZuwD
rs9mo7l/BdZnupEpLnydyjiQPcGXuD7btBzNTKOpEdELuOp2/gmdAQSVweYGpP90
esvYwCjoIaOjXoEPtSfENYWOhHIqvQ==
=63Z1
-----END PGP SIGNATURE-----

--Sig_/fD6AAWwQM+5dF0afKAc.40g--
