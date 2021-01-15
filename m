Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BFC02F73AE
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 08:27:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731277AbhAOH07 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 02:26:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729451AbhAOH06 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 02:26:58 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 038A4C061757
        for <netdev@vger.kernel.org>; Thu, 14 Jan 2021 23:26:18 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1l0JUn-00067h-79; Fri, 15 Jan 2021 08:26:09 +0100
Received: from [IPv6:2a03:f580:87bc:d400:1f14:2ed2:f7ac:c4d] (unknown [IPv6:2a03:f580:87bc:d400:1f14:2ed2:f7ac:c4d])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256
         client-signature RSA-PSS (4096 bits) client-digest SHA256)
        (Client CN "mkl@blackshift.org", Issuer "StartCom Class 1 Client CA" (not verified))
        (Authenticated sender: mkl@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 9A6245C44F1;
        Fri, 15 Jan 2021 07:26:05 +0000 (UTC)
To:     Vincent MAILHOL <mailhol.vincent@wanadoo.fr>,
        Oliver Hartkopp <socketcan@hartkopp.net>
Cc:     linux-can <linux-can@vger.kernel.org>,
        Arunachalam Santhanam <arunachalam.santhanam@in.bosch.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jimmy Assarsson <extja@kvaser.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        "open list : NETWORKING DRIVERS" <netdev@vger.kernel.org>
References: <20210112130538.14912-1-mailhol.vincent@wanadoo.fr>
 <20210112130538.14912-2-mailhol.vincent@wanadoo.fr>
 <981eb251-1573-5852-4b16-2e207eb3c4da@hartkopp.net>
 <CAMZ6RqKeGVsF+CcqoAWC7JXEo2oLTS5E5B3Jk4oeiF9XWEC3Sw@mail.gmail.com>
From:   Marc Kleine-Budde <mkl@pengutronix.de>
Autocrypt: addr=mkl@pengutronix.de; prefer-encrypt=mutual; keydata=
 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
Subject: Re: [PATCH v10 1/1] can: usb: etas_es58X: add support for ETAS ES58X
 CAN USB interfaces
Message-ID: <3daf39cb-2835-379d-86df-91b17282594a@pengutronix.de>
Date:   Fri, 15 Jan 2021 08:26:01 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <CAMZ6RqKeGVsF+CcqoAWC7JXEo2oLTS5E5B3Jk4oeiF9XWEC3Sw@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="epfT1Br9KFKBmVpkyuj6BGl3P8PJ3tpKG"
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--epfT1Br9KFKBmVpkyuj6BGl3P8PJ3tpKG
Content-Type: multipart/mixed; boundary="o9inDsSlrN66A04ochUbDSaLVkSou9ERX";
 protected-headers="v1"
From: Marc Kleine-Budde <mkl@pengutronix.de>
To: Vincent MAILHOL <mailhol.vincent@wanadoo.fr>,
 Oliver Hartkopp <socketcan@hartkopp.net>
Cc: linux-can <linux-can@vger.kernel.org>,
 Arunachalam Santhanam <arunachalam.santhanam@in.bosch.com>,
 Wolfgang Grandegger <wg@grandegger.com>,
 "David S . Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
 Jimmy Assarsson <extja@kvaser.com>, Masahiro Yamada <masahiroy@kernel.org>,
 "open list : NETWORKING DRIVERS" <netdev@vger.kernel.org>
Message-ID: <3daf39cb-2835-379d-86df-91b17282594a@pengutronix.de>
Subject: Re: [PATCH v10 1/1] can: usb: etas_es58X: add support for ETAS ES58X
 CAN USB interfaces
References: <20210112130538.14912-1-mailhol.vincent@wanadoo.fr>
 <20210112130538.14912-2-mailhol.vincent@wanadoo.fr>
 <981eb251-1573-5852-4b16-2e207eb3c4da@hartkopp.net>
 <CAMZ6RqKeGVsF+CcqoAWC7JXEo2oLTS5E5B3Jk4oeiF9XWEC3Sw@mail.gmail.com>
In-Reply-To: <CAMZ6RqKeGVsF+CcqoAWC7JXEo2oLTS5E5B3Jk4oeiF9XWEC3Sw@mail.gmail.com>

--o9inDsSlrN66A04ochUbDSaLVkSou9ERX
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 1/15/21 1:41 AM, Vincent MAILHOL wrote:
> On Fri. 15 Jan 2021 at 02:23, Oliver Hartkopp <socketcan@hartkopp.net> =
wrote:
>>
>> Hi Vincent,
>>
>> On 12.01.21 14:05, Vincent Mailhol wrote:
>>> This driver supports the ES581.4, ES582.1 and ES584.1 interfaces from=

>>> ETAS GmbH (https://www.etas.com/en/products/es58x.php).
>>
>> (..)
>>
>>> diff --git a/drivers/net/can/usb/etas_es58x/es58x_fd.c b/drivers/net/=
can/usb/etas_es58x/es58x_fd.c
>>> new file mode 100644
>>> index 000000000000..6b9534f23c96
>>> --- /dev/null
>>> +++ b/drivers/net/can/usb/etas_es58x/es58x_fd.c
>>
>> (..)
>>
>>> +static void es58x_fd_print_bittiming(struct net_device *netdev,
>>> +                                  struct es58x_fd_bittiming
>>> +                                  *es58x_fd_bittiming, char *type)
>>> +{
>>> +     netdev_vdbg(netdev, "bitrate %s    =3D %d\n", type,
>>> +                 le32_to_cpu(es58x_fd_bittiming->bitrate));
>>> +     netdev_vdbg(netdev, "tseg1 %s      =3D %d\n", type,
>>> +                 le16_to_cpu(es58x_fd_bittiming->tseg1));
>>> +     netdev_vdbg(netdev, "tseg2 %s      =3D %d\n", type,
>>> +                 le16_to_cpu(es58x_fd_bittiming->tseg2));
>>> +     netdev_vdbg(netdev, "brp %s        =3D %d\n", type,
>>> +                 le16_to_cpu(es58x_fd_bittiming->brp));
>>> +     netdev_vdbg(netdev, "sjw %s        =3D %d\n", type,
>>> +                 le16_to_cpu(es58x_fd_bittiming->sjw));
>>> +}
>>
>> What is the reason for this code?
>>
>> These values can be retrieved with the 'ip' tool and are probably
>> interesting for development - but not in the final code.
>=20
> First thing, I used netdev_vdbg() (verbose debug). That macro
> will only produce code if VERBOSE_DEBUG is defined. Normal users
> will not see those. So yes, this is mostly for development.
>=20
> Also, just realised that netdev_vdbg() is barely used
> anywhere (only three files use it:
> https://elixir.bootlin.com/linux/v5.11-rc3/C/ident/netdev_vdbg).
>=20
> I guess that I will remove it :)
>=20
>>> +
>>> +static void es58x_fd_print_conf(struct net_device *netdev,
>>> +                             struct es58x_fd_tx_conf_msg *tx_conf_ms=
g)
>>> +{
>>> +     es58x_fd_print_bittiming(netdev, &tx_conf_msg->nominal_bittimin=
g,
>>> +                              "nominal");
>>> +     netdev_vdbg(netdev, "samples_per_bit    =3D %d\n",
>>> +                 tx_conf_msg->samples_per_bit);
>>> +     netdev_vdbg(netdev, "sync_edge          =3D %d\n",
>>> +                 tx_conf_msg->sync_edge);
>>> +     netdev_vdbg(netdev, "physical_layer     =3D %d\n",
>>> +                 tx_conf_msg->physical_layer);
>>> +     netdev_vdbg(netdev, "self_reception     =3D %d\n",
>>> +                 tx_conf_msg->self_reception_mode);
>>> +     netdev_vdbg(netdev, "ctrlmode           =3D %d\n", tx_conf_msg-=
>ctrlmode);
>>> +     netdev_vdbg(netdev, "canfd_enabled      =3D %d\n",
>>> +                 tx_conf_msg->canfd_enabled);
>>> +     if (tx_conf_msg->canfd_enabled) {
>>> +             es58x_fd_print_bittiming(netdev,
>>> +                                      &tx_conf_msg->data_bittiming, =
"data");
>>> +             netdev_vdbg(netdev,
>>> +                         "Transmitter Delay Compensation        =3D =
%d\n",
>>> +                         tx_conf_msg->tdc);
>>> +             netdev_vdbg(netdev,
>>> +                         "Transmitter Delay Compensation Offset =3D =
%d\n",
>>> +                         le16_to_cpu(tx_conf_msg->tdco));
>>> +             netdev_vdbg(netdev,
>>> +                         "Transmitter Delay Compensation Filter =3D =
%d\n",
>>> +                         le16_to_cpu(tx_conf_msg->tdcf));
>>> +     }
>>> +}
>>
>> Same here.
>>
>> Either the information can be retrieved with the 'ip' tool OR the are
>> not necessary as set to some reasonable default anyway
>=20
> Ack, will remove.
>=20
>> OR we should
>> implement the functionality in the general CAN driver infrastructure.
>=20
> Would make sense to me to add the tdco (Transmitter Delay
> Compensation Offset). Ref: ISO 11898-1 section
> 11.3.3 "Transmitter delay compensation"
>=20
> I would just like your opinion on one topic: the tdco is specific
> to CAN FD. If we add it, we have two choices:
>   1. put it in struct can_bittiming: that will mean that we will
>      have an unused field for classical CAN (field bittiming of
>      struct can_priv).
>   2. put it in struct can_priv (but outside of struct
>      can_bittiming): no unused field but less pretty.

3. Deprecate struct can_bittiming as the user space interface
   and transfer each member individually via netlink. Extend
   the kernel-only can_bittiming by the tdc related
   parameters, and add these to the new netlink interface.

I prefer this, as I want to extend the bittiming_const in this way, too. =
There
are CAN controllers, where the bit timing calculation:

> 	bt->prop_seg =3D tseg1 / 2;
> 	bt->phase_seg1 =3D tseg1 - bt->prop_seg;

doesn't work anymore, as they have asymmetric prog_seg and phase_seg1, so=
 that
splitting tseg1 in half doesn't work anymore.

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |


--o9inDsSlrN66A04ochUbDSaLVkSou9ERX--

--epfT1Br9KFKBmVpkyuj6BGl3P8PJ3tpKG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmABQ4kACgkQqclaivrt
76lNyAf+K7h9VMYE4qP3RXoskgWJSzAQPjLgza08h1165bLdica2gGDyPFSMaa0H
JRHXKGBh1aMDVHzAgWpNxxgckf1gEnqZzGirMwn9aFIyGRehNWRMC6fJYim497kW
c9eYqACAXrqhOnXbG3OHK97pKzBRXSvfN1AgIKaqYi5XwLR5OwHRTp8Yw/BB83nj
p4z7nFHlnXCiIwwPHFoEWj2X0PRuoi/qgyRFT0AbEjA7+ZvRcj9rBcGEkclt3dvd
5pQA3F73I8l0F6Je30IH8caV/61/oPQFQZ28E9bQFJ9dobRuEb0ZbHWMm+nuynoV
heJhIVqIRvjLUsBsxl24hy5d1lkdaQ==
=2QcJ
-----END PGP SIGNATURE-----

--epfT1Br9KFKBmVpkyuj6BGl3P8PJ3tpKG--
