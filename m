Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B921E619D66
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 17:37:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231331AbiKDQhF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 12:37:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231827AbiKDQhA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 12:37:00 -0400
Received: from relay11.mail.gandi.net (relay11.mail.gandi.net [217.70.178.231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CB5927148;
        Fri,  4 Nov 2022 09:36:57 -0700 (PDT)
Received: (Authenticated sender: maxime.chevallier@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 9D4D610000C;
        Fri,  4 Nov 2022 16:36:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1667579816;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=808GK+NY0bb9SRQPS3AOWotYB050t9mvngzQ7fYdHj0=;
        b=LPFwd04kD+EfMdBuALeI7XL56MoTr+69iRZ7JoeMct1muLj9rxm+G1EpKw4rpRhh7kkCwy
        D2rlkiN7D3IPKDadbptg9C9dfFiExZcnQjzdINJ1453lFrFmwgwrLI5mmGoOQTVVhFAivg
        O6wlOc7fmO+exNWnY/yXVPp/SMUCx8ecyAvXs2gdm/G+yi0cd5MHQ7likz8ecHlgNbFGrB
        aEorQ84ibVsVy7zkV3mRC+5NHMBBZca1WqMNr3DR7XfgGf+bYS4+6gHMrLjLFFeCd39IM1
        y1JgI1WGtavOlwbaY47LPvWggiqYVT0aDS9iWJ0rpXrTEQSYos8z75qhfpIkUQ==
Date:   Fri, 4 Nov 2022 17:36:52 +0100
From:   Maxime Chevallier <maxime.chevallier@bootlin.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "thomas.petazzoni@bootlin.com" <thomas.petazzoni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        Luka Perkov <luka.perkov@sartura.hr>,
        Robert Marko <robert.marko@sartura.hr>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@somainline.org>
Subject: Re: [PATCH net-next v7 5/5] ARM: dts: qcom: ipq4019: Add
 description for the IPQESS Ethernet controller
Message-ID: <20221104173652.594b17db@pc-8.home>
In-Reply-To: <20221104154047.6rtchfslvijqyxp6@skbuf>
References: <20221104142746.350468-1-maxime.chevallier@bootlin.com>
        <20221104142746.350468-6-maxime.chevallier@bootlin.com>
        <50814a5b-03d3-95b4-ab14-bfd19adae52b@linaro.org>
        <20221104143250.6qjkphkhrycp75rv@skbuf>
        <3bdb7b04-27a2-8d50-b96a-76ad914a0988@linaro.org>
        <20221104154047.6rtchfslvijqyxp6@skbuf>
Organization: Bootlin
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Krzysztof, Vladimir,

On Fri, 4 Nov 2022 15:40:48 +0000
Vladimir Oltean <vladimir.oltean@nxp.com> wrote:

> On Fri, Nov 04, 2022 at 11:08:07AM -0400, Krzysztof Kozlowski wrote:
> > On 04/11/2022 10:32, Vladimir Oltean wrote:  
> > > On Fri, Nov 04, 2022 at 10:31:06AM -0400, Krzysztof Kozlowski
> > > wrote:  
> > >>> diff --git a/arch/arm/boot/dts/qcom-ipq4019.dtsi
> > >>> b/arch/arm/boot/dts/qcom-ipq4019.dtsi index
> > >>> b23591110bd2..5fa1af147df9 100644 ---
> > >>> a/arch/arm/boot/dts/qcom-ipq4019.dtsi +++
> > >>> b/arch/arm/boot/dts/qcom-ipq4019.dtsi @@ -38,6 +38,7 @@ aliases
> > >>> { spi1 = &blsp1_spi2;
> > >>>  		i2c0 = &blsp1_i2c3;
> > >>>  		i2c1 = &blsp1_i2c4;
> > >>> +		ethernet0 = &gmac;  
> > >>
> > >> Hm, I have doubts about this one. Why alias is needed and why it
> > >> is a property of a SoC? Not every board has Ethernet enabled, so
> > >> this looks like board property.
> > >>
> > >> I also wonder why do you need it at all?  
> > > 
> > > In general, Ethernet aliases are needed so that the bootloader
> > > can fix up the MAC address of each port's OF node with values it
> > > gets from the U-Boot environment or an AT24 EEPROM or something
> > > like that.  
> > 
> > Assuming that's the case here, my other part of question remains -
> > is this property of SoC or board? The buses (SPI, I2C) are
> > properties of boards, even though were incorrectly put here. If the
> > board has multiple ethernets, the final ordering is the property of
> > the board, not SoC. I would assume that bootloader also configures
> > the MAC address based on the board config, not per SoC...  
> 
> I don't disagree. On NXP LS1028A, we also have all aliases in board
> device trees and not in the SoC dtsi.

You're right indeed, it was put there so that it's alongside the other
aliases, but it makes more sense to include it in the board file. I'll
respin with the alias removed.

Thanks,

Maxime
