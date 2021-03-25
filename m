Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B20EA349322
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 14:34:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230347AbhCYNeD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 09:34:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230339AbhCYNdk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 09:33:40 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D7BEC06175F;
        Thu, 25 Mar 2021 06:33:40 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id z1so2424105edb.8;
        Thu, 25 Mar 2021 06:33:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rTsRHpZndxgeS88GP9I79vuy4E3KHPhBU7D9Qw0WHCM=;
        b=g9CIjKlm8pC7lTaO6uioaZLuZC7fssojA8XJFkYo5/aLirEkOJVBCwx8YMv2zhwGB/
         Qa2M0sLrbOWVGBVSzz7xnqlK0m8q76T0WEJeVlIsUI4X6czuSc2crrOcL4v8HBeFuo/M
         bHRzYDJhTP9xpkrIVAwvHn13mtNG6XbgbgVTNWL6XCX8XbwMwY3MZQD6lqy03mjBzA4h
         2B12c0rlZypC+/dH48k+ZfPYGxjhsHozVWcfkJJ2iaAeDWNCK5prMO8JJ73cQReZc1/g
         UT18/by426/eKF+CvLHsKL0Z3sf0DcMMSBQqowcpMPIK5LUlZo5hTAx4XFnma4mmXGFl
         NAwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rTsRHpZndxgeS88GP9I79vuy4E3KHPhBU7D9Qw0WHCM=;
        b=Lj7/G9J/WLVrCmo+33it9flnyNVmYuU6RVhzeOjMxtARUpAWpOImTtJLWLIpzffwd+
         Dow2xhuK1EUiYsoU2GIKBB6f+U5seTq7/hxnjV1HJLZbp7ivknENRBznb1pvJXOENQgq
         AK2x2Za+hWMdaWrFnP4I252iDdh90uTUTP8+vv/iGxycxAcUUj9A9mYUVTnjlG1fPQ8T
         E6rVNjvmVGI7/3exunvOf7MFYTRoR6TWKxd4mRpcmn6JWH0Srv0BICnBuVipEYK57MH3
         108hsrTFS8DvRoNBTnbPKhyG/h353YRXlWtjKbBUWC8wLK6ID8F7BQqaG1hUcHwQYSz0
         MKIw==
X-Gm-Message-State: AOAM530iWW6Jr02WkIiBJbuqXJqMJsnmIO/Gp0Luaqa9Q6wQWDe/wZVX
        7Mgr4P4loeUCGxw9WBQ/rwcDaLPER9XtBqUlfJ0=
X-Google-Smtp-Source: ABdhPJxqmMPzuMrRzVuL37n6W7+MhKOw+Qkoq79g9Qi9zRISYcKyjKP6R1Xm2pEhuzO54fISTX6r5adSAeKLqF37+Kk=
X-Received: by 2002:aa7:d0cb:: with SMTP id u11mr9144416edo.163.1616679218814;
 Thu, 25 Mar 2021 06:33:38 -0700 (PDT)
MIME-Version: 1.0
References: <20210325124225.2760-1-linux.amoon@gmail.com> <20210325124225.2760-2-linux.amoon@gmail.com>
 <YFyIvxOHwIs3R/IT@lunn.ch>
In-Reply-To: <YFyIvxOHwIs3R/IT@lunn.ch>
From:   Anand Moon <linux.amoon@gmail.com>
Date:   Thu, 25 Mar 2021 19:03:28 +0530
Message-ID: <CANAwSgRHHwOtWb87aeqF=kio53xCO0_c_ZkF+9hKohWoyji6dg@mail.gmail.com>
Subject: Re: [PATCHv1 1/6] dt-bindings: net: ethernet-phy: Fix the parsing of
 ethernet-phy compatible string
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Kevin Hilman <khilman@baylibre.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        netdev@vger.kernel.org, devicetree <devicetree@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-amlogic@lists.infradead.org, Rob Herring <robh@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

On Thu, 25 Mar 2021 at 18:27, Andrew Lunn <andrew@lunn.ch> wrote:
>
> On Thu, Mar 25, 2021 at 12:42:20PM +0000, Anand Moon wrote:
> > Fix the parsing of check of pattern ethernet-phy-ieee802.3 used
> > by the device tree to initialize the mdio phy.
> >
> > As per the of_mdio below 2 are valid compatible string
> >       "ethernet-phy-ieee802.3-c22"
> >       "ethernet-phy-ieee802.3-c45"
>
> Nope, this is not the full story. Yes, you can have these compatible
> strings. But you can also use the PHY ID,
> e.g. ethernet-phy-idAAAA.BBBB, where AAAA and BBBB are what you find in
> registers 2 and 3 of the PHY.
>

Oops I did not read the drivers/net/mdio/of_mdio.c completely.
Thanks for letting me know so in the next series,
I will try to add the below compatible string as per the description in the dts.

               compatible = "ethernet-phy-id001c.c916",
                            "ethernet-phy-ieee802.3-c22";

> > Cc: Rob Herring <robh@kernel.org>
> > Signed-off-by: Anand Moon <linux.amoon@gmail.com>
> > ---
> >  Documentation/devicetree/bindings/net/ethernet-phy.yaml | 6 +++---
> >  1 file changed, 3 insertions(+), 3 deletions(-)
> >
> > diff --git a/Documentation/devicetree/bindings/net/ethernet-phy.yaml b/Documentation/devicetree/bindings/net/ethernet-phy.yaml
> > index 2766fe45bb98..cfc7909d3e56 100644
> > --- a/Documentation/devicetree/bindings/net/ethernet-phy.yaml
> > +++ b/Documentation/devicetree/bindings/net/ethernet-phy.yaml
> > @@ -33,7 +33,7 @@ properties:
> >          description: PHYs that implement IEEE802.3 clause 22
> >        - const: ethernet-phy-ieee802.3-c45
> >          description: PHYs that implement IEEE802.3 clause 45
> > -      - pattern: "^ethernet-phy-id[a-f0-9]{4}\\.[a-f0-9]{4}$"
> > +      - pattern: "^ethernet-phy-ieee[0-9]{3}\\.[0-9][-][a-f0-9]{4}$"
>
> So here you need, in addition to, not instead of.
>
> Please test you change on for example imx6ul-14x14-evk.dtsi
>

Yes I have gone through the test case.

>    Andrew

- Anand
