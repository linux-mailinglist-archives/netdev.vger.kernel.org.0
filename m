Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38D4A6BA907
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 08:27:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231600AbjCOH1Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 03:27:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231557AbjCOH1X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 03:27:23 -0400
Received: from mail.zeus03.de (www.zeus03.de [194.117.254.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D4345BDAE
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 00:27:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple; d=sang-engineering.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=k1; bh=g4ixwWgZk+hP0glUWWvMJ/9M6sji
        gmZC1jxuIW+OZ58=; b=w60xD37kBYH8CBw80xumkxpT/t6adPa+4Lb3NjHMB9if
        8/bWvrSxo5btxN7eAk+6hbI0a5zmcdB7HLRMzzVHRtNLWno8xfprnZ9wkMulEkeL
        ENfr9IcoVjDVC2QUsCLfvAwgdRY/4uwNOS6d2VVp7tdaIHHnjfrE9pqzFf4MCrY=
Received: (qmail 3356968 invoked from network); 15 Mar 2023 08:27:18 +0100
Received: by mail.zeus03.de with ESMTPSA (TLS_AES_256_GCM_SHA384 encrypted, authenticated); 15 Mar 2023 08:27:18 +0100
X-UD-Smtp-Session: l3s3148p1@VVcuRuv26Nkujnvb
Date:   Wed, 15 Mar 2023 08:27:18 +0100
From:   Wolfram Sang <wsa+renesas@sang-engineering.com>
To:     Wei Fang <wei.fang@nxp.com>
Cc:     "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        Shenwei Wang <shenwei.wang@nxp.com>,
        Clark Wang <xiaoning.wang@nxp.com>,
        dl-linux-imx <linux-imx@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 3/4] fec: add FIXME to move 'mac_managed_pm' to
 probe
Message-ID: <ZBFzVjaRjcITP0bA@ninjato>
Mail-Followup-To: Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Wei Fang <wei.fang@nxp.com>,
        "linux-renesas-soc@vger.kernel.org" <linux-renesas-soc@vger.kernel.org>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        Shenwei Wang <shenwei.wang@nxp.com>,
        Clark Wang <xiaoning.wang@nxp.com>,
        dl-linux-imx <linux-imx@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <20230314131443.46342-1-wsa+renesas@sang-engineering.com>
 <20230314131443.46342-4-wsa+renesas@sang-engineering.com>
 <DB9PR04MB8106C492FAAE4D7BE9CB731688BF9@DB9PR04MB8106.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="DAgezE5i+dVbrDpK"
Content-Disposition: inline
In-Reply-To: <DB9PR04MB8106C492FAAE4D7BE9CB731688BF9@DB9PR04MB8106.eurprd04.prod.outlook.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--DAgezE5i+dVbrDpK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> > On Renesas hardware, we had issues because the above flag was set during
> > 'open'. It was concluded that it needs to be set during 'probe'. It loo=
ks like FEC
> > needs the same fix but I can't test it because I don't have the hardwar=
e. At
> > least, leave a note about the issue.
> >=20
>=20
> Could you describe this issue in more details? So that I can reproduce an=
d fix this
> issue and test it. Thanks!

Yes, I will resend the series as RFC with more explanations.


--DAgezE5i+dVbrDpK
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAmQRc1YACgkQFA3kzBSg
KbYIUg/5AYrq7VV325fjSMJh0iT7yGzYJRrrsnkBsHsy4U6UvaRyoyk8o2EbjLQu
qLvwRpSUkr8DCYEnkllzKUMg9S4q1lf6NO3PBxwDpQw025CJwakruWEIdSKUdVHj
jZeka8m+Y77aXhRP5tmoqKcRCfZktgxnlOK3TN+FONyFCQPtn5WEFHRmb6rPxm6B
hI+oz6NhH5Elwaz76XcW9frge3Q0z+Aq2EOhE4jYWgX2hZth0fNCsMfdbQ5xBnrb
YLYmTWEAQoR/zYIkvjk3iAsqXsar67bgbaff2posseGaJRIOVEXXs2p9MCT9V7iG
4OcT0muZnZXrhtnQlQRGlF30VGZBAf8uT11A4rCsga3LJPzF7zGiaXrJC1zkPmMP
ReCX7oP7t7imBwGDsFc46lTEHgC7HeYFRi5Y00+0YQ3dn5fUo0fPW36/v2x/UgU6
DfYA7o2MTAi1aXM+gaPrKTTkUlNVsHXRk6ufksnNo3014HEIh9duzpg0vcA4vIfz
EsOEoh8XU+Zd/lddnXDd7G+VYNO5WjFh/RFKEq/K7zrLkRPmY4lYUuXo1wkSHpEz
/iFHFNPk372MYUiWCoRGy5ei28HG1QKXAvcW+OJrLBTJ9Yh2bkwh3IVnsV/XtRr7
hLXMv19SQ47X+Nf5H//a8aPsIMMyCc36RmxMO627x2ZJp7JuHjI=
=UTgG
-----END PGP SIGNATURE-----

--DAgezE5i+dVbrDpK--
