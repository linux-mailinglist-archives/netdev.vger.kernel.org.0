Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 403F42A782C
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 08:44:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728855AbgKEHoq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 02:44:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725320AbgKEHoq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Nov 2020 02:44:46 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F273BC0613CF
        for <netdev@vger.kernel.org>; Wed,  4 Nov 2020 23:44:45 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1kaZwl-0000Dr-UI; Thu, 05 Nov 2020 08:44:40 +0100
Received: from [IPv6:2a03:f580:87bc:d400:74d6:79:dc8d:9bc9] (unknown [IPv6:2a03:f580:87bc:d400:74d6:79:dc8d:9bc9])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits)
         client-signature RSA-PSS (4096 bits))
        (Client CN "mkl@blackshift.org", Issuer "StartCom Class 1 Client CA" (not verified))
        (Authenticated sender: mkl@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 7370B58ADD3;
        Thu,  5 Nov 2020 07:44:35 +0000 (UTC)
To:     Vincent MAILHOL <mailhol.vincent@wanadoo.fr>,
        Oliver Hartkopp <socketcan@hartkopp.net>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        linux-can <linux-can@vger.kernel.org>, kernel@pengutronix.de
References: <20201103220636.972106-1-mkl@pengutronix.de>
 <20201103220636.972106-6-mkl@pengutronix.de>
 <20201103172102.3d75cb96@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CANn89iK5xqYmLT=DZk0S15pRObSJbo2-zrO7_A0Q46Ujg1RxYg@mail.gmail.com>
 <988aea6a-c6b6-5d58-3a8e-604a52df0320@hartkopp.net>
 <20201104080237.4d6605ef@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <550bf8d4-bf4c-b1ef-cd41-78c2b71514e3@hartkopp.net>
 <CAMZ6RqK=oEn3pgHb2byMC_SOVdG3Bbsfzssu9Fd-jDpSzEbrwQ@mail.gmail.com>
From:   Marc Kleine-Budde <mkl@pengutronix.de>
Autocrypt: addr=mkl@pengutronix.de; prefer-encrypt=mutual; keydata=
 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
Subject: Re: [net 05/27] can: dev: can_get_echo_skb(): prevent call to
 kfree_skb() in hard IRQ context
Message-ID: <02c5f3c7-7b6a-a487-39fc-50b5fad0eebc@pengutronix.de>
Date:   Thu, 5 Nov 2020 08:44:31 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <CAMZ6RqK=oEn3pgHb2byMC_SOVdG3Bbsfzssu9Fd-jDpSzEbrwQ@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="k8eyacHwfbgWBAd63vkBdRW325jroGsr4"
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--k8eyacHwfbgWBAd63vkBdRW325jroGsr4
Content-Type: multipart/mixed; boundary="9JGncgaiO20Vp0jxy0EKrDBBgDS5I0EOv";
 protected-headers="v1"
From: Marc Kleine-Budde <mkl@pengutronix.de>
To: Vincent MAILHOL <mailhol.vincent@wanadoo.fr>,
 Oliver Hartkopp <socketcan@hartkopp.net>
Cc: Jakub Kicinski <kuba@kernel.org>, Eric Dumazet <edumazet@google.com>,
 netdev <netdev@vger.kernel.org>, David Miller <davem@davemloft.net>,
 linux-can <linux-can@vger.kernel.org>, kernel@pengutronix.de
Message-ID: <02c5f3c7-7b6a-a487-39fc-50b5fad0eebc@pengutronix.de>
Subject: Re: [net 05/27] can: dev: can_get_echo_skb(): prevent call to
 kfree_skb() in hard IRQ context
References: <20201103220636.972106-1-mkl@pengutronix.de>
 <20201103220636.972106-6-mkl@pengutronix.de>
 <20201103172102.3d75cb96@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CANn89iK5xqYmLT=DZk0S15pRObSJbo2-zrO7_A0Q46Ujg1RxYg@mail.gmail.com>
 <988aea6a-c6b6-5d58-3a8e-604a52df0320@hartkopp.net>
 <20201104080237.4d6605ef@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <550bf8d4-bf4c-b1ef-cd41-78c2b71514e3@hartkopp.net>
 <CAMZ6RqK=oEn3pgHb2byMC_SOVdG3Bbsfzssu9Fd-jDpSzEbrwQ@mail.gmail.com>
In-Reply-To: <CAMZ6RqK=oEn3pgHb2byMC_SOVdG3Bbsfzssu9Fd-jDpSzEbrwQ@mail.gmail.com>

--9JGncgaiO20Vp0jxy0EKrDBBgDS5I0EOv
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 11/5/20 5:47 AM, Vincent MAILHOL wrote:
>>> Okay, we can take this as a quick fix but to me it seems a little
>>> strange to be dropping what is effectively locally generated frames.
>=20
> For those who are not familiar with SocketCAN and to make sure that we
> are all aligned here, let me give a bit of context of how the echo on C=
AN
> skbs is usually implement in the drivers:
>  * In the xmit() branch, the driver would queue the skb using
>    can_put_echo_skb().
>  * Whenever the driver gets notified of a successful TX, it will loopba=
ck
>    the skb using can_get_echo_skb().
>=20
> This is why the loopback is usually done in hardware IRQ context (but
> drivers are also free to skip the second step and directly loopback the=

> skb in the xmit() branch).
>=20
>> Thanks! So this patch doesn't hinder Marc's PR :-)
>>
>>> Can we use a NAPI poll model here and back pressure TX if the echo
>>> is not keeping up?
>>
>> Some of the CAN network drivers already support NAPI.

