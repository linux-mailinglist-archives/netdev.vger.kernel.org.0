Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 145B22CBCC0
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 13:18:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729869AbgLBMQ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 07:16:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727406AbgLBMQ5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 07:16:57 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A52A1C0613D4
        for <netdev@vger.kernel.org>; Wed,  2 Dec 2020 04:16:16 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1kkR3E-0007V4-K3; Wed, 02 Dec 2020 13:16:04 +0100
Received: from [IPv6:2a03:f580:87bc:d400:fdcb:9941:7509:5481] (unknown [IPv6:2a03:f580:87bc:d400:fdcb:9941:7509:5481])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits)
         client-signature RSA-PSS (4096 bits))
        (Client CN "mkl@blackshift.org", Issuer "StartCom Class 1 Client CA" (not verified))
        (Authenticated sender: mkl@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id C4C865A19A8;
        Wed,  2 Dec 2020 12:16:02 +0000 (UTC)
Subject: Re: [PATCH v2 2/2] net: dsa: qca: ar9331: export stats64
To:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>
Cc:     linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        netdev@vger.kernel.org
References: <20201202120712.6212-1-o.rempel@pengutronix.de>
 <20201202120712.6212-3-o.rempel@pengutronix.de>
From:   Marc Kleine-Budde <mkl@pengutronix.de>
Autocrypt: addr=mkl@pengutronix.de; prefer-encrypt=mutual; keydata=
 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
Message-ID: <d3f790c6-d84c-f1bd-df6e-912ab64cce8c@pengutronix.de>
Date:   Wed, 2 Dec 2020 13:15:58 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201202120712.6212-3-o.rempel@pengutronix.de>
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="41ih9RevJEQzc3YocuUBOatzzAzDZBPkb"
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--41ih9RevJEQzc3YocuUBOatzzAzDZBPkb
Content-Type: multipart/mixed; boundary="qEmfahugNKNaZ0LxDS6X7YJo8mxrIuQua";
 protected-headers="v1"
From: Marc Kleine-Budde <mkl@pengutronix.de>
To: Oleksij Rempel <o.rempel@pengutronix.de>, Andrew Lunn <andrew@lunn.ch>,
 Vivien Didelot <vivien.didelot@gmail.com>,
 Florian Fainelli <f.fainelli@gmail.com>, Vladimir Oltean
 <olteanv@gmail.com>, "David S. Miller" <davem@davemloft.net>,
 Jakub Kicinski <kuba@kernel.org>, Russell King <linux@armlinux.org.uk>
Cc: linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org,
 Pengutronix Kernel Team <kernel@pengutronix.de>, netdev@vger.kernel.org
Message-ID: <d3f790c6-d84c-f1bd-df6e-912ab64cce8c@pengutronix.de>
Subject: Re: [PATCH v2 2/2] net: dsa: qca: ar9331: export stats64
References: <20201202120712.6212-1-o.rempel@pengutronix.de>
 <20201202120712.6212-3-o.rempel@pengutronix.de>
In-Reply-To: <20201202120712.6212-3-o.rempel@pengutronix.de>

--qEmfahugNKNaZ0LxDS6X7YJo8mxrIuQua
Content-Type: text/plain; charset=utf-8
Content-Language: de-DE
Content-Transfer-Encoding: quoted-printable

On 12/2/20 1:07 PM, Oleksij Rempel wrote:
> Add stats support for the ar9331 switch.
>=20
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> ---
>  drivers/net/dsa/qca/ar9331.c | 242 ++++++++++++++++++++++++++++++++++-=

>  1 file changed, 241 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/net/dsa/qca/ar9331.c b/drivers/net/dsa/qca/ar9331.=
c
> index e24a99031b80..1a8027bc9561 100644
> --- a/drivers/net/dsa/qca/ar9331.c
> +++ b/drivers/net/dsa/qca/ar9331.c
> @@ -101,6 +101,57 @@
>  	 AR9331_SW_PORT_STATUS_RX_FLOW_EN | AR9331_SW_PORT_STATUS_TX_FLOW_EN =
| \
>  	 AR9331_SW_PORT_STATUS_SPEED_M)
> =20
> +/* MIB registers */
> +#define AR9331_MIB_COUNTER(x)			(0x20000 + ((x) * 0x100))
> +
> +#define AR9331_PORT_MIB_rxbroad(_port)		(AR9331_MIB_COUNTER(_port) + 0=
x00)
> +#define AR9331_PORT_MIB_rxpause(_port)		(AR9331_MIB_COUNTER(_port) + 0=
x04)
> +#define AR9331_PORT_MIB_rxmulti(_port)		(AR9331_MIB_COUNTER(_port) + 0=
x08)
> +#define AR9331_PORT_MIB_rxfcserr(_port)		(AR9331_MIB_COUNTER(_port) + =
0x0c)
> +#define AR9331_PORT_MIB_rxalignerr(_port)	(AR9331_MIB_COUNTER(_port) +=
 0x10)
