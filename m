Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78C7F567968
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 23:34:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231340AbiGEVeq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 17:34:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229849AbiGEVep (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 17:34:45 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3148E84;
        Tue,  5 Jul 2022 14:34:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=kKAWByl3Wyi3A9Ef1Qy70BLTUzK6DPnPcCzJYHhgBdM=; b=cCfyKT79+wZT44GOrFEY1F5AWw
        HukYgUDodaGrTIdLGXfCeUjLfPQALNGvYlfcaL10TAkLIrKpm31U9QdgjAe4psw80wzhrzwSUUyfD
        i+u0ize98+wkYPFPypI2mxRdIrHUQ+iJ4o3UnYPmwgDBmW5N98sLtSooKfJfi8i7KZAukUYZljjH9
        K2zZd+hCxjjGAIc38MTkaN3H7bSInMu9Q9wCVSoq5p4ceXywWEqeEQOUR3ja2rAkPZYNogol0QX34
        w7gSNBwqskcschyVI8N4gNrp8pB1ExK2DbR0otIpMmT3pvXzzeTlfim2xJX/DGK61OPTiH3f9w13H
        zRNOtiQA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:33198)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1o8qBm-0001tb-CW; Tue, 05 Jul 2022 22:34:34 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1o8qBk-0003gK-3I; Tue, 05 Jul 2022 22:34:32 +0100
Date:   Tue, 5 Jul 2022 22:34:32 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Rob Herring <robh@kernel.org>
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH v2 net-next 1/4] dt-bindings: net: convert sff,sfp to
 dtschema
Message-ID: <YsSuaKA4rRkXbt2D@shell.armlinux.org.uk>
References: <20220704134604.13626-1-ioana.ciornei@nxp.com>
 <20220704134604.13626-2-ioana.ciornei@nxp.com>
 <20220705212903.GA2615438-robh@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220705212903.GA2615438-robh@kernel.org>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 05, 2022 at 03:29:03PM -0600, Rob Herring wrote:
> On Mon, Jul 04, 2022 at 04:46:01PM +0300, Ioana Ciornei wrote:
> > +  maximum-power-milliwatt:
> > +    maxItems: 1
> > +    description:
> > +      Maximum module power consumption Specifies the maximum power consumption
> > +      allowable by a module in the slot, in milli-Watts. Presently, modules can
> > +      be up to 1W, 1.5W or 2W.
> 
>        enum: [ 1000, 1500, 2000 ]
> 
> Or is it not just those values? Maybe 'maximum: 2000' instead.

There is no enforcing of the value, we just read the value from
firmware and use it as a limit for the module (and the module can
specify powers of 1.5W or 2W in its EEPROM, otherwise it defaults
to 1W. Future standards may allow higher power consumptions.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
