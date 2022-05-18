Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C07DF52BC48
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 16:16:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237268AbiERMr0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 08:47:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237425AbiERMp5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 08:45:57 -0400
Received: from relay1-d.mail.gandi.net (relay1-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::221])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C60715D308;
        Wed, 18 May 2022 05:42:25 -0700 (PDT)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 1863A240006;
        Wed, 18 May 2022 12:42:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1652877744;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3gM9WXfVKLQSwc3deM8grfiskd/pEHtQBWIsO3/UiFA=;
        b=BVT23yrs3RTS7Oays8mQt1y5yO2CLE6kuXnLPiQJ35xmRgRerwJGEJJ75CA2EnSviEn4tH
        k9FsITgPYESsuQMEoR7Mf6yMyrYLMLLHcaca/wmC3HllzJuinX32Ndmfp0//C4gOA0R7ZK
        694jNF25jIcEz0pKhrRqRhfpj24hJ0sFX4roiI4shAekeVVvFbBQUzI4c5s+ZwufI01M/2
        dGSNO70ZXEc//bLwo6uGK91g7gwjjPkTuQC+B2IleBwiGD2jcGEkndMnRvEAQN5WFBFj+S
        ewQgZFJ/7/nou1jSRwatnNUO0qSYxouAisQ4w8xvnd/WNE4l6RlLpbIeRhP4aQ==
Date:   Wed, 18 May 2022 14:41:11 +0200
From:   =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Rob Herring <robh@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Magnus Damm <magnus.damm@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Herve Codina <herve.codina@bootlin.com>,
        =?UTF-8?B?TWlxdcOobA==?= Raynal <miquel.raynal@bootlin.com>,
        Milan Stevanovic <milan.stevanovic@se.com>,
        Jimmy Lalande <jimmy.lalande@se.com>,
        Pascal Eberhard <pascal.eberhard@se.com>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v4 05/12] dt-bindings: net: dsa: add bindings
 for Renesas RZ/N1 Advanced 5 port switch
Message-ID: <20220518144111.135c7d0d@fixe.home>
In-Reply-To: <20220518120503.3m2zfw7kmhsfg336@skbuf>
References: <20220509131900.7840-1-clement.leger@bootlin.com>
        <20220509131900.7840-6-clement.leger@bootlin.com>
        <20220511152221.GA334055-robh@kernel.org>
        <20220511153337.deqxawpbbk3actxf@skbuf>
        <20220518015924.GC2049643-robh@kernel.org>
        <20220518120503.3m2zfw7kmhsfg336@skbuf>
Organization: Bootlin
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le Wed, 18 May 2022 15:05:03 +0300,
Vladimir Oltean <olteanv@gmail.com> a =C3=A9crit :

> On Tue, May 17, 2022 at 08:59:24PM -0500, Rob Herring wrote:
> > On Wed, May 11, 2022 at 06:33:37PM +0300, Vladimir Oltean wrote: =20
> > > On Wed, May 11, 2022 at 10:22:21AM -0500, Rob Herring wrote: =20
> > > > > +patternProperties:
> > > > > +  "^ethernet-ports$": =20
> > > >=20
> > > > Move to 'properties', not a pattern.
> > > >=20
> > > > With that,
> > > >=20
> > > > Reviewed-by: Rob Herring <robh@kernel.org> =20
> > >=20
> > > Even if it should have been "^(ethernet-)?ports$"? =20
> >=20
> > Why? Allowing 'ports' is for existing users. New ones don't need the=20
> > variability and should use just 'ethernet-ports'.
> >=20
> > Rob =20
>=20
> Yeah, ok, somehow the memo that new DSA drivers shouldn't support "ports"
> didn't reach me. They invariably will though, since the DSA framework is
> the main parser of the property, and that is shared by both old and new
> drivers.

Should also the subnodes of "ethernet-ports" use the
"ethernet-port@[0-9]*" naming ? Or keeping the existing pattern is ok
(ie "^(ethernet-)?port@[0-4]$") ?

Thanks,

--=20
Cl=C3=A9ment L=C3=A9ger,
Embedded Linux and Kernel engineer at Bootlin
https://bootlin.com
