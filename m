Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9391D1F4DDB
	for <lists+netdev@lfdr.de>; Wed, 10 Jun 2020 08:07:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726105AbgFJGHv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jun 2020 02:07:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726072AbgFJGHu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jun 2020 02:07:50 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 954E8C05BD1E
        for <netdev@vger.kernel.org>; Tue,  9 Jun 2020 23:07:50 -0700 (PDT)
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1jitth-0008J3-Lj; Wed, 10 Jun 2020 08:07:37 +0200
Received: from ore by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <ore@pengutronix.de>)
        id 1jittX-0001xa-5S; Wed, 10 Jun 2020 08:07:27 +0200
Date:   Wed, 10 Jun 2020 08:07:27 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Dan Williams <dan.j.williams@intel.com>
Cc:     David Miller <davem@davemloft.net>, marex@denx.de,
        Andrew Lunn <andrew@lunn.ch>, mkubecek@suse.cz,
        f.fainelli@gmail.com, Jonathan Corbet <corbet@lwn.net>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Netdev <netdev@vger.kernel.org>, linville@tuxdriver.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        kuba@kernel.org, mkl@pengutronix.de, kernel@pengutronix.de,
        david@protonic.nl, amitc@mellanox.com, petrm@mellanox.com,
        christian.herber@nxp.com, hkallweit1@gmail.com
Subject: Re: [PATCH ethtool v1] netlink: add master/slave configuration
 support
Message-ID: <20200610060727.q4nzryh3mp6fj2ax@pengutronix.de>
References: <20200609101935.5716b3bd@hermes.lan>
 <20200609.113633.1866761141966326637.davem@davemloft.net>
 <4d664ff641dbf3aeab1ecd5eacda220dab9d7d17.camel@intel.com>
 <20200609.123858.466960203090925019.davem@davemloft.net>
 <CAPcyv4jr9F_0q4S-LSvHzJK7mamLW-m1Skgw7cXvkZYNtStyxA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="6rzrcepciphpb3j5"
Content-Disposition: inline
In-Reply-To: <CAPcyv4jr9F_0q4S-LSvHzJK7mamLW-m1Skgw7cXvkZYNtStyxA@mail.gmail.com>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 07:07:27 up 207 days, 20:26, 198 users,  load average: 0.05, 0.08,
 0.02
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--6rzrcepciphpb3j5
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 09, 2020 at 02:48:51PM -0700, Dan Williams wrote:
> On Tue, Jun 9, 2020 at 12:57 PM David Miller <davem@davemloft.net> wrote:
> >
> > From: "Williams, Dan J" <dan.j.williams@intel.com>
> > Date: Tue, 9 Jun 2020 19:30:50 +0000
> >
> > > On Tue, 2020-06-09 at 11:36 -0700, David Miller wrote:
> > >> From: Stephen Hemminger <stephen@networkplumber.org>
> > >> Date: Tue, 9 Jun 2020 10:19:35 -0700
> > >>
> > >> > Yes, words do matter and convey a lot of implied connotation and
> > >> > meaning.
> > >>
> > >> What is your long term plan?  Will you change all of the UAPI for
> > >> bonding for example?
> > >
> > > The long term plan in my view includes talking with standards bodies =
to
> > > move new content to, for example, master/subordinate. In other words,
> > > practical forward steps, not retroactively changing interfaces.
> >
> > When that knowledge is established legitimately in standards and
> > transferred into common knowledge of these technologies, yes then
> > please come present your proposals.
>=20
> Our hands are not completely tied by the specifications, as a
> community we have a non-zero level of influence over standards bodies,
> even direct participation in some. So we could do something stronger
> than passively wait for standards to catch up. For example, deprecate
> our consideration of future specifications that include this language
> and set a cut off date.
>=20
> I understand the confusion that arises from using terminology
> differently from the specification, but at the same time when
> specification language actively hurts kernel code maintainability we
> change it. For example, when I did the first iteration of what
> eventually became libnvdimm Ingo rightly reacted to the naming being
> too ACPI specification centric and wanting more kernel-centric naming.
>=20
> If the common kernel name for what was formerly called a "slave"
> device is a "subordinate" device then the confusion is lessened, only
> one common kernel translation to consider.
>=20
> > But right now using different words will create confusion.
> >
> > I also find master/subordinate an interesting proposal, what if master
> > is a triggering term?  Why only slave?
>=20
> "slave" has a direct connection to human suffering deployed at global sca=
le.
>=20
> One way I think about this is consider we have our first ever Linux
> Plumbers on the African continent, and you had a choice about giving a
> talk about how the git master branch operates, or a talk about slave
> devices which one would you feel more immediately comfortable leading?
> Any hesitation you would feel freely using the word slave with a
> predominantly black audience is a similar speed bump a contributor
> might feel needing to consume that term to get their job done.
>=20
> Explaining "no, not that connotation of slave" does not scale as much
> as transitioning to another term.
>=20
> > I know people feel something needs to change, but do that moving
> > forward for the technologies themselves.
>=20
> This is the start of a process that the kernel community can take an
> active role to lead, we have it within our control to not wait for the
> lowest common denominator to catch up.
>=20
> > Not how we implement support
> > for a technology which is established already.
> >
> > Plant the seed, don't chop the tree down.
>=20
> I appreciate the engagement.

