Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10A256364D6
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 16:53:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238955AbiKWPxw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 10:53:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238785AbiKWPxB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 10:53:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 121AC5A6EA;
        Wed, 23 Nov 2022 07:52:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 73E2E61DD9;
        Wed, 23 Nov 2022 15:52:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F5EEC43144;
        Wed, 23 Nov 2022 15:52:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669218776;
        bh=ZtsEDAGH6M1Hm2mKwIp+nkyl3EOfULlsa+PR5Jh+/yY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aCYae1otHmgUnvQhYydPYexYhzz0miYjM4zpf8c2mnxAms5CtVYUfAM7tWuXKgBlL
         NCzjlOivqXZ6UqIGFo6Q3BntqxLP3hoWG6T432NPpsWDwgRF2tNVlSSreyLi6w5epT
         5yRu6zDAJOHqLx2PKvtXWr2dbpMJrrYdASELSXDQ7oXGnQVROdJjqD20wCxJmK/TbF
         LxosEZjoFf2ROozxpxjVeaVFcuzQLwzX93rS2p4/AwotUvzWq5hYJvRgCJVOQBQ8wc
         Y+r3iBPxcrfDRitsbVrK4soZK4ULKoO7A7tHxHwHfbIwT8fluQgTwO6NOBHUOHbov+
         PWGuJ73a1veDQ==
Date:   Wed, 23 Nov 2022 15:52:45 +0000
From:   Mark Brown <broonie@kernel.org>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-clk@vger.kernel.org, linux-riscv@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-gpio@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-input@vger.kernel.org, linux-leds@vger.kernel.org,
        linux-media@vger.kernel.org, linux-mips@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-mtd@lists.infradead.org,
        netdev@vger.kernel.org, linux-can@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-pwm@vger.kernel.org,
        linux-rtc@vger.kernel.org, linux-serial@vger.kernel.org,
        alsa-devel@alsa-project.org, linux-spi@vger.kernel.org,
        linux-usb@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-watchdog@vger.kernel.org, Stephen Boyd <sboyd@kernel.org>,
        Vinod Koul <vkoul@kernel.org>,
        Jonathan Cameron <jic23@kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Viresh Kumar <vireshk@kernel.org>,
        Sebastian Reichel <sre@kernel.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: Re: [PATCH v2 9/9] dt-bindings: drop redundant part of title (manual)
Message-ID: <Y35BzU80hf36eRyo@sirena.org.uk>
References: <20221121110615.97962-1-krzysztof.kozlowski@linaro.org>
 <20221121110615.97962-10-krzysztof.kozlowski@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="QAOhPtWQs4kr9fZE"
Content-Disposition: inline
In-Reply-To: <20221121110615.97962-10-krzysztof.kozlowski@linaro.org>
X-Cookie: I'm rated PG-34!!
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--QAOhPtWQs4kr9fZE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Nov 21, 2022 at 12:06:15PM +0100, Krzysztof Kozlowski wrote:
> The Devicetree bindings document does not have to say in the title that
> it is a "Devicetree binding" or a "schema", but instead just describe
> the hardware.

Acked-by: Mark Brown <broonie@kernel.org>

--QAOhPtWQs4kr9fZE
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmN+QcwACgkQJNaLcl1U
h9AXjAf8DK+4g+6i+PYcdDNKGnFY/1uo0vNGE7MKgsNgIAMn42Y9Tw++ts0ZwHYw
EDuQqMblUcsp9NKWMs1LVsvQ2YGAbZUXjgUzWpiImszGWwmUf6DZkjwNojGA5ngh
GAGhKyUYUGXRb0MKJ1X4O3pobituSQSnz8UWlDrpBOO2OiWnWvdbURWlhNYNqMSm
70ahwExSo8nv/Dxkvf+GV0FHLToE5K4JZxqRh/Gn0l0206IYzY4jvEbCq0DEuZPH
Jt7Az6phpVvce86sAHnvukNdIa0EQ/8pR+v9idvZiGVY5NJvdJA54BR+1AoXlMna
RQueknzjRrsbdQSr0xa/wr8lQW5rpw==
=Wum3
-----END PGP SIGNATURE-----

--QAOhPtWQs4kr9fZE--
