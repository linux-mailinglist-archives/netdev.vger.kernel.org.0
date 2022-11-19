Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31FD5630E4F
	for <lists+netdev@lfdr.de>; Sat, 19 Nov 2022 12:10:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232568AbiKSLKZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Nov 2022 06:10:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbiKSLKS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Nov 2022 06:10:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32F3F6B9E9;
        Sat, 19 Nov 2022 03:10:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 99C4960A1F;
        Sat, 19 Nov 2022 11:10:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 763BCC433C1;
        Sat, 19 Nov 2022 11:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668856217;
        bh=ene1SzTvsJEbW7r9yE4HzkF6rHfAR+aLIm+4UV/wgpo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AwWwg8hTEvU1lRotHevSh1bppQ+LWfLwM9aU/yyuaFSoeFCmSwjJ4hNXPYNKPqyxF
         RwoQt69tGMzjEml+0YwDwVnLfETtKSINebD6ZDDIjJG2YZ26iP67zsjgz4cgG6uGnz
         NeH6bx6FUo9hgiiy06aaBkM2k9pRw5peXY9fXGbpIdefsltNF4FVq05z66zkCjnicj
         f/YnghTN3aq/ykMs6EmMfO5tnMvkQz4JaZBC1pmyIfU8l5HPFc7Qkk3nYySibldc2a
         4zm4rXtEkUSkKLdGBy0DoGhHf7XI5Gph/tChnTnqwzMKjNhd3aisTxqnB1pP+2RhuX
         Z5WZrjjMLqJaQ==
Date:   Sat, 19 Nov 2022 12:10:11 +0100
From:   Wolfram Sang <wsa@kernel.org>
To:     Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <uwe@kleine-koenig.org>
Cc:     Angel Iglesias <ang.iglesiasg@gmail.com>,
        Lee Jones <lee.jones@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        linux-i2c@vger.kernel.org, kernel@pengutronix.de,
        linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-gpio@vger.kernel.org,
        Broadcom internal kernel review list 
        <bcm-kernel-feedback-list@broadcom.com>,
        linux-rpi-kernel@lists.infradead.org, linux-iio@vger.kernel.org,
        linux-input@vger.kernel.org, platform-driver-x86@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-leds@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-media@vger.kernel.org, patches@opensource.cirrus.com,
        linux-actions@lists.infradead.org,
        linux-renesas-soc@vger.kernel.org,
        linux-amlogic@lists.infradead.org, alsa-devel@alsa-project.org,
        linux-omap@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-mtd@lists.infradead.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, chrome-platform@lists.linux.dev,
        linux-pm@vger.kernel.org, Purism Kernel Team <kernel@puri.sm>,
        linux-pwm@vger.kernel.org, linux-rtc@vger.kernel.org,
        linux-spi@vger.kernel.org, linux-staging@lists.linux.dev,
        linux-serial@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-fbdev@vger.kernel.org, linux-watchdog@vger.kernel.org,
        openipmi-developer@lists.sourceforge.net
Subject: Re: [PATCH 000/606] i2c: Complete conversion to i2c_probe_new
Message-ID: <Y3i5kz6IL7tFbVwX@shikoro>
Mail-Followup-To: Wolfram Sang <wsa@kernel.org>,
        Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <uwe@kleine-koenig.org>,
        Angel Iglesias <ang.iglesiasg@gmail.com>,
        Lee Jones <lee.jones@linaro.org>,
        Grant Likely <grant.likely@linaro.org>, linux-i2c@vger.kernel.org,
        kernel@pengutronix.de, linux-integrity@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-gpio@vger.kernel.org,
        Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
        linux-rpi-kernel@lists.infradead.org, linux-iio@vger.kernel.org,
        linux-input@vger.kernel.org, platform-driver-x86@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-leds@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-media@vger.kernel.org, patches@opensource.cirrus.com,
        linux-actions@lists.infradead.org,
        linux-renesas-soc@vger.kernel.org,
        linux-amlogic@lists.infradead.org, alsa-devel@alsa-project.org,
        linux-omap@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-mtd@lists.infradead.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, chrome-platform@lists.linux.dev,
        linux-pm@vger.kernel.org, Purism Kernel Team <kernel@puri.sm>,
        linux-pwm@vger.kernel.org, linux-rtc@vger.kernel.org,
        linux-spi@vger.kernel.org, linux-staging@lists.linux.dev,
        linux-serial@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-fbdev@vger.kernel.org, linux-watchdog@vger.kernel.org,
        openipmi-developer@lists.sourceforge.net
References: <20221118224540.619276-1-uwe@kleine-koenig.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="xRatB1/o2GNYTDWD"
Content-Disposition: inline
In-Reply-To: <20221118224540.619276-1-uwe@kleine-koenig.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--xRatB1/o2GNYTDWD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Uwe,

> This series completes all drivers to this new callback (unless I missed
> something). It's based on current next/master.

Thanks for this work, really, but oh my poor inbox...

> I don't think it's feasable to apply this series in one go, so I ask the
> maintainers of the changed files to apply via their tree.

This seems reasonable. It would have made sense to send "patch series
per subsystem" then. So people only see the subset they are interested
in. I know filename-to-subsys mapping is hardly ever perfect. But in my
experience, even imperfect, it is more convenient than such a huge patch
series.

Happy hacking,

   Wolfram


--xRatB1/o2GNYTDWD
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAmN4uY8ACgkQFA3kzBSg
KbYEfw/+L6nVN4bUDqiN6AeU0yv+Wq/oAFkIUgM8TLT/4gzeEwPsCcTwHBaHQFEF
sO9yZWukjVYlt2YlcEZglBVIAl7Ha17oQfv2HbWzZXl4cv8PEMfodh6PuOpcPuna
P+RjiB40nPPxUt5hZ7EjiOpqML0Xy9G8X9Uzs5rA4Yt2OSXcGSYhCZb+U/Vygwlo
VmLhSQhUnluCyhMZlbTn+bnmVCSHW8Bk5YBKOWygj8K7/LRYKfcNKXjMV35OsBix
3rezawgwT9KZlZ6ABJZ6U/o5Lp91OP/XeUfhMp76fmAOBcrh25HhWcunmbfRNto7
gsYho2Ov6yLtz3/Gq4gsDB2HULSajZW1behtfyfufpmkyGd8+C5+/uUjfltWtpqm
qaAL4YC+kjzarFDRKtIINCqlixjh0VUUKCkf6c4IDCNoLD4HW5KGevjvMvG0kJ9S
ftPKDwBpZ+cMZtpTcYgRQRiEb30VekQVyWM8SL+350sLO2dVhy7tjAX1jTnWZ843
4L3c6tSTioFtNmuIREzKl4EX2xkZUq6ajI4QeAcleHXAsBKHB5kvDpfKYIfGZ49X
mvIEEWRaUXGZAyqx2tMBXvuSA2aL+Gk9hrW3cvCHoBh6EkGfa6R4flw7yN0RkYHR
Fzq+Jpg1jOHfQhNDoZ8yqFo2xQZQpp1oDdVAjW70IRrE5KPvV0k=
=eSNj
-----END PGP SIGNATURE-----

--xRatB1/o2GNYTDWD--
