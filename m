Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EDCE4B1E79
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 07:16:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237269AbiBKGPC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 01:15:02 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:56880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240332AbiBKGO5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 01:14:57 -0500
X-Greylist: delayed 310 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 10 Feb 2022 22:14:56 PST
Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B60FD5F71
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 22:14:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1644560094;
        bh=UcMqKg8/lHoUaA1L/FnQpr6E2HfUHEEM01YhIMbo3DM=;
        h=X-UI-Sender-Class:Date:In-Reply-To:References:Subject:Reply-to:To:
         CC:From;
        b=dnmz7bO2zCR9X352hpII0akYAYb1ZAEpw3LFDJBXn6mKbsDU/0ow43673l0QnNRrS
         tLvf2gzcj+iR1HHEm9ZLROiOJCh4nj13MLnwk+IO1zy4YHqyDgHKkmIMt5/1ZTFwAS
         1QqZX6QHxPEb6r8o+C0qetxpxpRqc21gWZQ72RI8=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from frank-s9 ([217.61.154.74]) by mail.gmx.net (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MFbVu-1nXBu33NjK-00H6Ci; Fri, 11
 Feb 2022 07:09:29 +0100
Date:   Fri, 11 Feb 2022 07:09:25 +0100
User-Agent: K-9 Mail for Android
In-Reply-To: <20220211051403.3952-1-luizluca@gmail.com>
References: <20220211051403.3952-1-luizluca@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH net-next] net: dsa: realtek: realtek-mdio: reset before setup
Reply-to: frank-w@public-files.de
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        netdev@vger.kernel.org
CC:     linus.walleij@linaro.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, davem@davemloft.net,
        kuba@kernel.org, alsi@bang-olufsen.dk, arinc.unal@arinc9.com
From:   Frank Wunderlich <frank-w@public-files.de>
Message-ID: <43326919-9721-4150-A5D4-AAFDB8F5CD27@public-files.de>
X-Provags-ID: V03:K1:3+3XwKWcWg97YZ2razLB/wI7JeIDP7ze2+atyMWtHnZJaeelipO
 y0HwPMLTCLNqdg7kCol802LWOSxD6EZbnkseDpBf7RoIbq4XKqg65FjVBXZdibz/KAiO8x8
 iPCMSfLQHJ3+HhG+2fdACwNvdwDDDdKSbsMKwyr0DwAEJShFMXnZoZwWEGc0SSJkW1G3pgh
 b4Fe5RxjaxZsJeH3rUj0A==
