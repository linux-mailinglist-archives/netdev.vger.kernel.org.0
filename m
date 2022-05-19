Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FA8152D933
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 17:50:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241297AbiESPue (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 11:50:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241369AbiESPuQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 11:50:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCD306005F;
        Thu, 19 May 2022 08:49:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7942A61C15;
        Thu, 19 May 2022 15:49:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8D1DC34100;
        Thu, 19 May 2022 15:49:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652975356;
        bh=wRDcSZWRg8F5GYZDzBv0ctTZeIUjFAPm7X9uhNSHFwo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=E8aho+U1muOFpeLWM0FXTi1BWNJEHPMiiyTsSAWPRXoUVn1W9kxdpb8bXWeIqCP0I
         RgySRFIxpxZGCW+dFeItge4EvYalvRZEg0Cgh0g3od/B0mM9C5I5gHZxlp3zS17szb
         c5bkgEdd4USnWPTmdrMaQUniW6zDIP6hlmCflaZ35MN1XW370dVNykwsOXVvWL22FT
         LPl+JL6xj6Fyb+tKDiJN1n9dKwO/T5SCnvCYdekG5eGwwI2FfmR4WyoLQnjiwCQX7B
         d5cy4ncvffbet63U7dI+bWul3B8lva2Z7pt5x6u6iRvg0XRh4RMHtCp5trBWkacZsd
         VkXTDxeVKlNHw==
Date:   Thu, 19 May 2022 16:49:09 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Corentin Labbe <clabbe@baylibre.com>,
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
Message-ID: <YoZm9eabWy/FNKu1@sirena.org.uk>
References: <20220518200939.689308-1-clabbe@baylibre.com>
 <20220518200939.689308-5-clabbe@baylibre.com>
 <95f3f0a4-17e6-ec5f-6f2f-23a5a4993a44@linaro.org>
 <YoYqmAB3P7fNOSVG@sirena.org.uk>
 <c74b0524-60c6-c3af-e35f-13521ba2b02e@linaro.org>
 <YoYw2lKbgCiDXP0A@lunn.ch>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="jOI5UhwGK68KoNhN"
Content-Disposition: inline
In-Reply-To: <YoYw2lKbgCiDXP0A@lunn.ch>
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


--jOI5UhwGK68KoNhN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, May 19, 2022 at 01:58:18PM +0200, Andrew Lunn wrote:
> On Thu, May 19, 2022 at 01:33:21PM +0200, Krzysztof Kozlowski wrote:
> > On 19/05/2022 13:31, Mark Brown wrote:
> > > On Thu, May 19, 2022 at 11:55:28AM +0200, Krzysztof Kozlowski wrote:
> > >> On 18/05/2022 22:09, Corentin Labbe wrote:

> > >>> +  regulators:
> > >>> +    description:
> > >>> +       List of phandle to regulators needed for the PHY

> > >> I don't understand that... is your PHY defining the regulators or using
> > >> supplies? If it needs a regulator (as a supply), you need to document
> > >> supplies, using existing bindings.

> > > They're trying to have a generic driver which works with any random PHY
> > > so the binding has no idea what supplies it might need.

> > OK, that makes sense, but then question is why not using existing
> > naming, so "supplies" and "supply-names"?

> I'm not saying it is not possible, but in general, the names are not
> interesting. All that is needed is that they are all on, or
> potentially all off to save power on shutdown. We don't care how many
> there are, or what order they are enabled.

I think Krzysztof is referring to the name of the property rather than
the contents of the -names property there.

--jOI5UhwGK68KoNhN
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmKGZvQACgkQJNaLcl1U
h9BKbAf+IovUQ3DSAoKJdf32JsgeB+o/vNXD8MscsyZm5JvIVj5BOLWLb1emeGJP
Yp3omFPSMOvlsZtrBEx7Fk4MO/Rt0zWemfEcHAfnPI2yPp0LVZLBEqStTWeQQHab
DdrMZrX6CDbQojP0q4eYGt24OF/dMIYThDp7XU4GDH4Sy7KXD5SpYGuR5Pe9F2Uy
KZ/25LSM7z8oKUaMHCx21nUm1bHXbuBiP46PKEX4aiSJ1f+S5WhdlC4PI0ZnUMis
iC00xj4guPTArs7K9DX8y4AwrjlMOogR5Nqwkl5c8xiZQs2lsMI/HfnctaUdiIe9
qBKP7Eyse3kVuq04h+CQHDUYTCrBIQ==
=ZhuD
-----END PGP SIGNATURE-----

--jOI5UhwGK68KoNhN--
