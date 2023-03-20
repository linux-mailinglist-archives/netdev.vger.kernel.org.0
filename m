Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F23646C10EB
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 12:37:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231236AbjCTLhK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 07:37:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231239AbjCTLhI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 07:37:08 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24C0913518
        for <netdev@vger.kernel.org>; Mon, 20 Mar 2023 04:37:07 -0700 (PDT)
Received: from moin.white.stw.pengutronix.de ([2a0a:edc0:0:b01:1d::7b] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1peDmk-0005Mb-3u; Mon, 20 Mar 2023 12:34:42 +0100
Received: from pengutronix.de (unknown [IPv6:2a00:20:c04b:45e4:1953:f0f4:6a85:b0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 05ADB19732D;
        Mon, 20 Mar 2023 09:23:50 +0000 (UTC)
Date:   Mon, 20 Mar 2023 10:23:49 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Rob Herring <robh@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andreas =?utf-8?Q?F=C3=A4rber?= <afaerber@suse.de>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Samuel Holland <samuel@sholland.org>,
        Joel Stanley <joel@jms.id.au>,
        Andrew Jeffery <andrew@aj.id.au>,
        =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>,
        Broadcom internal kernel review list 
        <bcm-kernel-feedback-list@broadcom.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Appana Durga Kedareswara rao <appana.durga.rao@xilinx.com>,
        Naga Sureshkumar Relli <naga.sureshkumar.relli@xilinx.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Daniel Machon <daniel.machon@microchip.com>,
        UNGLinuxDriver@microchip.com, Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-actions@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@lists.linux.dev, linux-aspeed@lists.ozlabs.org,
        linux-can@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-rockchip@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-mediatek@lists.infradead.org
Subject: Re: [PATCH] dt-bindings: net: Drop unneeded quotes
Message-ID: <20230320092349.7eqjqiblksjpw3fb@pengutronix.de>
References: <20230317233605.3967621-1-robh@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="5rfbuzw7ieky3r2g"
Content-Disposition: inline
In-Reply-To: <20230317233605.3967621-1-robh@kernel.org>
X-SA-Exim-Connect-IP: 2a0a:edc0:0:b01:1d::7b
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


--5rfbuzw7ieky3r2g
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 17.03.2023 18:36:03, Rob Herring wrote:
> Cleanup bindings dropping unneeded quotes. Once all these are fixed,
> checking for this can be enabled in yamllint.
>=20
> Signed-off-by: Rob Herring <robh@kernel.org>
> ---
[...]
>  .../devicetree/bindings/net/can/xilinx,can.yaml    |  6 +++---

Acked-by: Marc Kleine-Budde <mkl@pengutronix.de> # for bindings/net/can

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--5rfbuzw7ieky3r2g
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEDs2BvajyNKlf9TJQvlAcSiqKBOgFAmQYJiIACgkQvlAcSiqK
BOhjVQf/acPAkVlZAgSx2EeDlEf8hS1lf2sRkjDcvxt3kTD2h5jAh5U3kLV5DTD4
MjEV9UTZecOll5eioSnCl1DrrqCemegxaoOeML/pQDa4hNYWmm5JHZFLOKdQbL0T
B9Jl3hxOtVzm95NTggCnKp31A7Q7ft8wfQgSN//1++W90f7Yot/HEv/oPR68ElzX
J2GyX741B6AfKBqEztJ6OYDWiB2lHw6zzIxacqqM+zn9vjVteFg2FsbKvCRAbUCV
Bxg0WyzixKLhUf2Of1QOnEW70UfVtICWJ25BjPXp9+WGomovd5nb0MbV+2lou9kk
0u595tSMCR5sWDa8jKOahMLP+4ZClA==
=xkke
-----END PGP SIGNATURE-----

--5rfbuzw7ieky3r2g--
