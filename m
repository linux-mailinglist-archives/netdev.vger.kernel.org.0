Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A05C86AAC58
	for <lists+netdev@lfdr.de>; Sat,  4 Mar 2023 21:15:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229702AbjCDUPC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Mar 2023 15:15:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbjCDUPA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Mar 2023 15:15:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46E9C18169;
        Sat,  4 Mar 2023 12:14:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 08C8EB808D0;
        Sat,  4 Mar 2023 20:14:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21BEFC433EF;
        Sat,  4 Mar 2023 20:14:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677960896;
        bh=3r578BL7TwpWHlpQ0on74A4ds7yYrKerlhknBqHE0IQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Of74lGgrQfr/3MT85Mry+dk98AnwqBx/+IKkV8dz7hpunpG/juil6jblXMxLIcXBH
         otDFXzf26WX1vIQfjtEdOfRcHdWgRJ6boGHh/XsJsH/L1/dtv7Z5jnzlaj2op2B4o4
         nGMfOtYx0YzF4FQmz+EBu9ckLQPtV3mUYeJDCdB5elK/H55dP2tJpt/pvCT6I8ESZS
         EYIJw0pgzfvvru+19Oo2drthgeVkF5beApFrnmEAqghgBqsbpzQmm5hoht9HFoxh3N
         3kN6/VWB+pginmwR+OoqxqA0Q70T/VI0WywY3cn/oA7H6RmGx2NYH+NcaRO0HJUqAa
         NE+vFF1/bWCDg==
Date:   Sat, 4 Mar 2023 20:14:53 +0000
From:   Mark Brown <broonie@kernel.org>
To:     Rob Herring <robh@kernel.org>
Cc:     devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Clark <robdclark@gmail.com>,
        Abhinav Kumar <quic_abhinavk@quicinc.com>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Sean Paul <sean@poorly.run>,
        Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <maz@kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Vinod Koul <vkoul@kernel.org>,
        Kishon Vijay Abraham I <kishon@kernel.org>,
        Conor Dooley <conor.dooley@microchip.com>,
        linux-clk@vger.kernel.org, linux-crypto@vger.kernel.org,
        dri-devel@lists.freedesktop.org, freedreno@lists.freedesktop.org,
        linux-media@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-phy@lists.infradead.org, linux-gpio@vger.kernel.org,
        alsa-devel@alsa-project.org, linux-riscv@lists.infradead.org,
        linux-spi@vger.kernel.org
Subject: Re: [PATCH] dt-bindings: yamllint: Require a space after a comment
 '#'
Message-ID: <ZAOmvQMn+7R9KcVx@sirena.org.uk>
References: <20230303214223.49451-1-robh@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="DpC9JxmBtx/VM1Dr"
Content-Disposition: inline
In-Reply-To: <20230303214223.49451-1-robh@kernel.org>
X-Cookie: Single tasking: Just Say No.
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--DpC9JxmBtx/VM1Dr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Mar 03, 2023 at 03:42:23PM -0600, Rob Herring wrote:
> Enable yamllint to check the prefered commenting style of requiring a
> space after a comment character '#'. Fix the cases in the tree which
> have a warning with this enabled. Most cases just need a space after the
> '#'. A couple of cases with comments which were not intended to be
> comments are revealed. Those were in ti,sa2ul.yaml, ti,cal.yaml, and
> brcm,bcmgenet.yaml.

Acked-by: Mark Brown <broonie@kernel.org>

--DpC9JxmBtx/VM1Dr
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmQDprwACgkQJNaLcl1U
h9AqEQf+Ki9N0115CHG31rvFs9RFMaV3z2FBkTIO1Zs9u9jJ0UFONa8aS8bq8aPQ
gm3UuhyofZ4p+tqg6Y6nKHVWZalcU4N95+sNm/ZzjCvDKR66x0O+uPlCXd8pfREU
kNoKd5CFtP+fjtXf0oEscR6C4Pu/I20EuDWUyrfNii3oFMAuDeVS2wgXadAxOJ6d
fSPFcja3GW9gJ4EE0LacuhUM5ZUtW25HeTc7vmBynRd7tTqjc4FQgPSyt8tvUe0Y
VodxCsoIvcS9vx94nDyo1USMh/HFKAtRlJNuuWj1+kWcrRUfBuJVlSSzZt6o9M+k
6cA73SE3SJ8RJIFe8Bz9r6ULWYSY6A==
=/n6h
-----END PGP SIGNATURE-----

--DpC9JxmBtx/VM1Dr--
