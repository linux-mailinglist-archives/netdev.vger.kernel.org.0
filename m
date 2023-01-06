Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 415EF6601A3
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 14:58:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233750AbjAFN6b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 08:58:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbjAFN6a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 08:58:30 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FB0277AD5;
        Fri,  6 Jan 2023 05:58:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=EuJq8aalKfu+0oZW3TJ0EoGfR/E0+h0Uny3kQ2BRO4g=; b=R4
        RWJo5mePeXJ9soGnmolcF0e7zMy3/p87zDpSlnL6WWuevJ0S+C5GwOvRs3oVyKbqmJt/bx6m77ik5
        Fv23PRuTah0ptEw+uq5QmLMx3Aw2B/WMdrZaoP+BdsqpdBAf6rr1uCu3nqJaCnSwy8vhadhHVXXjd
        Rey+f/JnKIkoptE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pDnEi-001L0W-1K; Fri, 06 Jan 2023 14:58:20 +0100
Date:   Fri, 6 Jan 2023 14:58:20 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Frank.Sae" <Frank.Sae@motor-comm.com>
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Peter Geis <pgwipeout@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        xiaogang.fan@motor-comm.com, fei.zhang@motor-comm.com,
        hua.sun@motor-comm.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH net-next v1 1/3] dt-bindings: net: Add Motorcomm yt8xxx
 ethernet phy Driver bindings
Message-ID: <Y7go/KP8TZTdp6wm@lunn.ch>
References: <20230105073024.8390-1-Frank.Sae@motor-comm.com>
 <20230105073024.8390-2-Frank.Sae@motor-comm.com>
 <b74baadf-37a4-c9a2-c821-3c3e0143fa4a@linaro.org>
 <8fa89dac-6859-af93-0dc0-ffcb42b5bb30@motor-comm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8fa89dac-6859-af93-0dc0-ffcb42b5bb30@motor-comm.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> >> +  motorcomm,rx-delay-basic:
> >> +    description: |
> >> +      Tristate, setup the basic RGMII RX Clock delay of PHY.
> >> +      This basic delay is fixed at 2ns (1000Mbps) or 8ns (100Mbps、10Mbps).
> >> +      This basic delay usually auto set by hardware according to the voltage
> >> +      of RXD0 pin (low = 0, turn off;   high = 1, turn on).
> >> +      If not exist, this delay is controlled by hardware.
> > 
> > I don't understand that at all. What "not exist"? There is no verb and
> > no subject.
> > 
> > The type and description are really unclear.
> > 
> >> +      0: turn off;   1: turn on.
> >> +    $ref: /schemas/types.yaml#/definitions/uint32
> >> +    enum: [0, 1]
> > 
> > So this is bool?
> > 
> 
> This basic delay can be controlled by hardware or dts.
> 
> Default value depends on power on strapping, according to the voltage
> of RXD0 pin (low = 0, turn off;   high = 1, turn on).
> 
> "not exist" means that This basic delay is controlled by hardware,
> and software don't change this.

As i said in my other reply, this is not how Linux controls this. This
property should be removed.

	 Andrew
