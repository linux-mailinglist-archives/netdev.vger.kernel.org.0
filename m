Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21E992C744F
	for <lists+netdev@lfdr.de>; Sat, 28 Nov 2020 23:19:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388662AbgK1Vtm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Nov 2020 16:49:42 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:44512 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728306AbgK1SAl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Nov 2020 13:00:41 -0500
Received: by mail-wr1-f68.google.com with SMTP id 64so9106646wra.11
        for <netdev@vger.kernel.org>; Sat, 28 Nov 2020 10:00:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version;
        bh=yfXf9YNJgWfclql82Mbk7CqOdd6zu31QKqLeQVNQfh8=;
        b=V7B+J/zj8PQk09oIaeacEoOVzXd3/+S8Y/XUqkzo0HMvhD+6htTtaErSJ3Z+rnVswl
         hO6SN8oxsFdpHAldzz+pFEjSgRQYJsin3y0g9sdiGbZdV9Gi5g6iAX657oS9z9zfzawA
         IM+uQQPkF/VpIGRvOwJDUojsmxLUU3ICjuRDTDI7RU5Hey61hrdQOHihYRljFWJPtOO2
         dQHRhdujuQqTTOPhRRTZeMLjsB2B7b6JwkxOtfhY92YFK+SbOypiiMOcbm/ytxkh64t1
         J3laIp4gxEwAUeVk03KpMsylEZWM0fE86Ihwcx058wmfd4qQRdlkYWnfSUh58nKegjya
         +b2A==
X-Gm-Message-State: AOAM530h787UzkcOJVs0kYRHR9owWAAywXr5/itw4OXFrAM3yHBdba4g
        FBIlzDrOhCjkF01n140tdHWAcNMrkWN+YA==
X-Google-Smtp-Source: ABdhPJyZNrMMtLXyfS84EU8b7N9m48DmbCU+f17XpGm6Itjg4Dh38j2Xo6An/oti7aatSoZrrTfhPw==
X-Received: by 2002:adf:e788:: with SMTP id n8mr18841456wrm.84.1606586398656;
        Sat, 28 Nov 2020 09:59:58 -0800 (PST)
Received: from localhost ([2a01:4b00:f419:6f00:e2db:6a88:4676:d01b])
        by smtp.gmail.com with ESMTPSA id w10sm20926801wra.34.2020.11.28.09.59.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Nov 2020 09:59:57 -0800 (PST)
Message-ID: <9fbd551fd077af9cfced7d6b75b79019caa9547f.camel@debian.org>
Subject: Re: [RFC iproute2] tc/mqprio: json-ify output
From:   Luca Boccassi <bluca@debian.org>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org
Date:   Sat, 28 Nov 2020 17:59:56 +0000
In-Reply-To: <20201128093420.3d9f6aea@hermes.local>
References: <20201127152625.61874-1-bluca@debian.org>
         <20201127212151.4984075c@hermes.local>
         <66c38398895dd591ded53e0d1bf34a13f3e83a32.camel@debian.org>
         <20201128093420.3d9f6aea@hermes.local>
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-B/ypMrw3iTFSiyvgLi1Q"
User-Agent: Evolution 3.38.1-2 
MIME-Version: 1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--=-B/ypMrw3iTFSiyvgLi1Q
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2020-11-28 at 09:34 -0800, Stephen Hemminger wrote:
> On Sat, 28 Nov 2020 12:17:00 +0000
> Luca Boccassi <bluca@debian.org> wrote:
>=20
> > On Fri, 2020-11-27 at 21:21 -0800, Stephen Hemminger wrote:
> > > On Fri, 27 Nov 2020 15:26:25 +0000
> > > Luca Boccassi <bluca@debian.org> wrote:
> > > =C2=A0=20
> > > > As reported by a Debian user, mqprio output in json mode is
> > > > invalid:
> > > >=20
> > > > {
> > > > =C2=A0=C2=A0=C2=A0=C2=A0 "kind": "mqprio",
> > > > =C2=A0=C2=A0=C2=A0=C2=A0 "handle": "8021:",
> > > > =C2=A0=C2=A0=C2=A0=C2=A0 "dev": "enp1s0f0",
> > > > =C2=A0=C2=A0=C2=A0=C2=A0 "root": true,
> > > > =C2=A0=C2=A0=C2=A0=C2=A0 "options": { tc 2 map 0 0 0 1 0 1 0 0 0 0 =
0 0 0 0 0 0
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 queues:(0:3)=
 (4:7)
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 mode:channel
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 shaper:dcb}
> > > > }
> > > >=20
> > > > json-ify it, while trying to maintain the same formatting
> > > > for standard output.
> > > >=20
> > > > https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D972784
> > > >=20
> > > > Signed-off-by: Luca Boccassi <bluca@debian.org>=C2=A0=20
> > >=20
> > > Did you try feeding that into the python parser?
> > > What is before/after?=C2=A0=20
> >=20
> > Uh, which python parser?
> >=20
> > The reporter tested the patch, there's a small error. Before is
> > above,
> > after is:
> >=20
> > {
> > =C2=A0=C2=A0=C2=A0 "kind": "mqprio",
> > =C2=A0=C2=A0=C2=A0 "handle": "8001:",
> > =C2=A0=C2=A0=C2=A0 "root": true,
> > =C2=A0=C2=A0=C2=A0 "options": {
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 "tc": 2,
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 "map": [ 0,0,0,1,0,1,0,0,0,0=
,0,0,0,0,0,0 ],
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 "queues": [
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 "": =
[ 0,3 ],
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 "": =
[ 4,7 ] ],
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 "mode": "channel",
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 "shaper": "dcb"
> > =C2=A0=C2=A0=C2=A0 }
> > }
> >=20
> > Will fix the "queues" to remove the empty name in v2.
>=20
> Try:
> =C2=A0 $ tc -j qdisc | pythom -m json.tools
>=20
> The empty tags are non-standard practice can it be done better?

