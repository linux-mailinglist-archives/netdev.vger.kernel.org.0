Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 346866C9CC9
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 09:51:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232807AbjC0Hvi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 03:51:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232844AbjC0Hv3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 03:51:29 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 737C13599
        for <netdev@vger.kernel.org>; Mon, 27 Mar 2023 00:51:27 -0700 (PDT)
Received: from moin.white.stw.pengutronix.de ([2a0a:edc0:0:b01:1d::7b] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1pghdG-0003gU-7y; Mon, 27 Mar 2023 09:51:10 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id ADDD219CEAC;
        Mon, 27 Mar 2023 07:51:07 +0000 (UTC)
Date:   Mon, 27 Mar 2023 09:51:06 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Dario Binacchi <dario.binacchi@amarulasolutions.com>
Cc:     linux-kernel@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh@kernel.org>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Rob Herring <robh+dt@kernel.org>,
        Amarula patchwork <linux-amarula@amarulasolutions.com>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        michael@amarulasolutions.com, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-can@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com, netdev@vger.kernel.org
Subject: Re: [RESEND PATCH v7 0/5] can: bxcan: add support for ST bxCAN
 controller
Message-ID: <20230327075106.ucfzckbhkwa23wci@pengutronix.de>
References: <20230315211040.2455855-1-dario.binacchi@amarulasolutions.com>
 <CABGWkvpHHLNzZHDMzWveoHtApmR3czVvoCOnuWBZt-UoLVU-6g@mail.gmail.com>
 <20230324155632.24chi5ndo23awhhp@pengutronix.de>
 <CABGWkvpsza=b8GAFkyL2VMMHqkHyY4VLQ=8aky5G8vWTeAR49g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="w6wvx2l43euoafha"
Content-Disposition: inline
In-Reply-To: <CABGWkvpsza=b8GAFkyL2VMMHqkHyY4VLQ=8aky5G8vWTeAR49g@mail.gmail.com>
X-SA-Exim-Connect-IP: 2a0a:edc0:0:b01:1d::7b
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-2.3 required=5.0 tests=RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--w6wvx2l43euoafha
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 26.03.2023 18:07:14, Dario Binacchi wrote:
> > On 21.03.2023 12:25:15, Dario Binacchi wrote:
> > > A gentle ping to remind you of this series.
> > > I have no idea why it hasn't deserved any response for quite some
> > > time.
> > > Is there anything I am still missing?
> >
> > I wonder if we want to do a s/master/primary/ in the DT bindings and
> > driver?
>=20
> The ST reference manual (RM0386) explicitly uses the master and slave wor=
ds
> in the bxcan chapter.

ACK

> I would stay consistent with it.

Yes, this is a known problem, on the one hand I'd like the drivers to
match the datasheet, but here I am in favor of a deviation.

> But I have no problem changing it to primary. I just sent v8 with the
> changes you suggested for shared irq and clock enable/disable,

These changes look good!

> but if you prefer to use primary I will send the v9 version with that
> change. Please let me know your opinion.

Please convert the driver and bindings to use "primary". Feel free to
mention that the datasheet calls the primary peripheral "master".

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung N=C3=BCrnberg              | Phone: +49-5121-206917-129  |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--w6wvx2l43euoafha
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEDs2BvajyNKlf9TJQvlAcSiqKBOgFAmQhSucACgkQvlAcSiqK
BOiPjQf9E5vCrptcbyNMbkUflXvdpNyA61rS146Nh9RTyCJEn2ACUqG+HnYYLtoY
za2I3hFo7w8rtro5lMUCpm5VelthwcH0ye1rg6l27SrXoNJqscr1FIfjULRTCgPb
UcKxrn++mNJILZVBCEVD0e9cEA6ZVz7aWXWOCodnjzR/Zs8t61VBYaKOU/owFzfl
ukyZeFWOAlfHidUNyOf9DZcYH0yEyWDgQ1epR+FHvuMkj2/5u35K/dZjD0QzO0Ee
wJzk3qbrJaR7amHXfaOwm+FYUl4xIEV6CDDXVxTvvUAAajNfzm+WZceALYU4tRQw
GLaIUlEJklglv+zm79XBdEZeaGSQag==
=FOmF
-----END PGP SIGNATURE-----

--w6wvx2l43euoafha--
