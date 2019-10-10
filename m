Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9840CD3236
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 22:42:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726227AbfJJU3d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 16:29:33 -0400
Received: from metis.ext.pengutronix.de ([85.220.165.71]:50341 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725951AbfJJU3d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Oct 2019 16:29:33 -0400
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1iIf3u-0005lQ-OZ; Thu, 10 Oct 2019 22:29:26 +0200
Received: from [IPv6:2a03:f580:87bc:d400:d889:c8b8:5209:79fb] (unknown [IPv6:2a03:f580:87bc:d400:d889:c8b8:5209:79fb])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256
         client-signature RSA-PSS (4096 bits) client-digest SHA256)
        (Client CN "mkl@blackshift.org", Issuer "StartCom Class 1 Client CA" (not verified))
        (Authenticated sender: mkl@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id E580546493A;
        Thu, 10 Oct 2019 20:29:21 +0000 (UTC)
To:     Jeroen Hofstee <jhofstee@victronenergy.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        linux-can <linux-can@vger.kernel.org>
Cc:     =?UTF-8?Q?Martin_Hundeb=c3=b8ll?= <martin@geanix.com>,
        Kurt Van Dijck <dev.kurt@vandijck-laurijssen.be>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>
References: <20191010121750.27237-1-mkl@pengutronix.de>
 <20191010121750.27237-25-mkl@pengutronix.de>
 <dfdbefb3-48c4-0830-9627-146da062a01a@pengutronix.de>
 <694ef4e8-166b-7eeb-4d6e-39a0ecacc93f@victronenergy.com>
From:   Marc Kleine-Budde <mkl@pengutronix.de>
Openpgp: preference=signencrypt
Autocrypt: addr=mkl@pengutronix.de; prefer-encrypt=mutual; keydata=
 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
Subject: Re: [PATCH 24/29] can: ti_hecc: add fifo underflow error reporting
Message-ID: <0c58e9a7-4cb8-dc75-14b8-9b33290916da@pengutronix.de>
Date:   Thu, 10 Oct 2019 22:29:12 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <694ef4e8-166b-7eeb-4d6e-39a0ecacc93f@victronenergy.com>
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="peiOrQAva8kwdDkS179PcizzSElKs5aYS"
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--peiOrQAva8kwdDkS179PcizzSElKs5aYS
Content-Type: multipart/mixed; boundary="UWw7XaTsCkn5srHEdZoUGzuAL6HSnmXvZ";
 protected-headers="v1"
From: Marc Kleine-Budde <mkl@pengutronix.de>
To: Jeroen Hofstee <jhofstee@victronenergy.com>,
 "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
 linux-can <linux-can@vger.kernel.org>
Cc: =?UTF-8?Q?Martin_Hundeb=c3=b8ll?= <martin@geanix.com>,
 Kurt Van Dijck <dev.kurt@vandijck-laurijssen.be>,
 "davem@davemloft.net" <davem@davemloft.net>,
 "kernel@pengutronix.de" <kernel@pengutronix.de>
Message-ID: <0c58e9a7-4cb8-dc75-14b8-9b33290916da@pengutronix.de>
Subject: Re: [PATCH 24/29] can: ti_hecc: add fifo underflow error reporting
References: <20191010121750.27237-1-mkl@pengutronix.de>
 <20191010121750.27237-25-mkl@pengutronix.de>
 <dfdbefb3-48c4-0830-9627-146da062a01a@pengutronix.de>
 <694ef4e8-166b-7eeb-4d6e-39a0ecacc93f@victronenergy.com>
In-Reply-To: <694ef4e8-166b-7eeb-4d6e-39a0ecacc93f@victronenergy.com>

--UWw7XaTsCkn5srHEdZoUGzuAL6HSnmXvZ
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: quoted-printable

On 10/10/19 7:51 PM, Jeroen Hofstee wrote:
>>> When the rx fifo overflows the ti_hecc would silently drop them since=

>>> the overwrite protection is enabled for all mailboxes. So disable it
>>> for the lowest priority mailbox and increment the rx_fifo_errors when=

>>> receive message lost is set. Drop the message itself in that case,
>>> since it might be partially updated.
>> Is that your observation or does the data sheet say anything to this
>> situation?
>=20
> I couldn't find in the data sheet, so I simply tested it, by allowing
> the highest mailbox to be overwritten and send a stream alternating
> with messages will all bits set and all cleared. That does end with
> canids from one message combined with data from another.

I see. This is why the register is called overwrite _protection_ control.=


>>> Signed-off-by: Jeroen Hofstee <jhofstee@victronenergy.com>
>>> Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
>>> ---
>>>  drivers/net/can/ti_hecc.c | 21 +++++++++++++++++----
>>>  1 file changed, 17 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/drivers/net/can/ti_hecc.c b/drivers/net/can/ti_hecc.c
>>> index 6ea29126c60b..c2d83ada203a 100644
>>> --- a/drivers/net/can/ti_hecc.c
>>> +++ b/drivers/net/can/ti_hecc.c
>>> @@ -82,7 +82,7 @@ MODULE_VERSION(HECC_MODULE_VERSION);
>>>  #define HECC_CANTA		0x10	/* Transmission acknowledge */
>>>  #define HECC_CANAA		0x14	/* Abort acknowledge */
>>>  #define HECC_CANRMP		0x18	/* Receive message pending */
>>> -#define HECC_CANRML		0x1C	/* Remote message lost */
>>> +#define HECC_CANRML		0x1C	/* Receive message lost */
>>>  #define HECC_CANRFP		0x20	/* Remote frame pending */
>>>  #define HECC_CANGAM		0x24	/* SECC only:Global acceptance mask */
>>>  #define HECC_CANMC		0x28	/* Master control */
>>> @@ -385,8 +385,17 @@ static void ti_hecc_start(struct net_device *nde=
v)
>>>  	/* Enable tx interrupts */
>>>  	hecc_set_bit(priv, HECC_CANMIM, BIT(HECC_MAX_TX_MBOX) - 1);
>>> =20
>>> -	/* Prevent message over-write & Enable interrupts */
>>> -	hecc_write(priv, HECC_CANOPC, HECC_SET_REG);
>>> +	/* Prevent message over-write to create a rx fifo, but not for
>>> +	 * the lowest priority mailbox, since that allows detecting
>>> +	 * overflows instead of the hardware silently dropping the
>>> +	 * messages. The lowest rx mailbox is one above the tx ones,
>>> +	 * hence its mbxno is the number of tx mailboxes.
>>> +	 */
>>> +	mbxno =3D HECC_MAX_TX_MBOX;
>>> +	mbx_mask =3D ~BIT(mbxno);
>>> +	hecc_write(priv, HECC_CANOPC, mbx_mask);
>>> +
>>> +	/* Enable interrupts */
>>>  	if (priv->use_hecc1int) {
>>>  		hecc_write(priv, HECC_CANMIL, HECC_SET_REG);
>>>  		hecc_write(priv, HECC_CANGIM, HECC_CANGIM_DEF_MASK |
>>> @@ -531,6 +540,7 @@ static unsigned int ti_hecc_mailbox_read(struct c=
an_rx_offload *offload,
>>>  {
>>>  	struct ti_hecc_priv *priv =3D rx_offload_to_priv(offload);
>>>  	u32 data, mbx_mask;
>>> +	int lost;
>>> =20
>>>  	mbx_mask =3D BIT(mbxno);
>>>  	data =3D hecc_read_mbx(priv, mbxno, HECC_CANMID);
>>> @@ -552,9 +562,12 @@ static unsigned int ti_hecc_mailbox_read(struct =
can_rx_offload *offload,
>>>  	}
>>> =20
>>>  	*timestamp =3D hecc_read_stamp(priv, mbxno);
>>> +	lost =3D hecc_read(priv, HECC_CANRML) & mbx_mask;
>>> +	if (unlikely(lost))
>>> +		priv->offload.dev->stats.rx_fifo_errors++;
>> In the flexcan and at91_can driver we're incrementing the following er=
rors:
>> 			dev->stats.rx_over_errors++;
>> 			dev->stats.rx_errors++;
>=20
> I understood it as follows, see[1] e.g.:
>
> rx_errors -> link level errors, not really applicable to CAN
> (perhaps in single shot mode or if you want)

I increment this for CRC, bit stuffing and all the other bus errors. As
well as on HW FIFO overflows.

> rx_over_errors -> the hardware itself cannot keep up.
> Not applicable for CAN.

If the HW FIFO overflows for whatever reason, I increment this.

> rx_fifo_errors -> the software driver cannot keep up.
> So I picked that one.

If the rx-offload queue reaches it's limit I increment this.

> rx_dropped -> software is dropping on purpose based on limits etc.
>=20
> But I might be wrong.

rx-offload used this if the skb cannot be allocated.

Basically the kernel doc gives a general description of these values but
says: look at the driver for exact meaning :)

I wanted to keep it similar with the CAN drivers.

>> You can save the register access if you only check for overflows if
>> reading from the lowest prio mailbox.
>>
>> If you're discarding the data if the mailbox is marked as overflow
>> there's no need to read the data in the first place.
>>
>=20
> Mind it that you don't cause a race! The bit can become set
> during reading of the data, it should be check _after_ we
> have a copy of the mailbox.

Right. My understanding of the bit was wrong.

In the flexcan HW there is a similar bit. It says there was an overflow
in this mailbox. But a coherence mechanism guarantees that the mailbox
is not changed by the CAN core, while the ARM accesses it.

> You can do a double check, one
> before one after, but since there should be no fifo overflow
> anyway, there is no reason to optimize for that path. (@250k
> I cannot get more then 3 messages in the fifo...).
Thanks for the explanations,
Marc

--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--UWw7XaTsCkn5srHEdZoUGzuAL6HSnmXvZ--

--peiOrQAva8kwdDkS179PcizzSElKs5aYS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEmvEkXzgOfc881GuFWsYho5HknSAFAl2flJgACgkQWsYho5Hk
nSATiwf7B4n2aQwOaGGAmvyo0oepF77hTYtWMbhXScg5GPcLICNSsCtrkW4EYUy0
CxSh0F0pPCkBd6EvDWqLAdLmJ2ZrA5juNKP2bkKklNZtDyQ5i26wyS4XtS+vush1
oS1tMRvH8DQsKO5BTPeakI/2Ysq5+X0RRazxudJuXOyA/rciM9zcKJzzXIQPgkyT
7OhX2JhJ029Qxdn9qPjLB9I835I1Cfl+B0hu3x/FiCWkMSpCeauWGaat8j/rEb71
L2CHs5e7En1dxm/m7GuHFe+qNIf977eNtzMAiDF3pXyQ46T/i9Mk7rr0ix+73La5
BI6Rx2E2gpc58r2n4dJVEvKdWW0p2g==
=6/qO
-----END PGP SIGNATURE-----

--peiOrQAva8kwdDkS179PcizzSElKs5aYS--
