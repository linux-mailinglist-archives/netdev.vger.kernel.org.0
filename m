Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D36106A6200
	for <lists+netdev@lfdr.de>; Tue, 28 Feb 2023 22:59:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229841AbjB1V7K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Feb 2023 16:59:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229885AbjB1V7D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Feb 2023 16:59:03 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C8E11E9E4;
        Tue, 28 Feb 2023 13:59:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D907BB80DE7;
        Tue, 28 Feb 2023 21:58:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AB95C4339B;
        Tue, 28 Feb 2023 21:58:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677621538;
        bh=EApezt/xrKSUqcwtPB/lYFfV3ScYq2GN1UtJeJ9Yc+c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cUYRfMKeK+p4AXiL2yRjGGOTvS01vXKugWnhKFkzYTZRH2viq9VagyHHpn9RYO06E
         7161gTVDpaIwYbqDcrlmVPN0o/cugLq/+gDN1auuBxF/uZPh9OpMPhpNLHF+53h7/f
         DoT1TtdWlebJgWhfw4OQoDjoiCvi0XiuNGbnLek0xsWC1Yu/OVJnYFJLHZprcXRPiC
         7v5WbvF/tLxYWQO6MfSWwUmY8KP3GIJ8Wrz1RAHaWryhlvgwMlV6ERJb7McemY4aKl
         vDe/gg3FPRtgYCN2VZVVoHhp+1BFL8FRLCFU2j+s5qzK8bnhmFkzpbIMlP6wDedOvJ
         P7W07HuSh0APg==
Date:   Tue, 28 Feb 2023 21:58:55 +0000
From:   Mark Brown <broonie@kernel.org>
To:     Rob Herring <robh@kernel.org>
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        devicetree@vger.kernel.org, Miguel Ojeda <ojeda@kernel.org>,
        Benson Leung <bleung@chromium.org>,
        Guenter Roeck <groeck@chromium.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Andrzej Hajda <andrzej.hajda@intel.com>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Robert Foss <rfoss@kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Sam Ravnborg <sam@ravnborg.org>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Pavel Machek <pavel@ucw.cz>, Lee Jones <lee@kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Kalle Valo <kvalo@kernel.org>,
        Sebastian Reichel <sre@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-clk@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-gpio@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
        netdev@vger.kernel.org, linux-can@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-pm@vger.kernel.org,
        alsa-devel@alsa-project.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH] dt-bindings: Fix SPI and I2C bus node names in examples
Message-ID: <Y/55H2lZZf7a3Xbu@sirena.org.uk>
References: <20230228215433.3944508-1-robh@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="MyLQObbLmZa89Gv8"
Content-Disposition: inline
In-Reply-To: <20230228215433.3944508-1-robh@kernel.org>
X-Cookie: Single tasking: Just Say No.
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--MyLQObbLmZa89Gv8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Feb 28, 2023 at 03:54:33PM -0600, Rob Herring wrote:
> SPI and I2C bus node names are expected to be "spi" or "i2c",
> respectively, with nothing else, a unit-address, or a '-N' index. A
> pattern of 'spi0' or 'i2c0' or similar has crept in. Fix all these
> cases. Mostly scripted with the following commands:

Acked-by: Mark Brown <broonie@kernel.org>

--MyLQObbLmZa89Gv8
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmP+eR4ACgkQJNaLcl1U
h9DqWQf/fzAqwVcR5vEvDlZIOyeJ93q74mz/Rl0dA1kXgtn8VCrgOTQv1BlYjrCE
YSIOVaCA5NiKGfDp99bOWw61eY5vrMwgY1dL8JB2fdMVGhAnk4dN0ewMN2lc2Zxs
/aZeYDxjeMRJOEv+9UinuEKROblNzSwDJFxyTFoOddlrYg7leB2icMBQRsd3m5+h
Thr8sNClvv0OyNBx5LchcIvla+hu2AAQSAvLHe/Q0aUCOGooYIUsdfDeNqNJa6vF
7wjeN3etYc7wp/PyeJKwrO9AhmkCXzazy4OwW4esqLUxQEO88PTJxkHJjNW+tvu3
lFl5XDtQUMJ9ACGlaRM0sEP28dPf5w==
=8se/
-----END PGP SIGNATURE-----

--MyLQObbLmZa89Gv8--
