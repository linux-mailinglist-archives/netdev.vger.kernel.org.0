Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 667EB295B16
	for <lists+netdev@lfdr.de>; Thu, 22 Oct 2020 10:58:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2508789AbgJVI6d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Oct 2020 04:58:33 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:57852 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2442698AbgJVI6c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Oct 2020 04:58:32 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 476341C0B78; Thu, 22 Oct 2020 10:58:29 +0200 (CEST)
Date:   Thu, 22 Oct 2020 10:58:28 +0200
From:   Pavel Machek <pavel@ucw.cz>
To:     Pavel Pisa <pisa@cmp.felk.cvut.cz>
Cc:     linux-can@vger.kernel.org, devicetree@vger.kernel.org,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Wolfgang Grandegger <wg@grandegger.com>,
        David Miller <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>, mark.rutland@arm.com,
        Carsten Emde <c.emde@osadl.org>, armbru@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marin Jerabek <martin.jerabek01@gmail.com>,
        Ondrej Ille <ondrej.ille@gmail.com>,
        Jiri Novak <jnovak@fel.cvut.cz>,
        Jaroslav Beran <jara.beran@gmail.com>,
        Petr Porazil <porazil@pikron.com>,
        Drew Fustini <pdp7pdp7@gmail.com>,
        Rob Herring <robh@kernel.org>
Subject: Re: [PATCH v6 2/6] dt-bindings: net: can: binding for CTU CAN FD
 open-source IP core.
Message-ID: <20201022085828.GA23695@amd>
References: <cover.1603354744.git.pisa@cmp.felk.cvut.cz>
 <8c2c52067354e9ccb76d7923a0e8b7765902e4a1.1603354744.git.pisa@cmp.felk.cvut.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="azLHFNyN32YCQGCU"
Content-Disposition: inline
In-Reply-To: <8c2c52067354e9ccb76d7923a0e8b7765902e4a1.1603354744.git.pisa@cmp.felk.cvut.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--azLHFNyN32YCQGCU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu 2020-10-22 10:36:17, Pavel Pisa wrote:
> The device-tree bindings for open-source/open-hardware CAN FD IP core
> designed at the Czech Technical University in Prague.
>=20
> CTU CAN FD IP core and other CTU CAN bus related projects
> listing and documentation page
>=20
>    http://canbus.pages.fel.cvut.cz/
>=20
> Signed-off-by: Pavel Pisa <pisa@cmp.felk.cvut.cz>
> Reviewed-by: Rob Herring <robh@kernel.org>

1,2: Acked-by: Pavel Machek <pavel@ucw.cz>

--=20
http://www.livejournal.com/~pavelmachek

--azLHFNyN32YCQGCU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl+RSbQACgkQMOfwapXb+vJxNgCff14TzbCILlD8HKHyf0HnX0IO
h3UAoKzEY2B9pSeuWYOLeCnUhXhpOcr0
=KJcN
-----END PGP SIGNATURE-----

--azLHFNyN32YCQGCU--
