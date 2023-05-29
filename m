Return-Path: <netdev+bounces-6025-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8823171462A
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 10:12:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DC9D11C2097F
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 08:12:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 82B474696;
	Mon, 29 May 2023 08:12:20 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75E282112
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 08:12:20 +0000 (UTC)
Received: from relay3-d.mail.gandi.net (relay3-d.mail.gandi.net [217.70.183.195])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C2A890;
	Mon, 29 May 2023 01:12:16 -0700 (PDT)
X-GND-Sasl: miquel.raynal@bootlin.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
	t=1685347935;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gDcQFJJFfV1Siup4q6p4OZgQniQ046aFw0ogwoYkvUs=;
	b=IJcLwSpdqY/S84uOjPw4mCXhRQWiUo2wiEp6u12X0zgjXdUfl6QFEMfT6iSI4RpjDwgrr6
	zQpruIZUAGkBu8NkfM0mLoEglwlMO5gK4glbPp6jkOBwOpcr36RjULZNtXefw/qrjxZH5J
	d2EEfJUjcGDrcRllXYnasz8rittgSOac7nbyFdkRmDuNN++OPMBP9lJqZAvl+cxQtgKI+Q
	lQeYypHwFMI/3KfRmm1XMlIkRrK+UczFia+7js0ErmgoUGcUJK5t4YB7otsnwYts/X5VX9
	HBrBlL/prkHHBEUvMM4E6kUHaFQddwcRGAp7jsyPMx/9iSFwsQXXOlIPXMxjmw==
X-GND-Sasl: miquel.raynal@bootlin.com
X-GND-Sasl: miquel.raynal@bootlin.com
X-GND-Sasl: miquel.raynal@bootlin.com
X-GND-Sasl: miquel.raynal@bootlin.com
X-GND-Sasl: miquel.raynal@bootlin.com
X-GND-Sasl: miquel.raynal@bootlin.com
X-GND-Sasl: miquel.raynal@bootlin.com
X-GND-Sasl: miquel.raynal@bootlin.com
X-GND-Sasl: miquel.raynal@bootlin.com
Received: by mail.gandi.net (Postfix) with ESMTPSA id 2184660002;
	Mon, 29 May 2023 08:12:13 +0000 (UTC)
Date: Mon, 29 May 2023 10:12:13 +0200
From: Miquel Raynal <miquel.raynal@bootlin.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Stefan Schmidt <stefan@datenfreihafen.org>, linux-wpan@vger.kernel.org,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org, Alexander Aring
 <alex.aring@gmail.com>, "David S. Miller" <davem@davemloft.net>, Eric
 Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo
 Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next v1 1/1] ieee802154: ca8210: Remove stray
 gpiod_unexport() call
Message-ID: <20230529101213.46f4f2b1@xps-13>
In-Reply-To: <20230528140938.34034-1-andriy.shevchenko@linux.intel.com>
References: <20230528140938.34034-1-andriy.shevchenko@linux.intel.com>
Organization: Bootlin
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Andy,

andriy.shevchenko@linux.intel.com wrote on Sun, 28 May 2023 17:09:38
+0300:

> There is no gpiod_export() and gpiod_unexport() looks pretty much stray.
> The gpiod_export() and gpiod_unexport() shouldn't be used in the code,
> GPIO sysfs is deprecated. That said, simply drop the stray call.
>=20
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

Any reason not to consider a backport into stable kernels?
Cc: stable + Fixes would certainly be welcome in this case?

> ---
>  drivers/net/ieee802154/ca8210.c | 1 -
>  1 file changed, 1 deletion(-)
>=20
> diff --git a/drivers/net/ieee802154/ca8210.c b/drivers/net/ieee802154/ca8=
210.c
> index a2d242034220..f9b10e84de06 100644
> --- a/drivers/net/ieee802154/ca8210.c
> +++ b/drivers/net/ieee802154/ca8210.c
> @@ -2855,7 +2855,6 @@ static int ca8210_interrupt_init(struct spi_device =
*spi)
>  	);
>  	if (ret) {
>  		dev_crit(&spi->dev, "request_irq %d failed\n", pdata->irq_id);
> -		gpiod_unexport(gpio_to_desc(pdata->gpio_irq));
>  		gpio_free(pdata->gpio_irq);
>  	}
> =20


Thanks,
Miqu=C3=A8l

