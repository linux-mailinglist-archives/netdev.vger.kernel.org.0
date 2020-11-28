Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 580CB2C7405
	for <lists+netdev@lfdr.de>; Sat, 28 Nov 2020 23:18:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731463AbgK1Vtp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Nov 2020 16:49:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733289AbgK1SPo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Nov 2020 13:15:44 -0500
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A43FEC0253C2
        for <netdev@vger.kernel.org>; Sat, 28 Nov 2020 09:34:35 -0800 (PST)
Received: by mail-pg1-x542.google.com with SMTP id k11so6867721pgq.2
        for <netdev@vger.kernel.org>; Sat, 28 Nov 2020 09:34:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version;
        bh=iVeRyPUEAP68LIhs81XmMLPJn7kP/wOQ4p1WmeyvyHk=;
        b=dK9ynXKIsp5GVqhxDxpB8tW9IZFDxPCuCU3Vk97/dJVBZMB1WgLLaoIPTqwfRYP+Ek
         u3rv227iUR34dPVOVp8afEx/uucauttGroHZbGsxuTFKLOMPGPqCD5GHwys9zWj8wrua
         KG2g4lqaxLuYLQhHGYHVWPGV5bX9AqxMq3SBtGUPUArQrN9G6wFLrRHeIksvbiwBiNaZ
         VzFqBaPMUW5uEzAUpwxfIZmOLw5CeSsPa6oLsSVuujCTF4/aepyJw6cP2p7/oU5Y1e3A
         iXSQgpj9vrvCQtgb3VPF4RZqNb3G7WDFtnW6xMmicV79BkhEcXnqDHimtjhtwRo5kZrc
         DPfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version;
        bh=iVeRyPUEAP68LIhs81XmMLPJn7kP/wOQ4p1WmeyvyHk=;
        b=eIkBrUFjOxDcBBDxXC0lSsr1VEJmeqrRlHB7Pd8OyVKROZJYyAUlZQXZHLJEU4sq5j
         3g0kvSC/pG4wcNxQqf9EWXRaegUjjqxd7QspX897T3NQygnCvkunHQQD3ukE4S5qHEyU
         jLcLEiQjwtETPncVcFjBYOM/nDUHh2WhV/LIpeQ1rG+Ot56rxa2f7IO4/G7AsYoW4/ht
         Uo0vyc0x/Gvo+7/AnAOg93wvKGepmwS/JxFdiE3pC+KTp+XPpOLQw0DQT4KxVefOVqY6
         z2bmmyvcid/+Bg+JSzRXgFfuVom0RxQ9/LPtE5H2rrfXjGyNY9Q0gNq90fDPSZRWLeWX
         rXoA==
X-Gm-Message-State: AOAM530enoCQdzLjqxX1/KDmTbrum0U9pRJsGEiY/0TCre8u4JPxaQ8D
        mSLUBP4Qw15TOFZ1TsuT6zYfOg==
X-Google-Smtp-Source: ABdhPJyeSEBObmR//7BrEMAKjDH9m4u08rSmeNnkd+g3xpjdDlu9e+ljtWlzOGsKQCjfPeMfstsWJw==
X-Received: by 2002:a17:90a:aa0f:: with SMTP id k15mr17315232pjq.171.1606584875003;
        Sat, 28 Nov 2020 09:34:35 -0800 (PST)
