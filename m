Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00EDF2D6379
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 18:26:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404191AbgLJRRj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 12:17:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392761AbgLJRR1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Dec 2020 12:17:27 -0500
Received: from mail.katalix.com (mail.katalix.com [IPv6:2a05:d01c:827:b342:16d0:7237:f32a:8096])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 63EC7C0613CF
        for <netdev@vger.kernel.org>; Thu, 10 Dec 2020 09:16:47 -0800 (PST)
Received: from localhost (82-69-49-219.dsl.in-addr.zen.co.uk [82.69.49.219])
        (Authenticated sender: tom)
        by mail.katalix.com (Postfix) with ESMTPSA id ADE449A8EA;
        Thu, 10 Dec 2020 17:16:45 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=katalix.com; s=mail;
        t=1607620605; bh=5YlF3VYvg42GKosusPaGx3L8EJ6W4JT4LZRkZnHLEP0=;
        h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
         Content-Disposition:In-Reply-To:From;
        z=Date:=20Thu,=2010=20Dec=202020=2017:16:45=20+0000|From:=20Tom=20P
         arkin=20<tparkin@katalix.com>|To:=20Guillaume=20Nault=20<gnault@re
         dhat.com>|Cc:=20netdev@vger.kernel.org,=20jchapman@katalix.com|Sub
         ject:=20Re:=20[PATCH=20v4=20net-next=200/2]=20add=20ppp_generic=20
         ioctl(s)=20to=20bridge=0D=0A=20channels|Message-ID:=20<20201210171
         645.GB4413@katalix.com>|References:=20<20201210155058.14518-1-tpar
         kin@katalix.com>=0D=0A=20<20201210171309.GC15778@linux.home>|MIME-
         Version:=201.0|Content-Disposition:=20inline|In-Reply-To:=20<20201
         210171309.GC15778@linux.home>;
        b=pgrJ1Bfy3pSTqr3chd/JwGowmSgG4lobz/Z/X3j2DfPJAdTSMsDQiyF3A+QMXS2BY
         0oSyyLFf0mC5VIlA0XnGJEdQ1J1HW7v8rPJgmEcLpn5MhAv+Ce+uGHFfTjSHNCyTSC
         QV0QHHpf5AjGVSTbOWoCwzW35gn3gXK6afjlHBhiQUsmzgM2S4suY8PDLRMtmRc5w0
         v6oZk+rKfi+hIhqo3ArAXixr4hTJ4YgJBm9zPZBy51b7gyuT8mOQKv2XEw70RJ5RB9
         R+hkO4bczM4FBaeCogBsdLpyRZEXu8pmdFFhZ/vJgaqLcJqw0+oRcmyJ8daKP5XIjp
         eD76o2K1B6Sww==
Date:   Thu, 10 Dec 2020 17:16:45 +0000
From:   Tom Parkin <tparkin@katalix.com>
To:     Guillaume Nault <gnault@redhat.com>
Cc:     netdev@vger.kernel.org, jchapman@katalix.com
Subject: Re: [PATCH v4 net-next 0/2] add ppp_generic ioctl(s) to bridge
 channels
Message-ID: <20201210171645.GB4413@katalix.com>
References: <20201210155058.14518-1-tparkin@katalix.com>
 <20201210171309.GC15778@linux.home>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="QTprm0S8XgL7H0Dt"
Content-Disposition: inline
In-Reply-To: <20201210171309.GC15778@linux.home>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--QTprm0S8XgL7H0Dt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On  Thu, Dec 10, 2020 at 18:13:09 +0100, Guillaume Nault wrote:
> On Thu, Dec 10, 2020 at 03:50:56PM +0000, Tom Parkin wrote:
> > Following on from my previous RFC[1], this series adds two ioctl calls
> > to the ppp code to implement "channel bridging".
> >=20
> > When two ppp channels are bridged, frames presented to ppp_input() on
> > one channel are passed to the other channel's ->start_xmit function for
> > transmission.
> >=20
> > The primary use-case for this functionality is in an L2TP Access
> > Concentrator where PPP frames are typically presented in a PPPoE session
> > (e.g. from a home broadband user) and are forwarded to the ISP network =
in
> > a PPPoL2TP session.
>=20
> Looks good to me now. Thanks Tom!
>=20
> Reviewed-by: Guillaume Nault <gnault@redhat.com>
>=20

Thanks again for your review and help with the series :-)

--QTprm0S8XgL7H0Dt
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEsUkgyDzMwrj81nq0lIwGZQq6i9AFAl/SV/kACgkQlIwGZQq6
i9ClGAf8CnFnxUU21oTUnCj3rBcZaCwP3FNoh999Q4lQqVZDY7GiQWGwove4BHJj
wpEF0/DyTh78Pr158NW38SUwGW32WR90Z3jDsUd6dUFCueLUvWsix7zckiSChKcJ
qMo0h4DhCjRMLyNTvsJrd/jhltfzlAPgCKfD+pJ4Rhc+t8gBd8my0ClYjArenl9X
n212JLBL5WDx65lB3KzyWJQ7k352ZyHXlWxwdBpBqwlmNq0kHr7TNPShY3sOQbSx
h/HxWj/dTiluDExAxW1RWlB4Yg2MctIMRSuV4z8W9nPHROPr4JxuPqNt6KeoblXZ
o3fVTw29Hjmwd+xh8WEEz0Kst+Njxg==
=Qrza
-----END PGP SIGNATURE-----

--QTprm0S8XgL7H0Dt--
