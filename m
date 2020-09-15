Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4599226B0A3
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 00:16:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727707AbgIOWQs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 18:16:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727744AbgIOWQM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 18:16:12 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A88BC061788
        for <netdev@vger.kernel.org>; Tue, 15 Sep 2020 15:16:11 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1kIJF9-0008So-E5; Wed, 16 Sep 2020 00:16:07 +0200
Received: from [IPv6:2a03:f580:87bc:d400:8d0c:cfd0:3f99:a545] (unknown [IPv6:2a03:f580:87bc:d400:8d0c:cfd0:3f99:a545])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits)
         client-signature RSA-PSS (4096 bits))
        (Client CN "mkl@blackshift.org", Issuer "StartCom Class 1 Client CA" (not verified))
        (Authenticated sender: mkl@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 61AB25611C7;
        Tue, 15 Sep 2020 22:16:06 +0000 (UTC)
To:     Joakim Zhang <qiangqing.zhang@nxp.com>,
        Michael Walle <michael@walle.cc>
Cc:     "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <20200416093126.15242-1-qiangqing.zhang@nxp.com>
 <20200416093126.15242-2-qiangqing.zhang@nxp.com>
 <DB8PR04MB6795F7E28A9964A121A06140E6D80@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <d5579883c7e9ab3489ec08a73c407982@walle.cc>
 <39b5d77bda519c4d836f44a554890bae@walle.cc>
 <e38cf40b-ead3-81de-0be7-18cca5ca1a0c@pengutronix.de>
 <9dc13a697c246a5c7c53bdd89df7d3c7@walle.cc>
 <DB8PR04MB6795751DBB178E1EDF74136FE66F0@DB8PR04MB6795.eurprd04.prod.outlook.com>
From:   Marc Kleine-Budde <mkl@pengutronix.de>
Autocrypt: addr=mkl@pengutronix.de; prefer-encrypt=mutual; keydata=
 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
Subject: Re: [PATCH linux-can-next/flexcan] can: flexcan: fix TDC feature
Message-ID: <61489f52-84d5-e800-02f9-e40596e269ef@pengutronix.de>
Date:   Wed, 16 Sep 2020 00:16:02 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <DB8PR04MB6795751DBB178E1EDF74136FE66F0@DB8PR04MB6795.eurprd04.prod.outlook.com>
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="oktyPB2XaEkVQu5bljUrqPoWNIloAeCJn"
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--oktyPB2XaEkVQu5bljUrqPoWNIloAeCJn
Content-Type: multipart/mixed; boundary="nhgaP010P1WugN0YmumH3rp69KyfXv3Xe";
 protected-headers="v1"
From: Marc Kleine-Budde <mkl@pengutronix.de>
To: Joakim Zhang <qiangqing.zhang@nxp.com>, Michael Walle <michael@walle.cc>
Cc: "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
 dl-linux-imx <linux-imx@nxp.com>,
 "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Message-ID: <61489f52-84d5-e800-02f9-e40596e269ef@pengutronix.de>
Subject: Re: [PATCH linux-can-next/flexcan] can: flexcan: fix TDC feature
References: <20200416093126.15242-1-qiangqing.zhang@nxp.com>
 <20200416093126.15242-2-qiangqing.zhang@nxp.com>
 <DB8PR04MB6795F7E28A9964A121A06140E6D80@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <d5579883c7e9ab3489ec08a73c407982@walle.cc>
 <39b5d77bda519c4d836f44a554890bae@walle.cc>
 <e38cf40b-ead3-81de-0be7-18cca5ca1a0c@pengutronix.de>
 <9dc13a697c246a5c7c53bdd89df7d3c7@walle.cc>
 <DB8PR04MB6795751DBB178E1EDF74136FE66F0@DB8PR04MB6795.eurprd04.prod.outlook.com>
In-Reply-To: <DB8PR04MB6795751DBB178E1EDF74136FE66F0@DB8PR04MB6795.eurprd04.prod.outlook.com>

--nhgaP010P1WugN0YmumH3rp69KyfXv3Xe
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: quoted-printable

On 6/30/20 4:25 AM, Joakim Zhang wrote:
> I have also noticed this difference, although this could not break func=
tion,
> but IMO, using priv->can.ctrlmode should be better.
>=20
> Some nitpicks:
>
> 1) Can we use uniform check for HW which supports CAN FD in the driver,=
 using
