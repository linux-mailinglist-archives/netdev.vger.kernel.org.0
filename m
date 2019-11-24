Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 366CF1082FA
	for <lists+netdev@lfdr.de>; Sun, 24 Nov 2019 11:48:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726825AbfKXKsZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Nov 2019 05:48:25 -0500
Received: from mo4-p02-ob.smtp.rzone.de ([81.169.146.169]:34320 "EHLO
        mo4-p02-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725980AbfKXKsY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Nov 2019 05:48:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1574592501;
        s=strato-dkim-0002; d=goldelico.com;
        h=To:References:Message-Id:Cc:Date:In-Reply-To:From:Subject:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=GGJ2DpglOTfvtp343vHN8wM7zSn3rwwNmq6U3UpQtmg=;
        b=ZRKz02jWOM2MrmUOZ91m2e8TjMiDqqr+Y+TouMkRpDwyXMhw71xjrQ1efjyEVnONbN
        0wXAs1AWRui+VK/SrMh+3di0JAGBBaFym6OEoWfyhgvj72v+WLtUTn5VO6Ora7IzQE62
        6bGMRxoYkZpG/eltyAjwkHHyUk1LqGkAWCqzRrKNR93xYLWr7l4cOTgZcJxguF/p8PsT
        zPfXT1WQrnkQVRHB17vdUBTRzc1h/CZPd4JpigXn2bfaOvsrFO5IngNPd9gpx+YSDs/k
        QeHKEnirTFPY/k3wBX88MPly2L040hZR3WZ7j9fScpnYUjW/XNX6BfIpy69b3qstxkcp
        cv4Q==
X-RZG-AUTH: ":JGIXVUS7cutRB/49FwqZ7WcJeFKiMgPgp8VKxflSZ1P34KBj5Qpw97WFDlSfXA4NgJM="
X-RZG-CLASS-ID: mo00
Received: from imac.fritz.box
        by smtp.strato.de (RZmta 44.29.0 DYNA|AUTH)
        with ESMTPSA id L09db3vAOAlxwA0
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (curve secp521r1 with 521 ECDH bits, eq. 15360 bits RSA))
        (Client did not present a certificate);
        Sun, 24 Nov 2019 11:47:59 +0100 (CET)
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Subject: Re: [PATCH 2/2] net: wireless: ti: wl1251: sdio: remove ti,power-gpio
From:   "H. Nikolaus Schaller" <hns@goldelico.com>
In-Reply-To: <e1f18e0f1401a0d8b07ccb176732a2e3f3a5732a.1574591746.git.hns@goldelico.com>
Date:   Sun, 24 Nov 2019 11:47:59 +0100
Cc:     linux-wireless@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        devicetree <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Discussions about the Letux Kernel 
        <letux-kernel@openphoenux.org>, kernel@pyra-handheld.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alexios Zavras <alexios.zavras@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Nikolaus Schaller <hns@goldelico.com>,
        Rob Herring <robh+dt@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Mark Rutland <mark.rutland@arm.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <56A8FB98-51B6-4CAC-9743-0A86DFE09CA8@goldelico.com>
References: <cover.1574591746.git.hns@goldelico.com> <e1f18e0f1401a0d8b07ccb176732a2e3f3a5732a.1574591746.git.hns@goldelico.com>
To:     Ulf Hansson <ulf.hansson@linaro.org>
X-Mailer: Apple Mail (2.3124)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> Am 24.11.2019 um 11:35 schrieb H. Nikolaus Schaller =
<hns@goldelico.com>:
>=20
> Remove handling of this property from code.
> Note that wl->power_gpio is still needed in
> the header file for SPI mode (N900).
>=20
> Suggested by: Ulf Hansson <ulf.hansson@linaro.org>
> Signed-off-by: H. Nikolaus Schaller <hns@goldelico.com>
> ---
> drivers/net/wireless/ti/wl1251/sdio.c | 30 ---------------------------
> 1 file changed, 30 deletions(-)
>=20
> diff --git a/drivers/net/wireless/ti/wl1251/sdio.c =
b/drivers/net/wireless/ti/wl1251/sdio.c
> index df0c20a555e3..82446196f9a8 100644
> --- a/drivers/net/wireless/ti/wl1251/sdio.c
> +++ b/drivers/net/wireless/ti/wl1251/sdio.c
> @@ -15,9 +15,7 @@
> #include <linux/wl12xx.h>
> #include <linux/irq.h>
> #include <linux/pm_runtime.h>
> -#include <linux/gpio.h>
> #include <linux/of.h>
> -#include <linux/of_gpio.h>
> #include <linux/of_irq.h>
>=20
> #include "wl1251.h"
> @@ -162,15 +160,6 @@ static int wl1251_sdio_set_power(struct wl1251 =
*wl, bool enable)
> printk("%s %d\n", __func__, enable);
>=20
> 	if (enable) {
> -		/*
> -		 * Power is controlled by runtime PM, but we still call =
board
> -		 * callback in case it wants to do any additional setup,
> -		 * for example enabling clock buffer for the module.
> -		 */
> -		if (gpio_is_valid(wl->power_gpio))
> -			gpio_set_value(wl->power_gpio, true);
> -
> -
> 		ret =3D pm_runtime_get_sync(&func->dev);
> 		if (ret < 0) {
> 			pm_runtime_put_sync(&func->dev);
> @@ -188,9 +177,6 @@ printk("%s %d\n", __func__, enable);
> 		ret =3D pm_runtime_put_sync(&func->dev);
> 		if (ret < 0)
> 			goto out;
> -
> -		if (gpio_is_valid(wl->power_gpio))
> -			gpio_set_value(wl->power_gpio, false);
> 	}
>=20
> out:
> @@ -245,27 +231,11 @@ printk("%s: of=3D%pOFcC\n", __func__, np);
>=20
> 	wl1251_board_data =3D wl1251_get_platform_data();
> 	if (!IS_ERR(wl1251_board_data)) {
> -		wl->power_gpio =3D wl1251_board_data->power_gpio;
> 		wl->irq =3D wl1251_board_data->irq;
> 		wl->use_eeprom =3D wl1251_board_data->use_eeprom;
> 	} else if (np) {
> 		wl->use_eeprom =3Dof_property_read_bool(np, =
"ti,wl1251-has-eeprom");
> -		wl->power_gpio =3D of_get_named_gpio(np, =
"ti,power-gpio", 0);
> 		wl->irq =3D of_irq_get(np, 0);
> -
> -		if (wl->power_gpio =3D=3D -EPROBE_DEFER || wl->irq =3D=3D =
-EPROBE_DEFER) {

^^^ spotted a bug myself... wl->irq check must not be removed.

Noted for v2.


> -			ret =3D -EPROBE_DEFER;
> -			goto disable;
> -		}
> -	}
> -
> -	if (gpio_is_valid(wl->power_gpio)) {
> -		ret =3D devm_gpio_request(&func->dev, wl->power_gpio,
> -								"wl1251 =
power");
> -		if (ret) {
> -			wl1251_error("Failed to request gpio: %d\n", =
ret);
> -			goto disable;
> -		}
> 	}
>=20
> 	if (wl->irq) {
> --=20
> 2.23.0
>=20

