Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32D012C73A6
	for <lists+netdev@lfdr.de>; Sat, 28 Nov 2020 23:14:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732132AbgK1Vt4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Nov 2020 16:49:56 -0500
Received: from mail-lf1-f68.google.com ([209.85.167.68]:40238 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387503AbgK1TVQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Nov 2020 14:21:16 -0500
Received: by mail-lf1-f68.google.com with SMTP id u19so12151889lfr.7
        for <netdev@vger.kernel.org>; Sat, 28 Nov 2020 11:20:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version;
        bh=Osz08ogBvWqpuVushMqAsEENhQDHGWCk1XF352bnKXk=;
        b=VnVW/rCY+LSk0lWFngG73Qv/tjQIgixIG/cFm9D2YvfQMbI1j45Ek2Id3eRQhgtVzw
         XKLz92caRMK4/FY6MlFHTqGH58qpirahMkuFpEElZA4QxPA/to+HMWQiJPG4i9ZbN5Go
         tKSsop/rG6S1i4APIPAjEJDN5uz4hNV1be1XodausJzWu2lq2HXq34B0o9PazdGsshZ4
         ohoEvvw8BWnXue+TwTZVRHw1NoHkjNAAEd06ZxjjJefMYUhauHjggUXkepvwtB4OEqp+
         sv5i9kv9oODu4092e1iGBsBFJ/fXxzgVRUT3SuvVG+ywSH/O0wqUeHunK9tt7ywo4wJJ
         +EIg==
X-Gm-Message-State: AOAM5326nTuQ8c0FXQDAF6yK1DKIQ6qTQk0y/xqwX8ukCFFmLBKzxQHD
        8SjT2PgN/qk1kqBHAzRCZkoZWzAXKlNFUA==
X-Google-Smtp-Source: ABdhPJxOMHFTD+l2qA03aSUyYJAWrSPBtAvP3rWa/Ewf2Csl35lwLLGL7niuB77P7e12JN94zk5+YQ==
X-Received: by 2002:a5d:634d:: with SMTP id b13mr17674062wrw.310.1606565829911;
        Sat, 28 Nov 2020 04:17:09 -0800 (PST)
Received: from localhost ([2a01:4b00:f419:6f00:e2db:6a88:4676:d01b])
        by smtp.gmail.com with ESMTPSA id r13sm14071616wrm.25.2020.11.28.04.17.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Nov 2020 04:17:08 -0800 (PST)
Message-ID: <66c38398895dd591ded53e0d1bf34a13f3e83a32.camel@debian.org>
Subject: Re: [RFC iproute2] tc/mqprio: json-ify output
From:   Luca Boccassi <bluca@debian.org>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org
Date:   Sat, 28 Nov 2020 12:17:00 +0000
In-Reply-To: <20201127212151.4984075c@hermes.local>
References: <20201127152625.61874-1-bluca@debian.org>
         <20201127212151.4984075c@hermes.local>
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-kPVNDjUZOjO7lOeqnR+w"
User-Agent: Evolution 3.38.1-2 
MIME-Version: 1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--=-kPVNDjUZOjO7lOeqnR+w
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2020-11-27 at 21:21 -0800, Stephen Hemminger wrote:
> On Fri, 27 Nov 2020 15:26:25 +0000
> Luca Boccassi <bluca@debian.org> wrote:
>=20
> > As reported by a Debian user, mqprio output in json mode is
> > invalid:
> >=20
> > {
> > =C2=A0=C2=A0=C2=A0=C2=A0 "kind": "mqprio",
> > =C2=A0=C2=A0=C2=A0=C2=A0 "handle": "8021:",
> > =C2=A0=C2=A0=C2=A0=C2=A0 "dev": "enp1s0f0",
> > =C2=A0=C2=A0=C2=A0=C2=A0 "root": true,
> > =C2=A0=C2=A0=C2=A0=C2=A0 "options": { tc 2 map 0 0 0 1 0 1 0 0 0 0 0 0 =
0 0 0 0
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 queues:(0:3) (4:=
7)
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 mode:channel
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 shaper:dcb}
> > }
> >=20
> > json-ify it, while trying to maintain the same formatting
> > for standard output.
> >=20
> > https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D972784
> >=20
> > Signed-off-by: Luca Boccassi <bluca@debian.org>
>=20
> Did you try feeding that into the python parser?
> What is before/after?

Uh, which python parser?

The reporter tested the patch, there's a small error. Before is above,
after is:

{
    "kind": "mqprio",
    "handle": "8001:",
    "root": true,
    "options": {
        "tc": 2,
        "map": [ 0,0,0,1,0,1,0,0,0,0,0,0,0,0,0,0 ],
        "queues": [
            "": [ 0,3 ],
            "": [ 4,7 ] ],
        "mode": "channel",
        "shaper": "dcb"
    }
}

Will fix the "queues" to remove the empty name in v2.

--=20
Kind regards,
Luca Boccassi

--=-kPVNDjUZOjO7lOeqnR+w
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEE6g0RLAGYhL9yp9G8SylmgFB4UWIFAl/CP7wACgkQSylmgFB4
UWK7KQf+PbWasc2nmftLss69YapzyzSSR2uHstXfzHFAP6CdKRethQoDnHY3+92f
k1Tigadrxd77CnOIL6zYeiQsTgvvsge4x7P0aba4dYoTQhsRaeYhDDPpx/gUWeBY
qtPNq6g/imhA/AMR8fkAKUteNgWe+ibHWC1SE0EbXxW9fimgqstF3N9yb6ac2Pm/
c1r3GlbjqljPTqcnI0C63FUyx/iXscqx7JuggYJQVRA71oipXF8a84MwdJNI/mnN
NTCmy0pD3zx2vgspM+ZGy5BMjCEOi+TW3mtzCJcYHdczqgzBxnjN8SNYnhXkCrsG
FUDZPedXKXjbzgdq/wTaMUQtO+3Bfg==
=SUSN
-----END PGP SIGNATURE-----

--=-kPVNDjUZOjO7lOeqnR+w--
