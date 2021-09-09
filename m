Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBD00404790
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 11:10:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232511AbhIIJLQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 05:11:16 -0400
Received: from mail.katalix.com ([3.9.82.81]:36716 "EHLO mail.katalix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232344AbhIIJLP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Sep 2021 05:11:15 -0400
Received: from localhost (82-69-49-219.dsl.in-addr.zen.co.uk [82.69.49.219])
        (Authenticated sender: tom)
        by mail.katalix.com (Postfix) with ESMTPSA id 5360D8CBD2;
        Thu,  9 Sep 2021 10:10:05 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=katalix.com; s=mail;
        t=1631178605; bh=S5cUewsLIelagEyliEJ6UyVWnsjw94B9J1KlcsX+IMU=;
        h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
         Content-Disposition:In-Reply-To:From;
        z=Date:=20Thu,=209=20Sep=202021=2010:10:05=20+0100|From:=20Tom=20Pa
         rkin=20<tparkin@katalix.com>|To:=20Xiyu=20Yang=20<xiyuyang19@fudan
         .edu.cn>|Cc:=20"David=20S.=20Miller"=20<davem@davemloft.net>,=0D=0
         A=09Jakub=20Kicinski=20<kuba@kernel.org>,=0D=0A=09Cong=20Wang=20<c
         ong.wang@bytedance.com>,=0D=0A=09Randy=20Dunlap=20<rdunlap@infrade
         ad.org>,=0D=0A=09Xin=20Xiong=20<xiongx18@fudan.edu.cn>,=0D=0A=09"G
         ong,=20Sishuai"=20<sishuai@purdue.edu>,=0D=0A=09Matthias=20Schiffe
         r=20<mschiffer@universe-factory.net>,=0D=0A=09Bhaskar=20Chowdhury=
         20<unixbhaskar@gmail.com>,=20netdev@vger.kernel.org,=0D=0A=09linux
         -kernel@vger.kernel.org,=20yuanxzhang@fudan.edu.cn,=0D=0A=09Xin=20
         Tan=20<tanxin.ctf@gmail.com>|Subject:=20Re:=20[PATCH]=20net/l2tp:=
         20Fix=20reference=20count=20leak=20in=20l2tp_udp_recv_core|Message
         -ID:=20<20210909091005.GB7098@katalix.com>|References:=20<16311619
         30-77772-1-git-send-email-xiyuyang19@fudan.edu.cn>=0D=0A=20<202109
         09090156.GA7098@katalix.com>|MIME-Version:=201.0|Content-Dispositi
         on:=20inline|In-Reply-To:=20<20210909090156.GA7098@katalix.com>;
        b=LRYzfGSoRf6fB/e/lQHYCa23SUGzOBde3/9YnbI0WQMXywqDRj7mU7pb4xkgt0WfF
         JpMp1S9iKNTgkXVufRC6XYCJ1e86Dc/6dchHFhfiYMBWc7Tcl+0vLPYp3B1Mx5WXbl
         ppteHY5V4E/b2o1IRSbkCVbrNeFfqmvRBfMcSs6wYBMDxC7lR3CcGx4V/Wh7dJmEiT
         qLVFLTYEJKCX2L1aZPV/YzroKquveEFg6aqddsxVOzHpwASFCFxFw55ARThiWAc/wJ
         k+rU7BWc9IF58++/K3S/xJZRlqXskeoMkgr3hZ7zsrOjOAP0cOTEruNbIq11rcApxs
         EtUlMqNHLAzDg==
Date:   Thu, 9 Sep 2021 10:10:05 +0100
From:   Tom Parkin <tparkin@katalix.com>
To:     Xiyu Yang <xiyuyang19@fudan.edu.cn>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Cong Wang <cong.wang@bytedance.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Xin Xiong <xiongx18@fudan.edu.cn>,
        "Gong, Sishuai" <sishuai@purdue.edu>,
        Matthias Schiffer <mschiffer@universe-factory.net>,
        Bhaskar Chowdhury <unixbhaskar@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        yuanxzhang@fudan.edu.cn, Xin Tan <tanxin.ctf@gmail.com>
Subject: Re: [PATCH] net/l2tp: Fix reference count leak in l2tp_udp_recv_core
Message-ID: <20210909091005.GB7098@katalix.com>
References: <1631161930-77772-1-git-send-email-xiyuyang19@fudan.edu.cn>
 <20210909090156.GA7098@katalix.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="pvezYHf7grwyp3Bc"
Content-Disposition: inline
In-Reply-To: <20210909090156.GA7098@katalix.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--pvezYHf7grwyp3Bc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On  Thu, Sep 09, 2021 at 10:01:56 +0100, Tom Parkin wrote:
> On  Thu, Sep 09, 2021 at 12:32:00 +0800, Xiyu Yang wrote:
> > The reference count leak issue may take place in an error handling
> > path. If both conditions of tunnel->version =3D=3D L2TP_HDR_VER_3 and t=
he
> > return value of l2tp_v3_ensure_opt_in_linear is nonzero, the function
> > would directly jump to label invalid, without decrementing the reference
> > count of the l2tp_session object session increased earlier by
> > l2tp_tunnel_get_session(). This may result in refcount leaks.
>=20
> I agree with your analysis.  Thanks for catching this!
>=20

Also: I forgot to mention I think this fixes:

4522a70db7aa ("l2tp: fix reading optional fields of L2TPv3")

> >=20
> > Fix this issue by decrease the reference count before jumping to the
> > label invalid.
> >=20
> > Signed-off-by: Xiyu Yang <xiyuyang19@fudan.edu.cn>
> > Signed-off-by: Xin Xiong <xiongx18@fudan.edu.cn>
> > Signed-off-by: Xin Tan <tanxin.ctf@gmail.com>
> > ---
> >  net/l2tp/l2tp_core.c | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> >=20
> > diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
> > index 53486b162f01..93271a2632b8 100644
> > --- a/net/l2tp/l2tp_core.c
> > +++ b/net/l2tp/l2tp_core.c
> > @@ -869,8 +869,10 @@ static int l2tp_udp_recv_core(struct l2tp_tunnel *=
tunnel, struct sk_buff *skb)
> >  	}
> > =20
> >  	if (tunnel->version =3D=3D L2TP_HDR_VER_3 &&
> > -	    l2tp_v3_ensure_opt_in_linear(session, skb, &ptr, &optr))
> > +	    l2tp_v3_ensure_opt_in_linear(session, skb, &ptr, &optr)) {
> > +		l2tp_session_dec_refcount(session);
> >  		goto invalid;
> > +	}
>=20
> The error paths in l2tp_udp_recv_core are a bit convoluted because of
> the check (!session || !session->recv_skb) which may or may not need
> to drop a session reference if triggered.
>=20
> I think it could be simplified since session->recv_skb is always set
> for all the current session types in the tree, but doing that is probably
> a little patch series on its own.
>=20
> > =20
> >  	l2tp_recv_common(session, skb, ptr, optr, hdrflags, length);
> >  	l2tp_session_dec_refcount(session);
> > --=20
> > 2.7.4
> >=20
>=20
> --=20
> Tom Parkin
> Katalix Systems Ltd
> https://katalix.com
> Catalysts for your Embedded Linux software development



--=20
Tom Parkin
Katalix Systems Ltd
https://katalix.com
Catalysts for your Embedded Linux software development

--pvezYHf7grwyp3Bc
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEsUkgyDzMwrj81nq0lIwGZQq6i9AFAmE5z2wACgkQlIwGZQq6
i9C4qQf/SOQ8IC/syT/vn7h1nvj8jVbE+ktHfMD5hsv2z3pumYBVIi+DnUfbwX+l
l8/Hp9YSk2KjVdXuYBgRqgcJ0vD9wVIfoafXrr7pjAGkEiVx6SVVJbefobi18Pry
Uyl18XFkc0j8I5DGfwdWWuKdy7Jx6eyVupvFfKOw79mqe5zmz2FnUmckcNdYnNSN
IkzTEnuCvXrUQIVV+JiHRy4ef/psO50L1Lgb+cPeuZImpjuzFFwTYxN4Og2jsvKe
Fg+7sRjxDajqSbVQQ680GhQYwp49d/5reVob1+Ssk4xcAG0QFNaATyUmjEj1iu5c
vPBSzTLYbZEnxk1wnyjs2jEwHBm4mw==
=aUD2
-----END PGP SIGNATURE-----

--pvezYHf7grwyp3Bc--