> priv->can.ctrlmode_supported instead of quirks?>
> --- a/drivers/net/can/flexcan.c
> +++ b/drivers/net/can/flexcan.c
> @@ -1392,7 +1392,7 @@ static int flexcan_chip_start(struct net_device *=
dev)
>                 priv->write(reg_ctrl2, &regs->ctrl2);
>         }
>=20
> -       if ((priv->devtype_data->quirks & FLEXCAN_QUIRK_SUPPORT_FD)) {
> +       if (priv->can.ctrlmode_supported & CAN_CTRLMODE_FD) {

makes sense

>                 u32 reg_fdctrl;
>=20
>                 reg_fdctrl =3D priv->read(&regs->fdctrl);
>=20
> Also delete the redundant parentheses here.
>=20
> 2) Clean timing register.
> --- a/drivers/net/can/flexcan.c
> +++ b/drivers/net/can/flexcan.c
> @@ -1167,6 +1167,14 @@ static void flexcan_set_bittiming_cbt(const stru=
ct net_device *dev)
>         struct flexcan_regs __iomem *regs =3D priv->regs;
>         u32 reg_cbt, reg_fdctrl;
>=20
> +       reg_cbt =3D priv->read(&regs->cbt);
> +       reg_cbt &=3D ~(FLEXCAN_CBT_BTF |
> +               FIELD_PREP(FLEXCAN_CBT_EPRESDIV_MASK, 0x3ff) |
> +               FIELD_PREP(FLEXCAN_CBT_ERJW_MASK, 0x1f) |
> +               FIELD_PREP(FLEXCAN_CBT_EPROPSEG_MASK, 0x3f) |
> +               FIELD_PREP(FLEXCAN_CBT_EPSEG1_MASK, 0x1f) |
> +               FIELD_PREP(FLEXCAN_CBT_EPSEG2_MASK, 0x1f));
> +

Why is this needed? The "reg_cbt &=3D" sets reg_cbt basically to 0, as th=
e fields
and the BTF occupy all 32bit.

The only thing that's left over is the read()....

>         /* CBT */
>         /* CBT[EPSEG1] is 5 bit long and CBT[EPROPSEG] is 6 bit
>          * long. The can_calc_bittiming() tries to divide the tseg1
> @@ -1192,6 +1200,13 @@ static void flexcan_set_bittiming_cbt(const stru=
ct net_device *dev)
>         if (priv->can.ctrlmode & CAN_CTRLMODE_FD) {
>                 u32 reg_fdcbt;
>=20
> +               reg_fdcbt =3D priv->read(&regs->fdcbt);
> +               reg_fdcbt &=3D ~(FIELD_PREP(FLEXCAN_FDCBT_FPRESDIV_MASK=
, 0x3ff) |
> +                       FIELD_PREP(FLEXCAN_FDCBT_FRJW_MASK, 0x7) |
> +                       FIELD_PREP(FLEXCAN_FDCBT_FPROPSEG_MASK, 0x1f) |=

> +                       FIELD_PREP(FLEXCAN_FDCBT_FPSEG1_MASK, 0x7) |
> +                       FIELD_PREP(FLEXCAN_FDCBT_FPSEG2_MASK, 0x7));
> +

Okay, I'll add this, as the fdcbt contains some reserved bits...Let's pre=
serve them.

I've changed the setting of reg_fdcbt like this to make sense:

> -               reg_fdcbt =3D FIELD_PREP(FLEXCAN_FDCBT_FPRESDIV_MASK, d=
bt->brp - 1) |
> +               reg_fdcbt |=3D FIELD_PREP(FLEXCAN_FDCBT_FPRESDIV_MASK, =
dbt->brp - 1) |

thanks,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |


--nhgaP010P1WugN0YmumH3rp69KyfXv3Xe--

--oktyPB2XaEkVQu5bljUrqPoWNIloAeCJn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAl9hPSIACgkQqclaivrt
76k6ywf8CL2DTulCTb5oUza5T84JI4bu82tlKa74W7TPy24AFU0AHgCNAI7xRF23
yNokchx9mk3D3Emf0uZxG3JxeGd8OhHgmLwzk561vtOIZig+FNxIUuFDK8UcIiOI
1hgy4ABPkke9hG7W78tc2f9QTCDBDbkYTpr1G/WjeB4R/TDiJX41Xsj6nWuxcBeR
y76VvJZgb5HzR1tIwEeOj42kEwzUGIeh99cnWQxPugkhxlTUngSrFMzz5rHKdk2K
iOi/NXKMPHdFuE6T6Nice7ozPFcfmvM8mBk4xzHcStWBNt4DnzzArEaI4WndvAFs
BV9i4MUUOxrDR7mF0y1eeAIZ9GYwXQ==
=1TXd
-----END PGP SIGNATURE-----

--oktyPB2XaEkVQu5bljUrqPoWNIloAeCJn--
