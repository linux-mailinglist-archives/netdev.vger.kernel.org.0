Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D0D2520304
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 18:56:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239345AbiEIRAl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 13:00:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239330AbiEIRAi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 13:00:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C526F127193;
        Mon,  9 May 2022 09:56:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5B4F161535;
        Mon,  9 May 2022 16:56:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 307B2C385B1;
        Mon,  9 May 2022 16:56:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652115402;
        bh=ma7KAt89IfR03ZZVvYgYcIHD1fN0+zc6+GsP1F0gGzM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BCDBv2RszqfGdCRpA+zNo6nDPlRAGB4Um5Q05dhrDATW6+VY9oikBbL1zqEEv1Jn7
         S+EIpoJvQVYeXmM8tFhEkKKx2Py1/Sj8lsjxi4v1FYlb9XfOeyCfDdkEsj8rcYdLCX
         Yjc1DwuItizN4NHPa5fH4f/H/I5rpkFNVCTLa2JS4re+x+jFUqTvmRIBDYZaOUZxKx
         I2VD9a3K+OINYZeowh3qGTK0kabNNRpINVXSGQCJRCzX7YWFJF6SZ0Drs/GNHxIzVf
         CYgE+QW/LGYPdDnCLrrc2Xo+l7I7IpZe1gZEE3hoyHKAMeyoG8EitIDQ1xDzGK/onX
         21/6jYDVL1WKA==
Date:   Mon, 9 May 2022 17:56:34 +0100
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
Message-ID: <YnlHwpiow9Flgzas@sirena.org.uk>
References: <20220509074857.195302-1-clabbe@baylibre.com>
 <20220509074857.195302-4-clabbe@baylibre.com>
 <YnkGV8DyTlCuT92R@lunn.ch>
 <YnkWl+xYCX8r9DE7@Red>
 <Ynk7L07VH/RFVzl6@lunn.ch>
 <Ynk9ccoVh32Deg45@sirena.org.uk>
 <YnlDbbegQ1IbbaHy@lunn.ch>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="8w1oAQG8zH7Npult"
Content-Disposition: inline
In-Reply-To: <YnlDbbegQ1IbbaHy@lunn.ch>
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


--8w1oAQG8zH7Npult
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, May 09, 2022 at 06:38:05PM +0200, Andrew Lunn wrote:

> So we have a collection of regulators, varying in numbers between
> different PHYs, with different vendor names and purposes. In general,
> they all should be turned on. Yet we want them named so it is clear
> what is going on.

> Is there a generic solution here so that the phylib core can somehow
> enumerate them and turn them on, without actually knowing what they
> are called because they have vendor specific names in order to be
> clear what they are?

> There must be a solution to this, phylib cannot be the first subsystem
> to have this requirement, so if you could point to an example, that
> would be great.

No, it's not really come up much before - generally things with
regulator control that have generic drivers tend not to be sophisticated
enough to have more than one supply, or to be on an enumerable bus where
the power is part of the bus specification so have the power specified
as part of the bus.  You'd need to extend the regulator bindings to
support parallel array of phandles and array of names properties like
clocks have as an option like you were asking for, which would doubtless
be fun for validation but is probably the thing here.

--8w1oAQG8zH7Npult
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmJ5R8IACgkQJNaLcl1U
h9DsBgf/dLCjimiHfZ3BVIqJ24wTWXFg5dJk+Jp65LrpXJ6qSG86NuEHpNdoLTbZ
9y2PhDrkyF9y28KpLHo26UuISE9N74k2L/ZNzJrsqCVTc933fJ+JaViuvhx+LsdY
ZXlZG27WBycLjVGqW3BVqiN1h8xFIJZ+4I/LYr832cUHnPrQu+JpoJpvsMjrge3+
iSm3dqO1KZEGCaw8lK4MlGRS8ZoPBUA1lc4h2yvU8zpJc0OfIq5LU0p0DlggMlLE
ag0ct9nkNKD96unqDxXIYscDNf/9Kv2UjXR4M18yNnmLDZr4bDuiQAB+L+2jKzbR
dyOk2GxUf6FtgeOrdPmWMPuAn4+YWw==
=EKEu
-----END PGP SIGNATURE-----

--8w1oAQG8zH7Npult--
