Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81EF06AA407
	for <lists+netdev@lfdr.de>; Fri,  3 Mar 2023 23:17:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233671AbjCCWRj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Mar 2023 17:17:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233621AbjCCWRX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Mar 2023 17:17:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EDA43D09E;
        Fri,  3 Mar 2023 14:08:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 026D261912;
        Fri,  3 Mar 2023 21:51:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5195C433EF;
        Fri,  3 Mar 2023 21:51:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677880281;
        bh=Br50V+ZnNhKeUVmf1H88XflaSYA3zbjNUSaOrfbHpWM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=L0Wgj2qDMYr7AQFFunxAnGexnwRXj41XfheavwO4sQNH9ThQWN7YWlj2Dp73Ahdw/
         2uXKlv/22ez+DVr7ejBSi69+v/MiAkOp+L5BIU6bdV3QorAgVbad15r3DUWG3n/DEN
         M10p5eVyq7bMRTBYHiwIAV7dwH08VMMfs8aaRdkMd/hoae6WtB50Y8/GEMWE9hfPsr
         X7GJJ+ZO9cmyRf0HO7C4myHQ+bm9TdwZkTHEpy9iYruGmrWIunUXZc3w5CkIZpxxYi
         kXKl6tYBhJNPTsNy5u9kGPM7Uf/kIR6xDR/XGWpONnVXpZwWkjJ02fE/UU6YbDF9O8
         LSMB76p+PtvfA==
Date:   Fri, 3 Mar 2023 21:51:12 +0000
From:   Conor Dooley <conor@kernel.org>
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
        Mark Brown <broonie@kernel.org>,
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
Message-ID: <cdad5aa0-bd94-4137-9063-af45e94a25b7@spud>
References: <20230303214223.49451-1-robh@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="mffVr3k4EP4yfp2t"
Content-Disposition: inline
In-Reply-To: <20230303214223.49451-1-robh@kernel.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--mffVr3k4EP4yfp2t
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 03, 2023 at 03:42:23PM -0600, Rob Herring wrote:
> Enable yamllint to check the prefered commenting style of requiring a
> space after a comment character '#'. Fix the cases in the tree which
> have a warning with this enabled. Most cases just need a space after the
> '#'. A couple of cases with comments which were not intended to be
> comments are revealed. Those were in ti,sa2ul.yaml, ti,cal.yaml, and
> brcm,bcmgenet.yaml.
>=20
> Signed-off-by: Rob Herring <robh@kernel.org>
> ---

> Cc: Conor Dooley <conor.dooley@microchip.com>

> diff --git a/Documentation/devicetree/bindings/spi/microchip,mpfs-spi.yam=
l b/Documentation/devicetree/bindings/spi/microchip,mpfs-spi.yaml
> index 1051690e3753..74a817cc7d94 100644
> --- a/Documentation/devicetree/bindings/spi/microchip,mpfs-spi.yaml
> +++ b/Documentation/devicetree/bindings/spi/microchip,mpfs-spi.yaml
> @@ -22,7 +22,7 @@ properties:
>        - items:
>            - const: microchip,mpfs-qspi
>            - const: microchip,coreqspi-rtl-v2
> -      - const: microchip,coreqspi-rtl-v2 #FPGA QSPI
> +      - const: microchip,coreqspi-rtl-v2 # FPGA QSPI
>        - const: microchip,mpfs-spi

I had to think for a minute as to what that comment even meant...
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>

Thanks,
Conor.

--mffVr3k4EP4yfp2t
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZAJr0AAKCRB4tDGHoIJi
0rHgAP9euC+7Ztk0BIMgxdrJzAjogpoZQH6UzawtcdI6SIq2nQD/d5Bvci5DVqMV
DWn8X2un+KM/vLbl8yUpHlGFB4QKwQY=
=v1U9
-----END PGP SIGNATURE-----

--mffVr3k4EP4yfp2t--
