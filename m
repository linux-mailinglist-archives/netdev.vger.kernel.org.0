Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CAC04764DD
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 13:49:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726675AbfGZLtI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jul 2019 07:49:08 -0400
Received: from metis.ext.pengutronix.de ([85.220.165.71]:41983 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726567AbfGZLtI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jul 2019 07:49:08 -0400
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1hqyib-00072d-3S; Fri, 26 Jul 2019 13:49:01 +0200
Received: from [IPv6:2003:c7:729:c72b:c9d4:83d5:b99:4f4d] (unknown [IPv6:2003:c7:729:c72b:c9d4:83d5:b99:4f4d])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256
         client-signature RSA-PSS (4096 bits) client-digest SHA256)
        (Client CN "mkl@blackshift.org", Issuer "StartCom Class 1 Client CA" (not verified))
        (Authenticated sender: mkl@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 18DC643976D;
        Fri, 26 Jul 2019 11:48:56 +0000 (UTC)
To:     Jeroen Hofstee <jhofstee@victronenergy.com>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>
Cc:     Anant Gole <anantgole@ti.com>, AnilKumar Ch <anilkumar@ti.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
References: <1556539376-20932-1-git-send-email-jhofstee@victronenergy.com>
From:   Marc Kleine-Budde <mkl@pengutronix.de>
Openpgp: preference=signencrypt
Autocrypt: addr=mkl@pengutronix.de; prefer-encrypt=mutual; keydata=
 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
Subject: Re: [PATCH] can: ti_hecc: use timestamp based rx-offloading
Message-ID: <04bdda38-79fa-c266-2a3c-1229a1fd8229@pengutronix.de>
Date:   Fri, 26 Jul 2019 13:48:50 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <1556539376-20932-1-git-send-email-jhofstee@victronenergy.com>
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="8Vcx5zN8NAF034AJYysdQKrpAeRKXuUgg"
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--8Vcx5zN8NAF034AJYysdQKrpAeRKXuUgg
Content-Type: multipart/mixed; boundary="M37tVGSr116Pwc4jJbfEdkeK6V5F6LKxb";
 protected-headers="v1"
From: Marc Kleine-Budde <mkl@pengutronix.de>
To: Jeroen Hofstee <jhofstee@victronenergy.com>,
 "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>
Cc: Anant Gole <anantgole@ti.com>, AnilKumar Ch <anilkumar@ti.com>,
 Wolfgang Grandegger <wg@grandegger.com>,
 "David S. Miller" <davem@davemloft.net>,
 "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
 open list <linux-kernel@vger.kernel.org>
Message-ID: <04bdda38-79fa-c266-2a3c-1229a1fd8229@pengutronix.de>
Subject: Re: [PATCH] can: ti_hecc: use timestamp based rx-offloading
References: <1556539376-20932-1-git-send-email-jhofstee@victronenergy.com>
In-Reply-To: <1556539376-20932-1-git-send-email-jhofstee@victronenergy.com>

--M37tVGSr116Pwc4jJbfEdkeK6V5F6LKxb
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: quoted-printable

On 4/29/19 2:03 PM, Jeroen Hofstee wrote:
> As already mentioned in [1] and included in [2], there is an off by one=

> issue since the high bank is already enabled when the _next_ mailbox to=

> be read has index 12, so the mailbox being read was 13. The message can=

> therefore go into mailbox 31 and the driver will be repolled until the
> mailbox 12 eventually receives a msg. Or the message might end up in th=
e
> 12th mailbox, but then it would become disabled after reading it and on=
ly
> be enabled again in the next "round" after mailbox 13 was read, which c=
an
> cause out of order messages, since the lower priority mailboxes can
> accept messages in the meantime.
>=20
> As mentioned in [3] there is a hardware race condition when changing th=
e
> CANME register while messages are being received. Even when including a=

> busy poll on reception, like in [2] there are still overflows and out o=
f
> order messages at times, but less then without the busy loop polling.
> Unlike what the patch suggests, the polling time is not in the microsec=
ond
> range, but takes as long as a current CAN bus reception needs to finish=
,
> so typically more in the fraction of millisecond range. Since the timeo=
ut
> is in jiffies it won't timeout.
>=20
> Even with these additional fixes the driver is still not able to provid=
e a
> proper FIFO which doesn't drop packages. So change the driver to use
> rx-offload and base order on timestamp instead of message box numbers. =
As
> a side affect, this also fixes [4] and [5].
>=20
> Before this change messages with a single byte counter were dropped /
> received out of order at a bitrate of 250kbit/s on an am3517. With this=

> patch that no longer occurs up to and including 1Mbit/s.
>=20
> [1] https://linux-can.vger.kernel.narkive.com/zgO9inVi/patch-can-ti-hec=
c-fix-rx-wrong-sequence-issue#post6
> [2] http://arago-project.org/git/projects/?p=3Dlinux-omap3.git;a=3Dcomm=
it;h=3D02346892777f07245de4d5af692513ebd852dcb2
> [3] https://linux-can.vger.kernel.narkive.com/zgO9inVi/patch-can-ti-hec=
c-fix-rx-wrong-sequence-issue#post5
> [4] https://patchwork.ozlabs.org/patch/895956/
> [5] https://www.spinics.net/lists/netdev/msg494971.html
>=20
> Cc: Anant Gole <anantgole@ti.com>
> Cc: AnilKumar Ch <anilkumar@ti.com>
> Signed-off-by: Jeroen Hofstee <jhofstee@victronenergy.com>

[...]

> @@ -744,8 +652,8 @@ static irqreturn_t ti_hecc_interrupt(int irq, void =
*dev_id)
>  	struct net_device *ndev =3D (struct net_device *)dev_id;
>  	struct ti_hecc_priv *priv =3D netdev_priv(ndev);
>  	struct net_device_stats *stats =3D &ndev->stats;
> -	u32 mbxno, mbx_mask, int_status, err_status;
> -	unsigned long ack, flags;
> +	u32 mbxno, mbx_mask, int_status, err_status, stamp;
> +	unsigned long flags, rx_pending;
> =20
>  	int_status =3D hecc_read(priv,
>  		(priv->use_hecc1int) ? HECC_CANGIF1 : HECC_CANGIF0);
> @@ -769,11 +677,11 @@ static irqreturn_t ti_hecc_interrupt(int irq, voi=
d *dev_id)
>  			spin_lock_irqsave(&priv->mbx_lock, flags);
>  			hecc_clear_bit(priv, HECC_CANME, mbx_mask);
>  			spin_unlock_irqrestore(&priv->mbx_lock, flags);
> -			stats->tx_bytes +=3D hecc_read_mbx(priv, mbxno,
> -						HECC_CANMCF) & 0xF;
> +			stamp =3D hecc_read_stamp(priv, mbxno);
> +			stats->tx_bytes +=3D can_rx_offload_get_echo_skb(&priv->offload,
> +									mbxno, stamp);
>  			stats->tx_packets++;
>  			can_led_event(ndev, CAN_LED_EVENT_TX);
> -			can_get_echo_skb(ndev, mbxno);
>  			--priv->tx_tail;
>  		}
> =20
> @@ -784,12 +692,11 @@ static irqreturn_t ti_hecc_interrupt(int irq, voi=
d *dev_id)
>  		((priv->tx_head & HECC_TX_MASK) =3D=3D HECC_TX_MASK)))
>  			netif_wake_queue(ndev);
> =20
> -		/* Disable RX mailbox interrupts and let NAPI reenable them */
> -		if (hecc_read(priv, HECC_CANRMP)) {
> -			ack =3D hecc_read(priv, HECC_CANMIM);
> -			ack &=3D BIT(HECC_MAX_TX_MBOX) - 1;
> -			hecc_write(priv, HECC_CANMIM, ack);
> -			napi_schedule(&priv->napi);
> +		/* offload RX mailboxes and let NAPI deliver them */
> +		while ((rx_pending =3D hecc_read(priv, HECC_CANRMP))) {
> +			can_rx_offload_irq_offload_timestamp(&priv->offload,
> +							     rx_pending);
> +			hecc_write(priv, HECC_CANRMP, rx_pending);

Can prepare a patch to move the RMP writing into the mailbox_read()
function. This makes the mailbox available a bit earlier and works
better for memory pressure situations, where no skb can be allocated.

>  		}
>  	}

