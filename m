Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC65C6BD173
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 14:53:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230325AbjCPNxj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 09:53:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230247AbjCPNxf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 09:53:35 -0400
Received: from mail.zeus03.de (www.zeus03.de [194.117.254.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45A0FB7193
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 06:53:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple; d=sang-engineering.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=k1; bh=/Z6rpmwkteOiygLm8KF3rdmk2hab
        C2Tl5Edd5c1AYUQ=; b=WTHkIUgrQv/pjJdGqUHJFUl69GDucON4YS2TCjE6zK41
        h/VmRN3JubQ7yi36myAu+HQTSO+BDH72fiXTfN7UKo65SpkOCtYaAWGl9IDpG6oK
        1pZPf6UVezzCrU+6eb0PeOpWoeDsdMCx4u1tquQe2RQPi4nzCOMFBdR45ckkwQU=
Received: (qmail 3800160 invoked from network); 16 Mar 2023 14:53:27 +0100
Received: by mail.zeus03.de with ESMTPSA (TLS_AES_256_GCM_SHA384 encrypted, authenticated); 16 Mar 2023 14:53:27 +0100
X-UD-Smtp-Session: l3s3148p1@zvT8yAT3Rt8ujnvb
Date:   Thu, 16 Mar 2023 14:53:27 +0100
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
Message-ID: <ZBMfV2BwiMLyKC7w@ninjato>
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
 <ZBFzVjaRjcITP0bA@ninjato>
 <ZBLNCYgeTtNBSaMi@ninjato>
 <AM5PR04MB313943C24A61C48D761B452688BC9@AM5PR04MB3139.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="CnzlotyyzHK1hC34"
Content-Disposition: inline
In-Reply-To: <AM5PR04MB313943C24A61C48D761B452688BC9@AM5PR04MB3139.eurprd04.prod.outlook.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--CnzlotyyzHK1hC34
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


> Thank you Wolfram. But I'm not sure whether it's really an issue. The flag
> " mac_managed_pm" indicates that the MAC driver will take care of
> suspending/resuming the PHY, that is to say the MAC driver calls
> phy_stop()/phy_start() in its PM callbacks. If a ethernet interface never
> brings up, the MAC PM callbacks do nothing and just return 0 directly. So I
> think it's fine for the MDIO PM to do suspend/resume the PHY unless the MDIO
> bus can't be accessed.

I have one board here where accessing the MDIO bus times out, although I
don't really understand why. And another one where the call to
phy_init_hw() during resume causes issues. There might be more problems
with these boards, but I think it is cleaner to avoid any MDIO bus
suspend/resume if we have 'mac_managed_pm' anyway.


--CnzlotyyzHK1hC34
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAmQTH1MACgkQFA3kzBSg
KbYL7Q//dywmjoDxGliQjbHP6vLj7AlkKf/mueKBQyaDBW0qnKpaLnuv+7kLWyxt
mPykS6JxAAQFVmqTjEry5H87e12bVId9ejgTIWbyFLPP6j+qwrmjFT+Y0TBiQlNi
p1QXEFsLAQ2seKaDfTj3S97jONGhmjQ9V37Kl743JkbCWijkTqXnaDcrXVoZ7LKl
xV2LamIwxfxOPb7DXVnCFfThOgRnFDnWaLM863zH34VPTawQ67kzO0nVWgP+JM0Q
OwdxPuly7r+nQ284Dy6UM9pIxcmcVHNsZeMPLgqOhIOrcXGA0oG9S1SbelglGzK4
S3O6rbwFx18Ge4ED1oARBfqc4BZAH7bcX0gZvUq43jfB3aNMNK35J3GgRqRzavfE
H0/uPUNuLZ6V7NS4eraxCk4C1377jzNN0mQZDDPWs0vjb3BC9cXc1/UrNQxLL91t
8xFZkz4Q692WXBv1JW1/TZU+6cUEYpj6O19ESaVqU4HhcLgtxzrw0zE/B35EQXUz
jwVoM/dMqjcExxQ1ClOanClOS5HIswrEZEZNj04UYASmK7DxaWcDBamcNHli+/IF
wfKIjyPJSoReJin/U8iZcWHSBy114lUMZ442FX3X3fY7zJCDlLmU64AyFDIafIM6
ds4o8/MSnD/yXEBS/RqYmkvbwmFoYa99RbAzy946S9a1uRhBTmU=
=NkQ5
-----END PGP SIGNATURE-----

--CnzlotyyzHK1hC34--
