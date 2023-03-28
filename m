Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 361C16CBCDE
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 12:50:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232710AbjC1Kt6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 06:49:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232782AbjC1Ktn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 06:49:43 -0400
Received: from relay6-d.mail.gandi.net (relay6-d.mail.gandi.net [217.70.183.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D4C183D2;
        Tue, 28 Mar 2023 03:49:32 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 5D4C3C000C;
        Tue, 28 Mar 2023 10:49:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1680000571;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DZwbjwApUPbEAxWyjzNQKcxlg9HxjXUPAgc9lcUn1TA=;
        b=B+jjP1kbZq2i/Le+7MOBlB7hrooY4SX7tCFLCTFSNpG1ToNUo/E+TT62mIBQ7fKqHNz3DG
        3aflaq7ytMEMHOgtIBoJR5OjPm0LwI4lE96xzBWHxdyL1gIKHGEIhaZF73BIR8xF2nRWa0
        LzWJHoxzoysjDKXVoqITeYIYO/UVnRhhr4WFFv9i4tUaticYQBj0CbxXQIrgYtT3ECkPkM
        +S9amzJuXTUitK/RMbu3nATsG/wF4YqF5JNhV3SzyHBHntalSa8Urny+CdCsBUDMIOzT+i
        XV0BL5gjqwFUgKXgIlY3JUY60rSfpoD5jKaCv4mfO9rpnYvP9F+Ox3606O24uw==
Date:   Tue, 28 Mar 2023 12:49:26 +0200
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        Michael Hennerich <michael.hennerich@analog.com>,
        Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-wpan@vger.kernel.org
Subject: Re: [PATCH 11/12] net: ieee802154: adf7242: drop owner from driver
Message-ID: <20230328124926.0a1375d4@xps-13>
In-Reply-To: <20230311173303.262618-11-krzysztof.kozlowski@linaro.org>
References: <20230311173303.262618-1-krzysztof.kozlowski@linaro.org>
        <20230311173303.262618-11-krzysztof.kozlowski@linaro.org>
Organization: Bootlin
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Krzysztof,

krzysztof.kozlowski@linaro.org wrote on Sat, 11 Mar 2023 18:33:02 +0100:

> Core already sets owner in spi_driver.
>=20
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

Same here:

Acked-by: Miquel Raynal <miquel.raynal@bootlin.com>

> ---
>  drivers/net/ieee802154/adf7242.c | 1 -
>  1 file changed, 1 deletion(-)
>=20
> diff --git a/drivers/net/ieee802154/adf7242.c b/drivers/net/ieee802154/ad=
f7242.c
> index 509acc86001c..f9972b8140f9 100644
> --- a/drivers/net/ieee802154/adf7242.c
> +++ b/drivers/net/ieee802154/adf7242.c
> @@ -1338,7 +1338,6 @@ static struct spi_driver adf7242_driver =3D {
>  	.driver =3D {
>  		   .of_match_table =3D adf7242_of_match,
>  		   .name =3D "adf7242",
> -		   .owner =3D THIS_MODULE,
>  		   },
>  	.probe =3D adf7242_probe,
>  	.remove =3D adf7242_remove,


Thanks,
Miqu=C3=A8l
