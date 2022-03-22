Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 706024E3E51
	for <lists+netdev@lfdr.de>; Tue, 22 Mar 2022 13:19:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234776AbiCVMTq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Mar 2022 08:19:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234771AbiCVMTo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Mar 2022 08:19:44 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1731565DA;
        Tue, 22 Mar 2022 05:18:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=WJmfDag7+TqMzK9Ot3/KBQ12CVBH/OW+HOoM2Whva/E=; b=t3D3jpdVqfWhqEMqg8GrnrY/oD
        rrCx3Tu16rNIfRsSn7HBKIvpwkMGoKgESlRZ3/uXppj2ap2hi07KAlzwO+f0rCXDebC1ZAiEOgOC6
        BGG5aPJ+iSzgT704cSqWW3lSZgfBCB/QoL6SU2YD+rf+b/kiT2diS+nDEMd3dijUeR3A=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nWdSL-00C7SU-U1; Tue, 22 Mar 2022 13:17:45 +0100
Date:   Tue, 22 Mar 2022 13:17:45 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Dylan Hung <dylan_hung@aspeedtech.com>
Cc:     "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "joel@jms.id.au" <joel@jms.id.au>,
        "andrew@aj.id.au" <andrew@aj.id.au>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "p.zabel@pengutronix.de" <p.zabel@pengutronix.de>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-aspeed@lists.ozlabs.org" <linux-aspeed@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        BMC-SW <BMC-SW@aspeedtech.com>
Subject: Re: [PATCH 0/2] Add reset deassertion for Aspeed MDIO
Message-ID: <Yjm+aQwXuWh5TLpr@lunn.ch>
References: <20220321070131.23363-1-dylan_hung@aspeedtech.com>
 <YjhrUrXzLxvKtDP8@lunn.ch>
 <HK0PR06MB283430933D2FE015531B52749C179@HK0PR06MB2834.apcprd06.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <HK0PR06MB283430933D2FE015531B52749C179@HK0PR06MB2834.apcprd06.prod.outlook.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Do I still need to add a reset assertion/deassertion if the hardware
> asserts the reset by default?

One use case would be kexec when one kernel is used to boot another
kernel. But since this is shared by multiple busses, it is probably
not worth the complexity unless that is something you expect you
customers to do, e.g. during kernel development work.

	Andrew
