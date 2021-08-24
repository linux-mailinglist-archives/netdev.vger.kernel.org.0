Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D6083F55A7
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 04:09:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233771AbhHXCJw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Aug 2021 22:09:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229742AbhHXCJv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Aug 2021 22:09:51 -0400
Received: from ozlabs.org (bilbo.ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D488C061575;
        Mon, 23 Aug 2021 19:09:07 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4Gtsww2w1Cz9sXM;
        Tue, 24 Aug 2021 12:09:04 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1629770945;
        bh=t8udJ6b3N0UaUSZ3BGOlaMN6Co2sK8BZqj+NJF3I+No=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=NUK4v+qATIBq7WL0xY5pFWbcWzJhIsPWunQrvEldw0AzCjDoJL80cuEIE2UnIZ5R7
         jJvUFQHrORnU9RG4ewhauBjcv2e3QKP2EyTuTOXZYGXdHdBkDFQxUFbvtt1fPLBffp
         f2STgCkY/2cVa3oy/6P5MNNeD2klSUIS/7mAEnbsF3LXHmv6G1gm5sJ8XHdkdNLNLu
         aZO04G6/7yZORLIZf6hR0u0ejK34KUpMkrN7O7TpI8ovxHZU5PCxC2UCaTrxWVkyQr
         /21/1ep7IoGWuM5bPzAebDrJ/Ij8uJj74Qx/MQxYbSxpHqkAuZKqMvEMbUaX/cefOn
         nKL44yCbpSwMQ==
Date:   Tue, 24 Aug 2021 12:09:03 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Petr Mladek <pmladek@suse.com>, David Miller <davem@davemloft.net>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        Wireless <linux-wireless@vger.kernel.org>,
        Chris Down <chris@chrisdown.name>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        Networking <netdev@vger.kernel.org>
Subject: Re: linux-next: manual merge of the wireless-drivers-next tree with
 the printk tree
Message-ID: <20210824120903.0c427fb9@canb.auug.org.au>
In-Reply-To: <20210824120714.421e734d@canb.auug.org.au>
References: <20210809131813.3989f9e8@canb.auug.org.au>
        <20210824120714.421e734d@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/5n6IoWL2IMYIcg8e2lGgRWN";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/5n6IoWL2IMYIcg8e2lGgRWN
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

[Just cc'ing Dave]

On Tue, 24 Aug 2021 12:07:14 +1000 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> On Mon, 9 Aug 2021 13:18:13 +1000 Stephen Rothwell <sfr@canb.auug.org.au>=
 wrote:
> >
> > Today's linux-next merge of the wireless-drivers-next tree got a
> > conflict in:
> >=20
> >   MAINTAINERS
> >=20
> > between commit:
> >=20
> >   337015573718 ("printk: Userspace format indexing support")
> >=20
> > from the printk tree and commit:
> >=20
> >   d249ff28b1d8 ("intersil: remove obsolete prism54 wireless driver")
> >=20
> > from the wireless-drivers-next tree.
> >=20
> > I fixed it up (see below) and can carry the fix as necessary. This
> > is now fixed as far as linux-next is concerned, but any non trivial
> > conflicts should be mentioned to your upstream maintainer when your tree
> > is submitted for merging.  You may also want to consider cooperating
> > with the maintainer of the conflicting tree to minimise any particularly
> > complex conflicts.
> >=20
> > --=20
> > Cheers,
> > Stephen Rothwell
> >=20
> > diff --cc MAINTAINERS
> > index 5cf181197a50,492bc169c3bd..000000000000
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@@ -14974,18 -14927,6 +14974,11 @@@ S:	Maintaine
> >   F:	include/linux/printk.h
> >   F:	kernel/printk/
> >  =20
> >  +PRINTK INDEXING
> >  +R:	Chris Down <chris@chrisdown.name>
> >  +S:	Maintained
> >  +F:	kernel/printk/index.c
> >  +
> > - PRISM54 WIRELESS DRIVER
> > - M:	Luis Chamberlain <mcgrof@kernel.org>
> > - L:	linux-wireless@vger.kernel.org
> > - S:	Obsolete
> > - W:	https://wireless.wiki.kernel.org/en/users/Drivers/p54
> > - F:	drivers/net/wireless/intersil/prism54/
> > -=20
> >   PROC FILESYSTEM
> >   L:	linux-kernel@vger.kernel.org
> >   L:	linux-fsdevel@vger.kernel.org =20
>=20
> This is now a conflict between the net-next tree and Linus' tree.

--=20
Cheers,
Stephen Rothwell

--Sig_/5n6IoWL2IMYIcg8e2lGgRWN
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmEkVL8ACgkQAVBC80lX
0GxQCwgAnH1FfJYTJWR2GqxEGsRtXxtdsIj1W68C2NndtyhzZpUezGfBWr6CG5nm
rG+dH3Cl6U72Xw6+XoDyHfhBRlwZbi+UL9QZk1JOD5OXdTz1G0ACRQYhA0rQDuJs
/ANU9eC3m/PXxvX5L7/5ay12135kOa78NrGldQMDt1tEALXfWbckvTu7Q5yAbpaT
E92+aOYjHyp7dChDpv4Wx0woEYHTX74+pLl5gq4hc9MAFsWGo70YG0LkUVu+R34V
2OeDIiqzcPSMlgShGTIg2Z0ZyOJgr9XmMDkYskakYtE63OTWickZjiVewsnmIqqT
t24tYt7ZnPlaHNDYjAsEg1qbuJZkPQ==
=W40K
-----END PGP SIGNATURE-----

--Sig_/5n6IoWL2IMYIcg8e2lGgRWN--
