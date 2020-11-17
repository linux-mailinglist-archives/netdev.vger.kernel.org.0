Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 718172B5F6B
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 13:54:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727204AbgKQMyY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 07:54:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725779AbgKQMyX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 07:54:23 -0500
Received: from mail.katalix.com (mail.katalix.com [IPv6:2a05:d01c:827:b342:16d0:7237:f32a:8096])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2679EC0613CF
        for <netdev@vger.kernel.org>; Tue, 17 Nov 2020 04:54:23 -0800 (PST)
Received: from localhost (82-69-49-219.dsl.in-addr.zen.co.uk [82.69.49.219])
        (Authenticated sender: tom)
        by mail.katalix.com (Postfix) with ESMTPSA id 8198696F3E;
        Tue, 17 Nov 2020 12:54:22 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=katalix.com; s=mail;
        t=1605617662; bh=HAbkPbtBzwiGVOtJxkw+KOM36RwzNN0dv4TQLKNaTPo=;
        h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
         Content-Disposition:In-Reply-To:From;
        z=Date:=20Tue,=2017=20Nov=202020=2012:54:22=20+0000|From:=20Tom=20P
         arkin=20<tparkin@katalix.com>|To:=20Jakub=20Kicinski=20<kuba@kerne
         l.org>|Cc:=20Guillaume=20Nault=20<gnault@redhat.com>,=20netdev@vge
         r.kernel.org,=0D=0A=09jchapman@katalix.com|Subject:=20Re:=20[RFC=2
         0PATCH=200/2]=20add=20ppp_generic=20ioctl=20to=20bridge=20channels
         |Message-ID:=20<20201117125422.GC4640@katalix.com>|References:=20<
         20201106181647.16358-1-tparkin@katalix.com>=0D=0A=20<2020110915523
         7.69c2b867@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>=0D=0A=20
         <20201110092834.GA30007@linux.home>=0D=0A=20<20201110084740.3e3418
         c0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>|MIME-Version:=20
         1.0|Content-Disposition:=20inline|In-Reply-To:=20<20201110084740.3
         e3418c0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>;
        b=yrkr9ORSvQLFFeimKsKJfUfAARJmULTDZ3HMTNrlGnRDcGLG70ONTjZEI7nWCFTpL
         9lj5UgkaUOoB4XcSiYdPBEmL66GM+o9Om9c8SOaCMpAEggAVnsdGB1b8rPO+bJnnZc
         LRZhsnLR8YvS3iHQrJrOZ2JWNAFsu7T1dsxo4mSQG+HrFLLz9GK3qFNLMG1VXWznQ7
         Cig1QPaAyZFZLd+aFyWT3UNCABzhUm+enT+N5hTL4KN/Ejd7geV+SZBONi5Xm9aaIr
         otMz5Ci/HWHXxx9FDvaQct8t5teOJDcQi8cHvvhVXz3pu5DvoM/JQwjVYhQhnDCZJd
         MO45lT9AcfqpQ==
Date:   Tue, 17 Nov 2020 12:54:22 +0000
From:   Tom Parkin <tparkin@katalix.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Guillaume Nault <gnault@redhat.com>, netdev@vger.kernel.org,
        jchapman@katalix.com
Subject: Re: [RFC PATCH 0/2] add ppp_generic ioctl to bridge channels
Message-ID: <20201117125422.GC4640@katalix.com>
References: <20201106181647.16358-1-tparkin@katalix.com>
 <20201109155237.69c2b867@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20201110092834.GA30007@linux.home>
 <20201110084740.3e3418c0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="2JFBq9zoW8cOFH7v"
Content-Disposition: inline
In-Reply-To: <20201110084740.3e3418c0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--2JFBq9zoW8cOFH7v
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On  Tue, Nov 10, 2020 at 08:47:40 -0800, Jakub Kicinski wrote:
> On Tue, 10 Nov 2020 10:28:34 +0100 Guillaume Nault wrote:
> > On Mon, Nov 09, 2020 at 03:52:37PM -0800, Jakub Kicinski wrote:
> > > On Fri,  6 Nov 2020 18:16:45 +0000 Tom Parkin wrote: =20
> > > > This small RFC series implements a suggestion from Guillaume Nault =
in
> > > > response to my previous submission to add an ac/pppoe driver to the=
 l2tp
