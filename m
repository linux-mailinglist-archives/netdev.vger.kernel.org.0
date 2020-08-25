Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35815251500
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 11:07:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729238AbgHYJHv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 05:07:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729180AbgHYJHv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Aug 2020 05:07:51 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78E23C061574;
        Tue, 25 Aug 2020 02:07:50 -0700 (PDT)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1598346466;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=SaumOMvqykv2fVelHFDh71R9GtVzr0ITzcTENOJjTl8=;
        b=UcDkxNj5qK1yUVcghxnMxXbJnAOdXkzrXCd9au3CLSTsrOGT5CH/qf5Qn6Kq/sMgB9rbFC
        9sqWn16GRfeI9T50jQdw4cEWEWWEAZEVCv0vEgEw13u8NjPJ93/Yl+7nMIV3u+1dBSeCNc
        KYzwtm45SSIEAL7zPDKxW+dN+QCsT9+o4TSX7LsdgWPv1+NS6MfxOwVDz0JGDsaGgCUNMI
        r2EmsELmJSaFXrFxJHqLxnv8/x5KTh/03n9z9Pre5Uymhn7xSbZUR48kcdVK8dWjwWbhcB
        1PxlQU/Fve/pa3PcxRMgYSS8oMVgymoPxSBqfjuuB7YS89S4aovF9lFBeecR+g==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1598346466;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=SaumOMvqykv2fVelHFDh71R9GtVzr0ITzcTENOJjTl8=;
        b=xSC8bGOqibqBXr4Yv5OQ69Sq/OCoitUysQhRdKvEZ8srw9TV4paneGMYsnfLMPgt4twdQg
        d4yu0hK0K9XtStBg==
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>,
        ilias.apalodimas@linaro.org, Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH v3 2/8] net: dsa: Add DSA driver for Hirschmann Hellcreek switches
In-Reply-To: <20200824224450.GK2403519@lunn.ch>
References: <20200820081118.10105-1-kurt@linutronix.de> <20200820081118.10105-3-kurt@linutronix.de> <20200824224450.GK2403519@lunn.ch>
Date:   Tue, 25 Aug 2020 11:07:34 +0200
Message-ID: <87eenv14bt.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue Aug 25 2020, Andrew Lunn wrote:
[snip]
>>=20=20
>>  source "drivers/net/dsa/sja1105/Kconfig"
>>=20=20
>> +source "drivers/net/dsa/hirschmann/Kconfig"
>> +
>>  config NET_DSA_QCA8K
>>  	tristate "Qualcomm Atheros QCA8K Ethernet switch family support"
>>  	depends on NET_DSA
>
> Hi Kurt
>
> The DSA entries are sorted into alphabetic order based on what you see
> in make menuconfig. As such, "Hirschmann Hellcreek TSN Switch support"
> fits in between "DSA mock-up Ethernet switch chip support" and "Lantiq
> / Intel GSWIP"

Yes, of course. I've only sorted the entries in the previous patch...

