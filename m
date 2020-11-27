Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C8CC2C623B
	for <lists+netdev@lfdr.de>; Fri, 27 Nov 2020 10:49:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728849AbgK0Js4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Nov 2020 04:48:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728792AbgK0Jsz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Nov 2020 04:48:55 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FC9AC0613D4
        for <netdev@vger.kernel.org>; Fri, 27 Nov 2020 01:48:55 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1kiaN0-0005u7-KB; Fri, 27 Nov 2020 10:48:50 +0100
Received: from [IPv6:2a03:f580:87bc:d400:2ba:5988:109d:d012] (2a03-f580-87bc-d400-02ba-5988-109d-d012.ip6.dokom21.de [IPv6:2a03:f580:87bc:d400:2ba:5988:109d:d012])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits)
         client-signature RSA-PSS (4096 bits))
        (Client CN "mkl@blackshift.org", Issuer "StartCom Class 1 Client CA" (not verified))
        (Authenticated sender: mkl@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id A46EB59DE2E;
        Fri, 27 Nov 2020 09:48:48 +0000 (UTC)
To:     Oliver Hartkopp <socketcan@hartkopp.net>, dvyukov@google.com,
        netdev@vger.kernel.org, linux-can@vger.kernel.org
Cc:     syzkaller-bugs@googlegroups.com,
        syzbot+381d06e0c8eaacb8706f@syzkaller.appspotmail.com,
        syzbot+d0ddd88c9a7432f041e6@syzkaller.appspotmail.com,
        syzbot+76d62d3b8162883c7d11@syzkaller.appspotmail.com
References: <20201126192140.14350-1-socketcan@hartkopp.net>
From:   Marc Kleine-Budde <mkl@pengutronix.de>
Autocrypt: addr=mkl@pengutronix.de; prefer-encrypt=mutual; keydata=
 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
Subject: Re: [PATCH] can: remove WARN() statement from list operation sanity
 check
Message-ID: <73bec80c-fb97-0808-8ca5-6579d9ff5251@pengutronix.de>
Date:   Fri, 27 Nov 2020 10:48:45 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201126192140.14350-1-socketcan@hartkopp.net>
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="v0VvSJHnuJ5EC56hb3h8YtCtTwopSNL6L"
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--v0VvSJHnuJ5EC56hb3h8YtCtTwopSNL6L
Content-Type: multipart/mixed; boundary="qwG4MSrNhYaBbRPgxYZUvxaqJs2AOouo5";
 protected-headers="v1"
From: Marc Kleine-Budde <mkl@pengutronix.de>
To: Oliver Hartkopp <socketcan@hartkopp.net>, dvyukov@google.com,
 netdev@vger.kernel.org, linux-can@vger.kernel.org
Cc: syzkaller-bugs@googlegroups.com,
 syzbot+381d06e0c8eaacb8706f@syzkaller.appspotmail.com,
 syzbot+d0ddd88c9a7432f041e6@syzkaller.appspotmail.com,
 syzbot+76d62d3b8162883c7d11@syzkaller.appspotmail.com
Message-ID: <73bec80c-fb97-0808-8ca5-6579d9ff5251@pengutronix.de>
Subject: Re: [PATCH] can: remove WARN() statement from list operation sanity
 check
References: <20201126192140.14350-1-socketcan@hartkopp.net>
In-Reply-To: <20201126192140.14350-1-socketcan@hartkopp.net>

--qwG4MSrNhYaBbRPgxYZUvxaqJs2AOouo5
Content-Type: text/plain; charset=utf-8
Content-Language: de-DE
Content-Transfer-Encoding: quoted-printable

On 11/26/20 8:21 PM, Oliver Hartkopp wrote:
> To detect potential bugs in CAN protocol implementations (double remova=
l
> of receiver entries) a WARN() statement has been used if no matching li=
st
> item was found for removal.
>=20
> The fault injection issued by syzkaller was able to create a situation
> where the closing of a socket runs simultaneously to the notifier call
> chain for removing the CAN network device in use.
>=20
> This case is very unlikely in real life but it doesn't break anything.
> Therefore we just replace the WARN() statement with pr_warn() to
> preserve the notification for the CAN protocol development.
>=20
> Reported-by: syzbot+381d06e0c8eaacb8706f@syzkaller.appspotmail.com
> Reported-by: syzbot+d0ddd88c9a7432f041e6@syzkaller.appspotmail.com
> Reported-by: syzbot+76d62d3b8162883c7d11@syzkaller.appspotmail.com
> Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
> ---
>  net/can/af_can.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
>=20
> diff --git a/net/can/af_can.c b/net/can/af_can.c
> index 5d124c155904..7c5ccdec89e1 100644
> --- a/net/can/af_can.c
> +++ b/net/can/af_can.c
> @@ -539,14 +539,17 @@ void can_rx_unregister(struct net *net, struct ne=
t_device *dev, canid_t can_id,
>  			break;
>  	}
> =20
>  	/* Check for bugs in CAN protocol implementations using af_can.c:
>  	 * 'rcv' will be NULL if no matching list item was found for removal.=

> +	 * As this case may potentially happen when closing a socket while
> +	 * the notifier for removing the CAN netdev is running we just print
> +	 * a warning here. Reported by syskaller (see commit message)
I've removed the "Reported by syskaller (see commit message)" while apply=
ing the
patch, to keep this comment short and to the point. Use tig/git blame (or=
 any
other future tool) to figure out the commit message for details :D

>  	 */
>  	if (!rcv) {
> -		WARN(1, "BUG: receive list entry not found for dev %s, id %03X, mask=
 %03X\n",
> -		     DNAME(dev), can_id, mask);
> +		pr_warn("can: receive list entry not found for dev %s, id %03X, mask=
 %03X\n",
> +			DNAME(dev), can_id, mask);
>  		goto out;
>  	}
> =20
>  	hlist_del_rcu(&rcv->list);
>  	dev_rcv_lists->entries--;
>=20

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |


--qwG4MSrNhYaBbRPgxYZUvxaqJs2AOouo5--

--v0VvSJHnuJ5EC56hb3h8YtCtTwopSNL6L
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAl/Ay30ACgkQqclaivrt
76nRsAf/bbkRLKRF4JaMAnbu5kbsLBcFYFdsky0MKDchMLcxruEP3ZHlIDptjMpp
da3mNdqrfzXmEPiNhYk9bUgMp6vcthermCD3NSE5p/il7hC4oIO4lH0n90+bBTTK
X/VYWrSPEgcBXibGfQqSApzLBEFZKQFC816NBTFmXUZ/6eyOdzQb3pEyaGRDLp3c
XMk5vabewtVQGOH1dRbF7H3S3UW8tAtv6Ws2pAO4PVqgO7RHqjYZztqsCH7lNR5H
QaxnvBCriHH9IEa4o+Wej4lQIPBB1E8rXcLWOfYd87ZIF6W44SyieX4tDxMjq7nK
9nJ+/IjpDO9lLqG8u6Y+5I5K0fducQ==
=qxzd
-----END PGP SIGNATURE-----

--v0VvSJHnuJ5EC56hb3h8YtCtTwopSNL6L--
