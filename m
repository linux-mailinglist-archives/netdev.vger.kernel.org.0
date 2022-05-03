Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 715DC518A45
	for <lists+netdev@lfdr.de>; Tue,  3 May 2022 18:42:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239722AbiECQqC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 12:46:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239702AbiECQqB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 12:46:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B2E12C10A;
        Tue,  3 May 2022 09:42:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3EE0CB81EB6;
        Tue,  3 May 2022 16:42:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDCEFC385AF;
        Tue,  3 May 2022 16:42:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651596146;
        bh=RdmnwE+iucpL+/8qT85xaKQLpnn8IQBlp7A0PPpBkjc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MBuAO2xSVQR0Es2Khy87In4R8Y100/OP9420inSPVtGjNodMGqIXGDeoQHgu0zdtp
         ZSMtkeQgwnC2B29WSRQCYL/O4jCHnME+f80aw4Fo5XWoHHVCVGx/BOqioVIUben+m7
         dAMycifIRkxwmDNlXwHi1GwZNR0O1uzfUUGAcwMMFdw8KhKSWf9AkZmD379wvLv9fh
         Uaih7P0/38fdDXOhFQTx4yM432rKEcsSGfyxP2ivUAyVZhwEsQe0HLwzNoIPwQXGpI
         dxuPOzqD0QB+YJpXI7AwZY3EEZfQI0H8Fxh83x1xt1dkQXlECEzWDKnz//DiA0KIY/
         DnUedifNgT+/g==
Date:   Tue, 3 May 2022 17:42:13 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Rob Herring <robh@kernel.org>
Cc:     devicetree@vger.kernel.org,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Abel Vesa <abel.vesa@nxp.com>, Stephen Boyd <sboyd@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Jonathan Cameron <jic23@kernel.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Vinod Koul <vkoul@kernel.org>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Zhang Rui <rui.zhang@intel.com>,
        Niklas =?iso-8859-1?Q?S=F6derlund?= 
        <niklas.soderlund@ragnatech.se>, Anson Huang <Anson.Huang@nxp.com>,
        Fabrice Gasnier <fabrice.gasnier@foss.st.com>,
        Han Xu <han.xu@nxp.com>, Dario Binacchi <dariobin@libero.it>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Maxime Ripard <mripard@kernel.org>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        linux-clk@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-iio@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-mtd@lists.infradead.org, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-phy@lists.infradead.org,
        linux-rtc@vger.kernel.org, linux-serial@vger.kernel.org,
        alsa-devel@alsa-project.org, linux-pm@vger.kernel.org
Subject: Re: [PATCH] dt-bindings: Drop redundant 'maxItems/minItems' in
 if/then schemas
Message-ID: <YnFbZaARRe13BqEU@sirena.org.uk>
References: <20220503162738.3827041-1-robh@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="Ie5Q9u0aDDvYlHNh"
Content-Disposition: inline
In-Reply-To: <20220503162738.3827041-1-robh@kernel.org>
X-Cookie: Drop that pickle!
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--Ie5Q9u0aDDvYlHNh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, May 03, 2022 at 11:27:38AM -0500, Rob Herring wrote:
> Another round of removing redundant minItems/maxItems when 'items' list is
> specified. This time it is in if/then schemas as the meta-schema was
> failing to check this case.

Acked-by: Mark Brown <broonie@kernel.org>

--Ie5Q9u0aDDvYlHNh
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmJxW2QACgkQJNaLcl1U
h9AhOwgAgCQAzTimr9tUAEV2YxMIwidmRC9yH7j14TLxr45y9aG5gyGDcabEWvNT
1G+vE5DtD9PAsO0tkipn9eZam4zgKttaLGOTql3iSuyYP4IJZLz5B0UQdfH/Rblq
lwN3vZgGQIDC0Bq4GZFntPO4DgtMJRUjLYBkqZ9VRrAc0BtdLx0s2eLXna86GqsS
JRPrW4CqJ9evXkLhz4oWrns5IFYbbkZQBRDahnYbYEShXBVarN07FHDyJR7e563l
wHOqrXEThke2dA9JPWeaBTp7h9SiE6UhFUpzyFAd9YF+0t0k3slgr1oj89o28M6t
855bZNK3+42p+Ytiewlr25+J4xL31Q==
=Z4ML
-----END PGP SIGNATURE-----

--Ie5Q9u0aDDvYlHNh--