Received: from hermes.local (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id s18sm11578505pfc.5.2020.11.28.09.34.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Nov 2020 09:34:34 -0800 (PST)
Date:   Sat, 28 Nov 2020 09:34:20 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Luca Boccassi <bluca@debian.org>
Cc:     netdev@vger.kernel.org
Subject: Re: [RFC iproute2] tc/mqprio: json-ify output
Message-ID: <20201128093420.3d9f6aea@hermes.local>
In-Reply-To: <66c38398895dd591ded53e0d1bf34a13f3e83a32.camel@debian.org>
References: <20201127152625.61874-1-bluca@debian.org>
        <20201127212151.4984075c@hermes.local>
        <66c38398895dd591ded53e0d1bf34a13f3e83a32.camel@debian.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/NZfmbu.tGUIC+EVrvAG/Qou";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/NZfmbu.tGUIC+EVrvAG/Qou
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Sat, 28 Nov 2020 12:17:00 +0000
Luca Boccassi <bluca@debian.org> wrote:

> On Fri, 2020-11-27 at 21:21 -0800, Stephen Hemminger wrote:
> > On Fri, 27 Nov 2020 15:26:25 +0000
> > Luca Boccassi <bluca@debian.org> wrote:
> >  =20
> > > As reported by a Debian user, mqprio output in json mode is
> > > invalid:
> > >=20
> > > {
> > > =C2=A0=C2=A0=C2=A0=C2=A0 "kind": "mqprio",
> > > =C2=A0=C2=A0=C2=A0=C2=A0 "handle": "8021:",
> > > =C2=A0=C2=A0=C2=A0=C2=A0 "dev": "enp1s0f0",
> > > =C2=A0=C2=A0=C2=A0=C2=A0 "root": true,
> > > =C2=A0=C2=A0=C2=A0=C2=A0 "options": { tc 2 map 0 0 0 1 0 1 0 0 0 0 0 =
0 0 0 0 0
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 queues:(0:3) (=
4:7)
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 mode:channel
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 shaper:dcb}
> > > }
> > >=20
> > > json-ify it, while trying to maintain the same formatting
> > > for standard output.
> > >=20
> > > https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D972784
> > >=20
> > > Signed-off-by: Luca Boccassi <bluca@debian.org> =20
> >=20
> > Did you try feeding that into the python parser?
> > What is before/after? =20
>=20
> Uh, which python parser?
>=20
> The reporter tested the patch, there's a small error. Before is above,
> after is:
>=20
> {
>     "kind": "mqprio",
>     "handle": "8001:",
>     "root": true,
>     "options": {
>         "tc": 2,
>         "map": [ 0,0,0,1,0,1,0,0,0,0,0,0,0,0,0,0 ],
>         "queues": [
>             "": [ 0,3 ],
>             "": [ 4,7 ] ],
>         "mode": "channel",
>         "shaper": "dcb"
>     }
> }
>=20
> Will fix the "queues" to remove the empty name in v2.

Try:
  $ tc -j qdisc | pythom -m json.tools

The empty tags are non-standard practice can it be done better?

--Sig_/NZfmbu.tGUIC+EVrvAG/Qou
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEn2/DRbBb5+dmuDyPgKd/YJXN5H4FAl/CihwACgkQgKd/YJXN
5H4DPw/+LbSuqfynUHzSBwxmJX9wEGLfogg4D4/CAh8rJdGAVs+PLxm4vIzKKHCr
Nn054QpKqS1LctjsgFEAOmZRnhmfaf09yu8xg7fVLmWYKV63o/yo5pzVMx4WpbOo
qdLI9clqYW6iUQRlhhNJ4jgqpioaIEQ7LIWbqXb574jmx1wUWtk1SxvsotbB32n5
qiL45rMDKvAHdLRKI36DbPOTxxJUjA0P/hlgyzAO7qImKNR+0tI5jBniMgmP7Yn9
H7Xzvqsukr3pYwhPYlYYRxBddyu15gIT4FMGkzOdEi9y++12r0SC+Xq3dgRM+r//
XV6RfxHxWOdYbch/vVSR824oDw52u2PrkuZds9elgpbhWwn0DZL3SOiq5l/kh2rs
dc1dTtLl9xNIJIt6cX5rDAbmTBhfM1Rnk/XoA6gekvlIX+0LffZR08EFueN1YQ1z
P8G69AwbmSF1xYvKivoQYrdhFd3JmGVhzz6VGdZgCH3aCB3K7IFbE65sR9qVez/X
KL3/bc8E4DetVCNpnJJPuZT0EorTsg6/WKYCnLrdKo0a7ANdpzRwMItULDrHHeg2
noOcPNZnswzH4aiX70Ux8GYxdcuQN+89cy4UppIwk6hjploR/iHTr2loc7/aaDku
UBjEfydALvop1iZA6pUZEcM+S8V30Ki7/Ncqk2k0UU/7MU/FKHw=
=Sw9y
-----END PGP SIGNATURE-----

--Sig_/NZfmbu.tGUIC+EVrvAG/Qou--
