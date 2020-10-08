Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FFD4287E4C
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 23:47:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728037AbgJHVrx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 17:47:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726115AbgJHVrw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 17:47:52 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6E88C0613D2
        for <netdev@vger.kernel.org>; Thu,  8 Oct 2020 14:47:52 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1kQdlJ-0002et-0P; Thu, 08 Oct 2020 23:47:45 +0200
Received: from [IPv6:2a03:f580:87bc:d400:cb0f:29b6:9c97:99ea] (unknown [IPv6:2a03:f580:87bc:d400:cb0f:29b6:9c97:99ea])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256
         client-signature RSA-PSS (4096 bits) client-digest SHA256)
        (Client CN "mkl@blackshift.org", Issuer "StartCom Class 1 Client CA" (not verified))
        (Authenticated sender: mkl@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 35C8E5754A9;
        Thu,  8 Oct 2020 21:47:43 +0000 (UTC)
To:     Jakub Kicinski <kuba@kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>
Cc:     netdev@vger.kernel.org,
        syzbot+3f3837e61a48d32b495f@syzkaller.appspotmail.com,
        Robin van der Gracht <robin@protonic.nl>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>
References: <20201008061821.24663-1-xiyou.wangcong@gmail.com>
 <20201008103410.4fea97a5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Marc Kleine-Budde <mkl@pengutronix.de>
Autocrypt: addr=mkl@pengutronix.de; prefer-encrypt=mutual; keydata=
 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
Subject: Re: [Patch net] can: initialize skbcnt in j1939_tp_tx_dat_new()
Message-ID: <747813a4-eea4-b390-569e-44f8b3958fcb@pengutronix.de>
Date:   Thu, 8 Oct 2020 23:47:38 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201008103410.4fea97a5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="NQ2pfC95eU6i8g7nVimhUhzk8l9N7ptWy"
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--NQ2pfC95eU6i8g7nVimhUhzk8l9N7ptWy
Content-Type: multipart/mixed; boundary="h5eABzogSIp2hB8ZTSuigoDKn0OoRkVin";
 protected-headers="v1"
From: Marc Kleine-Budde <mkl@pengutronix.de>
To: Jakub Kicinski <kuba@kernel.org>, Cong Wang <xiyou.wangcong@gmail.com>
Cc: netdev@vger.kernel.org,
 syzbot+3f3837e61a48d32b495f@syzkaller.appspotmail.com,
 Robin van der Gracht <robin@protonic.nl>,
 Oleksij Rempel <linux@rempel-privat.de>,
 Oliver Hartkopp <socketcan@hartkopp.net>,
 Marc Kleine-Budde <mkl@pengutronix.de>
Message-ID: <747813a4-eea4-b390-569e-44f8b3958fcb@pengutronix.de>
Subject: Re: [Patch net] can: initialize skbcnt in j1939_tp_tx_dat_new()
References: <20201008061821.24663-1-xiyou.wangcong@gmail.com>
 <20201008103410.4fea97a5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201008103410.4fea97a5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>

--h5eABzogSIp2hB8ZTSuigoDKn0OoRkVin
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 10/8/20 7:34 PM, Jakub Kicinski wrote:
> On Wed,  7 Oct 2020 23:18:21 -0700 Cong Wang wrote:
>> This fixes an uninit-value warning:
>> BUG: KMSAN: uninit-value in can_receive+0x26b/0x630 net/can/af_can.c:6=
50
>>
>> Reported-and-tested-by: syzbot+3f3837e61a48d32b495f@syzkaller.appspotm=
ail.com
>> Fixes: 9d71dd0c7009 ("can: add support of SAE J1939 protocol")
>> Cc: Robin van der Gracht <robin@protonic.nl>
>> Cc: Oleksij Rempel <linux@rempel-privat.de>
>> Cc: Pengutronix Kernel Team <kernel@pengutronix.de>
>> Cc: Oliver Hartkopp <socketcan@hartkopp.net>
>> Cc: Marc Kleine-Budde <mkl@pengutronix.de>
>> Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
>> ---
>>  net/can/j1939/transport.c | 1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/net/can/j1939/transport.c b/net/can/j1939/transport.c
>> index 0cec4152f979..88cf1062e1e9 100644
>> --- a/net/can/j1939/transport.c
>> +++ b/net/can/j1939/transport.c
>> @@ -580,6 +580,7 @@ sk_buff *j1939_tp_tx_dat_new(struct j1939_priv *pr=
iv,
>>  	skb->dev =3D priv->ndev;
>>  	can_skb_reserve(skb);
>>  	can_skb_prv(skb)->ifindex =3D priv->ndev->ifindex;
>> +	can_skb_prv(skb)->skbcnt =3D 0;
>>  	/* reserve CAN header */
>>  	skb_reserve(skb, offsetof(struct can_frame, data));
>=20
> Thanks! Looks like there is another can_skb_reserve(skb) on line 1489,
> is that one fine?

I think say yes, but better safe the sorry.

> Marc - should I take this directly into net, in case there is a last
> minute PR to Linus for 5.9?

Yes, of you can pull Cong Wang's patch and my patch, that fixes the other=

missing init of skbcnt.

That tag includes my previous oneline-patch-pull-request from 20201006, t=
hat
fixes the c_can driver on basically all stm32mp1 based boards. Would be g=
ood to
see that in 5.9, as well.

git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can.git
tags/linux-can-fixes-for-5.9-20201008

I've send a proper pull request some seconds ago.

Marc
--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |


--h5eABzogSIp2hB8ZTSuigoDKn0OoRkVin--

--NQ2pfC95eU6i8g7nVimhUhzk8l9N7ptWy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAl9/iPoACgkQqclaivrt
76kaFAf+KfJSMVpEDd/Fv0gksJtx2ERxM2BlN8P8MwVq1BmMKcHU3LVdYdWBYuei
vhCvWYCjZayE9zd5dW/DTXTNX0cA9JmmT+QyP6wI90+Eu2OcsiLS08lYTEfANQwf
3QnGWYZ5LVgtfprOaDUZN2v1EwZVMNO/HuyuzlrQRP12sZQsBOo/7YnL0n2tAWo+
NZs8gXm23IJfY6NRqNViSYoBhMrES78CGxplxkS6kfvmuF/F5KHtYmeQQRwyJ3+P
6RuBgm707oJQdMcQcDx29hLnU6IpHj8psRc9DsUyrrRt/mAMaBAGbDkbcXNXOIzz
da4SxqRSSQeUd3MvVnEzH5EGhYHSqg==
=vmh/
-----END PGP SIGNATURE-----

--NQ2pfC95eU6i8g7nVimhUhzk8l9N7ptWy--
