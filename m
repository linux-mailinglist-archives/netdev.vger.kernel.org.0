Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97AC66AD2D8
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 00:32:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229580AbjCFXcp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 18:32:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229534AbjCFXco (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 18:32:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B6063CE10;
        Mon,  6 Mar 2023 15:32:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B34AB61184;
        Mon,  6 Mar 2023 23:32:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E21C3C433EF;
        Mon,  6 Mar 2023 23:32:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678145562;
        bh=ZGUTtquGzXTLF7VGJydoXmWIUDYMJ/fi4dkrB65U3c0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=m/f0fTlj6dXMj8VsjZ3Inkr6iRTv+kJUf6iG24bvoD3PBZ5m4w3tfafylbVEPd/Wt
         FQWpgyinzhzUIyyY6ZJjEZiOINzjC9L0Tfv5xGjb55Iynfju+p8UwfUtoNYlPKRzxH
         obJ3+1qor+bbvps6HyUwOR2DNk98Sk8BinXZPGRUpkgFxm2xPQtLiJ0KLDoNmNE2VJ
         2dNAPGMucj9ba1PcF5hKktSp9smySVQmtsSvEfQfzT6tpK/FX4jp3W0UTki7X1Rc6t
         XIXoByLPblr3FjCFLzLrMPEspEOqGZOcZsZ1Ih3Ob7B94DIbRV8H+Kft5WKqfQXL1q
         U6sg+ycRV51qA==
Date:   Mon, 6 Mar 2023 23:32:34 +0000
From:   Conor Dooley <conor@kernel.org>
To:     Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
Cc:     Lee Jones <lee@kernel.org>, Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Emil Renner Berthing <kernel@esmil.dk>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Sagar Kadam <sagar.kadam@sifive.com>,
        Yanhong Wang <yanhong.wang@starfivetech.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-riscv@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, kernel@collabora.com
Subject: Re: [PATCH 03/12] soc: sifive: ccache: Add StarFive JH7100 support
Message-ID: <b969cf86-d5df-462a-982b-c5b67f97c3d6@spud>
References: <20230211031821.976408-1-cristian.ciocaltea@collabora.com>
 <20230211031821.976408-4-cristian.ciocaltea@collabora.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="sWezJbPTi7EG0f2m"
Content-Disposition: inline
In-Reply-To: <20230211031821.976408-4-cristian.ciocaltea@collabora.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--sWezJbPTi7EG0f2m
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Feb 11, 2023 at 05:18:12AM +0200, Cristian Ciocaltea wrote:
> From: Emil Renner Berthing <kernel@esmil.dk>
>=20
> This adds support for the StarFive JH7100 SoC which also feature this
> SiFive cache controller.
>=20
> Unfortunately the interrupt for uncorrected data is broken on the JH7100
> and fires continuously, so add a quirk to not register a handler for it.
>=20
> Signed-off-by: Emil Renner Berthing <kernel@esmil.dk>
> [drop JH7110, rework Kconfig]
> Signed-off-by: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>

This driver doesn't really do very much of anything as things stand, so
I don't see really see all that much value in picking it up right now,
since the non-coherent bits aren't usable yet.

> ---
>  drivers/soc/sifive/Kconfig         |  1 +
>  drivers/soc/sifive/sifive_ccache.c | 11 ++++++++++-
>  2 files changed, 11 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/soc/sifive/Kconfig b/drivers/soc/sifive/Kconfig
> index e86870be34c9..867cf16273a4 100644
> --- a/drivers/soc/sifive/Kconfig
> +++ b/drivers/soc/sifive/Kconfig
> @@ -4,6 +4,7 @@ if SOC_SIFIVE || SOC_STARFIVE
> =20
>  config SIFIVE_CCACHE
>  	bool "Sifive Composable Cache controller"
> +	default SOC_STARFIVE

I don't think this should have a default set w/ the support that this
patch brings in. Perhaps later we should be doing defaulting, but not at
this point in the series.
Other than that, this is fine by me:
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>

Thanks,
Conor.

--sWezJbPTi7EG0f2m
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZAZ4EgAKCRB4tDGHoIJi
0qcEAP4r1H1KunxSPvzOIQ+psBjZf0GhVcU5HUKo2au2azIMUQD9H6CCIImWvFF5
+IBbmg9ik+sYw9HE7cIE67qmG8f03wQ=
=jWnP
-----END PGP SIGNATURE-----

--sWezJbPTi7EG0f2m--
