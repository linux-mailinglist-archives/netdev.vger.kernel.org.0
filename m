Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF8FB523363
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 14:51:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242770AbiEKMvS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 08:51:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242824AbiEKMvL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 08:51:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C4D93D1D0;
        Wed, 11 May 2022 05:51:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EC2B3B82359;
        Wed, 11 May 2022 12:51:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1872C3410F;
        Wed, 11 May 2022 12:51:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652273467;
        bh=ilKGaxGKhxB0YYV/ztEYYWw7I0QBzPzqY3ODK4muYDQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Q4gUwAz+TH/cL8ISyjeXIkdK5QhVVTrbZhwP/mcQHEF8uQUMG1CT/4TaLj/mk1jmZ
         MTmMaVV6JV4wZjSHrTSmg58dRcpgkiy6C1bBnCjVq4AwD1bVw8aqagwfKy8Z57eABM
         0MCX5J8aisIjZqpvG3rz/9JyAqSGEvT4Yug5afofW85kCj8L8aeshDNhL4EcB6YW1W
         GoUCoVwGzB9WkTfHivGVVxtkaxyVoXiiHX3b2vdOTA6DSuQBL1gPd6meQDvZ/d7yJX
         bhKqwYFeNAv1RXKdFWMLGHN9P6J83yu92ngvN1VcOa0+4D2q58gcks2P1RSwt2BZcD
         YifGv0I9oBVuA==
Date:   Wed, 11 May 2022 13:50:59 +0100
From:   Mark Brown <broonie@kernel.org>
To:     LABBE Corentin <clabbe@baylibre.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, alexandre.torgue@foss.st.com,
        calvin.johnson@oss.nxp.com, davem@davemloft.net,
        edumazet@google.com, hkallweit1@gmail.com,
        jernej.skrabec@gmail.com, joabreu@synopsys.com,
        krzysztof.kozlowski+dt@linaro.org, kuba@kernel.org,
        lgirdwood@gmail.com, linux@armlinux.org.uk, pabeni@redhat.com,
        peppe.cavallaro@st.com, robh+dt@kernel.org, samuel@sholland.org,
        wens@csie.org, netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@lists.linux.dev
Subject: Re: [PATCH 3/6] dt-bindings: net: Add documentation for phy-supply
Message-ID: <YnuxM3StiTuLMBux@sirena.org.uk>
References: <20220509074857.195302-1-clabbe@baylibre.com>
 <20220509074857.195302-4-clabbe@baylibre.com>
 <YnkGV8DyTlCuT92R@lunn.ch>
 <YnkWl+xYCX8r9DE7@Red>
 <Ynk7L07VH/RFVzl6@lunn.ch>
 <Ynk9ccoVh32Deg45@sirena.org.uk>
 <YnlDbbegQ1IbbaHy@lunn.ch>
 <YnlHwpiow9Flgzas@sirena.org.uk>
 <YnttssHyCf8PJJev@Red>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="sbRn3mnJQka7KUAO"
Content-Disposition: inline
In-Reply-To: <YnttssHyCf8PJJev@Red>
X-Cookie: Look ere ye leap.
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--sbRn3mnJQka7KUAO
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 11, 2022 at 10:02:58AM +0200, LABBE Corentin wrote:
> Le Mon, May 09, 2022 at 05:56:34PM +0100, Mark Brown a =E9crit :

> > as part of the bus.  You'd need to extend the regulator bindings to
> > support parallel array of phandles and array of names properties like
> > clocks have as an option like you were asking for, which would doubtless
> > be fun for validation but is probably the thing here.

> Does you mean something like this:

=2E..

> And then for our case, a regulator_get_bulk will be needed.
> Does I well understood what you mean ?

Yes.

--sbRn3mnJQka7KUAO
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmJ7sTIACgkQJNaLcl1U
h9CLDAf/WwjQBtzQ6Tt2Pi241jQ9Fv3CvwrQ+/Xb1dJ1V/872V1Ymq99YP0tS7CZ
LM1m2NWTzuDilJpzAfvyQX5QKp1OnRhT3qgz9Aer6r5zLJmTIByrlCMFlbrn6Q7V
OkjdV+G0cPYJQdezzzG4OKC24aGBvP/l7eKp1ZBe4sidLGLU6O6d5Hs4WUjgbMXQ
WGfqSNOR3Cyu+2qA/eDxt+sI8FWdu1zgNWifjYmhbuAgIuOW+fYOJS8atZtZFDQk
fFTABew0eD/hrBORWPLRpd0BOELQss8jC+TE8l8E83vG1Crl9BAhXoCMDRNk9+2g
X6a9mbgqEG0AaM1Ct57gLDsTU0mMKg==
=Nt6t
-----END PGP SIGNATURE-----

--sbRn3mnJQka7KUAO--
