Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32D136C6745
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 12:56:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231610AbjCWL4S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 07:56:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229690AbjCWL4B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 07:56:01 -0400
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E572C31E19;
        Thu, 23 Mar 2023 04:55:59 -0700 (PDT)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id B33D71C0E54; Thu, 23 Mar 2023 12:55:58 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ucw.cz; s=gen1;
        t=1679572558;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mPMt+Gw7dh2AF8TMwG0Z97+BcGNEXm4Po54Nb1Y/dZ4=;
        b=hx3CkCEIM5gkNB2D8axuaXGtlnD+snD2kE+9ljqeyDxkqAxzG5yo2c0kXB4P22J8U8W5w2
        fI+Z42u0XvSn5FnoKHJJ964bpKHn4h15Yc59BCT4D3H5NWZojhsiVohkRBR8txlnSwuXOA
        cU3cWn5jzUXs05AUXj8QTbcj9CL4mFI=
Date:   Thu, 23 Mar 2023 12:55:58 +0100
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
Subject: Re: [net-next PATCH v5 07/15] net: phy: marvell: Add software
 control of the LEDs
Message-ID: <ZBw+TgB9WX/yxsGv@duo.ucw.cz>
References: <20230319191814.22067-1-ansuelsmth@gmail.com>
 <20230319191814.22067-8-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="f/SBewD7J+rcMxu6"
Content-Disposition: inline
In-Reply-To: <20230319191814.22067-8-ansuelsmth@gmail.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--f/SBewD7J+rcMxu6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun 2023-03-19 20:18:06, Christian Marangi wrote:
> From: Andrew Lunn <andrew@lunn.ch>
>=20
> Add a brightness function, so the LEDs can be controlled from
> software using the standard Linux LED infrastructure.
>=20
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>

Acked-by: Pavel Machek <pavel@ucw.cz>

--=20
People of Russia, stop Putin before his war on Ukraine escalates.

--f/SBewD7J+rcMxu6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZBw+TgAKCRAw5/Bqldv6
8rtHAJ48sdcQ4rGVqWdsEQaC6XpnzDNNkACeK1KcTdGy+xUeBcXlplfpA39Cwc0=
=7Pcl
-----END PGP SIGNATURE-----

--f/SBewD7J+rcMxu6--
