Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7703968804A
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 15:40:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232527AbjBBOkg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 09:40:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232498AbjBBOk3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 09:40:29 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEEC58F506
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 06:40:25 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1pNal0-0003lC-Rj; Thu, 02 Feb 2023 15:40:10 +0100
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:fff9:bfd9:c514:9ad9])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 4382D16D655;
        Thu,  2 Feb 2023 14:40:08 +0000 (UTC)
Date:   Thu, 2 Feb 2023 15:40:00 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     Wolfgang Grandegger <wg@grandegger.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Fabrizio Castro <fabrizio.castro.jz@renesas.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Ulrich Hecht <uli+renesas@fpond.eu>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: Re: [PATCH 12/12] can: rcar_canfd: Add transceiver support
Message-ID: <20230202144000.2qvtnorgig52jfhw@pengutronix.de>
References: <cover.1674499048.git.geert+renesas@glider.be>
 <e825b50a843ffe40e33f34e4d858c07c1b2ff259.1674499048.git.geert+renesas@glider.be>
 <CAMuHMdXtiC-Oo01Y-vCbokjF=L+YXMN=TucgqCS4Vtcg5gt==g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="evlpwhhurau3f4do"
Content-Disposition: inline
In-Reply-To: <CAMuHMdXtiC-Oo01Y-vCbokjF=L+YXMN=TucgqCS4Vtcg5gt==g@mail.gmail.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--evlpwhhurau3f4do
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 24.01.2023 19:41:03, Geert Uytterhoeven wrote:
> On Mon, Jan 23, 2023 at 7:56 PM Geert Uytterhoeven
> <geert+renesas@glider.be> wrote:
> > Add support for CAN transceivers described as PHYs.
> >
> > While simple CAN transceivers can do without, this is needed for CAN
> > transceivers like NXP TJR1443 that need a configuration step (like
> > pulling standby or enable lines), and/or impose a bitrate limit.
> >
> > Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> > ---
> > This depends on "[PATCH 1/7] phy: Add devm_of_phy_optional_get() helper=
".
> > https://lore.kernel.org/all/f53a1bcca637ceeafb04ce3540a605532d3bc34a.16=
74036164.git.geert+renesas@glider.be
>=20
> v2: "[PATCH v2 3/9] phy: Add devm_of_phy_optional_get() helper"
>     https://lore.kernel.org/all/4cd0069bcff424ffc5c3a102397c02370b91985b.=
1674584626.git.geert+renesas@glider.be
>=20
> I'll keep you updated when/if this ends up on an immutable branch.

Should I take the patches 1...11 for can-next/main?

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--evlpwhhurau3f4do
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEDs2BvajyNKlf9TJQvlAcSiqKBOgFAmPbyz0ACgkQvlAcSiqK
BOg8HAf9EAiSb3vx5n466VIpvilTXE4tuHZJ7M8t+LG4FIc2/IxyaW2sxvc0KljI
CSwWsA5H1gxycXPSfHwZ1Z0R0z5b7HzLqCKRsmCJszEciTBsGyg5qfNuI4GgwRWN
Oy09kEK0CpsOClClaGOlla+9xhWhoiFT8yIScbTDfNGDaCl9wa16gdZnFUHwT4RH
VTpNvCLP07ZzaVloA0hAK4Laza0UXjngmJINlb/CX2glcj6KbZc0uUtDiFMixqDo
eZIbAYVjux5Ai/FXftLSsYrVRsqr4X53eYzyY7UQ9laPBgGQktdmcWTtkdF3urxJ
PpGWA43PLDvW1K/yI2zVA/bD4b6pXA==
=hK01
-----END PGP SIGNATURE-----

--evlpwhhurau3f4do--
