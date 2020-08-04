Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 787ED23B783
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 11:19:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730002AbgHDJSW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Aug 2020 05:18:22 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:58122 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725904AbgHDJSW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Aug 2020 05:18:22 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 10E1A1C0BDD; Tue,  4 Aug 2020 11:18:18 +0200 (CEST)
Date:   Tue, 4 Aug 2020 11:18:17 +0200
From:   Pavel Machek <pavel@ucw.cz>
To:     pisa@cmp.felk.cvut.cz
Cc:     linux-can@vger.kernel.org, devicetree@vger.kernel.org,
        mkl@pengutronix.de, socketcan@hartkopp.net, wg@grandegger.com,
        davem@davemloft.net, robh+dt@kernel.org, mark.rutland@arm.com,
        c.emde@osadl.org, armbru@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, martin.jerabek01@gmail.com,
        ondrej.ille@gmail.com, jnovak@fel.cvut.cz, jara.beran@gmail.com,
        porazil@pikron.com
Subject: Re: [PATCH v4 2/6] dt-bindings: net: can: binding for CTU CAN FD
 open-source IP core.
Message-ID: <20200804091817.yuf6s26bclehpwwi@duo.ucw.cz>
References: <cover.1596408856.git.pisa@cmp.felk.cvut.cz>
 <701442883f2b439637ff84544745725bdee7bcf8.1596408856.git.pisa@cmp.felk.cvut.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="kyw4twhhtai4pjwf"
Content-Disposition: inline
In-Reply-To: <701442883f2b439637ff84544745725bdee7bcf8.1596408856.git.pisa@cmp.felk.cvut.cz>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--kyw4twhhtai4pjwf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> The commit text again to make checkpatch happy.

?


> +    oneOf:
> +      - items:
> +          - const: ctu,ctucanfd
> +          - const: ctu,canfd-2
> +      - const: ctu,ctucanfd

For consistency, can we have ctu,canfd-1, ctu,canfd-2?

Best regards,
									Pavel

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--kyw4twhhtai4pjwf
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EARECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCXykn2QAKCRAw5/Bqldv6
8kYCAJ4jA/qIYWq2pUyjiAJ/fOhTarpq6wCgxLuE0RfCV4mrqnFOk1DXh6CugEU=
=4PoT
-----END PGP SIGNATURE-----

--kyw4twhhtai4pjwf--
