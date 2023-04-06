Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC79A6D928A
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 11:18:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236353AbjDFJSi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 05:18:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235372AbjDFJSg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 05:18:36 -0400
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5ADDD61BF;
        Thu,  6 Apr 2023 02:18:35 -0700 (PDT)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 4A05B1C0AB2; Thu,  6 Apr 2023 11:18:32 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ucw.cz; s=gen1;
        t=1680772712;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2LI2f/ixAsF1xEcVqPiJM0HMEuhAr1HeJpruxWNwBHI=;
        b=p5Nw802cTjRP6Znbb6g1y2PRtV6D7WbcwF9APljpEDb++sMNQ+ZdbAMXvdJQZIqX1L7LgV
        SNUeI1nJYQR2xDCf9OOlYAId/A7wwL3eFcqRsNJnRHGqpcEpagi7WXxvPeIBYdWWWLiTAv
        BLOzDz1+E2qS4QzFHDilkLesPhC2sXQ=
Date:   Thu, 6 Apr 2023 11:18:31 +0200
From:   Pavel Machek <pavel@ucw.cz>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Christian Marangi <ansuelsmth@gmail.com>,
        Lee Jones <lee@kernel.org>, Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        John Crispin <john@phrozen.org>, linux-leds@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org
Subject: Re: [net-next PATCH v6 16/16] arm: mvebu: dt: Add PHY LED support
 for 370-rd WAN port
Message-ID: <ZC6OZ2f/NLJxZgle@duo.ucw.cz>
References: <20230327141031.11904-1-ansuelsmth@gmail.com>
 <20230327141031.11904-17-ansuelsmth@gmail.com>
 <ZCKl1A9dZOIAdMY8@duo.ucw.cz>
 <2e5c6dfb-5f55-416f-a934-6fa3997783b7@lunn.ch>
 <ZCsu4qD8k947kN7v@duo.ucw.cz>
 <7cadf888-8d6e-4b7d-8f94-7e869fd49ee2@lunn.ch>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="lnbJBEJceP2MrxSb"
Content-Disposition: inline
In-Reply-To: <7cadf888-8d6e-4b7d-8f94-7e869fd49ee2@lunn.ch>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--lnbJBEJceP2MrxSb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > Acceptance criteria would be "consistent with documentation and with
> > other similar users". If the LED is really white, it should be
> > f1072004.mdio-mii\:white\:WAN, but you probably want
> > f1072004.mdio-mii\:white\:LAN (or :activity), as discussed elsewhere in=
 the thread.
>=20
> Hi Pavel
>=20
> What i ended up with is:
>=20
> f1072004.mdio-mii:00:white:wan
>=20
> The label on the box is WAN, since it is meant to be a WiFi routers,
> and this port should connected to your WAN. And this is what the LED
> code came up with, given my DT description for this device.

Ok, thanks for explanation.

> > Documentation is in Documentation/leds/well-known-leds.txt , so you
> > should probably add a new section about networking, and explain naming
> > scheme for network activity LEDs. When next users appear, I'll point
> > them to the documentation.
>=20
> I added a patch with the following text:
>=20
> * Ethernet LEDs
>=20
> Currently two types of Network LEDs are support, those controlled by
> the PHY and those by the MAC. In theory both can be present at the
> same time for one Linux netdev, hence the names need to differ between
> MAC and PHY.
>=20
> Do not use the netdev name, such as eth0, enp1s0. These are not stable
> and are not unique. They also don't differentiate between MAC and PHY.
>=20
> ** MAC LEDs
>=20
> Good: f1070000.ethernet:white:WAN
> Good: mdio_mux-0.1:00:green:left
> Good: 0000:02:00.0:yellow:top

> The first part must uniquely name the MAC controller. Then follows the
> colour.  WAN/LAN should be used for a single LED. If there are
> multiple LEDs, use left/right, or top/bottom to indicate their
> position on the RJ45 socket.

I don't think basing stuff on position is reasonable. (And am not sure
if making difference between MAC and PHY leds is good idea).

Normally, there's ethernet port with two LEDs, one is usually green
and indicates link, second being yellow and indicates activity,
correct?

On devices like ADSL modems, there is one LED per port, typically on
with link and blinking with activity. =20

Could we use that distinction instead? (id):green:link,
(id):yellow:activity, (id):?:linkact -- for combined LED as it seems.

Are there any other common leds? I seem to remember "100mbps" lights
=66rom time where 100mbit was fast...?

Best regards,
								Pavel
--=20
People of Russia, stop Putin before his war on Ukraine escalates.

--lnbJBEJceP2MrxSb
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZC6OZwAKCRAw5/Bqldv6
8h1QAJ9FtbGdRJcGzTml7Avdfr5VrMyV+ACeLDhyEz6nLaH6LXMXyofdCwWoYQ8=
=9p5m
-----END PGP SIGNATURE-----

--lnbJBEJceP2MrxSb--
