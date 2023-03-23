Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2DEC6C6780
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 13:02:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231791AbjCWMCV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 08:02:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231446AbjCWMB7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 08:01:59 -0400
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BED8D83D6;
        Thu, 23 Mar 2023 05:00:11 -0700 (PDT)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 65F781C0E45; Thu, 23 Mar 2023 13:00:10 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ucw.cz; s=gen1;
        t=1679572810;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=i6g24iXeL9/ShWvEYoM0S6zS1IAwwllZY3vf7uOY3BQ=;
        b=FUd82qEkq+eW84cAEji9+56Yzv2dhP9NcP+rEBPwkgQcu38rU4qSxXQN3Iyd+/LGu6pe6G
        TI7cog3eHrcVT+7wxVkneHkY8YGz5YUGYLLv2joiddVHP8rRxoOclT8tHt2RPVQ+wp1Bdm
        Km8X54avX15p43UoP+idujHY7IEQQ4Q=
Date:   Thu, 23 Mar 2023 13:00:09 +0100
From:   Pavel Machek <pavel@ucw.cz>
To:     Christian Marangi <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Lee Jones <lee@kernel.org>, John Crispin <john@phrozen.org>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-leds@vger.kernel.org,
        Jonathan McDowell <noodles@earth.li>
Subject: Re: [net-next PATCH v5 13/15] arm: qcom: dt: Add Switch LED for each
 port for rb3011
Message-ID: <ZBw/SbstO5oU6osW@duo.ucw.cz>
References: <20230319191814.22067-1-ansuelsmth@gmail.com>
 <20230319191814.22067-14-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="zouinu9G3n7jzOuo"
Content-Disposition: inline
In-Reply-To: <20230319191814.22067-14-ansuelsmth@gmail.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--zouinu9G3n7jzOuo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun 2023-03-19 20:18:12, Christian Marangi wrote:
> Add Switch LED for each port for MikroTik RB3011UiAS-RM.
>=20
> MikroTik RB3011UiAS-RM is a 10 port device with 2 qca8337 switch chips
> connected.
>=20
> It was discovered that in the hardware design all 3 Switch LED trace of
> the related port is connected to the same LED. This was discovered by
> setting to 'always on' the related led in the switch regs and noticing
> that all 3 LED for the specific port (for example for port 1) cause the
> connected LED for port 1 to turn on. As an extra test we tried enabling
> 2 different LED for the port resulting in the LED turned off only if
> every led in the reg was off.
>=20
> Aside from this funny and strange hardware implementation, the device
> itself have one green LED for each port, resulting in 10 green LED one
> for each of the 10 supported port.
>=20
> Cc: Jonathan McDowell <noodles@earth.li>
> Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>

Reviewed-by: Pavel Machek <pavel@ucw.cz>

--=20
People of Russia, stop Putin before his war on Ukraine escalates.

--zouinu9G3n7jzOuo
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZBw/SQAKCRAw5/Bqldv6
8oFMAKClNfnf4Qid7kCyj0YBbLipLy2WhQCffrRvBkk2AKCW09Vxt7sn/z9R3tU=
=MGkU
-----END PGP SIGNATURE-----

--zouinu9G3n7jzOuo--