It is interesting to see technical mind arguing about humanitarian
topics. Usually I need to translate IT to theologies, historic teachers
or linguists. So, let me try to do it other way around:

- a language is not a snapshot. The meaning of words is changing
  continually. For example, an ARM is buying Intel networking division and =
all
  i200 controller should be renamed to arm100..
  I'm not familiar with your local history, so i give some examples to
  German readers:
  - The word "F=C3=BChrer" was abused by some historical person and event.
  - The word "geil" is changed within one generation from sexual
    erection to a positive emotion reusable in almost every context.
  There is many language changes just within last century, please refer
  to DUDEN to learn more about it:
  https://www.duden.de/ueber_duden/auflagengeschichte
  Or for more generic examples:
  https://en.wikipedia.org/wiki/Language_change

- from your argumentation I would assume, you are trying to define a
  language. A language not historically misused, so it will be
  acceptable by every one. Or at least by the technical community.
  Suddenly, I should disappoint you. The number of programming
  languages defined by technical community is is still growing and none of =
it
  makes happy every one. How do you thing the reality looks for spoken lang=
uage?
  Welcome to my reality:
  https://en.wikipedia.org/wiki/Universal_language
  In case the historical argumentations are too boring, let me give you
  a modern, less boring example:
  https://youtu.be/7C-aB09i30E

- Are there any other attempts to change historical and linguistic
  reality by removing and replacing something? Sure:
  https://en.wikipedia.org/wiki/Book_burning


Regards,
Oleksij
--=20
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

--6rzrcepciphpb3j5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEERBNZvwSgvmcMY/T74omh9DUaUbMFAl7geJoACgkQ4omh9DUa
UbPUVxAAtAFesYvW2blzrOec4ViiN4687g25pl4c/1E8dFBcBnGc1S7CkcxaRdLS
dmna8qVGz8AHV0iI5xcxs9BgCvDQ0GLpHZXLVXdRNEaqzqjxeN3R71pRHAyGfLzQ
5j+wa1GrA+aQcfCX0g8owjUkMipX+tv63KoMxMpvzKJCQvKlgwBxwnV2HIij7YIw
HjYxfvrSzqLIPzHyJbv6ij6BXl2sfzORU5XqtGPHm0klwPOwntHAWxe8bCzkO3Xe
o2ZH6fSFMWdFi7EppxOwGkjZclN68gklT2prGRUoSarvolgShoyl+BNsvw8+ef6v
X+IoomBvz84xUtuigpS0BsG1dUGLF7PjAyJyPLxeW4MX1dngu9OKbOOnHE2Ek1sN
EbWHMAFRsHgZlHYyBsI+iN0fqXvcznbuMdGUD1SkZwXF67LQvVImJ5dxoaLgjzew
ihc1leTPojTd0+bXwZIInitD3SFqz1aalnTPry9nZSOAIo9KwQuA8pEYPCsVaPHw
4NDr40N9euw/eDnrSnSBGH5/PkEVne7TV9C051t8IAd+UPxmBRNjeXsGpYE3obpF
bbZzO5ogDqDE/GzHtoudUXe6s4U/BqumMtpqgO3XNV2XhQcxoabZwcalpL2nuz/H
P4TEuVfCUH5DR3GSePnwuBFJyekn3nSMB9K58zljq9ORWb759BI=
=aGp7
-----END PGP SIGNATURE-----

--6rzrcepciphpb3j5--