>
>> diff --git a/drivers/net/dsa/Makefile b/drivers/net/dsa/Makefile
>> index 4a943ccc2ca4..a707ccc3a940 100644
>> --- a/drivers/net/dsa/Makefile
>> +++ b/drivers/net/dsa/Makefile
>> @@ -23,3 +23,4 @@ obj-y				+=3D mv88e6xxx/
>>  obj-y				+=3D ocelot/
>>  obj-y				+=3D qca/
>>  obj-y				+=3D sja1105/
>> +obj-y				+=3D hirschmann/
>
> This file is also sorted.=20
>
>> +static int hellcreek_detect(struct hellcreek *hellcreek)
>> +{
>> +	u16 id, rel_low, rel_high, date_low, date_high, tgd_ver;
>> +	u8 tgd_maj, tgd_min;
>> +	u32 rel, date;
>> +
>> +	id	  =3D hellcreek_read(hellcreek, HR_MODID_C);
>> +	rel_low	  =3D hellcreek_read(hellcreek, HR_REL_L_C);
>> +	rel_high  =3D hellcreek_read(hellcreek, HR_REL_H_C);
>> +	date_low  =3D hellcreek_read(hellcreek, HR_BLD_L_C);
>> +	date_high =3D hellcreek_read(hellcreek, HR_BLD_H_C);
>> +	tgd_ver   =3D hellcreek_read(hellcreek, TR_TGDVER);
>> +
>> +	if (id !=3D HELLCREEK_MODULE_ID)
>> +		return -ENODEV;
>
> Are there other Hellcreek devices? I'm just wondering if we should
> have a specific compatible for 0x4c30 as well as the more generic=20
> "hirschmann,hellcreek".

Yes, there will be different revisions of the Hellcreek devices. This ID
is really device specific. A lot of features of this switch are
configured in the VHDL code. For instance the MAC settings (100 or 1000
Mbit/s).

I've discussed this with the HW engineer from Hirschmann. He suggested
to keep this check here, as the driver is currently specific for the
that device. We have to make sure that the driver matches the hardware.

My plan was to extend this when I have access to other revisions. There
will be a SPI variant as well. But, I didn't want to implement it without t=
he
ability to test it.

>
>> +static void hellcreek_get_ethtool_stats(struct dsa_switch *ds, int port,
>> +					uint64_t *data)
>> +{
>> +	struct hellcreek *hellcreek =3D ds->priv;
>> +	struct hellcreek_port *hellcreek_port;
>> +	unsigned long flags;
>> +	int i;
>> +
>> +	hellcreek_port =3D &hellcreek->ports[port];
>> +
>> +	spin_lock_irqsave(&hellcreek->reg_lock, flags);
>> +	for (i =3D 0; i < ARRAY_SIZE(hellcreek_counter); ++i) {
>> +		const struct hellcreek_counter *counter =3D &hellcreek_counter[i];
>> +		u8 offset =3D counter->offset + port * 64;
>> +		u16 high, low;
>> +		u64 value =3D 0;
>> +
>> +		hellcreek_select_counter(hellcreek, offset);
>> +
>> +		/* The registers are locked internally by selecting the
>> +		 * counter. So low and high can be read without reading high
>> +		 * again.
>> +		 */
>
> Is there any locking/snapshot of all the counters at once? Most
> devices have support for that, so you can compare counters against
> each other.

No, there is not.

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEooWgvezyxHPhdEojeSpbgcuY8KYFAl9E1NYACgkQeSpbgcuY
8KaL0w//VF976EOOEOBKhK+2hWZPahnzgjOPnT7uDmywqh1ADsCemlrUWqj8XvlK
0alstAxF4JfBzrkSAwgLOflKhF7GGdboS3em5Frv0qx3DZWEhy19nDwO6poFRs4Q
2QYc3/fskFMghSqQ2hNAdh9zScmuIiYQMVjZ67ptjqd1tjFR28nCXyiI418booJB
Sibfy3F0Zp7G5II+SL2N0f7jlg0phNHNry7BcT/opo0CPVM/qGjjuX1lORks+NED
AazyeAfNt6bsRDYLJkTycGbw5cJgmRsJuGRjfm6wooUZqhJ7P0zZEMwJrWQty5aJ
Bgz5eMyvgG7ATtx+yjnL46JQMUIM3+LqPKgyXUKH794IMTkX1iitzl44kRJKfZw6
9gyChRl9l0QAtQ9WlDcUwqkfg9jL5oLsydnmI6XfCGnRSV6im4NsLOQ3bmaWRKKs
wRv0MmANpnTgNG4W4lNJOI3YOqBGcEW/10Ep2p5NX1NGfJ2VAw1Z1ZkBygFVJkBj
dlhllcCNbdtKbp/+a021XYQcr3uT37td55m2H9oha0a70O9Y5Rh3CxShprBNAyEm
8E8+PJykMNEOrq4Hp2VOcVmnJfsOc3LTbnUI6VoBobhVfLzJsXyzzq4MMsfdDqJz
603teNIit/Q5rkoE+rb9lN1WMq65DxGwJ85+X7WM5SOQsYwt8Tg=
=rWEy
-----END PGP SIGNATURE-----
--=-=-=--
