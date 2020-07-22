Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71573229473
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 11:06:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731267AbgGVJGU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 05:06:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726317AbgGVJGU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 05:06:20 -0400
Received: from mail.katalix.com (mail.katalix.com [IPv6:2a05:d01c:827:b342:16d0:7237:f32a:8096])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BECA5C0619DC
        for <netdev@vger.kernel.org>; Wed, 22 Jul 2020 02:06:19 -0700 (PDT)
Received: from localhost (82-69-49-219.dsl.in-addr.zen.co.uk [82.69.49.219])
        (Authenticated sender: tom)
        by mail.katalix.com (Postfix) with ESMTPSA id AF4E093AD5;
        Wed, 22 Jul 2020 10:06:18 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=katalix.com; s=mail;
        t=1595408778; bh=POpaLjnreB3BCzHaRLueXqwSdQ0nMNEgippwx5fsM4g=;
        h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
         Content-Disposition:In-Reply-To:From;
        z=Date:=20Wed,=2022=20Jul=202020=2010:06:18=20+0100|From:=20Tom=20P
         arkin=20<tparkin@katalix.com>|To:=20Jakub=20Kicinski=20<kuba@kerne
         l.org>|Cc:=20netdev@vger.kernel.org|Subject:=20Re:=20[PATCH=2005/2
         9]=20l2tp:=20cleanup=20difficult-to-read=20line=20breaks|Message-I
         D:=20<20200722090617.GA4419@katalix.com>|References:=20<2020072117
         3221.4681-1-tparkin@katalix.com>=0D=0A=20<20200721173221.4681-6-tp
         arkin@katalix.com>=0D=0A=20<20200721135938.46203a0a@kicinski-fedor
         a-pc1c0hjn.dhcp.thefacebook.com>|MIME-Version:=201.0|Content-Dispo
         sition:=20inline|In-Reply-To:=20<20200721135938.46203a0a@kicinski-
         fedora-pc1c0hjn.dhcp.thefacebook.com>;
        b=LhHUXM55UvFOB9B/hIyOQUCkTJaePxN9xSmrI91mpA5QFz/1OZlGGDTLeDY4AX3yy
         OeY0tn5kskc7fze4aGx8VrjI8Y6BH8a5KuZ4Dokk5MPXDsGz2XyUCLZmXaqt88ZQGh
         DlN24vjSEID+j/AQheCcLG0+5J2ReiNJf/sW1OvKIuEl999oHMuT16PDW5V0JHy+1n
         zpZAxuEVsmlmHc6y18emDmrYZm7oaTbk6mDL8ipQuGbFotA05ycjtWoR5h4Z7p6f6L
         dgCqAYYNOsbAlN2gy06vw4YhpoyoQScd+hwOrDS47WfRlQn3bl4zyJTXedYfpTJIJH
         geX1ljOCMyLww==
Date:   Wed, 22 Jul 2020 10:06:18 +0100
From:   Tom Parkin <tparkin@katalix.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH 05/29] l2tp: cleanup difficult-to-read line breaks
Message-ID: <20200722090617.GA4419@katalix.com>
References: <20200721173221.4681-1-tparkin@katalix.com>
 <20200721173221.4681-6-tparkin@katalix.com>
 <20200721135938.46203a0a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="wRRV7LY7NUeQGEoC"
Content-Disposition: inline
In-Reply-To: <20200721135938.46203a0a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--wRRV7LY7NUeQGEoC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On  Tue, Jul 21, 2020 at 13:59:38 -0700, Jakub Kicinski wrote:
> On Tue, 21 Jul 2020 18:31:57 +0100 Tom Parkin wrote:
> >  #if IS_ENABLED(CONFIG_IPV6)
> > -		if (info->attrs[L2TP_ATTR_IP6_SADDR] &&
> > -		    info->attrs[L2TP_ATTR_IP6_DADDR]) {
> > -			cfg.local_ip6 =3D nla_data(
> > -				info->attrs[L2TP_ATTR_IP6_SADDR]);
> > -			cfg.peer_ip6 =3D nla_data(
> > -				info->attrs[L2TP_ATTR_IP6_DADDR]);
> > -		} else
> > +		if (attrs[L2TP_ATTR_IP6_SADDR] && attrs[L2TP_ATTR_IP6_DADDR]) {
> > +			cfg.local_ip6 =3D nla_data(attrs[L2TP_ATTR_IP6_SADDR]);
> > +			cfg.peer_ip6 =3D nla_data(attrs[L2TP_ATTR_IP6_DADDR]);
> > +		} else {
> >  #endif
>=20
> This no longer builds. Probably because you added the closing backet
> which wasn't there?
>=20
> Please make sure each patch in the submission builds cleanly.

Sorry, this is a rebase snafu; my mistake.  I test-built the complete
patch series of course, but I'll test build each in turn for v2.

> Please split this submission into series of at most 15 patches at a
> time, to make sure reviewers don't get overloaded.

Will do.

> Please CC people who are working on the l2tp code (get_maintainers
> script is your friend).

Ack, thanks.

--wRRV7LY7NUeQGEoC
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEsUkgyDzMwrj81nq0lIwGZQq6i9AFAl8YAYUACgkQlIwGZQq6
i9BD6wf+I+A6ioJ7cb9NthPEwbMQpUTTabTREJOCQ0P26Lw+j2M9cMg+/oRSwc7w
L7qlrplMxeElzHjKBj5BoHKNzt8fjDGY50RZbrRGSIjGnhE2/K3T84zCNsA1omEX
Hd0hvv7kKw40KKcsIWMEzAYb4rVaEl2wLYGAt2KFff1DL4zkQ+wN46YOXTY5CAMz
TtViLWa1HYEGdxM/70T2fWyDEDjSDr/5SZG+jWR/Qc4jnuaxqVuCPyDxt3cKave3
kETPkqRMXAP20nCUzGxnSn1JqyXbRd2lzNfvwrnOBdlQY+tOTvRW1SRSdcDyg3rC
OUjfxqUpWBd+Hd6NctFKY0ZN0OIgcw==
=b8Cj
-----END PGP SIGNATURE-----

--wRRV7LY7NUeQGEoC--
