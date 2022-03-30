Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5E314EBBE0
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 09:38:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243879AbiC3Hjv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 03:39:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242842AbiC3Hjn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 03:39:43 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2BC0DFA2
        for <netdev@vger.kernel.org>; Wed, 30 Mar 2022 00:37:55 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nZSte-0004cO-Sb; Wed, 30 Mar 2022 09:37:38 +0200
Received: from pengutronix.de (2a03-f580-87bc-d400-5314-bece-822a-622d.ip6.dokom21.de [IPv6:2a03:f580:87bc:d400:5314:bece:822a:622d])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 585F256C47;
        Wed, 30 Mar 2022 07:37:36 +0000 (UTC)
Date:   Wed, 30 Mar 2022 09:37:35 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     "Zhang, Qiang1" <qiang1.zhang@intel.com>
Cc:     syzbot <syzbot+4d0ae90a195b269f102d@syzkaller.appspotmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "pfink@christ-es.de" <pfink@christ-es.de>,
        "syzkaller-bugs@googlegroups.com" <syzkaller-bugs@googlegroups.com>,
        "wg@grandegger.com" <wg@grandegger.com>
Subject: Re: [syzbot] memory leak in gs_usb_probe
Message-ID: <20220330073735.tqfmyfgzyfbqmkpn@pengutronix.de>
References: <000000000000bd6ee505db5cfec6@google.com>
 <PH0PR11MB5880D90EDFAA0A190D927914DA1F9@PH0PR11MB5880.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="u2qbbpeazfhzmyv4"
Content-Disposition: inline
In-Reply-To: <PH0PR11MB5880D90EDFAA0A190D927914DA1F9@PH0PR11MB5880.namprd11.prod.outlook.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--u2qbbpeazfhzmyv4
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 30.03.2022 01:57:08, Zhang, Qiang1 wrote:
> Hello,
>=20
> syzbot found the following issue on:
>=20
> HEAD commit:    52deda9551a0 Merge branch 'akpm' (patches from Andrew)
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=3D12b472dd700000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=3D9ca2a67ddb200=
27f
> dashboard link: https://syzkaller.appspot.com/bug?extid=3D4d0ae90a195b269=
f102d
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binuti=
ls for Debian) 2.35.2
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=3D12e96e1d700=
000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=3D12f8b513700000
>=20
> IMPORTANT: if you fix the issue, please add the following tag to the comm=
it:
> Reported-by: syzbot+4d0ae90a195b269f102d@syzkaller.appspotmail.com

[...]

> diff --git a/drivers/net/can/usb/gs_usb.c b/drivers/net/can/usb/gs_usb.c
> index 67408e316062..5234cfff84b8 100644
> --- a/drivers/net/can/usb/gs_usb.c
> +++ b/drivers/net/can/usb/gs_usb.c
> @@ -1092,6 +1092,7 @@ static struct gs_can *gs_make_candev(unsigned int c=
hannel,
>                 dev->data_bt_const.brp_inc =3D le32_to_cpu(bt_const_exten=
ded->dbrp_inc);
>=20
>                 dev->can.data_bittiming_const =3D &dev->data_bt_const;
> +               kfree(bt_const_extended);
>         }
>=20
>         SET_NETDEV_DEV(netdev, &intf->dev);

I have already send a similar fix:

| https://lore.kernel.org/all/20220329193450.659726-1-mkl@pengutronix.de

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--u2qbbpeazfhzmyv4
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmJECL0ACgkQrX5LkNig
010Jigf/UYHDKXYUu5jFycIr7rrBq8r5VIcDaqmDlplnJPSKchZQPkm8fh90b2yu
jOzjOuWc7KPzuG6RQczoTAKnFP7kZDaCyTEnsIsoE9sdOmN/mpriPLADvRVt24Xq
mdGz3n5YeqEjaX6Sc4qXOK2NuzDljYia+rN29+2hiTAehZ/ozKk+L4FDbOTqdA0+
p7onZyyAK1o9Gd0dj6oJ8uNXLuItZQpo+NiUZgfaHgbbcBNhjySxCiB/XPx1TkCw
bh3EVHr76BVZ/81Vi2boNxNOLNSrVpe7PKPLf5VRVR/yED/9GVopYwiWJWT9TW28
yj1X0NbloZxb4RBfmBy2pnMwPe1J3g==
=wJB8
-----END PGP SIGNATURE-----

--u2qbbpeazfhzmyv4--
