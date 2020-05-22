Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FF211DF06E
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 22:17:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731003AbgEVURb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 16:17:31 -0400
Received: from www.zeus03.de ([194.117.254.33]:44582 "EHLO mail.zeus03.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730981AbgEVURb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 May 2020 16:17:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple; d=sang-engineering.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=k1; bh=Kya5RXx7oQs/zCB1bwTMAzThdfrb
        CPSEAKSAoDM4i74=; b=Ec8eVWo4lKhBy7z/mkF3YeGr4KLIbg2JWm4ggnbVq53H
        BSIXQc7krWS0eJnN9yj2CIQmp1LMqs8bWFjSoPlmgCMRJHDAo1DB8pwePXDjFKpQ
        fqcFX0e99NFqQkjO+jzqW8juYPjBt+mGLEySHdWJdV5fVcAK19ZaVZgMpcGF2ds=
Received: (qmail 1450736 invoked from network); 22 May 2020 22:17:28 +0200
Received: by mail.zeus03.de with ESMTPSA (TLS_AES_256_GCM_SHA384 encrypted, authenticated); 22 May 2020 22:17:28 +0200
X-UD-Smtp-Session: l3s3148p1@kXB2UUKm9tkgAwDPXwlcAL8MbszJrcSX
Date:   Fri, 22 May 2020 22:17:27 +0200
From:   Wolfram Sang <wsa+renesas@sang-engineering.com>
To:     "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Cc:     Geert Uytterhoeven <geert@linux-m68k.org>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Jens Axboe <axboe@kernel.dk>, Rob Herring <robh+dt@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        "David S. Miller" <davem@davemloft.net>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Guenter Roeck <linux@roeck-us.net>, linux-ide@vger.kernel.org,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Linux I2C <linux-i2c@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>
Subject: Re: [PATCH 03/17] ARM: dts: r8a7742: Add I2C and IIC support
Message-ID: <20200522201727.GA21376@ninjato>
References: <1589555337-5498-1-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <1589555337-5498-4-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <20200515171031.GB19423@ninjato>
 <CA+V-a8t6rPs4s8uMCpBQEAUvwsVn7Cte-vX3z2atWRhy_RFLQw@mail.gmail.com>
 <20200518092601.GA3268@ninjato>
 <CAMuHMdVWe1EEAtP64VW+0zXNingM1LiENv_Rfz5qTQ+C0dtGSw@mail.gmail.com>
 <CA+V-a8tVx6D8Vh=rYD2=Z-14GAW0puo009FtjYM++sw8PAtJug@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="Qxx1br4bt0+wmkIi"
Content-Disposition: inline
In-Reply-To: <CA+V-a8tVx6D8Vh=rYD2=Z-14GAW0puo009FtjYM++sw8PAtJug@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--Qxx1br4bt0+wmkIi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> > According to the Hardware User's Manual Rev. 1.00, the registers do exi=
st
> > on all RZ/G1, except for RZ/G1E (see below).
> >
> >    "(automatic transmission can be used as a hardware function, but thi=
s is
> >     not meaningful for actual use cases)."
> >
> > (whatever that comment may mean?)

Strange comment, in deed. Given the paragraph before, I would guess Gen1
maybe had a "fitting" PMIC where SoC/PMIC handled DVFS kind of magically
with this automatic transfer feature? And Gen2 has not.

> > On R-Car E3 and RZ/G2E, which have a single IIC instance, we
> > handled that by:
> >
> >         The r8a77990 (R-Car E3) and r8a774c0 (RZ/G2E)
> >         controllers are not considered compatible with
> >         "renesas,rcar-gen3-iic" or "renesas,rmobile-iic"
> >         due to the absence of automatic transmission registers.

=46rom a "describe the HW" point of view, this still makes sense to me.
Although, it is unlikely we will add support for the automatic
transmission feature (maybe famous last words).

> > On R-Car E2 and RZ/G1E, we forgot, and used both SoC-specific and
> > family-specific compatible values.

Okay, but we can fix DTs when they have bugs, or?


--Qxx1br4bt0+wmkIi
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAl7IM1MACgkQFA3kzBSg
KbavTxAAorpBPKca5mdOGo3gbsj/1JqXSYqq0SnjdWLU6QdlVYuIsv1XCCDaWHzy
eiJeY2VIMeqdoOHtcqc8W4QF4/Zo6O72JIalnQUzjG6JMs3AWDkbdRQQ8ULF6MMv
iHd/h+E+GmtklAPGTMlMrC5KAMwRXbp6ot1F9T7J0nv8ET+2Rw741cydM7a7F+Hh
AaMHRVsJMOD4nGsAd5A6/oF0Vc2LqER4Jki+dkQSw2AJCTvyRpQ5MSpq290HZJHv
Ln5nGpxzHLznFpbMqLeqRr5mk1QmVH3k76gB6sLYoo0UFfkCn/6aMRXn0OGqgqV/
DS450PHShO1TdfTgekd5++BCGMFfTB0Ud0uhKSJ3TvLNSeojilWaC0zxaMY84K15
rcr9tKV35NJxualpbGP8ziWsDOQa36tJXa7x10I5Aetnrle23Sot6k9PbxUh6Bso
V/VtWKuUyNqe6wsMVXNvVj3WAE5NKCiKf1D8hzzyVYYoNPsp5dra6pzEhMVx+fQk
+KcYFHNwGnYLYZv/bU3pf8084R4QO1JqqSsHFaba21O6taURty+bBwE7fLeVwlcb
z1//GXsaHLZGqq++IjfqjrM8KgTZmmSQy8noLOBkD97xbqVnbYCobp5CWsokD6W8
VNjooWfgi0uj1I3A1AZPa+7ydJiAwB6OvQsAymOS6tm9kukzhd8=
=QVjR
-----END PGP SIGNATURE-----

--Qxx1br4bt0+wmkIi--
