Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC772322804
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 10:50:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231570AbhBWJrH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 04:47:07 -0500
Received: from mail.katalix.com ([3.9.82.81]:41932 "EHLO mail.katalix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230296AbhBWJqw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Feb 2021 04:46:52 -0500
Received: from localhost (82-69-49-219.dsl.in-addr.zen.co.uk [82.69.49.219])
        (Authenticated sender: tom)
        by mail.katalix.com (Postfix) with ESMTPSA id A3CD97D7D7;
        Tue, 23 Feb 2021 09:46:07 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=katalix.com; s=mail;
        t=1614073567; bh=TezFUDJgIK4u1WG+Ge0RUN6bW2Sfe6mTLwCIAvJ1zD4=;
        h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
         Content-Disposition:In-Reply-To:From;
        z=Date:=20Tue,=2023=20Feb=202021=2009:46:06=20+0000|From:=20Tom=20P
         arkin=20<tparkin@katalix.com>|To:=20Matthias=20Schiffer=20<mschiff
         er@universe-factory.net>|Cc:=20netdev@vger.kernel.org,=20"David=20
         S.=20Miller"=20<davem@davemloft.net>,=0D=0A=09Jakub=20Kicinski=20<
         kuba@kernel.org>,=20linux-kernel@vger.kernel.org|Subject:=20Re:=20
         [PATCH=20net]=20net:=20l2tp:=20reduce=20log=20level=20when=20passi
         ng=20up=20invalid=0D=0A=20packets|Message-ID:=20<20210223094606.GA
         12377@katalix.com>|References:=20<f2a482212eed80b5ba22cb590e89d3ed
         b290a872.1613760125.git.mschiffer@universe-factory.net>=0D=0A=20<2
         0210219201201.GA4974@katalix.com>=0D=0A=20<2e75a78b-afa2-3776-2695
         -f9f6ac93eb67@universe-factory.net>=0D=0A=20<20210222114907.GA4943
         @katalix.com>=0D=0A=20<ec0f874e-b5af-1007-5a83-e3de7399ef29@univer
         se-factory.net>|MIME-Version:=201.0|Content-Disposition:=20inline|
         In-Reply-To:=20<ec0f874e-b5af-1007-5a83-e3de7399ef29@universe-fact
         ory.net>;
        b=UDiy1Js0Kk3P8l3JKYEUZrRHyi3cKXppywx0ZJ/finn0cNWtxtELm6L9JMjLr0JL9
         cfpSgap9pBlafzp/xUdmyZOhAMHYD382jZmCemOcg5U1FRW5bs+pB+ZMWfvDUcjlO7
         OPBMhq1yHHw9QOgxw/PnDevGUefJFkpYBu7O9reeiC2Y8h95+YDIpwM6q3fMRfq1Bq
         ZJS+ZnqXRzNAs6k5ZDqARoyhPyYoFzASpc+iXMzpokcOp262o6ex3Z9LfIBxv4HQ+y
         5X+bWZl7SVTTMB1RxfRzgPHfWmZ372cU0k35XMWY3UYavjafYNgpjS4Jtd2e7sryMU
         WVB6o3XVMXbRg==
Date:   Tue, 23 Feb 2021 09:46:06 +0000
From:   Tom Parkin <tparkin@katalix.com>
To:     Matthias Schiffer <mschiffer@universe-factory.net>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: l2tp: reduce log level when passing up invalid
 packets
Message-ID: <20210223094606.GA12377@katalix.com>
References: <f2a482212eed80b5ba22cb590e89d3edb290a872.1613760125.git.mschiffer@universe-factory.net>
 <20210219201201.GA4974@katalix.com>
 <2e75a78b-afa2-3776-2695-f9f6ac93eb67@universe-factory.net>
 <20210222114907.GA4943@katalix.com>
 <ec0f874e-b5af-1007-5a83-e3de7399ef29@universe-factory.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="EVF5PPMfhYS0aIcm"
Content-Disposition: inline
In-Reply-To: <ec0f874e-b5af-1007-5a83-e3de7399ef29@universe-factory.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--EVF5PPMfhYS0aIcm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On  Mon, Feb 22, 2021 at 17:40:16 +0100, Matthias Schiffer wrote:
> On 2/22/21 12:49 PM, Tom Parkin wrote:
> > On  Sat, Feb 20, 2021 at 10:56:33 +0100, Matthias Schiffer wrote:
> > > On 2/19/21 9:12 PM, Tom Parkin wrote:
> > > > On  Fri, Feb 19, 2021 at 20:06:15 +0100, Matthias Schiffer wrote:
> > > > > Before commit 5ee759cda51b ("l2tp: use standard API for warning l=
og
> > > > > messages"), it was possible for userspace applications to use the=
ir own
> > > > > control protocols on the backing sockets of an L2TP kernel device=
, and as
> > > > > long as a packet didn't look like a proper L2TP data packet, it w=
ould be
> > > > > passed up to userspace just fine.
> > > >=20
> > > > Hum.  I appreciate we're now logging where we previously were not, =
but
> > > > I would say these warning messages are valid.
> > > >=20
> > > > It's still perfectly possible to use the L2TP socket for the L2TP c=
ontrol
> > > > protocol: packets per the RFCs won't trigger these warnings to the
> > > > best of my knowledge, although I'm happy to be proven wrong!
> > > >=20
> > > > I wonder whether your application is sending non-L2TP packets over =
the
> > > > L2TP socket?  Could you describe the usecase?
> > >=20
> > > I'm the developer of the UDP-based VPN/tunnel application fastd [1]. =
This is
> > > currently a pure userspace implementation, supporting both encrypted =
and
> > > unencrypted tunnels, with a protocol that doesn't look anything like =
L2TP.
> > >=20
> > > To improve performance of unencrypted tunnels, I'm looking into using=
 L2TP
> > > to offload the data plane to the kernel. Whether to make use of this =
would
> > > be negotiated in a session handshake (that is also used for key excha=
nge in
> > > encrypted mode).
> > >=20
> > > As the (IPv4) internet is stupid and everything is NATted, and I even=
 want
> > > to support broken NAT routers that somehow break UDP hole punching, I=
 use
> > > only a single socket for both control (handshake) and data packets.
> >=20
> > Thanks for describing the usecase a bit more.  It looks an interesting
> > project.
> >=20
> > To be honest I'm not sure the L2TP subsystem is a good match for
> > fastd's datapath offload though.
> >=20
> > This is for the following reasons:
> >=20
> > Firstly, the warnings referenced in your patch are early in the L2TP re=
cv
> > path, called shortly after our hook into the UDP recv code.
> >=20
> > So at this point, I don't believe the L2TP subsystem is really buying y=
ou
> > anything over a plain UPD recv.
> >=20
> > Now, I'm perhaps reading too much into what you've said, but I imagine
> > that fastd using the L2TP tunnel context is just a first step.  I
> > assume the end goal for datapath offload would be to use the L2TP
> > pseudowire code in order to have session data appear from e.g. a
> > virtual Ethernet interface.  That way you get to avoid copying data
> > to userspace, and then stuffing it back into the kernel via. tun/tap.
> > And that makes sense to me as a goal!
>=20
> That is indeed what I want to achieve.
>=20
> >=20
> > However, if that is indeed the goal, I really can't see it working
> > without fastd's protocol being modified to look like L2TP.  (I also,
> > btw, can't see it working without some kind of kernel-space L2TP
> > subsystem support for fastd's various encryption protocols, but that's
> > another matter).
>=20
> Only unencrypted connections would be offloaded.
>=20
> fastd's data protocol will be modified to use L2TP Ethernet pseudowire as
> specified by the RFC (I actually finished the userspace implementation of
> this yesterday, in branch method-l2tp for now). Two peers can negotiate t=
he
> protocol to use (called "method" in fastd terms) in the session handshake=
=2E A
> session would only be offloaded to kernel-space L2TP when both sides agree
> that they indeed want to use the L2TP method; otherwise fastd will contin=
ue
> to use TUN/TAP.
>=20
> The only part of the fastd protocol that I can't modify arbitrarily is the
> first packet of the handshake, as it must be compatible with older versio=
ns
> of fastd. There may be a point when I can set the T flag in handshakes
> unconditionally, but that would be 3~5 years in the future.
>

I see.  So the session would end up using L2TP headers, which seems
like it should be fine.

>=20
> >=20
> > If you take a look at the session recv datapath from l2tp_recv_common
> > onwards you'll see that there is a lot of code you have to avoid
> > confusing in l2tp_core.c alone, even before you get into any
> > pseudowire-specifics.  I can't see that being possible with fastd's
> > current data packet format >
> > In summary, I think at this point in the L2TP recv path a normal UDP
> > socket would serve you just as well, and I can't see the L2TP subsystem
> > being useful as a data offload mechanism for fastd in the future
> > without effectively changing fastd's packet format to look like L2TP.
> >=20
> > Secondly, given the above (and apologies if I've missed the mark); I
> > really wouldn't want to encourage you to use the L2TP subsystem for
> > future fastd improvements.
> >=20
> >  From fastd's perspective it is IMO a bad idea, since it would be easy
> > for a future (perfectly valid) change in the L2TP code to accidentally
> > break fastd.  And next time it might not be some easily-tweaked thing
> > like logging levels, but rather e.g. a security fix or bug fix which
> > cannot be undone.
> >=20
> >  From the L2TP subsystem's perspective it is a bad idea, since by
> > encouraging fastd to use the L2TP code, we end up hampering future L2TP
> > development in order to support a project which doesn't actually use
> > the L2TP protocol at all.
>=20
> As explained above, this only concerns fastd's handshake format. As long =
as
> no new L2TP version accepts 0 as its "Version" field and such packets
> continue to passed to userspace even without the T flag, fastd would be
> fine.
>=20
>=20
> >=20
> > In the hope of being more constructive -- have you considered whether
> > tc and/or ebpf could be used for fastd?  As more generic mechanisms I
> > think you might get on better with these than trying to twist the L2TP
> > code's arm :-)
>=20
> (e)BPF might actually be an option. I will look into this.
>=20
>=20
> >=20
> > > > > After the mentioned change, this approach would lead to significa=
nt log
> > > > > spam, as the previously hidden warnings are now shown by default.=
 Not
> > > > > even setting the T flag on the custom control packets is sufficie=
nt to
> > > > > surpress these warnings, as packet length and L2TP version are ch=
ecked
> > > > > before the T flag.
> > > >=20
> > > > Possibly we could sidestep some of these warnings by moving the T f=
lag
> > > > check further up in the function.
> > > >=20
> > > > The code would need to pull the first byte of the header, check the=
 type
> > > > bit, and skip further processing if the bit was set.  Otherwise go =
on to
> > > > pull the rest of the header.
> > > >=20
> > > > I think I'd prefer this approach assuming the warnings are not
> > > > triggered by valid L2TP messages. >>
> > > This will not be sufficient for my usecase: To stay compatible with o=
lder
> > > versions of fastd, I can't set the T flag in the first packet of the
> > > handshake, as it won't be known whether the peer has a new enough fas=
td
> > > version to understand packets that have this bit set. Luckily, the se=
cond
> > > handshake byte is always 0 in fastd's protocol, so these packets fail=
 the
> > > tunnel version check and are passed to userspace regardless.
> > >=20
> > > I'm aware that this usecase is far outside of the original intentions=
 of the
> > > code and can only be described as a hack, but I still consider this a
> > > regression in the kernel, as it was working fine in the past, without
> > > visible warnings.
> > >=20
> >=20
> > I'm sorry, but for the reasons stated above I disagree about it being
> > a regression.
>=20
> Hmm, is it common for protocol implementations in the kernel to warn about
> invalid packets they receive? While L2TP uses connected sockets and thus
> usually no unrelated packets end up in the socket, a simple UDP port scan
> originating from the configured remote address/port will trigger the "sho=
rt
> packet" warning now (nmap uses a zero-length payload for UDP scans by
> default). Log spam caused by a malicous party might also be a concern.

It's not unheard of, but it's not especially common either.  You can
see other pr_warn_ratelimit in the recv path in net/, but not very
many.  I note that pr_debug_ratelimit is much rarer.

I appreciate the argument about log spam -- I'm not really wedded to
these log messages per se, but it seemed worthwhile exploring why you
were tripping over them.

If fastd's data packet headers end up being L2TP headers when using
the L2TP data path, I don't think there's too much of an issue to be
honest.

> >=20
> > >=20
> > > [1] https://github.com/NeoRaider/fastd/
> > >=20
> > >=20
> > > >=20
> > > > >=20
> > > > > Reduce all warnings debug level when packets are passed to usersp=
ace.
> > > > >=20
> > > > > Fixes: 5ee759cda51b ("l2tp: use standard API for warning log mess=
ages")
> > > > > Signed-off-by: Matthias Schiffer <mschiffer@universe-factory.net>
> > >=20
> > >=20
> > >=20
> > > > > ---
> > > > >=20
> > > > > I'm unsure what to do about the pr_warn_ratelimited() in
> > > > > l2tp_recv_common(). It feels wrong to me that an incoming network=
 packet
> > > > > can trigger a kernel message above debug level at all, so maybe t=
hey
> > > > > should be downgraded as well? I believe the only reason these wer=
e ever
> > > > > warnings is that they were not shown by default.
> > > > >=20
> > > > >=20
> > > > >    net/l2tp/l2tp_core.c | 12 ++++++------
> > > > >    1 file changed, 6 insertions(+), 6 deletions(-)
> > > > >=20
> > > > > diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
> > > > > index 7be5103ff2a8..40852488c62a 100644
> > > > > --- a/net/l2tp/l2tp_core.c
> > > > > +++ b/net/l2tp/l2tp_core.c
> > > > > @@ -809,8 +809,8 @@ static int l2tp_udp_recv_core(struct l2tp_tun=
nel *tunnel, struct sk_buff *skb)
> > > > >    	/* Short packet? */
> > > > >    	if (!pskb_may_pull(skb, L2TP_HDR_SIZE_MAX)) {
> > > > > -		pr_warn_ratelimited("%s: recv short packet (len=3D%d)\n",
> > > > > -				    tunnel->name, skb->len);
> > > > > +		pr_debug_ratelimited("%s: recv short packet (len=3D%d)\n",
> > > > > +				     tunnel->name, skb->len);
> > > > >    		goto error;
> > > > >    	}
> > > > > @@ -824,8 +824,8 @@ static int l2tp_udp_recv_core(struct l2tp_tun=
nel *tunnel, struct sk_buff *skb)
> > > > >    	/* Check protocol version */
> > > > >    	version =3D hdrflags & L2TP_HDR_VER_MASK;
> > > > >    	if (version !=3D tunnel->version) {
> > > > > -		pr_warn_ratelimited("%s: recv protocol version mismatch: got %=
d expected %d\n",
> > > > > -				    tunnel->name, version, tunnel->version);
> > > > > +		pr_debug_ratelimited("%s: recv protocol version mismatch: got =
%d expected %d\n",
> > > > > +				     tunnel->name, version, tunnel->version);
> > > > >    		goto error;
> > > > >    	}
> > > > > @@ -863,8 +863,8 @@ static int l2tp_udp_recv_core(struct l2tp_tun=
nel *tunnel, struct sk_buff *skb)
> > > > >    			l2tp_session_dec_refcount(session);
> > > > >    		/* Not found? Pass to userspace to deal with */
> > > > > -		pr_warn_ratelimited("%s: no session found (%u/%u). Passing up.=
\n",
> > > > > -				    tunnel->name, tunnel_id, session_id);
> > > > > +		pr_debug_ratelimited("%s: no session found (%u/%u). Passing up=
=2E\n",
> > > > > +				     tunnel->name, tunnel_id, session_id);
> > > > >    		goto error;
> > > > >    	}

--EVF5PPMfhYS0aIcm
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEsUkgyDzMwrj81nq0lIwGZQq6i9AFAmA0ztoACgkQlIwGZQq6
i9AiHQf/Sd3d58K3aO3T37hZBS3ChhPCaZGdtn1tdcwvrv1xucVAxtiUOyY2rlDB
d4OhkBzL0zxdl5kVufRo5r9NWMBToaAnqiG0eG31l255c8JGBrAr8swJHpht+mvl
AsvheAhdtay4n6jyxhV9QjIxWLctHZI7zAmEx5uSZqLAcCY4XI/6yJhLR57D4Ifp
UMwulvIBeCU6eY54+FpOVhu8UvebNd+/IMXJIZARcr6XebCpP17QWsggUCdIPCIZ
52WEWOJmvKJoEwK0JdPEg+SDx9O1YuVJnM0cWcrTAoRrAigPSgYvDqwi8hdU+Ww4
2FszoevkpkcFWbgGj3ESItkuzArYFw==
=O/cl
-----END PGP SIGNATURE-----

--EVF5PPMfhYS0aIcm--
