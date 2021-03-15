Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6899D33AF6B
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 10:59:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229746AbhCOJ6a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 05:58:30 -0400
Received: from mail.katalix.com ([3.9.82.81]:57432 "EHLO mail.katalix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229641AbhCOJ55 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Mar 2021 05:57:57 -0400
Received: from localhost (82-69-49-219.dsl.in-addr.zen.co.uk [82.69.49.219])
        (Authenticated sender: tom)
        by mail.katalix.com (Postfix) with ESMTPSA id 7151E84BC1;
        Mon, 15 Mar 2021 09:57:54 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=katalix.com; s=mail;
        t=1615802274; bh=6prkNLF1rViXA+rPOusIL/SndZVvMjHOFKsTC1o6CNc=;
        h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
         Content-Disposition:In-Reply-To:From;
        z=Date:=20Mon,=2015=20Mar=202021=2009:57:54=20+0000|From:=20Tom=20P
         arkin=20<tparkin@katalix.com>|To:=20lyl2019@mail.ustc.edu.cn|Cc:=2
         0paulus@samba.org,=20davem@davemloft.net,=20linux-ppp@vger.kernel.
         org,=0D=0A=09netdev@vger.kernel.org,=20linux-kernel@vger.kernel.or
         g|Subject:=20Re:=20Re:=20[BUG]=20net/ppp:=20A=20use=20after=20free
         =20in=20ppp_unregister_channe|Message-ID:=20<20210315095754.GA4219
         @katalix.com>|References:=20<6057386d.ca12.1782148389e.Coremail.ly
         l2019@mail.ustc.edu.cn>=0D=0A=20<20210312101258.GA4951@katalix.com
         >=0D=0A=20<2ad7aaa2.fcad.17826e87afb.Coremail.lyl2019@mail.ustc.ed
         u.cn>|MIME-Version:=201.0|Content-Disposition:=20inline|In-Reply-T
         o:=20<2ad7aaa2.fcad.17826e87afb.Coremail.lyl2019@mail.ustc.edu.cn>
         ;
        b=LZVszhSZuz219TGRSksc+xvfuk4sW1LNjCCtgqkdxTzwxXcvH1pSud4376qYD6HWL
         ujLq8PimRbhDvkwVCVLcl/IdA8cI85dFKY9pb2+uiQFFyakKxSfrOmSdcRrrubibgs
         euV2C6osMxmahsU8Gr9hMIwY/HrZZCO4YfrXrPzSunHPL9AfYCZWBqNmiOkmhCyWXK
         7ElDSNFR8cy8H3CnJEp/gfbY0dQzvwshgG9HPfIO3SZ4+FaMkB+XBgOUcRvLHEyg29
         83Em30YcTMXWw37TmMrisDwk1ni2hchYoGzL8MMwr3fL+0WkzEZot150tnnmuDZaLt
         yltaDkLTyImeA==
Date:   Mon, 15 Mar 2021 09:57:54 +0000
From:   Tom Parkin <tparkin@katalix.com>
To:     lyl2019@mail.ustc.edu.cn
Cc:     paulus@samba.org, davem@davemloft.net, linux-ppp@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Re: [BUG] net/ppp: A use after free in ppp_unregister_channe
Message-ID: <20210315095754.GA4219@katalix.com>
References: <6057386d.ca12.1782148389e.Coremail.lyl2019@mail.ustc.edu.cn>
 <20210312101258.GA4951@katalix.com>
 <2ad7aaa2.fcad.17826e87afb.Coremail.lyl2019@mail.ustc.edu.cn>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="/9DWx/yDrRhgMJTb"
Content-Disposition: inline
In-Reply-To: <2ad7aaa2.fcad.17826e87afb.Coremail.lyl2019@mail.ustc.edu.cn>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--/9DWx/yDrRhgMJTb
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On  Fri, Mar 12, 2021 at 22:47:53 +0800, lyl2019@mail.ustc.edu.cn wrote:
>=20
>=20
>=20
> > -----=E5=8E=9F=E5=A7=8B=E9=82=AE=E4=BB=B6-----
> > =E5=8F=91=E4=BB=B6=E4=BA=BA: "Tom Parkin" <tparkin@katalix.com>
> > =E5=8F=91=E9=80=81=E6=97=B6=E9=97=B4: 2021-03-12 18:12:58 (=E6=98=9F=E6=
=9C=9F=E4=BA=94)
> > =E6=94=B6=E4=BB=B6=E4=BA=BA: lyl2019@mail.ustc.edu.cn
> > =E6=8A=84=E9=80=81: paulus@samba.org, davem@davemloft.net, linux-ppp@vg=
er.kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
> > =E4=B8=BB=E9=A2=98: Re: [BUG] net/ppp: A use after free in ppp_unregist=
er_channe
> >=20
> > Thanks for the report!
> >=20
> > On  Thu, Mar 11, 2021 at 20:34:44 +0800, lyl2019@mail.ustc.edu.cn wrote:
> > > File: drivers/net/ppp/ppp_generic.c
> > >=20
> > > In ppp_unregister_channel, pch could be freed in ppp_unbridge_channel=
s()
> > > but after that pch is still in use. Inside the function ppp_unbridge_=
channels,
> > > if "pchbb =3D=3D pch" is true and then pch will be freed.
> >=20
> > Do you have a way to reproduce a use-after-free scenario?
> >=20
> > From static analysis I'm not sure how pch would be freed in
> > ppp_unbridge_channels when called via. ppp_unregister_channel.
> >=20
> > In theory (at least!) the caller of ppp_register_net_channel holds=20
> > a reference on struct channel which ppp_unregister_channel drops.
> >=20
> > Each channel in a bridged pair holds a reference on the other.
> >=20
> > Hence on return from ppp_unbridge_channels, the channel should not have
> > been freed (in this code path) because the ppp_register_net_channel
> > reference has not yet been dropped.
> >=20
> > Maybe there is an issue with the reference counting or a race of some
> > sort?
> >=20
> > > I checked the commit history and found that this problem is introduce=
d from
> > > 4cf476ced45d7 ("ppp: add PPPIOCBRIDGECHAN and PPPIOCUNBRIDGECHAN ioct=
ls").
> > >=20
> > > I have no idea about how to generate a suitable patch, sorry.
>=20
> This issue was reported by a path-sensitive static analyzer developed by =
our Lab,
> thus i have not a crash or bug log.

Does the analyzer report the sequence of events that lead to a
possible use-after-free?   Is it starting from the assumption that
ppp_unbridge_channels is called with pch->file.refcnt =3D=3D 1?

> As the return type of ppp_unbridge_channels() is a int, can we return a v=
alue to
> inform caller that the channel is freed?

If ppp_unbridge_channels frees the channel in the
ppp_unregister_channel call path, that implies that
ppp_unregister_channel is called when only the bridge is keeping the
channel alive.  So the caller is attempting to drop a reference it
doesn't in fact have.

It might be preferable to defensively code against that possibility of
course.

--/9DWx/yDrRhgMJTb
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEsUkgyDzMwrj81nq0lIwGZQq6i9AFAmBPL54ACgkQlIwGZQq6
i9AyuggAr4h5Rb/mILMnt6v4Gc3RZ9yannFHesdENxrWQxNjeEvMT7av2t77lqQJ
DR+DBxMluf+gcEmEIPHgwx0OeiNCY8CB9tE1HXLG/r8pVnjqJyL4GjQO8BdaSRPt
s0odEAJXhlxcwrBBVXYwkWdILbDIF6cZRyjc3lX1WNsNNSumhMl2XSZ8rxYz03Gi
DnDoM8ODo6zhKMMNSaAJv8p7WhFEUpdM3KcUJZbRmZaf8fodSeTok45L2lItSMp8
l2FSVWW8Laexx/wjX5HTru5SffQze6je3qJY5fG+BTMvpW97/PHou9Rn+HrAc7RM
Is5uP7fllO/TSXSiHxAb9MJKkGDiJw==
=GwFI
-----END PGP SIGNATURE-----

--/9DWx/yDrRhgMJTb--
