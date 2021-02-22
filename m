Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86AF032156A
	for <lists+netdev@lfdr.de>; Mon, 22 Feb 2021 12:51:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230100AbhBVLuB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Feb 2021 06:50:01 -0500
Received: from mail.katalix.com ([3.9.82.81]:60554 "EHLO mail.katalix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230017AbhBVLtx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Feb 2021 06:49:53 -0500
Received: from localhost (82-69-49-219.dsl.in-addr.zen.co.uk [82.69.49.219])
        (Authenticated sender: tom)
        by mail.katalix.com (Postfix) with ESMTPSA id 81A2183631;
        Mon, 22 Feb 2021 11:49:07 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=katalix.com; s=mail;
        t=1613994547; bh=kusqFNayNSHJvroi0b93UBMHrJH+jM61SbSq8kbDq64=;
        h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
         Content-Disposition:In-Reply-To:From;
        z=Date:=20Mon,=2022=20Feb=202021=2011:49:07=20+0000|From:=20Tom=20P
         arkin=20<tparkin@katalix.com>|To:=20Matthias=20Schiffer=20<mschiff
         er@universe-factory.net>|Cc:=20netdev@vger.kernel.org,=20"David=20
         S.=20Miller"=20<davem@davemloft.net>,=0D=0A=09Jakub=20Kicinski=20<
         kuba@kernel.org>,=20linux-kernel@vger.kernel.org|Subject:=20Re:=20
         [PATCH=20net]=20net:=20l2tp:=20reduce=20log=20level=20when=20passi
         ng=20up=20invalid=0D=0A=20packets|Message-ID:=20<20210222114907.GA
         4943@katalix.com>|References:=20<f2a482212eed80b5ba22cb590e89d3edb
         290a872.1613760125.git.mschiffer@universe-factory.net>=0D=0A=20<20
         210219201201.GA4974@katalix.com>=0D=0A=20<2e75a78b-afa2-3776-2695-
         f9f6ac93eb67@universe-factory.net>|MIME-Version:=201.0|Content-Dis
         position:=20inline|In-Reply-To:=20<2e75a78b-afa2-3776-2695-f9f6ac9
         3eb67@universe-factory.net>;
        b=EsYLNTxAeriH4vcB/aUVEd/sBBiJiJpM+ctZWkcMMohMkHtTyumVKps3ULhawU33v
         9rrek620RQ3QYxR1/NTTeyWsdUmVLPcKBsJo18n4Ril0cfubLkJOnM1wsGfOmU+AX0
         VXIejOL/bxay4seC+DmWGWSotfeNW/XX2ot9y3D+F5jjoHc40IEXZbZo2yYSg0NDx5
         qLLnCztEKYm001w8bedU7ktiUFYx8RDpVuXzuNCl0e5Nr/Ks6s/dUbb8BSO+KD2ljd
         uuwCnBCaVArta0es6BqmeCMmT/szpjFUgkb1yn7So6amHo/LKjKBfV4O34AS75X8H8
         gRMt9JwoNz4TA==
Date:   Mon, 22 Feb 2021 11:49:07 +0000
From:   Tom Parkin <tparkin@katalix.com>
To:     Matthias Schiffer <mschiffer@universe-factory.net>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: l2tp: reduce log level when passing up invalid
 packets
Message-ID: <20210222114907.GA4943@katalix.com>
References: <f2a482212eed80b5ba22cb590e89d3edb290a872.1613760125.git.mschiffer@universe-factory.net>
 <20210219201201.GA4974@katalix.com>
 <2e75a78b-afa2-3776-2695-f9f6ac93eb67@universe-factory.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="W/nzBZO5zC0uMSeA"
Content-Disposition: inline
In-Reply-To: <2e75a78b-afa2-3776-2695-f9f6ac93eb67@universe-factory.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--W/nzBZO5zC0uMSeA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On  Sat, Feb 20, 2021 at 10:56:33 +0100, Matthias Schiffer wrote:
> On 2/19/21 9:12 PM, Tom Parkin wrote:
> > On  Fri, Feb 19, 2021 at 20:06:15 +0100, Matthias Schiffer wrote:
> > > Before commit 5ee759cda51b ("l2tp: use standard API for warning log
> > > messages"), it was possible for userspace applications to use their o=
wn
> > > control protocols on the backing sockets of an L2TP kernel device, an=
d as
> > > long as a packet didn't look like a proper L2TP data packet, it would=
 be
> > > passed up to userspace just fine.
> >=20
> > Hum.  I appreciate we're now logging where we previously were not, but
> > I would say these warning messages are valid.
> >=20
> > It's still perfectly possible to use the L2TP socket for the L2TP contr=
ol
> > protocol: packets per the RFCs won't trigger these warnings to the
> > best of my knowledge, although I'm happy to be proven wrong!
> >=20
> > I wonder whether your application is sending non-L2TP packets over the
> > L2TP socket?  Could you describe the usecase?
>=20
> I'm the developer of the UDP-based VPN/tunnel application fastd [1]. This=
 is
> currently a pure userspace implementation, supporting both encrypted and
> unencrypted tunnels, with a protocol that doesn't look anything like L2TP.
>=20
> To improve performance of unencrypted tunnels, I'm looking into using L2TP
> to offload the data plane to the kernel. Whether to make use of this would
> be negotiated in a session handshake (that is also used for key exchange =
in
> encrypted mode).
>=20
> As the (IPv4) internet is stupid and everything is NATted, and I even want
> to support broken NAT routers that somehow break UDP hole punching, I use
> only a single socket for both control (handshake) and data packets.

Thanks for describing the usecase a bit more.  It looks an interesting
project.

To be honest I'm not sure the L2TP subsystem is a good match for
fastd's datapath offload though.

This is for the following reasons:

Firstly, the warnings referenced in your patch are early in the L2TP recv
path, called shortly after our hook into the UDP recv code.

So at this point, I don't believe the L2TP subsystem is really buying you
anything over a plain UPD recv.

Now, I'm perhaps reading too much into what you've said, but I imagine
that fastd using the L2TP tunnel context is just a first step.  I
assume the end goal for datapath offload would be to use the L2TP
pseudowire code in order to have session data appear from e.g. a
virtual Ethernet interface.  That way you get to avoid copying data
to userspace, and then stuffing it back into the kernel via. tun/tap.
And that makes sense to me as a goal!

However, if that is indeed the goal, I really can't see it working
without fastd's protocol being modified to look like L2TP.  (I also,
btw, can't see it working without some kind of kernel-space L2TP
subsystem support for fastd's various encryption protocols, but that's
another matter).

If you take a look at the session recv datapath from l2tp_recv_common
onwards you'll see that there is a lot of code you have to avoid
confusing in l2tp_core.c alone, even before you get into any
pseudowire-specifics.  I can't see that being possible with fastd's
current data packet format.

In summary, I think at this point in the L2TP recv path a normal UDP
socket would serve you just as well, and I can't see the L2TP subsystem
being useful as a data offload mechanism for fastd in the future
without effectively changing fastd's packet format to look like L2TP.

Secondly, given the above (and apologies if I've missed the mark); I
really wouldn't want to encourage you to use the L2TP subsystem for
future fastd improvements.

=46rom fastd's perspective it is IMO a bad idea, since it would be easy
for a future (perfectly valid) change in the L2TP code to accidentally
break fastd.  And next time it might not be some easily-tweaked thing
like logging levels, but rather e.g. a security fix or bug fix which
cannot be undone.

=46rom the L2TP subsystem's perspective it is a bad idea, since by
encouraging fastd to use the L2TP code, we end up hampering future L2TP
development in order to support a project which doesn't actually use
the L2TP protocol at all.

In the hope of being more constructive -- have you considered whether
tc and/or ebpf could be used for fastd?  As more generic mechanisms I
think you might get on better with these than trying to twist the L2TP
code's arm :-)

> > > After the mentioned change, this approach would lead to significant l=
og
> > > spam, as the previously hidden warnings are now shown by default. Not
> > > even setting the T flag on the custom control packets is sufficient to
> > > surpress these warnings, as packet length and L2TP version are checked
> > > before the T flag.
> >=20
> > Possibly we could sidestep some of these warnings by moving the T flag
> > check further up in the function.
> >=20
> > The code would need to pull the first byte of the header, check the type
> > bit, and skip further processing if the bit was set.  Otherwise go on to
> > pull the rest of the header.
> >=20
> > I think I'd prefer this approach assuming the warnings are not
> > triggered by valid L2TP messages.
>=20
> This will not be sufficient for my usecase: To stay compatible with older
> versions of fastd, I can't set the T flag in the first packet of the
> handshake, as it won't be known whether the peer has a new enough fastd
> version to understand packets that have this bit set. Luckily, the second
> handshake byte is always 0 in fastd's protocol, so these packets fail the
> tunnel version check and are passed to userspace regardless.
>=20
> I'm aware that this usecase is far outside of the original intentions of =
the
> code and can only be described as a hack, but I still consider this a
> regression in the kernel, as it was working fine in the past, without
> visible warnings.
>=20

I'm sorry, but for the reasons stated above I disagree about it being
a regression.

>=20
> [1] https://github.com/NeoRaider/fastd/
>=20
>=20
> >=20
> > >=20
> > > Reduce all warnings debug level when packets are passed to userspace.
> > >=20
> > > Fixes: 5ee759cda51b ("l2tp: use standard API for warning log messages=
")
> > > Signed-off-by: Matthias Schiffer <mschiffer@universe-factory.net>
>=20
>=20
>=20
> > > ---
> > >=20
> > > I'm unsure what to do about the pr_warn_ratelimited() in
> > > l2tp_recv_common(). It feels wrong to me that an incoming network pac=
ket
> > > can trigger a kernel message above debug level at all, so maybe they
> > > should be downgraded as well? I believe the only reason these were ev=
er
> > > warnings is that they were not shown by default.
> > >=20
> > >=20
> > >   net/l2tp/l2tp_core.c | 12 ++++++------
> > >   1 file changed, 6 insertions(+), 6 deletions(-)
> > >=20
> > > diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
> > > index 7be5103ff2a8..40852488c62a 100644
> > > --- a/net/l2tp/l2tp_core.c
> > > +++ b/net/l2tp/l2tp_core.c
> > > @@ -809,8 +809,8 @@ static int l2tp_udp_recv_core(struct l2tp_tunnel =
*tunnel, struct sk_buff *skb)
> > >   	/* Short packet? */
> > >   	if (!pskb_may_pull(skb, L2TP_HDR_SIZE_MAX)) {
> > > -		pr_warn_ratelimited("%s: recv short packet (len=3D%d)\n",
> > > -				    tunnel->name, skb->len);
> > > +		pr_debug_ratelimited("%s: recv short packet (len=3D%d)\n",
> > > +				     tunnel->name, skb->len);
> > >   		goto error;
> > >   	}
> > > @@ -824,8 +824,8 @@ static int l2tp_udp_recv_core(struct l2tp_tunnel =
*tunnel, struct sk_buff *skb)
> > >   	/* Check protocol version */
> > >   	version =3D hdrflags & L2TP_HDR_VER_MASK;
> > >   	if (version !=3D tunnel->version) {
> > > -		pr_warn_ratelimited("%s: recv protocol version mismatch: got %d ex=
pected %d\n",
> > > -				    tunnel->name, version, tunnel->version);
> > > +		pr_debug_ratelimited("%s: recv protocol version mismatch: got %d e=
xpected %d\n",
> > > +				     tunnel->name, version, tunnel->version);
> > >   		goto error;
> > >   	}
> > > @@ -863,8 +863,8 @@ static int l2tp_udp_recv_core(struct l2tp_tunnel =
*tunnel, struct sk_buff *skb)
> > >   			l2tp_session_dec_refcount(session);
> > >   		/* Not found? Pass to userspace to deal with */
> > > -		pr_warn_ratelimited("%s: no session found (%u/%u). Passing up.\n",
> > > -				    tunnel->name, tunnel_id, session_id);
> > > +		pr_debug_ratelimited("%s: no session found (%u/%u). Passing up.\n",
> > > +				     tunnel->name, tunnel_id, session_id);
> > >   		goto error;
> > >   	}

--W/nzBZO5zC0uMSeA
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEsUkgyDzMwrj81nq0lIwGZQq6i9AFAmAzmi8ACgkQlIwGZQq6
i9AOyQf9Eg7vvaRSGNpasGloltzWibk81104zQC8vG9lqL8HDf2GmFAN0uzPv9Qj
ASAmdjI0Qz5Z2Rde6KcMovE3BfmsHMVYFveVMmL2QaDWmrzNPfticrl7XwfAnu7E
nUza3r0Wn/Hjk1u+q9taYHGt7ufvWnLqZFiRLpCTPOD9HBMRrhRBuXBGfMIvI7q+
LbvmMyH7pB3jgwLdH5kjVkn/MDASTuPNrSmaCzxr83WLpR2Hef5227dj7kZCy2WK
pdco8kevK4K9zy2XWtAa+XLtocDppBhhrNPb3onUZRvsZJEOZxC9iacBKB6YFBP0
VXuMKU472LPkoLjMkYziRyZ2km9aPQ==
=XIco
-----END PGP SIGNATURE-----

--W/nzBZO5zC0uMSeA--
