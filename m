Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A180A66DE9B
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 14:17:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237074AbjAQNRs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 08:17:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236214AbjAQNRj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 08:17:39 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1BDE39CE1;
        Tue, 17 Jan 2023 05:17:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=l5GYnfPodnVQISc2fnNDGCN36ORY7+q/Fybf955ZUzQ=; b=ppMz7mT+E+OJ1osQd5kVSnDKEh
        TjanOtc9ebQ1mozYdxtE2R6BHuJfL53SSOb0AY9bj01xhsvx9T5n2tisAXPya4S6Gn1MucmLy5Xhl
        Jjwfu6P6xpEpFZ8xdRqSz1IkJUMN4qzibVn9ep2AaN5/PsqfWU295a4o1+W7M3OY1EVk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pHlpi-002K7h-Vo; Tue, 17 Jan 2023 14:16:58 +0100
Date:   Tue, 17 Jan 2023 14:16:58 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     yanhong wang <yanhong.wang@starfivetech.com>
Cc:     "Frank.Sae" <Frank.Sae@motor-comm.com>,
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
Message-ID: <Y8afyunHKYDNMbRI@lunn.ch>
References: <20230105073024.8390-1-Frank.Sae@motor-comm.com>
 <20230105073024.8390-2-Frank.Sae@motor-comm.com>
 <Y7bN4vJXMi66FF6v@lunn.ch>
 <e762c7ac-63e7-a86e-3e3f-5c8a450b25b0@motor-comm.com>
 <Y7goXXiRBE6XHuCc@lunn.ch>
 <83fd7a69-7e6a-ab93-b05a-4eba8af4d245@motor-comm.com>
 <Y760k6/pKdjwu1fU@lunn.ch>
 <9b047a2a-ccd8-6079-efbf-5cb880bf5044@starfivetech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9b047a2a-ccd8-6079-efbf-5cb880bf5044@starfivetech.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Hi Andrew, i'm an engineer from StarFive Technology Co.
> 
> This configuration is mainly to adapt to VF2 with JH7110 SoC.
> This is a defect in the design of JH7110. Only the basic delay 
> configuration of PHY can't meet the delay needs of JH7110,
> must with the configuration of tx-clk-x-inverted together can
> gmac work normally. Otherwise, gmac cannot work normally at 
> different rates. JH7110 has been taped and cannot be modified 
> in design, so it can only be corrected on software.

So you have a choice of one PHY, since i don't know of any other PHY
with this capability. I hope this is well documented, since PHYs tend
to be considered interchangeable, use whatever is currently the
cheapest. And i assume you will fix the MAC for the next version of
the silicon?

So all these clock invert properties are fine.

I will take another look at the delay property..

  Andrew
