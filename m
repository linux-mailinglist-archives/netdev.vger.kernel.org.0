Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2CF44C7D0E
	for <lists+netdev@lfdr.de>; Mon, 28 Feb 2022 23:09:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231304AbiB1WKY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Feb 2022 17:10:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229634AbiB1WKX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Feb 2022 17:10:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 738FCC681F;
        Mon, 28 Feb 2022 14:09:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 39DA4B81698;
        Mon, 28 Feb 2022 22:09:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D10FC340EE;
        Mon, 28 Feb 2022 22:09:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646086180;
        bh=C3m4pnnTAF+o+8Z+tsT22TMwOAoIvmDl7rQIHuiLdMA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BdRbVBZNF8SyrlpXKAsHjo1A6k3f944Uzsh5hy2UmK5ywn8cPtoiWatoTWpomjQzc
         x44Jv7/Wzxo8T+fSgsmyLRYgbKXOQkqEy86p/ln+HE5A679Zvs+XoyM7aJWc8wSHt6
         ACqagutJzp7I7JrJGyMxpDRREGY/HUyTANKgF4FJ/99jkm+o2X+/pda0xDuvY8MbdY
         Sv4Zfi/zQD1hFPf6GsOnP6lA5hiuplekt76UNCcR1YonNLI47HOJfCmRDkLAT1NcBE
         yuQHyRRcOkNLJGUq9zBF6RREf+bF8FScygNYfOz5OBENPb041Vfalb0bt696k7uf4U
         g+dDDXgOJFcHA==
Date:   Mon, 28 Feb 2022 22:09:31 +0000
From:   Mark Brown <broonie@kernel.org>
To:     Rob Herring <robh@kernel.org>
Cc:     devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Sam Ravnborg <sam@ravnborg.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Pavel Machek <pavel@ucw.cz>, Lee Jones <lee.jones@linaro.org>,
        Guenter Roeck <groeck@chromium.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Vinod Koul <vkoul@kernel.org>,
        Sebastian Reichel <sre@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        dri-devel@lists.freedesktop.org,
        linux-arm-kernel@lists.infradead.org, linux-input@vger.kernel.org,
        linux-leds@vger.kernel.org, linux-mtd@lists.infradead.org,
        netdev@vger.kernel.org, linux-phy@lists.infradead.org,
        linux-pm@vger.kernel.org, linux-remoteproc@vger.kernel.org,
        alsa-devel@alsa-project.org, linux-spi@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH] dt-bindings: Another pass removing cases of 'allOf'
 containing a '$ref'
Message-ID: <Yh1IG9daOUOB52rf@sirena.org.uk>
References: <20220228213802.1639658-1-robh@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="xC2AwCckB4yHmCdp"
Content-Disposition: inline
In-Reply-To: <20220228213802.1639658-1-robh@kernel.org>
X-Cookie: Killing turkeys causes winter.
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--xC2AwCckB4yHmCdp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 28, 2022 at 03:38:02PM -0600, Rob Herring wrote:
> Another pass at removing unnecessary use of 'allOf' with a '$ref'.
>=20
> json-schema versions draft7 and earlier have a weird behavior in that
> any keywords combined with a '$ref' are ignored (silently). The correct
> form was to put a '$ref' under an 'allOf'. This behavior is now changed
> in the 2019-09 json-schema spec and '$ref' can be mixed with other
> keywords.

Acked-by: Mark Brown <broonie@kernel.org>

--xC2AwCckB4yHmCdp
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmIdSBoACgkQJNaLcl1U
h9Brnwf9Gb7P9H3jku9OngoretGUxGN4DtDmr+0Bvk7ZZFkSIVQYVBROL0mmUfer
wPLiKHS48VJM6irhxRMqHLa1CrIeAmJHZpkg0R1JH1Iw36fWPZiBTfrDG8qubOti
l/cEx7Jmxoj2EtB8xcTpbYGqwOqSZtDkAz1smUIh3coKzArwCPjkAYE59GjQ28SS
F+P6ze1awYqRh/vkZC5ge03hrBhxOKU1iVyqv4iRfWtwCXRxYM3aPTs4aLB/T0NW
svINogVRgGsGVmY7gRufv1wI7bJle7+MP7byPwsqzx2AXthe0fYt3x457mV59wjc
Ej2pLNgE/IiOKyZ8gmWU8kkWHOh2hQ==
=Hxgn
-----END PGP SIGNATURE-----

--xC2AwCckB4yHmCdp--
