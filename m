Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4DD327C538
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 13:33:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729465AbgI2Lcz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 07:32:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728989AbgI2Lap (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 07:30:45 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27DE8C0613E1
        for <netdev@vger.kernel.org>; Tue, 29 Sep 2020 04:30:45 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1kNDqE-0002GT-FF; Tue, 29 Sep 2020 13:30:42 +0200
Received: from [IPv6:2a03:f580:87bc:d400:feea:fa2e:c0c5:a14c] (unknown [IPv6:2a03:f580:87bc:d400:feea:fa2e:c0c5:a14c])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits)
         client-signature RSA-PSS (4096 bits))
        (Client CN "mkl@blackshift.org", Issuer "StartCom Class 1 Client CA" (not verified))
        (Authenticated sender: mkl@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 66B1456D5A0;
        Tue, 29 Sep 2020 11:30:41 +0000 (UTC)
To:     Joakim Zhang <qiangqing.zhang@nxp.com>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
References: <20200928180253.1454-1-qiangqing.zhang@nxp.com>
 <20200928180253.1454-2-qiangqing.zhang@nxp.com>
 <32c4ab0a-2e16-5cf2-5c26-7917d91f3429@pengutronix.de>
 <DB8PR04MB6795C370AFF065F239935F9FE6320@DB8PR04MB6795.eurprd04.prod.outlook.com>
From:   Marc Kleine-Budde <mkl@pengutronix.de>
Autocrypt: addr=mkl@pengutronix.de; prefer-encrypt=mutual; keydata=
 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
Subject: Re: [PATCH V3 1/3] can: flexcan: initialize all flexcan memory for
 ECC function
Message-ID: <95383b2d-698a-355f-2569-45e69bcbab0f@pengutronix.de>
Date:   Tue, 29 Sep 2020 13:30:37 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <DB8PR04MB6795C370AFF065F239935F9FE6320@DB8PR04MB6795.eurprd04.prod.outlook.com>
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="iO6VpddatKVQ6j87ANMG1MjqWXG6pGOAM"
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--iO6VpddatKVQ6j87ANMG1MjqWXG6pGOAM
Content-Type: multipart/mixed; boundary="yj8znetbrbEDzOA38xDH0nWsnvM8Jr5hF";
 protected-headers="v1"
From: Marc Kleine-Budde <mkl@pengutronix.de>
To: Joakim Zhang <qiangqing.zhang@nxp.com>,
 "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>
Cc: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
 dl-linux-imx <linux-imx@nxp.com>
Message-ID: <95383b2d-698a-355f-2569-45e69bcbab0f@pengutronix.de>
Subject: Re: [PATCH V3 1/3] can: flexcan: initialize all flexcan memory for
 ECC function
References: <20200928180253.1454-1-qiangqing.zhang@nxp.com>
 <20200928180253.1454-2-qiangqing.zhang@nxp.com>
 <32c4ab0a-2e16-5cf2-5c26-7917d91f3429@pengutronix.de>
 <DB8PR04MB6795C370AFF065F239935F9FE6320@DB8PR04MB6795.eurprd04.prod.outlook.com>
In-Reply-To: <DB8PR04MB6795C370AFF065F239935F9FE6320@DB8PR04MB6795.eurprd04.prod.outlook.com>

--yj8znetbrbEDzOA38xDH0nWsnvM8Jr5hF
Content-Type: text/plain; charset=utf-8
Content-Language: de-DE
Content-Transfer-Encoding: quoted-printable

On 9/29/20 1:27 PM, Joakim Zhang wrote:
> [...]
>>> +	reg_ctrl2 =3D priv->read(&regs->ctrl2);
>>> +	reg_ctrl2 |=3D FLEXCAN_CTRL2_WRMFRZ;
>>> +	priv->write(reg_ctrl2, &regs->ctrl2);
>>> +
>>> +	/* ranging from 0x0080 to 0x0ADF, ram details as below list:
>>> +	 * 0x0080--0x087F:	128 MBs
>>> +	 * 0x0880--0x0A7F:	128 RXIMRs
>>> +	 * 0x0A80--0x0A97:	6 RXFIRs
>>> +	 * 0x0A98--0x0A9F:	Reserved
>>> +	 * 0x0AA0--0x0AA3:	RXMGMASK
>>> +	 * 0x0AA4--0x0AA7:	RXFGMASK
>>> +	 * 0x0AA8--0x0AAB:	RX14MASK
>>> +	 * 0x0AAC--0x0AAF:	RX15MASK
>>> +	 * 0x0AB0--0x0ABF:	TX_SMB
>>> +	 * 0x0AC0--0x0ACF:	RX_SMB0
>>> +	 * 0x0AD0--0x0ADF:	RX_SMB1
>>
>> I don't like to have the register definition here *again), we have str=
uct
>> flexcan_regs for this.
>=20
> Do you mean still move these register definitions into flexcan_regs, ri=
ght?

ack

>>> +	 */
>>> +	memset_io((void __iomem *)regs + 0x80, 0, 0xadf - 0x80 + 1);
>>
>> why the cast?
>=20
> Yes, no need, will remove it.
>=20
>> Can you use the "&regs->foo - &regs->bar + x" to get the length for th=
e
>> memset?
>=20
> After move above register definition into flexcan_regs, I can change to=
 use
> this way to get the length for the memset_io.

ACK

>>> +
>>> +	/* ranging from 0x0F28 to 0x0FFF when CAN FD feature is enabled,
>>> +	 * ram details as below list:
>>> +	 * 0x0F28--0x0F6F:	TX_SMB_FD
>>> +	 * 0x0F70--0x0FB7:	RX_SMB0_FD
>>> +	 * 0x0FB8--0x0FFF:	RX_SMB0_FD
>>> +	 */
>>> +	memset_io((void __iomem *)regs + 0xf28, 0, 0xfff - 0xf28 + 1);
>>
>> same here
>=20
> Will change.

tnx

> Hi Marc, I'm going on holiday from tomorrow, so I would delay to send o=
ut a
> V4 to review until I come back, sorry for this. Thanks for your comment=
s of
> "can: flexcan: add CAN wakeup function for i.MX8", will rework the patc=
h
> later.

Fine with me, I think we can push these changes via net to v5.10 after th=
e v5.9
release is out.

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |


--yj8znetbrbEDzOA38xDH0nWsnvM8Jr5hF--

--iO6VpddatKVQ6j87ANMG1MjqWXG6pGOAM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAl9zGt0ACgkQqclaivrt
76mXBggAi8B0u2NZkxBnC5Vc7qq4WSdXuf8obnOlNyiLXZwgM8Lg6T5LOTFSKnOW
A/uQRF8Low1CHD0z/W0/9YPOYIvur7io3Y73SltVIohdLWH4iR4+z3FcG5t5HPCu
0sSsIbRpsjE9lqAFcohFltHG/qa35x3NVaUGDFrMi1c4JvmXO7OnfNPT5Mg+Fn+v
Iz8EJUUmVIFIxvPMOiFyw/e4LTc6LyuHT6+K5r7YV6asXWAWjydfOZ4hfPL7tcFb
iTngAcmhbUIIsSp2d74z2sG6Xgu8WXbyAjeBtWtAhfXX+RErSFcA09ZPoy7PyDe2
HCghhrpOGvzS3NqhKk8XXgtuMQuSjA==
=MVop
-----END PGP SIGNATURE-----

--iO6VpddatKVQ6j87ANMG1MjqWXG6pGOAM--
