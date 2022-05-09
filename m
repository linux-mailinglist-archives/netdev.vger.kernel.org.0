Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3460A520212
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 18:14:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238854AbiEIQQi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 12:16:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238834AbiEIQQh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 12:16:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9662B43AE8;
        Mon,  9 May 2022 09:12:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 57363B80D3A;
        Mon,  9 May 2022 16:12:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A191C385AC;
        Mon,  9 May 2022 16:12:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652112761;
        bh=ZELzv0dYPW3+yD6GyYliLIBpFDKrBVzaR8/2zkS7yF8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JZA5YtHu3oZSruZwa6S2pu6I1AMiagYfLgT6NavPYw3/HYBi1TY+2SdfVsiVmCx1A
         LcV2CzVbx6knxQ1yhEcafeD0KLmIxeQ8JGSfShv12BAD0SHZG9k3Fc2lpSi7i3w0Lw
         6vkP2pYlYkwkMTgQ/zq89OjMVOpKzsXPU+wkDKwWHGKSwxHFQ0LA7NCbncBxyQhZez
         bmhi8BJbVGHpq3L43b+ZDe6P/syw0qwLrh3VLY/UYsKIbX3GiEs2qTvTt/MpDD8Vp2
         hO/xcSYNRXCU4ed0ftuRcrxCGzQ/9DNQHG0ycTIo166cvmXvRNkbtWl3gpXh4+itcz
         JHiLecuyhl4dQ==
Date:   Mon, 9 May 2022 17:12:33 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     LABBE Corentin <clabbe@baylibre.com>, alexandre.torgue@foss.st.com,
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
Message-ID: <Ynk9ccoVh32Deg45@sirena.org.uk>
References: <20220509074857.195302-1-clabbe@baylibre.com>
 <20220509074857.195302-4-clabbe@baylibre.com>
 <YnkGV8DyTlCuT92R@lunn.ch>
 <YnkWl+xYCX8r9DE7@Red>
 <Ynk7L07VH/RFVzl6@lunn.ch>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="CNycEhaqQp6Or6dX"
Content-Disposition: inline
In-Reply-To: <Ynk7L07VH/RFVzl6@lunn.ch>
X-Cookie: Boycott meat -- suck your thumb.
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--CNycEhaqQp6Or6dX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, May 09, 2022 at 06:02:55PM +0200, Andrew Lunn wrote:
> On Mon, May 09, 2022 at 03:26:47PM +0200, LABBE Corentin wrote:

> > For the difference between the 2, according to my basic read (I am bad a it) of the shematic
> > https://linux-sunxi.org/images/5/50/OrangePi_3_Schematics_v1.5.pdf
> > phy-io(ephy-vdd25) seems to (at least) power MDIO bus.

> So there is nothing in the data sheet of the RTL8211E to suggest you
> can uses these different power supplies independently. The naming
> 'phy-io-supply' is very specific to RTL8211E, but you are defining a
> generic binding here. I don't know the regulator binding, it is
> possible to make phy-supply a list?

No, that's not a thing - the supplies are individual, named properties
and even if there were a list we'd still want them to be named so it's
clear what's going on.

--CNycEhaqQp6Or6dX
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmJ5PXAACgkQJNaLcl1U
h9Cb+Qf+MfRYbiD4XEpLhP4gge18kGLq3gf/PC8t0oiN1ICJLIo5J94BR0kjYpWS
eS+xHbhlh+5/sK++BvKLiMKyWcFcwKZhtuEjNJCMO4Wv9yLJmyrwBloMDTlEtEp0
f6DAFwAMWXN2jF7ArhfNV7fnwSZdJkeeJ4/WgQMxAtkGlcGmwis+lwIfVIAY28A7
opdj8RSRHjG+KQZy8f5NI3771wmXLhIe8as7zRGt9+57ukrCA++V0degWB/AzDSf
BzUJqQtFGNsC+B9VfemnyXQzCmIX+Fyz2/Y4EwstUnO5JkxgtFkyvKXSPRbObeot
1n6utSr2W8/hq3CAgz6mpxnpGFQQIA==
=9kj+
-----END PGP SIGNATURE-----

--CNycEhaqQp6Or6dX--