X-UI-Out-Filterresults: notjunk:1;V03:K0:tcMANmoXKiw=:9foOhSOzJiAKiXmqS+pcC6
 5oaZsi7yHGqniHHgo1lzmVBdkjJ401ZLVoe25MHa3AxIvjTZAwdUT3ye12qdRbg9fscoYjIi6
 TAju6P9l3+/BbyxIm6pE4ILdP5OMyg4s+bUFknKfX3Ua2iDvWQNl0vXu1aOrNPogv5ktIP9/1
 s68g6pMbRqCPRPjLdwfTGrhMYEG9BY/5zuhcHQcKaPcOaTqkhVJ5zpaHs2IG3Taz5wpDOKTW4
 3qQTc5l3nOK3buyan1K3QnjiHpdbLjX8+pOp8PAhE80d6NFCkp7cb8JYpCpzyLtWtWXSb7YCH
 OF8oJLOu3tmNLD+wvoTfq3sgLer7i5fG506XrzZoIhuffnGz5p5z3QWAyqJDVe0ML/oSmvgBx
 OmMBIKAXxbTbbh52G1of4OYezEoqcrzT375T/RK7MG+8gIZg5+oSnl7qvl+4/MPKHZn8tPKAJ
 3yR5yYuo4JQKe964QDudemGaMnG2OOS+szFBWeE0+ACoPcPHwC4+F2ajZNQmSezu4WffsdyNI
 kY0hLObfiIvO7x88mq47NH+9eah9Hj3fa1J5LUfsq4sWoZ/LSnRhjwW/v9ATRGfFBUSH8mssJ
 z/0nzHVpkwJTksrEf+hDTUyJqiRqjqjIOBAPkuxAH+SMzCFYl/rWDBYkkcTEOwhB3ZJvB1BWt
 0C6MmbruGRgvsJ/Z6xQl2GWhex0BxJRICqw0U/5iVACRYLzsZmUAma42Q+WQGTU/4f7osk2m2
 2qZpPlq6wciKLfa7x4dcsUQqQdRhnb6i0OGgrN8MvGag5G7Tm0har8INiAzevxfiK6Ce2rfM7
 gs87ivldMBeyQ/yuyk6IQ0yEiMvPBR/AoMAklDSly7jKeUWv+Vcmzh6LwwHWjTRiHgQZJXraX
 GJ8O19tCeYjhKrdu5W3HWPzn9pLfmUJncQsJDaV6eUm2EBK0JnEv4meaa6WI8VDFOvLKl2leT
 s/YnBLEUczfxuWPiMU32JL64NFYhH5Fg1HS8Mu8Q0s9Ewbm+K4B2272VIVsZ2CTQ1CCKNug5d
 BgugT6/VAaKVduBGeKqkyYRLP5QD9XZp3A9QBim31fdKMTzd0Gfk/0B3/3iFGbfbCuBI3zdp/
 SqzJhXMvMqmWMA=
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 11=2E Februar 2022 06:14:04 MEZ schrieb Luiz Angelo Daros de Luca <luizl=
uca@gmail=2Ecom>:
>Some devices, like the switch in Banana Pi BPI R64 only starts to
>answer
>after a HW reset=2E It is the same reset code from realtek-smi=2E
>
>Reported-by: Frank Wunderlich <frank-w@public-files=2Ede>
>Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail=2Ecom>
>---
> drivers/net/dsa/realtek/realtek-mdio=2Ec | 19 +++++++++++++++++++
> drivers/net/dsa/realtek/realtek-smi=2Ec  |  6 ++----
> drivers/net/dsa/realtek/realtek=2Eh      |  9 ++++++---
> 3 files changed, 27 insertions(+), 7 deletions(-)
>
>diff --git a/drivers/net/dsa/realtek/realtek-mdio=2Ec
>b/drivers/net/dsa/realtek/realtek-mdio=2Ec
>index e6e3c1769166=2E=2E78b419a6cb01 100644
>--- a/drivers/net/dsa/realtek/realtek-mdio=2Ec
>+++ b/drivers/net/dsa/realtek/realtek-mdio=2Ec
>@@ -152,6 +152,21 @@ static int realtek_mdio_probe(struct mdio_device
>*mdiodev)
>	/* TODO: if power is software controlled, set up any regulators here
>*/
>	priv->leds_disabled =3D of_property_read_bool(np,
>"realtek,disable-leds");
>=20
>+	/* Assert then deassert RESET */
>+	priv->reset =3D devm_gpiod_get_optional(dev, "reset", GPIOD_OUT_HIGH);
>+	if (IS_ERR(priv->reset)) {
>+		dev_err(dev, "failed to get RESET GPIO\n");
>+		return PTR_ERR(priv->reset);
>+	}
>+
>+	if (priv->reset) {
>+		dev_info(dev, "asserted RESET\n");
>+		msleep(REALTEK_HW_STOP_DELAY);
>+		gpiod_set_value(priv->reset, 0);
>+		msleep(REALTEK_HW_START_DELAY);
>+		dev_info(dev, "deasserted RESET\n");
>+	}
>+
> 	ret =3D priv->ops->detect(priv);
> 	if (ret) {
> 		dev_err(dev, "unable to detect switch\n");
>@@ -183,6 +198,10 @@ static void realtek_mdio_remove(struct mdio_device
>*mdiodev)
> 	if (!priv)
> 		return;
>=20
>+	/* leave the device reset asserted */
>+	if (priv->reset)
>+		gpiod_set_value(priv->reset, 1);
>+
> 	dsa_unregister_switch(priv->ds);
>=20
> 	dev_set_drvdata(&mdiodev->dev, NULL);
>diff --git a/drivers/net/dsa/realtek/realtek-smi=2Ec
>b/drivers/net/dsa/realtek/realtek-smi=2Ec
>index a849b5cbb4e4=2E=2Ecada5386f6a2 100644
>--- a/drivers/net/dsa/realtek/realtek-smi=2Ec
>+++ b/drivers/net/dsa/realtek/realtek-smi=2Ec
>@@ -43,8 +43,6 @@
> #include "realtek=2Eh"
>=20
> #define REALTEK_SMI_ACK_RETRY_COUNT		5
>-#define REALTEK_SMI_HW_STOP_DELAY		25	/* msecs */
>-#define REALTEK_SMI_HW_START_DELAY		100	/* msecs */
>=20
> static inline void realtek_smi_clk_delay(struct realtek_priv *priv)
> {
>@@ -426,9 +424,9 @@ static int realtek_smi_probe(struct platform_device
>*pdev)
> 		dev_err(dev, "failed to get RESET GPIO\n");
> 		return PTR_ERR(priv->reset);
> 	}
>-	msleep(REALTEK_SMI_HW_STOP_DELAY);
>+	msleep(REALTEK_HW_STOP_DELAY);
> 	gpiod_set_value(priv->reset, 0);
>-	msleep(REALTEK_SMI_HW_START_DELAY);
>+	msleep(REALTEK_HW_START_DELAY);
> 	dev_info(dev, "deasserted RESET\n");
>=20
> 	/* Fetch MDIO pins */
>diff --git a/drivers/net/dsa/realtek/realtek=2Eh
>b/drivers/net/dsa/realtek/realtek=2Eh
>index ed5abf6cb3d6=2E=2Ee7d3e1bcf8b8 100644
>--- a/drivers/net/dsa/realtek/realtek=2Eh
>+++ b/drivers/net/dsa/realtek/realtek=2Eh
>@@ -5,14 +5,17 @@
>  * Copyright (C) 2009-2010 Gabor Juhos <juhosg@openwrt=2Eorg>
>  */
>=20
>-#ifndef _REALTEK_SMI_H
>-#define _REALTEK_SMI_H
>+#ifndef _REALTEK_H
>+#define _REALTEK_H
>=20
> #include <linux/phy=2Eh>
> #include <linux/platform_device=2Eh>
> #include <linux/gpio/consumer=2Eh>
> #include <net/dsa=2Eh>
>=20
>+#define REALTEK_HW_STOP_DELAY		25	/* msecs */
>+#define REALTEK_HW_START_DELAY		100	/* msecs */
>+
> struct realtek_ops;
> struct dentry;
> struct inode;
>@@ -142,4 +145,4 @@ void rtl8366_get_ethtool_stats(struct dsa_switch
>*ds, int port, uint64_t *data);
> extern const struct realtek_variant rtl8366rb_variant;
> extern const struct realtek_variant rtl8365mb_variant;
>=20
>-#endif /*  _REALTEK_SMI_H */
>+#endif /*  _REALTEK_H */

Tested on Bpi-r64 v0=2E1=2E After this reset switch gets recognized=2E Bef=
ore mdio-read is always 0=2E

Tested-by: Frank Wunderlich <frank-w@public-files=2Ede>
regards Frank
