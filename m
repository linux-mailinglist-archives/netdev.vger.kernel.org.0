Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D29268E108
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 20:21:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229685AbjBGTVE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 14:21:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230168AbjBGTVD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 14:21:03 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D77F2F7A7
        for <netdev@vger.kernel.org>; Tue,  7 Feb 2023 11:21:02 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1pPTWK-0000Gm-JD; Tue, 07 Feb 2023 20:20:48 +0100
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:1929:cbfc:e29:aaab])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 3FA43172BA4;
        Tue,  7 Feb 2023 19:20:46 +0000 (UTC)
Date:   Tue, 7 Feb 2023 20:20:40 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     Wolfgang Grandegger <wg@grandegger.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Fabrizio Castro <fabrizio.castro.jz@renesas.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Ulrich Hecht <uli+renesas@fpond.eu>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, Vinod <vkoul@kernel.org>
Subject: Re: [PATCH 12/12] can: rcar_canfd: Add transceiver support
Message-ID: <20230207192040.2b5wplxp75agydyw@pengutronix.de>
References: <cover.1674499048.git.geert+renesas@glider.be>
 <e825b50a843ffe40e33f34e4d858c07c1b2ff259.1674499048.git.geert+renesas@glider.be>
 <CAMuHMdXtiC-Oo01Y-vCbokjF=L+YXMN=TucgqCS4Vtcg5gt==g@mail.gmail.com>
 <20230202144000.2qvtnorgig52jfhw@pengutronix.de>
 <CAMuHMdUm+ExFCspjk6OO3pvZ-mW8dOiZe7bS2r-ys0S=CBAT-Q@mail.gmail.com>
 <20230202150632.oo57ap7bdapsvrum@pengutronix.de>
 <CAMuHMdX0iHUvyFYSdQJFLOzatjgHDnHYDzVvWFukYpXKbq7RxA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="uebnley74i5a7pp2"
Content-Disposition: inline
In-Reply-To: <CAMuHMdX0iHUvyFYSdQJFLOzatjgHDnHYDzVvWFukYpXKbq7RxA@mail.gmail.com>
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


--uebnley74i5a7pp2
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 03.02.2023 11:24:08, Geert Uytterhoeven wrote:
> > > > > I'll keep you updated when/if this ends up on an immutable branch.
> > > >
> > > > Should I take the patches 1...11 for can-next/main?
> > >
> > > That would be great, thanks!
> >
> > Done.
>=20
> Thank you!
> Meanwhile, the dependency for 12/12 is now available as an immutable
> branch, cfr. https://lore.kernel.org/all/Y9za4a8qyapi4CWD@matsya

net-next/main is at v6.2-rc6, but does not include this series. I assume
it will be mainlined in the v6.3 merge window. I think you can resend
this patch against can/main once v6.3-rc1 is released.

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--uebnley74i5a7pp2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEDs2BvajyNKlf9TJQvlAcSiqKBOgFAmPipIYACgkQvlAcSiqK
BOgpVAf/ahELMG0vSewSeK3gt53ohA63VHVUWV6WwRiWHxj6dCbDF1w77kFFMKhL
/oCXDAZj/ZwOUyFl7hMlfLLtw7BqxDU/c8gs/F7EtwVWLZKqWJW9DOE9a6MF3z2O
UbaCSre8WMqm71VhaufiHUAAgmAdDpEfrKXXdiaNlIYzK8ZrvLkXVTxQA5oMEFRC
NcVq+mC+utHPU2FdZdLcob9p8nXNL815oNQNFQzVt3ajrF1JpNyzj9hEvU1nzPyM
K0DTlOU9NdTQy9wf/yV3IJ0RuAN5ig/FIz+rFTZIVISEQ6INy15c5vVHmhFnvevI
jwekga+zhkspicJD6LxUBuoUkjkpQg==
=uykw
-----END PGP SIGNATURE-----

--uebnley74i5a7pp2--
