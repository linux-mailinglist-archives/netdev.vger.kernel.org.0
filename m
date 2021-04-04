Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62C81353706
	for <lists+netdev@lfdr.de>; Sun,  4 Apr 2021 08:05:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232360AbhDDGFF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Apr 2021 02:05:05 -0400
Received: from mout.gmx.net ([212.227.15.19]:52127 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229566AbhDDGFC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 4 Apr 2021 02:05:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1617516287;
        bh=wfWZ0j/dMPCdegx9KjeoR7iuxOiNjoYJMvG3Z5+9snQ=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=gmUEV/MP5ujQ9LjmwhnHWnC5jdBSubnWEbJlnLE72is1rQBPyOEQSTbR+j45Kb4fq
         hI/aAnrDTpAf8//C9iV7unBh2WKqcornT5VWvOp+FfQauY9ma01oJRUIeGprxCd7v9
         cEN4qnhOgLUsetTCtT8ajd6uAFZVd/du65KxF++k=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.178.44] ([95.91.192.147]) by mail.gmx.net (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1N6sn7-1lfOXR3IeV-018MBg; Sun, 04
 Apr 2021 08:04:46 +0200
Subject: Re: [PATCH net-next v1 4/9] net: dsa: qca: ar9331: make proper
 initial port defaults
To:     Vladimir Oltean <olteanv@gmail.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mips@vger.kernel.org
References: <20210403114848.30528-1-o.rempel@pengutronix.de>
 <20210403114848.30528-5-o.rempel@pengutronix.de>
 <20210404001630.paqmt4v63d5gewy5@skbuf>
From:   Oleksij Rempel <linux@rempel-privat.de>
Message-ID: <e125e1d3-8d65-a8c1-2b2c-355c7da94e87@rempel-privat.de>
Date:   Sun, 4 Apr 2021 08:04:44 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210404001630.paqmt4v63d5gewy5@skbuf>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:DroEABeeuDI2OiLwvdHA0jAVifanj7KQVAZp/9D6C0bI+GOt9DR
 8W1ZCaA+7Rdb3ZckShg5c2jQuL/hDsGZRvwN3jBKK+zJzt5Tw7uGaVCcl1qhrYBCm96z0B1
 26C+QMrKvD1FyEF2firqjkwhONp0riS+25jA6tdk/OPfj7YMx4SbZrqy8hKfRJw8/yMmymB
 sDlq7Bthivm97ARF2M4WQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:wHK9S2rjuAg=:cKkkusv0FVSzeqK3fp9Urw
 sOOydvc/MztCG7dEL7HbPcEGPEWke317J6pREHnzcNOZbb+Add6EW/hTNrBQkYt+BFTN/5RDF
 cGJI5v7wZaB+8blD2GcUe3ArRqKra7Cs1IX9h67g65d6clQEOc1O5R5BWJL6N89AV3DIGpLCZ
 XeMz+yr+SUltU5oVpUzdS6UxE07Zixz0R9zhqeOvn8ta2OoSn3o6E8l5u8BTGdGDD8cQWAQpq
 K2GRFoWM3d/8zH6AvyG0cx3FM8uqzBP7+GoZkmEc4WBmLjrNJzM/TqEswiDZbhLoSuAdQq/pB
 ApxblKvBjcwuhCcTMnlGd8dOCxIlI+a7/0WsfoGfjnS5SQcOCzaFRJ2c7QVFfydo0ZrYhMG0q
 X7I2+pr7hf76+Qq9edFjLWyn3GV1BzEMNXZO0PI0odRVQ7wIi0pEyOEPbDSBaJqNMgqM4xwdE
 79BrJYVyPwylP4EM0XnBoOht4Q5bImnR9haQjFg6xucUrPk7UNHHDSl5vPCoG5NGHDSzmVjt2
 wsrUmVmKw914csDnmo9qqbelIstCbYsvmlM8l2PEKKWpnyeUSb7hEfEgni06/+cHRP+r+Gfr5
 cVnjyqSZqGZhHdwKHiHHloEmiVFIPobj7spMKxMa4hhEZ6KNKddxwL5z5nIwfTWOH2SqmJ2r3
 Sjdhg3fTLElQh1lkBFzk12cOW5rt5v/T18ECAr6svQrsacCYnVTWhnR8j0Te5pAUG7S2I/qD+
 4UwJju2av216puo0zuvZyN+CFAqfcgvN8RjAH9bNYzbCX7jwbV3udO2zSls3/qaazxA5gMDi7
 GkAzOXC52toVDAixhmH0i6IKeLvd7491WVxH0glzRRY1nAHwGwBhp0DgQeP14r3G61c1DXzu5
 9J7M6L1WmfrG3P6YKRG+vIQ4NVveWuKf5752OKQiJDYb1Gg8isUzWVOtpjdgVE+OGs9b6N0TR
 kl6nxT+6m0rsp86ubMTfi8ndqGVIl1NjHvy9B0tv1Hh2F9jEc+jXGshYJ6HK3pYyTrPsuqxR8
 Phvyt4W8yBDKk1wHH0y03+g7BCuspX3ZzJRyE+WaS58TYHwBUOFwhik15vfswrSl2+y0CMXbK
 MLtP3mHODIJi+v+KUYOexQgNxVI6eGxv5R2CH7IeEcphR3LaH9qg9oNp8sDDSkJeCUF/VjyCp
 T97lnyfBG4P+BrDOwsLVpYwW7UPoaTnMoE7WWd8IcIpUrVi29V4WKd33R01keWWSQIGzTEGfQ
 K2Xv/mH/boz3yFWqv
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 04.04.21 um 02:16 schrieb Vladimir Oltean:
> On Sat, Apr 03, 2021 at 01:48:43PM +0200, Oleksij Rempel wrote:
>> Make sure that all external port are actually isolated from each other,
>> so no packets are leaked.
>>
>> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
>> ---
>>  drivers/net/dsa/qca/ar9331.c | 145 ++++++++++++++++++++++++++++++++++-
>>  1 file changed, 143 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/net/dsa/qca/ar9331.c b/drivers/net/dsa/qca/ar9331.=
c
>> index 9a5035b2f0ff..a3de3598fbf5 100644
>> --- a/drivers/net/dsa/qca/ar9331.c
>> +++ b/drivers/net/dsa/qca/ar9331.c
>> @@ -60,10 +60,19 @@
>>
>>  /* MIB registers */
>>  #define AR9331_MIB_COUNTER(x)			(0x20000 + ((x) * 0x100))
>>
>> @@ -229,6 +278,7 @@ struct ar9331_sw_priv {
>>  	struct regmap *regmap;
>>  	struct reset_control *sw_reset;
>>  	struct ar9331_sw_port port[AR9331_SW_PORTS];
>> +	int cpu_port;
>>  };
>>
>>  static struct ar9331_sw_priv *ar9331_sw_port_to_priv(struct ar9331_sw_=
port *port)
>> @@ -371,12 +421,72 @@ static int ar9331_sw_mbus_init(struct ar9331_sw_p=
riv *priv)
>>  	return 0;
>>  }
>>
>> -static int ar9331_sw_setup(struct dsa_switch *ds)
>> +static int ar9331_sw_setup_port(struct dsa_switch *ds, int port)
>>  {
>>  	struct ar9331_sw_priv *priv =3D (struct ar9331_sw_priv *)ds->priv;
>>  	struct regmap *regmap =3D priv->regmap;
>> +	u32 port_mask, port_ctrl, val;
>>  	int ret;
>>
>> +	/* Generate default port settings */
>> +	port_ctrl =3D FIELD_PREP(AR9331_SW_PORT_CTRL_PORT_STATE,
>> +			       AR9331_SW_PORT_CTRL_PORT_STATE_DISABLED);
>> +
>> +	if (dsa_is_cpu_port(ds, port)) {
>> +		/*
>> +		 * CPU port should be allowed to communicate with all user
>> +		 * ports.
>> +		 */
>> +		//port_mask =3D dsa_user_ports(ds);
>
> Code commented out should ideally not be part of a submitted patch.

Sorry I overlooked this one

> And the networking comment style is:
>
> 		/* CPU port should be allowed to communicate with all user
> 		 * ports.
> 		 */

Aaa... networking part of kernel code...

>> +		port_mask =3D 0;
>> +		/*
>> +		 * Enable atheros header on CPU port. This will allow us
>> +		 * communicate with each port separately
>> +		 */
>> +		port_ctrl |=3D AR9331_SW_PORT_CTRL_HEAD_EN;
>> +		port_ctrl |=3D AR9331_SW_PORT_CTRL_LEARN_EN;
>> +	} else if (dsa_is_user_port(ds, port)) {
>> +		/*
>> +		 * User ports should communicate only with the CPU port.
>> +		 */
>> +		port_mask =3D BIT(priv->cpu_port);
>
> For all you care, the CPU port here is dsa_to_port(ds, port)->cpu_dp->in=
dex,
> no need to go to those lengths in order to find it. DSA does not have
> fixed number for the CPU port but a CPU port pointer per port in order
> to not close the door for the future support of multiple CPU ports.

ok.

>> +		/* Enable unicast address learning by default */
>> +		port_ctrl |=3D AR9331_SW_PORT_CTRL_LEARN_EN
>> +		/* IGMP snooping seems to work correctly, let's use it */
>> +			  | AR9331_SW_PORT_CTRL_IGMP_MLD_EN
>
> I don't really like this ad-hoc enablement of IGMP/MLD snooping from the=
 driver,
> please add the pass-through in DSA for SWITCHDEV_ATTR_ID_BRIDGE_MC_DISAB=
LED
> (dsa_slave_port_attr_set, dsa_port_switchdev_sync, dsa_port_switchdev_un=
sync
> should all call a dsa_switch_ops :: port_snoop_igmp_mld function) and th=
en
> toggle this bit from there.

sounds good. Looks like there are few more driver need to be fixed:
drivers/net/dsa/lan9303-core.c
drivers/net/dsa/mv88e6xxx/chip.c


>
>> +			  | AR9331_SW_PORT_CTRL_SINGLE_VLAN_EN;
>> +	} else {
>> +		/* Other ports do not need to communicate at all */
>> +		port_mask =3D 0;
>> +	}
>> +
>> +	val =3D FIELD_PREP(AR9331_SW_PORT_VLAN_8021Q_MODE,
>> +			 AR9331_SW_8021Q_MODE_NONE) |
>> +		FIELD_PREP(AR9331_SW_PORT_VLAN_PORT_VID_MEMBER, port_mask) |
>> +		FIELD_PREP(AR9331_SW_PORT_VLAN_PORT_VID,
>> +			   AR9331_SW_PORT_VLAN_PORT_VID_DEF);
>> +
>> +	ret =3D regmap_write(regmap, AR9331_SW_REG_PORT_VLAN(port), val);
>> +	if (ret)
>> +		goto error;
>> +
>> +	ret =3D regmap_write(regmap, AR9331_SW_REG_PORT_CTRL(port), port_ctrl=
);
>> +	if (ret)
>> +		goto error;
>> +
>> +	return 0;
>> +error:
>> +	dev_err_ratelimited(priv->dev, "%s: error: %i\n", __func__, ret);
>> +
>> +	return ret;
>> +}
>> +
>> +static int ar9331_sw_setup(struct dsa_switch *ds)
>> +{
>> +	struct ar9331_sw_priv *priv =3D (struct ar9331_sw_priv *)ds->priv;
>> +	struct regmap *regmap =3D priv->regmap;
>> +	int ret, i;
>> +
>>  	ret =3D ar9331_sw_reset(priv);
>>  	if (ret)
>>  		return ret;
>> @@ -390,7 +500,8 @@ static int ar9331_sw_setup(struct dsa_switch *ds)
>>
>>  	/* Do not drop broadcast frames */
>>  	ret =3D regmap_write_bits(regmap, AR9331_SW_REG_FLOOD_MASK,
>> -				AR9331_SW_FLOOD_MASK_BROAD_TO_CPU,
>> +				AR9331_SW_FLOOD_MASK_BROAD_TO_CPU
>> +				| AR9331_SW_FLOOD_MASK_MULTI_FLOOD_DP,
>>  				AR9331_SW_FLOOD_MASK_BROAD_TO_CPU);
>>  	if (ret)
>>  		goto error;
>> @@ -402,6 +513,36 @@ static int ar9331_sw_setup(struct dsa_switch *ds)
>>  	if (ret)
>>  		goto error;
>>
>> +	/*
>> +	 * Configure the ARL:
>> +	 * AR9331_SW_AT_ARP_EN - why?
>> +	 * AR9331_SW_AT_LEARN_CHANGE_EN - why?
>> +	 */
>
> Good question, why?

I still do not know if it is a good idea. This bits are enabled by
default. May be you can help me understand it. Datasheet says:
ARP_EN:
ARP frame acknowledge enable. Setting this bit to 1 is an
acknowledgement by the hardware of a received ARP frame and allows it
to be copied to the CPU port.

LEARN_CHANGE_EN:
0 - If a hash violation occurs during learning, no new address will be
learned in the ARL
1 - Enables a new MAC address change if a hash violation occurs
during learning

=2D-
Regards,
Oleksij