Yes, v2 that I sent earlier fixed the empty tags. Python's json.tools
is happy.

The test of v2 from the reporter gave this output:

https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D972784#27

[{"kind":"mqprio","handle":"8001:","root":true,"options":{"tc":2,"map":[0,0=
,0,1,0,1,0,0,0,0,0,0,0,0,0,0],"queues":[[0,3],[4,7]],"mode":"channel","shap=
er":"dcb"}},{"kind":"pfifo_fast","handle":"0:","parent":"8001:8","options":=
{"bands":3,"priomap ":[1,2,2,2,1,2,0,0,1,1,1,1,1,1,1,1],"multiqueue":false}=
},{"kind":"pfifo_fast","handle":"0:","parent":"8001:7","options":{"bands":3=
,"priomap ":[1,2,2,2,1,2,0,0,1,1,1,1,1,1,1,1],"multiqueue":false}},{"kind":=
"pfifo_fast","handle":"0:","parent":"8001:6","options":{"bands":3,"priomap =
":[1,2,2,2,1,2,0,0,1,1,1,1,1,1,1,1],"multiqueue":false}},{"kind":"pfifo_fas=
t","handle":"0:","parent":"8001:5","options":{"bands":3,"priomap ":[1,2,2,2=
,1,2,0,0,1,1,1,1,1,1,1,1],"multiqueue":false}},{"kind":"pfifo_fast","handle=
":"0:","parent":"8001:4","options":{"bands":3,"priomap ":[1,2,2,2,1,2,0,0,1=
,1,1,1,1,1,1,1],"multiqueue":false}},{"kind":"pfifo_fast","handle":"0:","pa=
rent":"8001:3","options":{"bands":3,"priomap ":[1,2,2,2,1,2,0,0,1,1,1,1,1,1=
,1,1],"multiqueue":false}},{"kind":"pfifo_fast","handle":"0:","parent":"800=
1:2","options":{"bands":3,"priomap ":[1,2,2,2,1,2,0,0,1,1,1,1,1,1,1,1],"mul=
tiqueue":false}},{"kind":"pfifo_fast","handle":"0:","parent":"8001:1","opti=
ons":{"bands":3,"priomap ":[1,2,2,2,1,2,0,0,1,1,1,1,1,1,1,1],"multiqueue":f=
alse}}]

Which when fed to python3 -m json.utils gives:

