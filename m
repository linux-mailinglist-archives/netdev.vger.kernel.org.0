Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2C4928DEC3
	for <lists+netdev@lfdr.de>; Wed, 14 Oct 2020 12:17:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727485AbgJNKRk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Oct 2020 06:17:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726028AbgJNKRk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Oct 2020 06:17:40 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63D12C061755
        for <netdev@vger.kernel.org>; Wed, 14 Oct 2020 03:17:40 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1kSdqi-00036B-Pd; Wed, 14 Oct 2020 12:17:36 +0200
Received: from [IPv6:2a03:f580:87bc:d400:3c11:afd4:9079:fce2] (unknown [IPv6:2a03:f580:87bc:d400:3c11:afd4:9079:fce2])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256
         client-signature RSA-PSS (4096 bits) client-digest SHA256)
        (Client CN "mkl@blackshift.org", Issuer "StartCom Class 1 Client CA" (not verified))
        (Authenticated sender: mkl@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id D58BD578EB3;
        Wed, 14 Oct 2020 10:17:29 +0000 (UTC)
To:     Joakim Zhang <qiangqing.zhang@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>
References: <20201007213159.1959308-1-mkl@pengutronix.de>
 <20201007213159.1959308-15-mkl@pengutronix.de>
 <DB8PR04MB6795CE6F83E1C25F8A04633FE6050@DB8PR04MB6795.eurprd04.prod.outlook.com>
From:   Marc Kleine-Budde <mkl@pengutronix.de>
Autocrypt: addr=mkl@pengutronix.de; prefer-encrypt=mutual; keydata=
 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
Subject: Re: [PATCH 14/17] can: flexcan: remove ack_grp and ack_bit handling
 from driver
Message-ID: <16223144-3d40-2e3b-52ef-08176a076ed5@pengutronix.de>
Date:   Wed, 14 Oct 2020 12:17:24 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <DB8PR04MB6795CE6F83E1C25F8A04633FE6050@DB8PR04MB6795.eurprd04.prod.outlook.com>
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="mblygUAZRtzggU8E3zjOhDytZ94rv0sUt"
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--mblygUAZRtzggU8E3zjOhDytZ94rv0sUt
Content-Type: multipart/mixed; boundary="TzIWZ33hlJ91xWksRrJQwc9Uo9qjuQMVW";
 protected-headers="v1"
From: Marc Kleine-Budde <mkl@pengutronix.de>
To: Joakim Zhang <qiangqing.zhang@nxp.com>,
 "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc: "davem@davemloft.net" <davem@davemloft.net>,
 "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
 "kernel@pengutronix.de" <kernel@pengutronix.de>
Message-ID: <16223144-3d40-2e3b-52ef-08176a076ed5@pengutronix.de>
Subject: Re: [PATCH 14/17] can: flexcan: remove ack_grp and ack_bit handling
 from driver
References: <20201007213159.1959308-1-mkl@pengutronix.de>
 <20201007213159.1959308-15-mkl@pengutronix.de>
 <DB8PR04MB6795CE6F83E1C25F8A04633FE6050@DB8PR04MB6795.eurprd04.prod.outlook.com>
In-Reply-To: <DB8PR04MB6795CE6F83E1C25F8A04633FE6050@DB8PR04MB6795.eurprd04.prod.outlook.com>

--TzIWZ33hlJ91xWksRrJQwc9Uo9qjuQMVW
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 10/14/20 10:53 AM, Joakim Zhang wrote:
>> Since commit:
>>
>>     048e3a34a2e7 can: flexcan: poll MCR_LPM_ACK instead of GPR ACK for=

>> stop mode acknowledgment
>>
>> the driver polls the IP core's internal bit MCR[LPM_ACK] as stop mode
>> acknowledge and not the acknowledgment on chip level.
>>
>> This means the 4th and 5th value of the property "fsl,stop-mode" isn't=
 used
>> anymore. This patch removes the used "ack_gpr" and "ack_bit" from the
>> driver.
>>
>> Link:
>> https://eur01.safelinks.protection.outlook.com/?url=3Dhttp%3A%2F%2Flor=
e.kern
>> el.org%2Fr%2F20201006203748.1750156-15-mkl%40pengutronix.de&amp;dat
>> a=3D02%7C01%7Cqiangqing.zhang%40nxp.com%7C1540ad5bf7bd4a1e10a508d8
>> 6b087a67%7C686ea1d3bc2b4c6fa92cd99c5c301635%7C0%7C0%7C637377031
>> 436785787&amp;sdata=3DierIIVdSqZFLklIvgMokHX6LU77cEWQgUGzUi6CHdDI%
>> 3D&amp;reserved=3D0
>> Fixes: 048e3a34a2e7 ("can: flexcan: poll MCR_LPM_ACK instead of GPR AC=
K
>> for stop mode acknowledgment")
>> Cc: Joakim Zhang <qiangqing.zhang@nxp.com>
>> Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
>=20
> [...]
>>  	/* stop mode property format is:
>> -	 * <&gpr req_gpr req_bit ack_gpr ack_bit>.
>> +	 * <&gpr req_gpr>.
>=20
> Hi Marc,
>=20
> Sorry for response delay, stop mode property format should be "<&gpr re=
q_gpr
> req_bit>", I saw this code change has went into linux-next, so I will c=
orrect
> it by the way next time when I upsteam wakeup function for i.MX8.

Doh! I wrongly deleted "req_bit" in the comment, but the code should be a=
ll
right. I'll add that back.

> Need I update stop mode property in dts file? Although this function wo=
n't be
> broken without dts update.

Yes, you can send patches to update the dts (after net-next was merged to=
 linus).

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |


--TzIWZ33hlJ91xWksRrJQwc9Uo9qjuQMVW--

--mblygUAZRtzggU8E3zjOhDytZ94rv0sUt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAl+G0DQACgkQqclaivrt
76nLmQf+MV3gJ4fq1XF1MrALcRD8RNn/iX6h8MkTimKrF+JZYuwSjxafyNi3bDTb
f4ZFA7/FVkucE2xuIX9ZXHE3lG69xHteEXIekSXx8204B/ENDZPZoU/ttHobgsE4
79bk3einErQFOgnLjY2Z7saN+NY5kWp9imWI/LH2FrsfVhjyra4j2KoJH3tLZ9zb
3BVgjchBirz4Gp//TfgcJfOWOJOgVQOMUm7qjuFFTroWuwVIyVu5JZuHMUznmZib
+16r6afC/cX5PD9HM49+PqBjdfIHk2YKjZJqp06JgeOJYDo+vUTyytoftEEvxCVF
lkOVGDadVcQ84aBzzDuBXh26iUtJ0A==
=9SJ0
-----END PGP SIGNATURE-----

--mblygUAZRtzggU8E3zjOhDytZ94rv0sUt--
