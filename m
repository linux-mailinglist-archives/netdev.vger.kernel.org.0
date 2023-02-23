Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FE666A0643
	for <lists+netdev@lfdr.de>; Thu, 23 Feb 2023 11:30:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233800AbjBWKaB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Feb 2023 05:30:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233717AbjBWK35 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Feb 2023 05:29:57 -0500
Received: from mail.zeus03.de (www.zeus03.de [194.117.254.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C8FE497FA
        for <netdev@vger.kernel.org>; Thu, 23 Feb 2023 02:29:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple; d=sang-engineering.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=k1; bh=qP1lk9slP6spetwfnNzelgnbPMU/
        UDdBf8vESAlYVE8=; b=OjJm45iiKTQq3XEmfZeyq3V0hF/ep5jLABrvU4Ta2wEr
        i2us02y/e6ZKMDWHk3/oK5y69qPFHkbrhWnfU8GwmU+Gm3hl5bKqW4/92xBc7my3
        CbAA1oOfAq0593OqV66mZHpCTX2re3yDqKk5a2ZFfTf6Rwg+hO6ec5L58uAPKZs=
Received: (qmail 885260 invoked from network); 23 Feb 2023 11:29:51 +0100
Received: by mail.zeus03.de with ESMTPSA (TLS_AES_256_GCM_SHA384 encrypted, authenticated); 23 Feb 2023 11:29:51 +0100
X-UD-Smtp-Session: l3s3148p1@PRoCflv1QJFehh92
Date:   Thu, 23 Feb 2023 11:29:47 +0100
From:   Wolfram Sang <wsa+renesas@sang-engineering.com>
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     linux-renesas-soc@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [REGRESSION PATCH RFC] net: phy: don't resume PHY via MDIO when
 iface is not up
Message-ID: <Y/dAG8aJEmQREuKR@shikoro>
Mail-Followup-To: Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        linux-renesas-soc@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20230223070519.2211-1-wsa+renesas@sang-engineering.com>
 <CAMuHMdVzzzztNU6dNFN30k4h4FheD2-439vaiY4AnGJz4EuwoQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="quG3KrzwVuVHDyF+"
Content-Disposition: inline
In-Reply-To: <CAMuHMdVzzzztNU6dNFN30k4h4FheD2-439vaiY4AnGJz4EuwoQ@mail.gmail.com>
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--quG3KrzwVuVHDyF+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Geert,

> > TLDR; Commit 96fb2077a517 ("net: phy: consider that suspend2ram may cut
> > off PHY power") caused regressions for us when resuming an interface
>=20
> That is actually an LTS commit.  Upstream is commit 4c0d2e96ba055bd8
> ("net: phy: consider that suspend2ram may cut off PHY power") in
> v5.12-rc1.

Oh, thank you for correcting me!

All the best,

   Wolfram


--quG3KrzwVuVHDyF+
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAmP3QBcACgkQFA3kzBSg
KbZadw//eZeHoqtatcfoxTTnniDmRrudmUAV79sYIHXf2BelftolojiuaYjlgPUe
WjJxt8TV/kkXS2MExCfTZTbORHAZY618Ocwu9XTJ21HWiCcoDOORcPXG3jxnvtqp
w70t9W5eMsgcMztILHbtN2pEQIZ/ltZyEo2DOf0hrZ8NvdT40Biwp1bBQ7eJJF+f
bHuK7WbAARkYv9YW36TdCHXLm2WZvsjQvHeazfSBKn304ru7WOfovHErG826fP2J
nY3sauTR86rFAIWz7fifulFhNZ1Xd0DLlJ5/xudce2zfAd+XtcD0VNdfek76dEN2
mRSKTIhSI5J38Xwy4tUfPl2PBlVUqq38b6554kBfsLpphV7ayJldnKhWyC6Q/ppA
o2LMflW2SmiHkTe/1z1WRBqVuYwp2XiVQmbOLyi23T+Dr7+AvRkbbt6p5NJUkRhD
4vMgtGIFzHzb6rTr47OHufidQ4MEIwp1M+yrfXyh5kKCsddcTHTPb6b4l1ykO2Cz
m+jceMNmIBgwzwVnlfENfY6OAJQTd2EenotB8DTTu7TlLBAy0JTNLm8ADlIJcVVE
L/XAZ9azQqG0zACTOqq589XB2VWXmiLcB7sHqOpSF+Ia3hpMU38+M6b0V8pHxvwc
Wxro5hOiaC72TnU6z3tvnorPFXXhi1LJgs5EP7e7Y16fJpLBn+s=
=gpeL
-----END PGP SIGNATURE-----

--quG3KrzwVuVHDyF+--
