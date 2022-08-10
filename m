Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7435058EC25
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 14:38:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231924AbiHJMii (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 08:38:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232080AbiHJMib (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 08:38:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89C7C83F1D;
        Wed, 10 Aug 2022 05:38:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 29393B81C44;
        Wed, 10 Aug 2022 12:38:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47DA7C433D6;
        Wed, 10 Aug 2022 12:38:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660135107;
        bh=vPpn+dGLzKb7Sc6Czii2tdPohCYiVuar8IVF4AUuPeQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KqEAwT2EOk+jDmHldnh6OQGmRp3C1Bt+kOGg/vQZDwNgQ95yt0/UllzC1sypkM381
         VoVi47u2MxCTA2tW8qWivLBlk+l00O/4JLVXJ3cvwGzmntQ0Oq7uBsfiIzvJ9iTazK
         ghO5qoaVrVkpq2fKn5AOGDJslZn5bROZXmJXdM2iJgVRsDv+UEzm9q8JxCkuoXWRkU
         IFqY0XuBXi+3K/umTuNQcWvaxnbZIFO6vWxcyNt4UroEWmihU0qT23Npd0wmj31cDU
         58V28sw+rBdPnA5z4ccojXUEWkaIckAAAA523IY012rVUYgB9i+wLLer4nQdFIG8sn
         mY8IBclIh+1Eg==
Date:   Wed, 10 Aug 2022 13:38:19 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     Michael Hennerich <Michael.Hennerich@analog.com>,
        Jean Delvare <jdelvare@suse.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Jonathan Cameron <jic23@kernel.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Pavel Machek <pavel@ucw.cz>,
        Tim Harvey <tharvey@gateworks.com>, Lee Jones <lee@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Sebastian Reichel <sre@kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Andrew Davis <afd@ti.com>,
        linux-hwmon@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-fbdev@vger.kernel.org, linux-leds@vger.kernel.org,
        netdev@vger.kernel.org, linux-pm@vger.kernel.org,
        alsa-devel@alsa-project.org
Subject: Re: [PATCH v2 5/5] dt-bindings: Drop Dan Murphy and Ricardo
 Rivera-Matos
Message-ID: <YvOmu3KvVl5xxtgY@sirena.org.uk>
References: <20220809162752.10186-1-krzysztof.kozlowski@linaro.org>
 <20220809162752.10186-6-krzysztof.kozlowski@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="IEszeuZxEA7/bbtR"
Content-Disposition: inline
In-Reply-To: <20220809162752.10186-6-krzysztof.kozlowski@linaro.org>
X-Cookie: First pull up, then pull down.
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--IEszeuZxEA7/bbtR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Aug 09, 2022 at 07:27:52PM +0300, Krzysztof Kozlowski wrote:
> Emails to Dan Murphy and Ricardo Rivera-Matos bounce ("550 Invalid
> recipient").  Andrew Davis agreed to take over the bindings.

Acked-by: Mark Brown <broonie@kernel.org>

--IEszeuZxEA7/bbtR
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmLzproACgkQJNaLcl1U
h9Btywf/Ylfto3rP12Is+BQJ2PghIgdBExy5qdKGCvvgKFln7xaTTlF3RaoXLQ0d
VAqhXaSdvHBsHgWzJ8c/B9p71/s7K5CXfcIrGeVm2OY9ZH2Cows3vqURj5tO5/FE
sEhZRrwYC2bI4okDihJglpf7HSCZT6OjniTKbc7sk3HP3W77xpCu9VPLfBCDreh0
WI0Uu3/vVOEsDt4IgAHXlqNqbRjQD2Rhwesx2PRPNpzrI7hCZ+qHORgTFlD7Qx3F
Qa8wcybPT0S6C5o/et9+rajj4M4plbo6uNxd9B4rrTYzLMUDZsMwZOpTkCiMhz7F
lgDRHQHDel322uDH+eBVQB/Aum7p+g==
=2qBa
-----END PGP SIGNATURE-----

--IEszeuZxEA7/bbtR--