And some drivers (i.e. flexcan and mcp251xfd) already queue the ech_skb v=
ia NAPI.

> I had a quick look at NAPI in the past and my understanding is that it
> requires the ability to turn off hardware interrupts meaning that it ca=
n
> be only used on some NIC, not but not, for example, on USB devices.
>=20
> It would be nice to extend the NAPI with skb loopback for drivers which=

> already supports it but I am not sure how to include the other drivers.=

>=20
>> @Marc: Can we also use NAPI for echo'ing the skbs?

The flexcan driver does:

https://elixir.bootlin.com/linux/v5.10-rc2/source/drivers/net/can/flexcan=
=2Ec#L1080

In the interrupt handler, the driver pushes the echo_skb into the rx-offl=
oad
queue and triggers NAPI. The rx-offload pushed the skb into the networkin=
g stack
via NAPI.

Here the code in the mcp251xfd driver:

https://elixir.bootlin.com/linux/v5.10-rc2/source/drivers/net/can/spi/mcp=
251xfd/mcp251xfd-core.c#L1237

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |


--9JGncgaiO20Vp0jxy0EKrDBBgDS5I0EOv--

--k8eyacHwfbgWBAd63vkBdRW325jroGsr4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAl+jrV8ACgkQqclaivrt
76mr/gf+JNei7BOuAL5HhkHMbRJoXQ1JNSORr4hiyDxvHwXLg8CmD3f5sAfH9x76
3O73n1Qx8j+QzImujVXA9DM3DJsKSvWNWQZfurtxkDegFV08MicXU2j1yx5N6jZH
Gs69PA6fbc1McJzwldiZyoiuCNxWllrpinBccRzwVWkY6rKhQo7LIXQR8sNbQfBj
LFhaIn7ec26HZjZsgEGk8DuRmp4LpS0OY2LT6frq5Gh1JQKMfcrnZlt9D4SZkNGV
8yiALe/FLTGfSK6hlJozsaamghLDO6RhnhN+3ERYcrDOM2mI/PluXP92B+RStYYn
5W2d5BiC3BmONy0L4K3hBKgh75XICQ==
=aPyB
-----END PGP SIGNATURE-----

--k8eyacHwfbgWBAd63vkBdRW325jroGsr4--
