Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3890F6D549A
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 00:15:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233781AbjDCWPV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 18:15:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233755AbjDCWPU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 18:15:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2C1A2733;
        Mon,  3 Apr 2023 15:15:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4B7A762741;
        Mon,  3 Apr 2023 22:15:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88528C433D2;
        Mon,  3 Apr 2023 22:15:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680560118;
        bh=57QA0D3vMKUxVxiGwf9bCE+CVxDRjP2244HhifV2zpw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=auNZJlAFrquPLRfqf4+Mg/ydhzeX03nR2BHZhssNIr60GLrXdRFNwla7sdquGTJoX
         tBbn5zn2w8ojwIgOPCaItN0L5jGXwCWYg5S1/0qNdQnCSOLYVbN3bVxx/3nd5EoVjW
         j8zAZJWIbikpAOY/ED/FMva8a8pLbAPt5IXQwkI0uaoVQWYJuID/nk+YyCNjsSB0KP
         rGPENaVbj+1STeyw2qGcV9iAiQ1dUhB9K2UnXQt3AfHA/InzLMtIws22kBDTSWaBeE
         mue4cTvAiNQ235Dl8Hm+DOjuHi0KpNfe0owHejloFUH1I/3zGu5xp8rHafdMl5EiID
         s8+Eu9k14Tg2A==
Date:   Mon, 3 Apr 2023 23:15:12 +0100
From:   Conor Dooley <conor@kernel.org>
To:     Samin Guo <samin.guo@starfivetech.com>
Cc:     linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Emil Renner Berthing <kernel@esmil.dk>,
        Jose Abreu <joabreu@synopsys.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Peter Geis <pgwipeout@gmail.com>,
        Yanhong Wang <yanhong.wang@starfivetech.com>,
        Tommaso Merciai <tomm.merciai@gmail.com>
Subject: Re: [-net-next v10 5/6] net: stmmac: Add glue layer for StarFive
 JH7110 SoC
Message-ID: <20230403-data-dawdler-afaaaf6fa87c@spud>
References: <20230403065932.7187-1-samin.guo@starfivetech.com>
 <20230403065932.7187-6-samin.guo@starfivetech.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="84nP7Z0ce07Qtixm"
Content-Disposition: inline
In-Reply-To: <20230403065932.7187-6-samin.guo@starfivetech.com>
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--84nP7Z0ce07Qtixm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Apr 03, 2023 at 02:59:31PM +0800, Samin Guo wrote:

> diff --git a/MAINTAINERS b/MAINTAINERS
> index 6b6b67468b8f..a9684b3c24f9 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -19909,6 +19909,7 @@ STARFIVE DWMAC GLUE LAYER
>  M:	Emil Renner Berthing <kernel@esmil.dk>
>  M:	Samin Guo <samin.guo@starfivetech.com>
>  S:	Maintained

> +F:	Documentation/devicetree/bindings/net/dwmac-starfive.c

Funny name you got for a binding there mate!

--84nP7Z0ce07Qtixm
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZCtP7wAKCRB4tDGHoIJi
0myQAP9wARDgakX8FcF58KbJswTnvpTw2I1YphYE7uWfxOLrlwD7Bo0T6w52woIL
AhFB+0TUkn9D0MEdo0+3Cvoz6DRWuww=
=tani
-----END PGP SIGNATURE-----

--84nP7Z0ce07Qtixm--
