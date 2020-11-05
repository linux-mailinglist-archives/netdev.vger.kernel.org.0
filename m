Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 772182A83B3
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 17:39:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731299AbgKEQjv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 11:39:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728999AbgKEQju (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Nov 2020 11:39:50 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EEC0C0613CF
        for <netdev@vger.kernel.org>; Thu,  5 Nov 2020 08:39:50 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1kaiIY-0006mf-4C; Thu, 05 Nov 2020 17:39:42 +0100
Received: from [IPv6:2a03:f580:87bc:d400:74d6:79:dc8d:9bc9] (unknown [IPv6:2a03:f580:87bc:d400:74d6:79:dc8d:9bc9])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256
         client-signature RSA-PSS (4096 bits) client-digest SHA256)
        (Client CN "mkl@blackshift.org", Issuer "StartCom Class 1 Client CA" (not verified))
        (Authenticated sender: mkl@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 75C2558B7F8;
        Thu,  5 Nov 2020 16:39:36 +0000 (UTC)
To:     Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        linux-can@vger.kernel.org, kernel@pengutronix.de,
        Thomas Kopp <thomas.kopp@microchip.com>
References: <20201103220636.972106-1-mkl@pengutronix.de>
 <20201103220636.972106-22-mkl@pengutronix.de> <20201105162417.GH7308@work>
From:   Marc Kleine-Budde <mkl@pengutronix.de>
Autocrypt: addr=mkl@pengutronix.de; prefer-encrypt=mutual; keydata=
 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
Subject: Re: [net 21/27] can: mcp251xfd: mcp251xfd_regmap_crc_read(): increase
 severity of CRC read error messages
Message-ID: <cee3b960-6633-bffd-d1a6-05e4a5e20b2e@pengutronix.de>
Date:   Thu, 5 Nov 2020 17:39:31 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201105162417.GH7308@work>
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="RCPPXwNYgkddMRpm5c5z8YQ9Qg7QMsKVY"
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--RCPPXwNYgkddMRpm5c5z8YQ9Qg7QMsKVY
Content-Type: multipart/mixed; boundary="ROCwuYTbGV6HU6PvUWBbKXVgTs1Q4fn3E";
 protected-headers="v1"
From: Marc Kleine-Budde <mkl@pengutronix.de>
To: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc: netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
 linux-can@vger.kernel.org, kernel@pengutronix.de,
 Thomas Kopp <thomas.kopp@microchip.com>
Message-ID: <cee3b960-6633-bffd-d1a6-05e4a5e20b2e@pengutronix.de>
Subject: Re: [net 21/27] can: mcp251xfd: mcp251xfd_regmap_crc_read(): increase
 severity of CRC read error messages
References: <20201103220636.972106-1-mkl@pengutronix.de>
 <20201103220636.972106-22-mkl@pengutronix.de> <20201105162417.GH7308@work>
In-Reply-To: <20201105162417.GH7308@work>

--ROCwuYTbGV6HU6PvUWBbKXVgTs1Q4fn3E
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 11/5/20 5:24 PM, Manivannan Sadhasivam wrote:
> Hi Marc,
>=20
> On Tue, Nov 03, 2020 at 11:06:30PM +0100, Marc Kleine-Budde wrote:
>> During debugging it turned out that some people have setups where the =
SPI
>> communication is more prone to CRC errors.
>>
>> Increase the severity of both the transfer retry and transfer failure =
message
>> to give users feedback without the need to recompile the driver with d=
ebug
>> enabled.
>>
>> Cc: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
>> Cc: Thomas Kopp <thomas.kopp@microchip.com>
>> Link: http://lore.kernel.org/r/20201019190524.1285319-15-mkl@pengutron=
ix.de
>> Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
>> ---
>>  drivers/net/can/spi/mcp251xfd/mcp251xfd-regmap.c | 16 ++++++++-------=
-
>>  1 file changed, 8 insertions(+), 8 deletions(-)
>>
>> diff --git a/drivers/net/can/spi/mcp251xfd/mcp251xfd-regmap.c b/driver=
s/net/can/spi/mcp251xfd/mcp251xfd-regmap.c
>> index ba25902dd78c..c9ffc5ea2b25 100644
>> --- a/drivers/net/can/spi/mcp251xfd/mcp251xfd-regmap.c
>> +++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd-regmap.c
>> @@ -330,17 +330,17 @@ mcp251xfd_regmap_crc_read(void *context,
>>  			goto out;
>>  		}
>> =20
>> -		netdev_dbg(priv->ndev,
>> -			   "CRC read error at address 0x%04x (length=3D%zd, data=3D%*ph, C=
RC=3D0x%04x) retrying.\n",
>> -			   reg, val_len, (int)val_len, buf_rx->data,
>> -			   get_unaligned_be16(buf_rx->data + val_len));
>> -	}
>> -
>> -	if (err) {
>>  		netdev_info(priv->ndev,
>> -			    "CRC read error at address 0x%04x (length=3D%zd, data=3D%*ph, =
CRC=3D0x%04x).\n",
>> +			    "CRC read error at address 0x%04x (length=3D%zd, data=3D%*ph, =
CRC=3D0x%04x) retrying.\n",
>>  			    reg, val_len, (int)val_len, buf_rx->data,
>>  			    get_unaligned_be16(buf_rx->data + val_len));
>=20
> I'm not finding this inner debug log useful. Does the user really care
> about the iterations it took to read a register? Just throwing the erro=
r
> after max try seems better to me.

Bitflips on the SPI should not happen, at least not regularly. Even with =
my
breadboard setup and max SPI frequency, I don't see any SPI CRC errors, u=
nless
there is bad cabling. Then a retry most of the times helps and the user d=
oesn't
notice. This drops performance...Yes logging drop performance, too, but a=
t least
someone will notice.

My rationale was to give the user feedback and not cover a potential prob=
lem.
The driver is new and probably not widely used and I have no idea how oft=
en it
runs into read-CRC problems in production use.

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |


--ROCwuYTbGV6HU6PvUWBbKXVgTs1Q4fn3E--

--RCPPXwNYgkddMRpm5c5z8YQ9Qg7QMsKVY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAl+kKsMACgkQqclaivrt
76kUPwgAiYKWvp90GEbocG1nNNP0GoH0FeWwKyNWJ96s3D+/KLvmyXGQukuzEgwg
n4Xho/AyASnZXvcMhCHmWNfqYu/GHJFJSC3OLBwRF/FkaQ94DHhEVpt8bzsMcuyG
tE+53OjAfh6OmgQthqMn9XM7Hj/Crcbft1x873FuoNXfFNUMjBjyRpfhvoCuocyH
041kYX9IRfbGwa1PkbPzNZSD1GnH7t+IyABOFJCNPXcmYIN1qPlmsCFZ2wzFInAQ
V2sgH978C9f/gkbSqKNL79s7EfCqOGvzzTqQtcNCrg6sfrWxLQAc6ZtsQDJQjr1L
Ald8DeB6ZPxoAbSvMu3tk5IjNoMlEQ==
=e0bF
-----END PGP SIGNATURE-----

--RCPPXwNYgkddMRpm5c5z8YQ9Qg7QMsKVY--