> +#define AR9331_PORT_MIB_rxrunt(_port)		(AR9331_MIB_COUNTER(_port) + 0x=
14)
> +#define AR9331_PORT_MIB_rxfragment(_port)	(AR9331_MIB_COUNTER(_port) +=
 0x18)
> +#define AR9331_PORT_MIB_rx64byte(_port)		(AR9331_MIB_COUNTER(_port) + =
0x1c)
> +#define AR9331_PORT_MIB_rx128byte(_port)	(AR9331_MIB_COUNTER(_port) + =
0x20)
> +#define AR9331_PORT_MIB_rx256byte(_port)	(AR9331_MIB_COUNTER(_port) + =
0x24)
> +#define AR9331_PORT_MIB_rx512byte(_port)	(AR9331_MIB_COUNTER(_port) + =
0x28)
> +#define AR9331_PORT_MIB_rx1024byte(_port)	(AR9331_MIB_COUNTER(_port) +=
 0x2c)
> +#define AR9331_PORT_MIB_rx1518byte(_port)	(AR9331_MIB_COUNTER(_port) +=
 0x30)
> +#define AR9331_PORT_MIB_rxmaxbyte(_port)	(AR9331_MIB_COUNTER(_port) + =
0x34)
> +#define AR9331_PORT_MIB_rxtoolong(_port)	(AR9331_MIB_COUNTER(_port) + =
0x38)
> +
> +/* 64 bit counter */
> +#define AR9331_PORT_MIB_rxgoodbyte(_port)	(AR9331_MIB_COUNTER(_port) +=
 0x3c)
> +
> +/* 64 bit counter */
> +#define AR9331_PORT_MIB_rxbadbyte(_port)	(AR9331_MIB_COUNTER(_port) + =
0x44)
> +
> +#define AR9331_PORT_MIB_rxoverflow(_port)	(AR9331_MIB_COUNTER(_port) +=
 0x4c)
> +#define AR9331_PORT_MIB_filtered(_port)		(AR9331_MIB_COUNTER(_port) + =
0x50)
> +#define AR9331_PORT_MIB_txbroad(_port)		(AR9331_MIB_COUNTER(_port) + 0=
x54)
> +#define AR9331_PORT_MIB_txpause(_port)		(AR9331_MIB_COUNTER(_port) + 0=
x58)
> +#define AR9331_PORT_MIB_txmulti(_port)		(AR9331_MIB_COUNTER(_port) + 0=
x5c)
> +#define AR9331_PORT_MIB_txunderrun(_port)	(AR9331_MIB_COUNTER(_port) +=
 0x60)
> +#define AR9331_PORT_MIB_tx64byte(_port)		(AR9331_MIB_COUNTER(_port) + =
0x64)
> +#define AR9331_PORT_MIB_tx128byte(_port)	(AR9331_MIB_COUNTER(_port) + =
0x68)
> +#define AR9331_PORT_MIB_tx256byte(_port)	(AR9331_MIB_COUNTER(_port) + =
0x6c)
> +#define AR9331_PORT_MIB_tx512byte(_port)	(AR9331_MIB_COUNTER(_port) + =
0x70)
> +#define AR9331_PORT_MIB_tx1024byte(_port)	(AR9331_MIB_COUNTER(_port) +=
 0x74)
> +#define AR9331_PORT_MIB_tx1518byte(_port)	(AR9331_MIB_COUNTER(_port) +=
 0x78)
> +#define AR9331_PORT_MIB_txmaxbyte(_port)	(AR9331_MIB_COUNTER(_port) + =
0x7c)
> +#define AR9331_PORT_MIB_txoversize(_port)	(AR9331_MIB_COUNTER(_port) +=
 0x80)
