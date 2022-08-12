Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75EEF59102D
	for <lists+netdev@lfdr.de>; Fri, 12 Aug 2022 13:37:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237446AbiHLLhH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Aug 2022 07:37:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231627AbiHLLhG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Aug 2022 07:37:06 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C085A5996;
        Fri, 12 Aug 2022 04:37:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=5cH4W1xFUfBKzHhA0qmhN71IL97dIcVdgSB2lbcjbhI=; b=VWrfiySIRfk42fymYJ4lbMVoYg
        IvsVVC0S+Tf0U+2J/GIMjtrvjKGe881kIM3qOo7ZdL0eJaBs45a3iNQ/gzMHghMZK4LUtiICadymK
        Ej1EwJqzyYs2gbFPaMyrtEkt6b4XXnfzjPn5+WFE3Qc8IOf1UbzFAIOJ7Dd3gR/icjf2rkFKYET3u
        x7duDKn+LxxDelM93iNu4xzc6g9xdbkpyECaZB2xahCkkjvw0/r2eEaRh+AV74gTFLaa8nKKwI2yE
        JmBdIY5qDTux4U2j0HKwoDA4wvjFQok/sYIB2sg/RTGlBrcwRnk/IB3AyPv/mtmdKsNMGblijkp+z
        Wc7c80uw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:33758)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1oMSyH-0000Dg-1j; Fri, 12 Aug 2022 12:36:57 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1oMSyE-0000t0-9V; Fri, 12 Aug 2022 12:36:54 +0100
Date:   Fri, 12 Aug 2022 12:36:54 +0100
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
Message-ID: <YvY7Vjtj+WV3BI59@shell.armlinux.org.uk>
References: <20220812145009.1229094-1-wei.fang@nxp.com>
 <20220812145009.1229094-2-wei.fang@nxp.com>
 <0cd22a17-3171-b572-65fb-e9d3def60133@linaro.org>
 <DB9PR04MB81060AF4890DEA9E2378940288679@DB9PR04MB8106.eurprd04.prod.outlook.com>
 <14cf568e-d7ee-886e-5122-69b2e58b8717@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <14cf568e-d7ee-886e-5122-69b2e58b8717@linaro.org>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 12, 2022 at 02:25:42PM +0300, Krzysztof Kozlowski wrote:
> hibernation is a feature, but 'disable-hibernation' is not. DTS
> describes the hardware, not policy or driver bejhvior. Why disabling
> hibernation is a property of hardware? How you described, it's not,
> therefore either property is not for DT or it has to be phrased
> correctly to describe the hardware.

However, older DT descriptions need to be compatible with later kernels,
and as existing setups have hibernation enabled, introducing a property
to _enable_ hibernation (which implies if the property is not present,
hibernation is disabled) changes the behaviour with older DT, thereby
breaking backwards compatibility.

Yes, DT needs to describe hardware, but there are also other
constraints too.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
