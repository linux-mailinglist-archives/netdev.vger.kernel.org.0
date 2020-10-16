Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB29C2904C6
	for <lists+netdev@lfdr.de>; Fri, 16 Oct 2020 14:11:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407209AbgJPMLS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Oct 2020 08:11:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407182AbgJPMLR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Oct 2020 08:11:17 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59365C061755;
        Fri, 16 Oct 2020 05:11:17 -0700 (PDT)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1602850275;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=l6tn/UiS5TsBzWHjXOllBWC9DcShkaQo1JEZyj3tsVc=;
        b=u6ffnwrCYpE8m1oEhCQ0agemjWz4sVVlEFKwlubQlZmdTSgeVI4KanOs8yrjL7QOqIRX7Z
        9aI8ph+2mQ4lhXBdp/3dyLJjww+cGr/Go7FKz1Yau1jPbZSYHfJJdv+foeWpMkP0NCF8tV
        s/h9PrkC/Op5/dXP5VbbIiuhDxpuaa/N/HE1lmOHOgLZISEhY489v6E7LncQsOeC6KxMbz
        v9TOp3tMro5pVOQMKhIlakrCq/E+aqaJ8FklYPdIBiq0snPttH0qRNnlIi5gVUwSIMfeFh
        HyTDseO8foiAyt2NZn2kQmY5NR9bCA5FkaDk7vjoUzncu9x3/errGDNbHwljZg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1602850275;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=l6tn/UiS5TsBzWHjXOllBWC9DcShkaQo1JEZyj3tsVc=;
        b=7ds7ctUzMtxSjaN6hk8h2zJbQh/s0exc8BqSS8hesWLAGCw5HC+cPy/7tLjuZRWA6dnzN6
        qmJfUQY/c/FKxoDw==
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>,
        ilias.apalodimas@linaro.org
Subject: Re: [PATCH net-next v6 2/7] net: dsa: Add DSA driver for Hirschmann Hellcreek switches
In-Reply-To: <87r1q4f1hq.fsf@kurt>
References: <20201004112911.25085-1-kurt@linutronix.de> <20201004112911.25085-3-kurt@linutronix.de> <20201004125601.aceiu4hdhrawea5z@skbuf> <87lfgj997g.fsf@kurt> <20201006092017.znfuwvye25vsu4z7@skbuf> <878scj8xxr.fsf@kurt> <20201006113237.73rzvw34anilqh4d@skbuf> <87wo037ajr.fsf@kurt> <20201006135631.73rm3gka7r7krwca@skbuf> <87362lt08b.fsf@kurt> <20201011153055.gottyzqv4hv3qaxv@skbuf> <87r1q4f1hq.fsf@kurt>
Date:   Fri, 16 Oct 2020 14:11:06 +0200
Message-ID: <87sgaee5gl.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain

On Mon Oct 12 2020, Kurt Kanzenbach wrote:
> On Sun Oct 11 2020, Vladimir Oltean wrote:
>> On Sun, Oct 11, 2020 at 02:29:08PM +0200, Kurt Kanzenbach wrote:
>>> On Tue Oct 06 2020, Vladimir Oltean wrote:
>>> > It would be interesting to see if you could simply turn off VLAN
>>> > awareness in standalone mode, and still use unique pvids per port.
>>>
>>> That doesn't work, just tested. When VLAN awareness is disabled,
>>> everything is switched regardless of VLAN tags and table.
>>
>> That's strange, do you happen to know where things are going wrong?
>
> No I don't. I'll clarify with the hardware engineer.

When VLAN awareness is disabled, the packet is still classified with the
pvid. But, later all rules regarding VLANs (except for the PCP field)
are ignored then. So, the programmed pvid doesn't matter in this case.

The only way to implement the non-filtering bridge behavior is this
flag. However, this has some more implications. For instance when
there's a non filtering bridge, then standalone mode doesn't work
anymore due to the VLAN unawareness. This is not a problem at the
moment, because there are only two ports. But, later when there are more
ports, then having two ports in a non-filtering bridge and one in
standalone mode doesn't work. That's another limitation that needs to be
considered when adding more ports later on.

Besides that problem everything else seem to work now in accordance to
the expected Linux behavior with roper restrictions in place.

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEooWgvezyxHPhdEojeSpbgcuY8KYFAl+JjdoACgkQeSpbgcuY
8KawTRAApd17ogXfDyCUUBFpdZRzcN3ZT/aBd6wyHTIKK/fQ2rCK4jxGUW1ORBLN
98NmmpclKVZy6E1tYZXMtIcUwObg9bSCSLcePhdF+vJKAwyueBmG54HYtGaqpbas
hOQqgwUGNpCywwQaHKoU72gOU5H/R3NgUZu9124mcGbMkH8ZbRZ7vnCqUITTZ6Rg
2t5vYaXjQJ1vnX7epOmoWaMKUXPPct6IdLB2xqMA67+5b1PyVTBgeets1LmaP8sb
x3mcfuGa/l1o/ZiXoULZjMDXQ1TJDz5KkKB0USfPbEm3dC8W2V9yfNehYR8J5r8C
C8mETidBoGVd9LPfxDzwRQqyeNti1WzMa0nZRmZRdrRhECxGhnyajbdclitAb2J3
RqUIkFWW3vKp9PSo5Q0vbaRuxEX3vOG6VBTCURR6JJ+pYyKHFc2M+ZLenYpVFukX
TyFIFYIp6HZCydzcc2cslwdvXEFpMfWRP+UOtkR7S+Zx+ZLvYXDem5PBrpTSwKwJ
Ns56XQf0B1y0TWtU8j5iN3boUVoxcfcg8LbgKCpUMyN2tLoPiCZBqbTiGDe5I9GR
ZgLa6vCt4E/hPrUKVWiuSNM/QSC2hCa472a+46YaoIvnk0Mr5MHovI4BO2/lOdWk
MXnMAQws63TzyT/NfuPkbQ+oEFRqd5ADHQqswE4lR5Ycst90Gr8=
=LUio
-----END PGP SIGNATURE-----
--=-=-=--
