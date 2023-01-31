Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23DF6682E31
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 14:42:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232244AbjAaNmZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 08:42:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232370AbjAaNmT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 08:42:19 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 424294FCF5;
        Tue, 31 Jan 2023 05:42:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=AfBzRuz0UO/lUfWWNyrD9Yc4wL4xaRinOB2IvcHpEDs=; b=O9bGmi/+mp0J/VyC2TzmwkX7W/
        469MlqHn/bSRsOWbqD+6kdLCyW5F8nTiTtzuQRyl8D8aGe1zBqJf6hOuq2cn6W5H3kb+UpHS/nfUw
        NtGXszdEdZ8zO8wMoVxYD4V6WshdW1jJFV+plKjJvXDhNvRx8YNritsxxTWGk5oUl/2Y=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pMqtc-003hAG-3z; Tue, 31 Jan 2023 14:42:00 +0100
Date:   Tue, 31 Jan 2023 14:42:00 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Frank.Sae" <Frank.Sae@motor-comm.com>
Cc:     Peter Geis <pgwipeout@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        yanhong.wang@starfivetech.com, xiaogang.fan@motor-comm.com,
        fei.zhang@motor-comm.com, hua.sun@motor-comm.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH net-next v3 1/5] dt-bindings: net: Add Motorcomm yt8xxx
 ethernet phy
Message-ID: <Y9kaqG/b4sO4aagM@lunn.ch>
References: <20230130063539.3700-1-Frank.Sae@motor-comm.com>
 <20230130063539.3700-2-Frank.Sae@motor-comm.com>
 <Y9fOHxn8rdIHuDbn@lunn.ch>
 <18446b51-6428-d8c8-7f59-6a3b9845d2c4@motor-comm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18446b51-6428-d8c8-7f59-6a3b9845d2c4@motor-comm.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> >> +properties:
> >> +  rx-internal-delay-ps:
> >> +    description: |
> >> +      RGMII RX Clock Delay used only when PHY operates in RGMII mode with
> >> +      internal delay (phy-mode is 'rgmii-id' or 'rgmii-rxid') in pico-seconds.
> >> +    enum: [ 0, 150, 300, 450, 600, 750, 900, 1050, 1200, 1350, 1500, 1650,
> >> +            1800, 1900, 1950, 2050, 2100, 2200, 2250, 2350, 2500, 2650, 2800,
> >> +            2950, 3100, 3250, 3400, 3550, 3700, 3850, 4000, 4150 ]
> >> +    default: 1950
> > 
> > Ah! There has been a misunderstand. Yes, this changes does make sense, but > 
> >> +
> >> +  tx-internal-delay-ps:
> >> +    description: |
> >> +      RGMII TX Clock Delay used only when PHY operates in RGMII mode with
> >> +      internal delay (phy-mode is 'rgmii-id' or 'rgmii-txid') in pico-seconds.
> >> +    enum: [ 0, 150, 300, 450, 600, 750, 900, 1050, 1200, 1350, 1500, 1650, 1800,
> >> +            1950, 2100, 2250 ]
> >> +    default: 150
> > 
> > ... i was actually trying to say this 150 is odd. Why is this not
> > 1950?
> 
>  Tx-delay is usually adjusted by the mac (~ 2ns).
>  So here is only fine-turn for the tx-delay.

In general, in Linux, this is not true. The PHY inserts both
delays. Yes, you can have the MAC insert the delay, but it then means
the MAC needs to modify phy-mode to indicate it has inserted the
delay, changing rgmii-id to rmgmii-rxid when it calls
phy_connect_*(). And few MAC drivers get this correct. So i would
avoid this. Default to 1950. And if there is a device which needs a
fine tune, it can use 2100, or 2250 in its DTS file.

     Andrew
