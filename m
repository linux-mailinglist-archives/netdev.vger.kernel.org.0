Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66067345BB1
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 11:10:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230165AbhCWKJi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 06:09:38 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:39886 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230115AbhCWKJS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Mar 2021 06:09:18 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 9B71F1C0B81; Tue, 23 Mar 2021 11:09:17 +0100 (CET)
Date:   Tue, 23 Mar 2021 11:09:16 +0100
From:   Pavel Machek <pavel@ucw.cz>
To:     Edward Cree <ecree.xilinx@gmail.com>
Cc:     Alexey Dobriyan <adobriyan@gmail.com>,
        torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, vgupta@synopsys.com,
        linux-snps-arc@lists.infradead.org, jiri@nvidia.com,
        idosch@nvidia.com, netdev@vger.kernel.org, Jason@zx2c4.com,
        mchehab@kernel.org
Subject: Re: [PATCH 10/11] pragma once: delete few backslashes
Message-ID: <20210323100916.GB20449@amd>
References: <YDvLYzsGu+l1pQ2y@localhost.localdomain>
 <YDvNSg9OPv7JqfRS@localhost.localdomain>
 <91f4ba8b-38a0-dfcf-1fec-31410a802f5f@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="l76fUT7nc3MelDdI"
Content-Disposition: inline
In-Reply-To: <91f4ba8b-38a0-dfcf-1fec-31410a802f5f@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--l76fUT7nc3MelDdI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!
> > index e201b4b1655a..46704c341b17 100644
> > --- a/arch/arc/include/asm/cacheflush.h
> > +++ b/arch/arc/include/asm/cacheflush.h
> > @@ -112,6 +112,6 @@ do {									\
> >  } while (0)
> > =20
> >  #define copy_from_user_page(vma, page, vaddr, dst, src, len)		\
> > -	memcpy(dst, src, len);						\
> > +	memcpy(dst, src, len)
> >  This changebar also removes a semicolon.
> It looks plausibly correct, but the commit message ought to mention it.

Probably should use do{}while(0) trick.
										Pavel
--=20
http://www.livejournal.com/~pavelmachek

--l76fUT7nc3MelDdI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmBZvkwACgkQMOfwapXb+vKCmwCaA/Ehp1Zz5+JZhFGU3sdRDdhk
yAAAn3HojwFRiHt1hZmig8TuKvvY0/yo
=Tk2F
-----END PGP SIGNATURE-----

--l76fUT7nc3MelDdI--
