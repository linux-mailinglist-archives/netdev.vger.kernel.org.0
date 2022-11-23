Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A7EF636442
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 16:44:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238078AbiKWPoI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 10:44:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237959AbiKWPn7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 10:43:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9A9B32B8E;
        Wed, 23 Nov 2022 07:43:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4589061DBF;
        Wed, 23 Nov 2022 15:43:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EA89C433D6;
        Wed, 23 Nov 2022 15:43:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669218237;
        bh=StrD+dB5u8Vcvhdu1J0yzbIhWxVUSSaCEXA8q6qXH6M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EAcsGtHkQu0j8o/AsR1zQOSAMoHzYiGZzCNI192tK8toJkZFTEA0nHjzpVwOAki5W
         56d4OXjCoFbrdSL8iyRal3OFHPP6pg859dn4/blZFzsZ6+n1KVl5o3AsCJIWfZV2WB
         0UuOOMxX8k4XhCC8Uzw9P+V2Yzdj1gNie77riZ9riRgrYBVXGr9A0EDSKOaaprmppk
         7BLFa/SUfGSrFTlEPOo0uHvvkIwmA3T0OE15sUzNsZ61/FJlN7P0k3CAIVwEsbYToo
         H8WF/ULVWxmqPNEXqVK7PgU/gneXdXSopvxoaSudnfnHrqh31pfiNuZrpyXxqLhuXI
         dfGICcT33p5AQ==
Date:   Wed, 23 Nov 2022 15:43:46 +0000
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
        Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: Re: [PATCH v2 6/9] dt-bindings: drop redundant part of title (end,
 part three)
Message-ID: <Y34/sh0TQqyNOrZi@sirena.org.uk>
References: <20221121110615.97962-1-krzysztof.kozlowski@linaro.org>
 <20221121110615.97962-7-krzysztof.kozlowski@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="M0yaUN06E1HOYGuo"
Content-Disposition: inline
In-Reply-To: <20221121110615.97962-7-krzysztof.kozlowski@linaro.org>
X-Cookie: I'm rated PG-34!!
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--M0yaUN06E1HOYGuo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Nov 21, 2022 at 12:06:12PM +0100, Krzysztof Kozlowski wrote:
> The Devicetree bindings document does not have to say in the title that
> it is a "binding", but instead just describe the hardware.

Acked-by: Mark Brown <broonie@kernel.org>

--M0yaUN06E1HOYGuo
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmN+P7IACgkQJNaLcl1U
h9BvLwf+MbWgPhuuE/RNAOPtXpIBFmNsCUxYdu0csUjyJgNENFj+zdwqH6yI3/v5
sVYRJF6Ze/c9y1Pokpk0G+MobI3H0JfEA6zRId+Uxnf65RT46OZWAqStaZipWhR+
MqQJeau+/Wkq9EliMzXIY+Z1abRsNxFpOmxQfU6Kr85gGzubG6jqMBBQHSKS9a/3
Deso3bTySefdyuzX9lZss2JUAvomH8WP1F3J7w/FFiBXs4r+04kkd5sboUbL40Xk
9faUc2iAuQOUXtZ1O9P/qbpUmy+LhEMICPgGMN6SeU8G1af87tErxqa0p9c34Y35
t/bDc74sRhfEPZZhpmCN+J7XV65OAQ==
=yi41
-----END PGP SIGNATURE-----

--M0yaUN06E1HOYGuo--
