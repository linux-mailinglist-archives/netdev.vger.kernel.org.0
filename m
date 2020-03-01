Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82F81174D3A
	for <lists+netdev@lfdr.de>; Sun,  1 Mar 2020 13:20:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726755AbgCAMUI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Mar 2020 07:20:08 -0500
Received: from mout-p-102.mailbox.org ([80.241.56.152]:42462 "EHLO
        mout-p-102.mailbox.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725874AbgCAMUI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Mar 2020 07:20:08 -0500
Received: from smtp1.mailbox.org (smtp1.mailbox.org [IPv6:2001:67c:2050:105:465:1:1:0])
        (using TLSv1.2 with cipher ECDHE-RSA-CHACHA20-POLY1305 (256/256 bits))
        (No client certificate requested)
        by mout-p-102.mailbox.org (Postfix) with ESMTPS id 48Vj5d17NfzKm5f;
        Sun,  1 Mar 2020 13:20:05 +0100 (CET)
X-Virus-Scanned: amavisd-new at heinlein-support.de
Received: from smtp1.mailbox.org ([80.241.60.240])
        by spamfilter04.heinlein-hosting.de (spamfilter04.heinlein-hosting.de [80.241.56.122]) (amavisd-new, port 10030)
        with ESMTP id HWUlL385E5Nj; Sun,  1 Mar 2020 13:20:01 +0100 (CET)
Subject: Re: [PATCH 3/3] ag71xx: Run ag71xx_link_adjust() only when needed
To:     Oleksij Rempel <linux@rempel-privat.de>,
        Heiner Kallweit <hkallweit1@gmail.com>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, jcliburn@gmail.com, chris.snook@gmail.com
References: <20200217233518.3159-1-hauke@hauke-m.de>
 <20200217233518.3159-3-hauke@hauke-m.de>
 <b980f225-66ca-1ae1-23cf-eff06810b050@gmail.com>
 <9c509cec-a1cd-c012-b2ab-4f1334b47a8e@rempel-privat.de>
From:   Hauke Mehrtens <hauke@hauke-m.de>
Autocrypt: addr=hauke@hauke-m.de; keydata=
 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
Message-ID: <b120575e-b129-63c5-962e-cb3a90d4c62b@hauke-m.de>
Date:   Sun, 1 Mar 2020 13:19:56 +0100
MIME-Version: 1.0
In-Reply-To: <9c509cec-a1cd-c012-b2ab-4f1334b47a8e@rempel-privat.de>
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="ViZckID5v60TmW5Ja8LCvrRuvF75PQ08Q"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--ViZckID5v60TmW5Ja8LCvrRuvF75PQ08Q
Content-Type: multipart/mixed; boundary="roYvzG7fm6EFmsRCU2AtNgG20VXCTaER7"

--roYvzG7fm6EFmsRCU2AtNgG20VXCTaER7
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 2/18/20 11:30 AM, Oleksij Rempel wrote:
> Hi,
>=20
> current kernel still missing following patch:
> https://github.com/olerem/linux-2.6/commit/9a9a531bbad6d00c6221f393fd85=
628475e1f121
>=20
> @Hauke, can you please test, rebase your changes (if needed) on top of =
this patch?

I rebased my changes on top of this:
https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/commi=
t/?id=3D892e09153fa3564fcbf9f422760b61eba48c123e
and my patch is not needed any more, I will send a V2 only containing
the first patch of this series, which should fix a potential bug.

You missed adding RGMII support in your patch, but the MAC supports
RGMII, I will also send a patch for that.

@Oleksij: Are you planning to add support for the GMAC configuration
like RGMII delays and so on?

Hauke


>=20
> Am 18.02.20 um 08:02 schrieb Heiner Kallweit:
>> On 18.02.2020 00:35, Hauke Mehrtens wrote:
>>> My system printed this line every second:
>>>   ag71xx 19000000.eth eth0: Link is Up - 1Gbps/Full - flow control of=
f
>>> The function ag71xx_phy_link_adjust() was called by the PHY layer eve=
ry
>>> second even when nothing changed.
>>>
>> With current phylib code this shouldn't happen, see phy_check_link_sta=
tus().
>> On which kernel version do you observe this behavior?
>>
>>> With this patch the old status is stored and the real the
>>> ag71xx_link_adjust() function is only called when something really
>>> changed. This way the update and also this print is only done once an=
y
>>> more.
>>>
>>> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
>>> Fixes: d51b6ce441d3 ("net: ethernet: add ag71xx driver")
>>> ---
>>>  drivers/net/ethernet/atheros/ag71xx.c | 24 +++++++++++++++++++++++-
>>>  1 file changed, 23 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/net/ethernet/atheros/ag71xx.c b/drivers/net/ethe=
rnet/atheros/ag71xx.c
>>> index 7d3fec009030..12eaf6d2518d 100644
>>> --- a/drivers/net/ethernet/atheros/ag71xx.c
>>> +++ b/drivers/net/ethernet/atheros/ag71xx.c
>>> @@ -307,6 +307,10 @@ struct ag71xx {
>>>  	u32 msg_enable;
>>>  	const struct ag71xx_dcfg *dcfg;
>>>
>>> +	unsigned int		link;
>>> +	unsigned int		speed;
>>> +	int			duplex;
>>> +
>>>  	/* From this point onwards we're not looking at per-packet fields. =
*/
>>>  	void __iomem *mac_base;
>>>
>>> @@ -854,6 +858,7 @@ static void ag71xx_link_adjust(struct ag71xx *ag,=
 bool update)
>>>
>>>  	if (!phydev->link && update) {
>>>  		ag71xx_hw_stop(ag);
>>> +		phy_print_status(phydev);
>>>  		return;
>>>  	}
>>>
>>> @@ -907,8 +912,25 @@ static void ag71xx_link_adjust(struct ag71xx *ag=
, bool update)
>>>  static void ag71xx_phy_link_adjust(struct net_device *ndev)
>>>  {
>>>  	struct ag71xx *ag =3D netdev_priv(ndev);
>>> +	struct phy_device *phydev =3D ndev->phydev;
>>> +	int status_change =3D 0;
>>> +
>>> +	if (phydev->link) {
>>> +		if (ag->duplex !=3D phydev->duplex ||
>>> +		    ag->speed !=3D phydev->speed) {
>>> +			status_change =3D 1;
>>> +		}
>>> +	}
>>> +
>>> +	if (phydev->link !=3D ag->link)
>>> +		status_change =3D 1;
>>> +
>>> +	ag->link =3D phydev->link;
>>> +	ag->duplex =3D phydev->duplex;
>>> +	ag->speed =3D phydev->speed;
>>>
>>> -	ag71xx_link_adjust(ag, true);
>>> +	if (status_change)
>>> +		ag71xx_link_adjust(ag, true);
>>>  }
>>>
>>>  static int ag71xx_phy_connect(struct ag71xx *ag)
>>>
>>
>=20
>=20
> --
> Regards,
> Oleksij
>=20



--roYvzG7fm6EFmsRCU2AtNgG20VXCTaER7--

--ViZckID5v60TmW5Ja8LCvrRuvF75PQ08Q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEyz0/uAcd+JwXmwtD8bdnhZyy68cFAl5bqGwACgkQ8bdnhZyy
68fOMggAnYKM8MezfjB3/rg9j/Aupl/ZPZxU8tITqVz5lV4cjgCDlNx42PqbWqvs
kreGALuQ9/KCfp7oHAXuzsfzMGYyPKegNjl60TebrjiU8PRVjYNEtvU5vDbWEZyQ
DPiBBS5AnCnKpddb0f4TQJSjUYkZUqzZ0tNQMYLlu3GJlhbK34LwBz+kwfsQzTkQ
Vl8ctqqV/0TPs5gTdFOfyfElObM1NZTcJ9bLcHWU6tIokVzHdj9B+0ig78RVL3tp
gxYHvmZiY4pRFtoi0ASWPR9xPpM9qmUkolWwc/ei0YuQT7DzC4WjI95DyVjQYE8f
rQpxzjv1tza+Q/ZaktOVNWQZb2UMuQ==
=YlGj
-----END PGP SIGNATURE-----

--ViZckID5v60TmW5Ja8LCvrRuvF75PQ08Q--