[
    {
        "kind": "mqprio",
        "handle": "8001:",
        "root": true,
        "options": {
            "tc": 2,
            "map": [
                0,
                0,
                0,
                1,
                0,
                1,
                0,
                0,
                0,
                0,
                0,
                0,
                0,
                0,
                0,
                0
            ],
            "queues": [
                [
                    0,
                    3
                ],
                [
                    4,
                    7
                ]
            ],
            "mode": "channel",
            "shaper": "dcb"
        }
    },
    {
        "kind": "pfifo_fast",
        "handle": "0:",
        "parent": "8001:8",
        "options": {
            "bands": 3,
            "priomap ": [
                1,
                2,
                2,
                2,
                1,
                2,
                0,
                0,
                1,
                1,
                1,
                1,
                1,
                1,
                1,
                1
            ],
            "multiqueue": false
        }
    },
    {
        "kind": "pfifo_fast",
        "handle": "0:",
        "parent": "8001:7",
        "options": {
            "bands": 3,
            "priomap ": [
                1,
                2,
                2,
                2,
                1,
                2,
                0,
                0,
                1,
                1,
                1,
                1,
                1,
                1,
                1,
                1
            ],
            "multiqueue": false
        }
    },
    {
        "kind": "pfifo_fast",
        "handle": "0:",
        "parent": "8001:6",
        "options": {
            "bands": 3,
            "priomap ": [
                1,
                2,
                2,
                2,
                1,
                2,
                0,
                0,
                1,
                1,
                1,
                1,
                1,
                1,
                1,
                1
            ],
            "multiqueue": false
        }
    },
    {
        "kind": "pfifo_fast",
        "handle": "0:",
        "parent": "8001:5",
        "options": {
            "bands": 3,
            "priomap ": [
                1,
                2,
                2,
                2,
                1,
                2,
                0,
                0,
                1,
                1,
                1,
                1,
                1,
                1,
                1,
                1
            ],
            "multiqueue": false
        }
    },
    {
        "kind": "pfifo_fast",
        "handle": "0:",
        "parent": "8001:4",
        "options": {
            "bands": 3,
            "priomap ": [
                1,
                2,
                2,
                2,
                1,
                2,
                0,
                0,
                1,
                1,
                1,
                1,
                1,
                1,
                1,
                1
            ],
            "multiqueue": false
        }
    },
    {
        "kind": "pfifo_fast",
        "handle": "0:",
        "parent": "8001:3",
        "options": {
            "bands": 3,
            "priomap ": [
                1,
                2,
                2,
                2,
                1,
                2,
                0,
                0,
                1,
                1,
                1,
                1,
                1,
                1,
                1,
                1
            ],
            "multiqueue": false
        }
    },
    {
        "kind": "pfifo_fast",
        "handle": "0:",
        "parent": "8001:2",
        "options": {
            "bands": 3,
            "priomap ": [
                1,
                2,
                2,
                2,
                1,
                2,
                0,
                0,
                1,
                1,
                1,
                1,
                1,
                1,
                1,
                1
            ],
            "multiqueue": false
        }
    },
    {
        "kind": "pfifo_fast",
        "handle": "0:",
        "parent": "8001:1",
        "options": {
            "bands": 3,
            "priomap ": [
                1,
                2,
                2,
                2,
                1,
                2,
                0,
                0,
                1,
                1,
                1,
                1,
                1,
                1,
                1,
                1
            ],
            "multiqueue": false
        }
    }
]

--=20
Kind regards,
Luca Boccassi

--=-B/ypMrw3iTFSiyvgLi1Q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEE6g0RLAGYhL9yp9G8SylmgFB4UWIFAl/CkBwACgkQSylmgFB4
UWLR+Af/ZhZKVCJVDz95XdTQhfcN3dOYTSI/FYAfk8DzU/zFvl980ANcmboWUbYB
jwImk9hJtz3L+A/x/Pwj1xa38H8FH1ZjKuvXD/AmaxfnsynGAjls2lzHeUIvsCg9
zRDZmc2WD75wSOF+bAuTSzhTfp0GQ7UWqOBzrqFf/fFoRKuY095KXhWAXsApB1P+
y2Bz8WxKiFApmjIMvQXVC7ljv5MIAmPxCTKli/jXqSU+rg1cEqWapaYJ5yF6TLYg
KysVupnIEqr1Jz3OLREinzyWOnXHIaf3nAEbnpgqOYU63XmvDVnwVJYDY2rKhVUl
w5ilr/izL7JT1651c4J3YrQ/s6fftQ==
=EP9+
-----END PGP SIGNATURE-----

--=-B/ypMrw3iTFSiyvgLi1Q--