> +
> +/* 64 bit counter */
> +#define AR9331_PORT_MIB_txbyte(_port)		(AR9331_MIB_COUNTER(_port) + 0x=
84)
> +
> +#define AR9331_PORT_MIB_txcollision(_port)	(AR9331_MIB_COUNTER(_port) =
+ 0x8c)
> +#define AR9331_PORT_MIB_txabortcol(_port)	(AR9331_MIB_COUNTER(_port) +=
 0x90)
> +#define AR9331_PORT_MIB_txmulticol(_port)	(AR9331_MIB_COUNTER(_port) +=
 0x94)
> +#define AR9331_PORT_MIB_txsinglecol(_port)	(AR9331_MIB_COUNTER(_port) =
+ 0x98)
> +#define AR9331_PORT_MIB_txexcdefer(_port)	(AR9331_MIB_COUNTER(_port) +=
 0x9c)
> +#define AR9331_PORT_MIB_txdefer(_port)		(AR9331_MIB_COUNTER(_port) + 0=
xa0)
> +#define AR9331_PORT_MIB_txlatecol(_port)	(AR9331_MIB_COUNTER(_port) + =
0xa4)
> +
>  /* Phy bypass mode
>   * -------------------------------------------------------------------=
-----
>   * Bit:   | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 |10 |11 |12 |13 |14 =
|15 |
> @@ -154,6 +205,59 @@
>  #define AR9331_SW_MDIO_POLL_SLEEP_US		1
>  #define AR9331_SW_MDIO_POLL_TIMEOUT_US		20
> =20
> +#define STATS_INTERVAL_JIFFIES			(100 * HZ)
> +
> +struct ar9331_sw_stats {
> +	u64 rxbroad;
> +	u64 rxpause;
> +	u64 rxmulti;
> +	u64 rxfcserr;
> +	u64 rxalignerr;
> +	u64 rxrunt;
> +	u64 rxfragment;
> +	u64 rx64byte;
> +	u64 rx128byte;
> +	u64 rx256byte;
> +	u64 rx512byte;
> +	u64 rx1024byte;
> +	u64 rx1518byte;
> +	u64 rxmaxbyte;
> +	u64 rxtoolong;
> +	u64 rxgoodbyte;
> +	u64 rxbadbyte;
> +	u64 rxoverflow;
> +	u64 filtered;
> +	u64 txbroad;
> +	u64 txpause;
> +	u64 txmulti;
> +	u64 txunderrun;
> +	u64 tx64byte;
> +	u64 tx128byte;
> +	u64 tx256byte;
> +	u64 tx512byte;
> +	u64 tx1024byte;
> +	u64 tx1518byte;
> +	u64 txmaxbyte;
> +	u64 txoversize;
> +	u64 txbyte;
> +	u64 txcollision;
> +	u64 txabortcol;
> +	u64 txmulticol;
> +	u64 txsinglecol;
> +	u64 txexcdefer;
> +	u64 txdefer;
> +	u64 txlatecol;
> +};
> +
> +struct ar9331_sw_priv;
> +struct ar9331_sw_port {
> +	int idx;
> +	struct ar9331_sw_priv *priv;
> +	struct delayed_work mib_read;
> +	struct ar9331_sw_stats stats;
> +	struct mutex lock;		/* stats access */

What does the lock protect? It's only used a single time.

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |


--qEmfahugNKNaZ0LxDS6X7YJo8mxrIuQua--

--41ih9RevJEQzc3YocuUBOatzzAzDZBPkb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAl/HhX4ACgkQqclaivrt
76lAzQf/ZK1hRAIz9Y3cMOxgZbC9CcKlpidw/8Jqdfw78yh4v7p5DZTHCDzdhJVK
SBsaWlyhIELxMdCvuquJdL7njavNSQ90L9yhJhfLcxYIisGkDRQ1osVTUikGtnlJ
Hq74dBIZ0QD1jdpmW9bVcYiwv7973JhMo2r2iquXNhQLCpRzxVbQP+dpJ8Qq1Pme
CVvPPaOTVn1Z/+vXAOo2PnHGyhM1OpaRogItT+Be/DBUQwFN7qt404K2eRs37APK
rL9G8BXNVMyi/bMmOfrQZAoR75732EMm0eFGTFndqID2wQSkAB1UGmp/lm1YD98g
ZDXlWBNuHsYy1O2cxLoR9hrSflxzkg==
=iIQW
-----END PGP SIGNATURE-----

--41ih9RevJEQzc3YocuUBOatzzAzDZBPkb--
