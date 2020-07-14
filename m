Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 083CE21F40E
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 16:27:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728706AbgGNO1d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 10:27:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728295AbgGNO1c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 10:27:32 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 754D9C061755;
        Tue, 14 Jul 2020 07:27:32 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id d1so1843914plr.8;
        Tue, 14 Jul 2020 07:27:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=f71cEbrvU8qSFVrNMyd+IPhSRxKJlEtp63rrrmSpA2Q=;
        b=jWAXL04KPiTqH4TIffgzAEkBckyIrQQOflai3QxCXERh6GjmizWKJKmyP8VdnUSN0i
         /AbN1cW8X70hneezxWRRIXGGdzPRiPEvTVO84p243zcjzazpLvOzlABNeWO7XISaWcQw
         6v4pz3GPPm6dcfp8NCp8L84/AqQ/aKvswU5/yGCQZauoDz1+Keg9AIgWP00fjNu5tFDc
         R3SH4peaVdLcUiSizx2QYOKAO0+z5mLXdHMdJ/1sLFQAsjkTOU2UZQejkkjyjRf5p9KJ
         bOzFy+6N95IYkqMB0dgGPemiATLMs/fjavaIBD56GkDVn36wt4pLDJcjm6zrOAdHc0Cp
         GawA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=f71cEbrvU8qSFVrNMyd+IPhSRxKJlEtp63rrrmSpA2Q=;
        b=qnxUHH/OL3nyadX69joHlFHoItjZzL2EEUl5/nS9JdKxaIbplxh2x3P9HU/cUi2sNE
         4okeBhkiqSbw0NzTPvQJHe5i4ZUazGbHgX7C4yMxyFpVXJEmqhJD9Yw7+tmS0xR/J/ap
         JLKfttNoAbzvteJXMhN8BQfZyjtMmD6qV5S8t7oBfc1X/BkT8Gbm/EScJRqKiT95oTZC
         WnKlfi7bqdOlsUn8EXaXpOK82ShRzoaWFEd9zFjdA2jK/dnmuJhqo5R7siTkxl7KQEll
         1fN+ycoyKrUwWkws78YvHQ9sa73pp5dvVzfiOde9yWe5gtXTiwvkbPWhNydinnXSVSrB
         hRUA==
X-Gm-Message-State: AOAM5312OyrbExqwHNVYLKLrUK0eftkPaD8hDGQWJdTCFv/GdxlinNF9
        8Iew8I+d4NmHCR7uMxb+nEs=
X-Google-Smtp-Source: ABdhPJyQvxixDi3jlzqf9gcL03sHpmVRsiN3MN+FexRB6Zd/QORmZKkwekGFsLQAMDBt07O/06x2zA==
X-Received: by 2002:a17:902:161:: with SMTP id 88mr4193550plb.325.1594736852040;
        Tue, 14 Jul 2020 07:27:32 -0700 (PDT)
Received: from blackclown ([103.88.82.145])
        by smtp.gmail.com with ESMTPSA id 207sm18209349pfa.100.2020.07.14.07.27.28
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 14 Jul 2020 07:27:30 -0700 (PDT)
Date:   Tue, 14 Jul 2020 19:57:24 +0530
From:   Suraj Upadhyay <usuraj35@gmail.com>
To:     Julia Lawall <julia.lawall@inria.fr>
Cc:     davem@davemloft.net, kuba@kernel.org,
        linux-decnet-user@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] decnet: dn_dev: Remove an unnecessary label.
Message-ID: <20200714142724.GC12651@blackclown>
References: <20200714141309.GA3184@blackclown>
 <alpine.DEB.2.22.394.2007141615490.2355@hadrien>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="nmemrqcdn5VTmUEE"
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.22.394.2007141615490.2355@hadrien>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--nmemrqcdn5VTmUEE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 14, 2020 at 04:16:15PM +0200, Julia Lawall wrote:
>=20
>=20
> On Tue, 14 Jul 2020, Suraj Upadhyay wrote:
>=20
> > Remove the unnecessary label from dn_dev_ioctl() and make its error
> > handling simpler to read.
> >
> > Signed-off-by: Suraj Upadhyay <usuraj35@gmail.com>
> > ---
> >  net/decnet/dn_dev.c | 8 +++-----
> >  1 file changed, 3 insertions(+), 5 deletions(-)
> >
> > diff --git a/net/decnet/dn_dev.c b/net/decnet/dn_dev.c
> > index 65abcf1b3210..64901bb9f314 100644
> > --- a/net/decnet/dn_dev.c
> > +++ b/net/decnet/dn_dev.c
> > @@ -462,7 +462,9 @@ int dn_dev_ioctl(unsigned int cmd, void __user *arg)
> >  	switch (cmd) {
> >  	case SIOCGIFADDR:
> >  		*((__le16 *)sdn->sdn_nodeaddr) =3D ifa->ifa_local;
> > -		goto rarok;
> > +		if (copy_to_user(arg, ifr, DN_IFREQ_SIZE))
> > +			ret =3D -EFAULT;
> > +			break;
>=20
> The indentation on break does not look correct.
>=20
> julia

Thanks for your response and advise, sent a v2 patch.

Suraj Upadhyay.

> >
> >  	case SIOCSIFADDR:
> >  		if (!ifa) {
> > @@ -485,10 +487,6 @@ int dn_dev_ioctl(unsigned int cmd, void __user *ar=
g)
> >  	rtnl_unlock();
> >
> >  	return ret;
> > -rarok:
> > -	if (copy_to_user(arg, ifr, DN_IFREQ_SIZE))
> > -		ret =3D -EFAULT;
> > -	goto done;
> >  }
> >
> >  struct net_device *dn_dev_get_default(void)
> > --
> > 2.17.1
> >
> >

--nmemrqcdn5VTmUEE
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE7AbCa0kOsMJ4cx0j+gRsbIfe744FAl8NwMwACgkQ+gRsbIfe
7448rw/8CA0mN5m4dMvP++UvjZdJ1C3W10rugWZhiILK1fXwPVSC2iq8TObE68/y
cKa8wGLAys54MwDw4fdsOOFieElaJU0JQDJhOEd7aXWoEGlD4kYPUTbydcJ/v150
iMJPsNYY/M5Ey5p7VYxkzidFlzNB+lFUJX8DQQNyk9SuYcNB0O+UWx3G2IoFL1WH
e81mupXoy71MSVj1gPshhN1U8m9qWKTUI3o6ynZSq6enK7x8S6VZGRmn2/6vo6HN
MOeHyhloMe6p1nbm9EyzvkrDXbM89E0v9NqKhk2ldcz5ZKABS2j6PSlsOlEFIBFj
ds9qLL3qR1+yYRLx9snSu7AVu50+JhegouehaVjPgl/JDpsLfzHE3QFWMNZ8pFDC
jiFCw+edOH9+sXC6Z3PgAN9LHBb2ruJ/X+OujW1LjJcAY5r506eCHLWk+NOEsioL
/HUfuwuVISgjfOLCgBMRps7KnpgKCo0C+hIqNd//nre8JxD+xYfR5c3emyrrjI4s
zMJlfdyIl8CCcI8VLF17Pkrl/s3qMzq6/+c4xdOBIJ1yEr62LLDamtFuyMxU7mMU
ynYb22kqKj99dY4jf6JgZ2dCjknb3SO4APhoX4eQ1Sfbydty53Fo5U1G3ZT3NaQu
LGucRfr/qnNlBzEe+pxod43+ZJkX6+A4tOSj/vTqdJeT79mENh0=
=SLPg
-----END PGP SIGNATURE-----

--nmemrqcdn5VTmUEE--
