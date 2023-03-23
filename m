Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4AAA6C673A
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 12:55:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230181AbjCWLz5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 07:55:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231564AbjCWLzi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 07:55:38 -0400
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61E2737716;
        Thu, 23 Mar 2023 04:55:18 -0700 (PDT)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 5FC521C0E53; Thu, 23 Mar 2023 12:55:13 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ucw.cz; s=gen1;
        t=1679572513;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2HU+qtDuEBkndRowafmlN4zSFAgAmqQpBV7WUzW/pEw=;
        b=brR2W08YUQmt9Sm8OW+MFRtTsOjxh+sgxEc4ehwL0bD0ikILpILyfPYkEOjGyYuPEQUDqg
        a5+qxrciyWABoEpKWXLpDv4gudVJSpy5VvYNKIxnimk2uOfL1ahMOWBCCYjB7Vly6KYuxp
        flNzSA6pi4pWl/VcGyeSJCh37TJIU8E=
Date:   Thu, 23 Mar 2023 12:55:12 +0100
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
        linux-arm-msm@vger.kernel.org, linux-leds@vger.kernel.org
Subject: Re: [net-next PATCH v5 03/15] net: dsa: qca8k: add LEDs blink_set()
 support
Message-ID: <ZBw+IFlTSdOL/Nx0@duo.ucw.cz>
References: <20230319191814.22067-1-ansuelsmth@gmail.com>
 <20230319191814.22067-4-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="dqJm/BlnENebHkpc"
Content-Disposition: inline
In-Reply-To: <20230319191814.22067-4-ansuelsmth@gmail.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--dqJm/BlnENebHkpc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> Add LEDs blink_set() support to qca8k Switch Family.
> These LEDs support hw accellerated blinking at a fixed rate
> of 4Hz.
>=20
> Reject any other value since not supported by the LEDs switch.
>=20
> Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>

Acked-by: Pavel Machek <pavel@ucw.cz>

--=20
People of Russia, stop Putin before his war on Ukraine escalates.

--dqJm/BlnENebHkpc
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZBw+IAAKCRAw5/Bqldv6
8m8mAKC69n0Fse77leJE2Kqs8p+lTM4F7ACbB2YTGnyKwYh9mEfsrVo17Oukog8=
=Ljrk
-----END PGP SIGNATURE-----

--dqJm/BlnENebHkpc--