> > > > subsystem[1].
> > > >=20
> > > > Following Guillaume's advice, this series adds an ioctl to the ppp =
code
> > > > to allow a ppp channel to be bridged to another.  Quoting Guillaume:
> > > >=20
> > > > "It's just a matter of extending struct channel (in ppp_generic.c) =
with
> > > > a pointer to another channel, then testing this pointer in ppp_inpu=
t().
> > > > If the pointer is NULL, use the classical path, if not, forward the=
 PPP
> > > > frame using the ->start_xmit function of the peer channel."
> > > >=20
> > > > This allows userspace to easily take PPP frames from e.g. a PPPoE
> > > > session, and forward them over a PPPoL2TP session; accomplishing the
> > > > same thing my earlier ac/pppoe driver in l2tp did but in much less =
code! =20
> > >=20
> > > I have little understanding of the ppp code, but I can't help but
> > > wonder why this special channel connection is needed? We have great
> > > many ways to redirect traffic between interfaces - bpf, tc, netfilter,
> > > is there anything ppp specific that is required here? =20
> >=20
> > I can see two viable ways to implement this feature. The one described
> > in this patch series is the simplest. The reason why it doesn't reuse
> > existing infrastructure is because it has to work at the link layer
> > (no netfilter) and also has to work on PPP channels (no network
> > device).
> >=20
> > The alternative, is to implement a virtual network device for the
> > protocols we want to support (at least PPPoE and L2TP, maybe PPTP)
> > and teach tunnel_key about them. Then we could use iproute2 commands
> > like:
> >  # ip link add name pppoe0 up type pppoe external
> >  # ip link add name l2tp0 up type l2tp external
> >  # tc qdisc add dev pppoe0 ingress
> >  # tc qdisc add dev l2tp0 ingress
> >  # tc filter add dev pppoe0 ingress matchall                        \
> >      action tunnel_key set l2tp_version 2 l2tp_tid XXX l2tp_sid YYY \
> >      action mirred egress redirect dev pppoe0
> >  # tc filter add dev l2tp0 ingress matchall  \
> >      action tunnel_key set pppoe_sid ZZZ     \
> >      action mirred egress redirect dev l2tp0
> >=20
> > Note: I've used matchall for simplicity, but a real uses case would
> > have to filter on the L2TP session and tunnel IDs and on the PPPoE
> > session ID.
> >=20
> > As I said in my reply to the original thread, I like this idea, but
> > haven't thought much about the details. So there might be some road
> > blocks. Beyond modernising PPP and making it better integrated into the
> > stack, that should also bring the possibility of hardware offload (but
> > would any NIC vendor be interested?).
>=20
> Integrating with the stack gives you access to all its features, other
> types of encap, firewalling, bpf, etc.
>=20
> > I think the question is more about long term maintainance. Do we want
> > to keep PPP related module self contained, with low maintainance code
> > (the current proposal)? Or are we willing to modernise the
> > infrastructure, add support and maintain PPP features in other modules
> > like flower, tunnel_key, etc.?
>=20
> Right, it's really not great to see new IOCTLs being added to drivers,
> but the alternative would require easily 50 times more code.

Jakub, could I quickly poll you on your current gut-feel level of
opposition to the ioctl-based approach?

Guillaume has given good feedback on the RFC code which I can work
into an actual patch submission, but I don't really want to if you're
totally opposed to the whole idea :-)

I appreciate you may want to reserve judgement pending a recap of the
ppp subsystem as it stands.

Thanks!

--2JFBq9zoW8cOFH7v
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEsUkgyDzMwrj81nq0lIwGZQq6i9AFAl+zx/kACgkQlIwGZQq6
i9BhTwgAt4BV0INCGp2c5ZrTRI5kTEAU5O6K9DdE2qp1QDMVbfvvBTbdo+LSqa0c
5a83Pr/ooOwbqM+FVpSnsxxLBW5DASpLEKxPF3/xHWkRoB4ubByp9QLInv5bmiKK
TV7IoTog9X1k2uVKrA4GSm63G/9kxmLyIUKojKoXw4Lu3xBLpFQLS283o5iB2eCX
TYxGdsO7k8GZYEMURb/Rskfr8ZGSjEHHRos7vDP49hoNmpI4u6AUZeyfbWE7F3mC
ie3D4RCYfp4Clv61ae4836taX8MdW29GML010sSIqLhsDRIBgcT6/a3p1KdhN+nS
HoMVc+UR8YguYnn2Mcuh4Z/kyUq6+A==
=dPbK
-----END PGP SIGNATURE-----

--2JFBq9zoW8cOFH7v--
