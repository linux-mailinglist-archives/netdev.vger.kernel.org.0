Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 689A227CA13
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 14:16:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732285AbgI2MQ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 08:16:29 -0400
Received: from mail.katalix.com ([3.9.82.81]:47252 "EHLO mail.katalix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732100AbgI2MQ2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Sep 2020 08:16:28 -0400
X-Greylist: delayed 84591 seconds by postgrey-1.27 at vger.kernel.org; Tue, 29 Sep 2020 08:16:27 EDT
Received: from localhost (82-69-49-219.dsl.in-addr.zen.co.uk [82.69.49.219])
        (Authenticated sender: tom)
        by mail.katalix.com (Postfix) with ESMTPSA id F099091603;
        Tue, 29 Sep 2020 13:16:25 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=katalix.com; s=mail;
        t=1601381786; bh=FdoiCpEDvvur0dbUNQ6PA36AD4fwZVfoD5dSGbAimZM=;
        h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
         Content-Disposition:In-Reply-To:From;
        z=Date:=20Tue,=2029=20Sep=202020=2013:16:25=20+0100|From:=20Tom=20P
         arkin=20<tparkin@katalix.com>|To:=20David=20Miller=20<davem@daveml
         oft.net>|Cc:=20netdev@vger.kernel.org,=20jchapman@katalix.com|Subj
         ect:=20Re:=20[PATCH=20net-next=201/1]=20l2tp:=20report=20rx=20cook
         ie=20discards=20in=20netlink=0D=0A=20get|Message-ID:=20<2020092912
         1625.GA4556@katalix.com>|References:=20<20200928124634.21461-1-tpa
         rkin@katalix.com>=0D=0A=20<20200928.184625.1187203928205342651.dav
         em@davemloft.net>|MIME-Version:=201.0|Content-Disposition:=20inlin
         e|In-Reply-To:=20<20200928.184625.1187203928205342651.davem@daveml
         oft.net>;
        b=IAUgayzOL6tFpy1l0SMrlumI6WrNW5Au+spBD+Slmqe/AYfX4TJpsnqM6N8JJ/ACi
         LCYXrVZlqZ59I8VNWNSYPMkW0982PFvoWCyDC/ONSaSAq4NKkpFpzC/tHo7ft+Lu3a
         0CwaTCO02bgP07XtjXIPiJc3CPdCS5fd6csxDuUX7Y3RgOGYXcJWkcY1vhoHqCsj8i
         VyDMA+uAIs5c6A74xqjS0IecHL3dmL5LFDooQrW+UQjhE98OKFL31TUpyxwIUeB3sC
         uX0JAuF8+/v02BTdwaQw7LP0t3GG5uOm++orBfSc8FZ8rvu4E0e4QriipbCLEeto5q
         tPUM83GZy4p+Q==
Date:   Tue, 29 Sep 2020 13:16:25 +0100
From:   Tom Parkin <tparkin@katalix.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, jchapman@katalix.com
Subject: Re: [PATCH net-next 1/1] l2tp: report rx cookie discards in netlink
 get
Message-ID: <20200929121625.GA4556@katalix.com>
References: <20200928124634.21461-1-tparkin@katalix.com>
 <20200928.184625.1187203928205342651.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="/9DWx/yDrRhgMJTb"
Content-Disposition: inline
In-Reply-To: <20200928.184625.1187203928205342651.davem@davemloft.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--/9DWx/yDrRhgMJTb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On  Mon, Sep 28, 2020 at 18:46:25 -0700, David Miller wrote:
> From: Tom Parkin <tparkin@katalix.com>
> Date: Mon, 28 Sep 2020 13:46:34 +0100
>=20
> > --- a/include/uapi/linux/l2tp.h
> > +++ b/include/uapi/linux/l2tp.h
> > @@ -143,6 +143,7 @@ enum {
> >  	L2TP_ATTR_RX_SEQ_DISCARDS,	/* u64 */
> >  	L2TP_ATTR_RX_OOS_PACKETS,	/* u64 */
> >  	L2TP_ATTR_RX_ERRORS,		/* u64 */
> > +	L2TP_ATTR_RX_COOKIE_DISCARDS,	/* u64 */
> >  	L2TP_ATTR_STATS_PAD,
> >  	__L2TP_ATTR_STATS_MAX,
> >  };
>=20
> You can't change the value of the L2TP_ATTR_STATS_PAD attribute.
>=20
> Instead you must add new values strictly right before the
> __L2TP_ATTR_STATS_MAX.

Of course, my mistake :-(

I'll respin accordingly, thanks.

--/9DWx/yDrRhgMJTb
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEsUkgyDzMwrj81nq0lIwGZQq6i9AFAl9zJZUACgkQlIwGZQq6
i9BLqAf9HNitkiDNNc+131BQtcrsZ544JC+C8JYtIQI/WiLu/U7qUL2cc+qiRjJi
/fTpbc8LJiGuQ0guAb62LPoafvVSpgGxGuVeG4nBbPMlDwp0UXA2j/sOk4YeOgpn
p4idvorHvJJ7Bg1i1pQLREjxhpFyl/x5U8RcQN7aK/pKLOM7wr/Zc0AyaOKdrZxR
5Ncx4P5FgSIpiU0wPTrYA+/4mTVp3Pg/MEzwSUNEiPYCUHZCQjgieiUpoIZzxXLl
nBszUp7Mwt9KzpRdWGFMwzu+Qveh7RuczLESszePjo2JPTLm25//0dXvedI0NafB
Ok7kPfx+WKmQX05+BrzHzvSOv1xV2Q==
=sGcv
-----END PGP SIGNATURE-----

--/9DWx/yDrRhgMJTb--
