Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9539559124F
	for <lists+netdev@lfdr.de>; Fri, 12 Aug 2022 16:34:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238673AbiHLOet (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Aug 2022 10:34:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233256AbiHLOeo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Aug 2022 10:34:44 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96CDDAB18C;
        Fri, 12 Aug 2022 07:34:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=yD5r2iwKIH2SlMWCJ47h9MpS0KVr39/25PEKuEp8OGc=; b=Z5pQS/exV3Dx+uM5To1Owm2/NS
        j7rurb+ldQ3KsH9cap6KdRTMv2vqAQvwTwMSk6j7zizi2q/IpsdFx0slKKLBSj959nkDYipeK0HQi
        cztreqDi+zVk7EVIVzsaXEEWx9z77sPTOcnNXLsJ/TJe0YOR92OaO0sw+7EX32OtYt973g9aXFN6F
        EvgzkyB2NIOrTnxAAwVJQWH5Ys9Y1ph3J5c11Cmw0ccAjtXap5i5uXxdvtp+FsPC4IgVho9RvbUBI
        v0UG/NzlbAH7N2wHpYlCoep/j4eWWlwx82YVYbn3Zrh/1uWrBNgdTVLIDh2/2a6KGIu5frauodmKL
        GyFmCu7A==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:33766)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1oMVk7-0000Lt-Kq; Fri, 12 Aug 2022 15:34:31 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1oMVk4-0000zV-Tm; Fri, 12 Aug 2022 15:34:28 +0100
Date:   Fri, 12 Aug 2022 15:34:28 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     Wei Fang <wei.fang@nxp.com>, "andrew@lunn.ch" <andrew@lunn.ch>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "krzysztof.kozlowski+dt@linaro.org" 
        <krzysztof.kozlowski+dt@linaro.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net 1/2] dt: ar803x: Document disable-hibernation property
Message-ID: <YvZk9PPxKoMR1kMt@shell.armlinux.org.uk>
References: <20220812145009.1229094-1-wei.fang@nxp.com>
 <20220812145009.1229094-2-wei.fang@nxp.com>
 <0cd22a17-3171-b572-65fb-e9d3def60133@linaro.org>
 <DB9PR04MB81060AF4890DEA9E2378940288679@DB9PR04MB8106.eurprd04.prod.outlook.com>
 <14cf568e-d7ee-886e-5122-69b2e58b8717@linaro.org>
 <YvY7Vjtj+WV3BI59@shell.armlinux.org.uk>
 <4cf8d73e-9f14-fe8d-d6e2-551920c1f29e@linaro.org>
 <YvZH9avGaZ3z5B5H@shell.armlinux.org.uk>
 <01021dde-106c-5660-ea96-a8b8fd89ad50@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <01021dde-106c-5660-ea96-a8b8fd89ad50@linaro.org>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 12, 2022 at 03:36:43PM +0300, Krzysztof Kozlowski wrote:
> On 12/08/2022 15:30, Russell King (Oracle) wrote:
> > On Fri, Aug 12, 2022 at 03:04:41PM +0300, Krzysztof Kozlowski wrote:
> >> I did not propose a property to enable hibernation. The property must
> >> describe hardware, so this piece is missing, regardless whether the
> >> logic in the driver is "enable" or "disable".
> >>
> >> The hardware property for example is: "broken foo, so hibernation should
> >> be disabled" or "engineer forgot to wire cables, so hibernation won't
> >> work"...
> > 
> > From the problem description, the PHY itself isn't broken. The stmmac
> > hardware doesn't reset properly when the clock from the PHY is stopped.
> 
> There is nothing like that in the property name or property description.
> Again - DT is not for describing driver behavior or driver policy.

Where have I said that it's describing driver behaviour or policy?
Hint: I haven't.

I have no idea why DT maintainers like to keep shoving that idiotic
statement down people's thoats. WE KNOW THIS. And that is NOT what
is being proposed here.

It is purely in your mind that this is a driver behaviour or driver
policy property. It *isn't*.

> > That could hardly be described as "broken" - it's quite common for
> > hardware specifications to state that clocks must be running for the
> > hardware to operate correctly.
> > 
> > This is a matter of configuring the hardware to inter-operate correctly.
> > Isn't that the whole purpose of DT?
> > 
> > So, nothing is broken. Nothing has forgotten to be wired. It's a matter
> > of properly configuring the hardware. Just the same as selecting the
> > correct interface mode to connect two devices together.
> 
> I just gave you two examples what could be written, don't need to stick
> them. You can use some real one...

So the original proposed property to _disable_ a feature implemented by
the hardware should be fine, because it's describing how the hardware
needs to be configured. It's not driver behaviour. It's not driver
policy. It's a configuration bit in a register.

I think you're thinking that the "hibernation" described here is
somehow related to system hibernation, which this has nothing to do
with. This is about configuring the PHY hardware to operate with the
MAC hardware.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
