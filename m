Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DA4752D180
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 13:31:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237416AbiESLbr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 07:31:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235135AbiESLbq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 07:31:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AF5755358;
        Thu, 19 May 2022 04:31:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BBF8461B18;
        Thu, 19 May 2022 11:31:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D567C385AA;
        Thu, 19 May 2022 11:31:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652959904;
        bh=MijcGSLlheaLd8D+OipECjVGW6bJpehfwvqYpqrbT5U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nFy4viiPjcDzOyA4en0kxaDlS2Dq2wIRp7CRp/P7o+WvGOl8Txis0CbJ3mKWagoLn
         Ke9ERT6kEWYoLSssJjxWAXOQeVoyUkpXe8L4TVGpi1C/4udiP7LgpsMXpAxQckgClJ
         9dF+RY1CsNq8TSdVhGZJrIekvenH3gKWCsfFmxbXz13uJrGjwOejrSF0xSqXjl8TNp
         /cMO03eO7ykymKxM5wf35O7LpK1CwSdUZBKW5sSdJlZLSbSvUoHUOXwVQIER6cjnH4
         3hdFT7u9eVOpjTwHn4XMm6hdD0taT4gkMHu9Nwz1kxF5eGxxVjG4v/PdI68JJXDZlk
         zyIZeADYy+LaQ==
Date:   Thu, 19 May 2022 12:31:36 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     Corentin Labbe <clabbe@baylibre.com>, andrew@lunn.ch,
        calvin.johnson@oss.nxp.com, davem@davemloft.net,
        edumazet@google.com, hkallweit1@gmail.com,
        jernej.skrabec@gmail.com, krzysztof.kozlowski+dt@linaro.org,
        kuba@kernel.org, lgirdwood@gmail.com, linux@armlinux.org.uk,
        pabeni@redhat.com, robh+dt@kernel.org, samuel@sholland.org,
        wens@csie.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@lists.linux.dev, netdev@vger.kernel.org
Subject: Re: [PATCH v2 4/5] dt-bindings: net: Add documentation for optional
 regulators
Message-ID: <YoYqmAB3P7fNOSVG@sirena.org.uk>
References: <20220518200939.689308-1-clabbe@baylibre.com>
 <20220518200939.689308-5-clabbe@baylibre.com>
 <95f3f0a4-17e6-ec5f-6f2f-23a5a4993a44@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="ISK1ldOBVTRUZTdj"
Content-Disposition: inline
In-Reply-To: <95f3f0a4-17e6-ec5f-6f2f-23a5a4993a44@linaro.org>
X-Cookie: Some restrictions may apply.
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--ISK1ldOBVTRUZTdj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, May 19, 2022 at 11:55:28AM +0200, Krzysztof Kozlowski wrote:
> On 18/05/2022 22:09, Corentin Labbe wrote:

> > +  regulators:
> > +    description:
> > +       List of phandle to regulators needed for the PHY

> I don't understand that... is your PHY defining the regulators or using
> supplies? If it needs a regulator (as a supply), you need to document
> supplies, using existing bindings.

They're trying to have a generic driver which works with any random PHY
so the binding has no idea what supplies it might need.

--ISK1ldOBVTRUZTdj
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmKGKpcACgkQJNaLcl1U
h9DYYAf9FUmpPRq5eJJuxSFhwB4pEIaskdfqRYeGXIebZCYZvHB80Fuk3SuFiizq
1MzfOCPFNucujqgezUWvvA+5LhpT88DmdvsEjyKGGgf1cJrPYH0Goi5Zcw17QKGX
BoKPnTZPlTKbPjp9+fV2X6ljzVOCIESTAcRWwzZpZ9CQNwXDrptLO72g47Esefo2
hXJ3WB4XYxEh9LJDiuThKfGCrrVTzosumYBj++rxw09P7v5e5+Yza3kTI3tw5YGz
do1dQaJi7OOTJk5MXI66mX785B39emZleorpkgK3MJY4hHCwgzWfpa0RSZiB8y5B
cULnxFfjt3GBgGoW2WgMrXU47y8BbQ==
=H3Kx
-----END PGP SIGNATURE-----

--ISK1ldOBVTRUZTdj--