Marc

--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--M37tVGSr116Pwc4jJbfEdkeK6V5F6LKxb--

--8Vcx5zN8NAF034AJYysdQKrpAeRKXuUgg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEmvEkXzgOfc881GuFWsYho5HknSAFAl066KMACgkQWsYho5Hk
nSDQNAf/SLz1+GBIBkre422kLlWi2HhYFlWnIRc7+uk12HUKOzsnluhDcXjdOxmh
sKqlYnFgwDU1rElu2OMLcwwBOyESwm3spL+9OC/hDg2jdfvZG0M/0tGwa+/QxjIC
dMgbYK29TTwuYWtIgY9nbSKHNRAlVszUnDD3WelT+VgEoFlC3AFk9IYBxwVUEsL/
2T6ElbIWSCXOD3Ad75yoPN5zvcVb/ekFcG3QCV8w3vn2RxDEG2HG15M3Mdkk9Zcf
WRbLB4NllVnuJ3U2EfLQyrT8A1fgBKPDHRLFWcFVFYduRR5ktxvbiisY+bGebLIj
DKAKcC1qe4IEccivuscShSTAvZcXEA==
=kW2T
-----END PGP SIGNATURE-----

--8Vcx5zN8NAF034AJYysdQKrpAeRKXuUgg--
