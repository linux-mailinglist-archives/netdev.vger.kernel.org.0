Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD5084D5108
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 18:59:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241084AbiCJR7R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 12:59:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236272AbiCJR7Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 12:59:16 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10EDAE448D;
        Thu, 10 Mar 2022 09:58:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=67s4LA1ACb5RaCvH71SlWaGzAg+v5mOWV/nAyGumpok=; b=Jm1TmqoELDQxuVQwVOGolwc2V/
        FaOkzoIM2DUYXl5fyzAb4UwHNQgCgzlGbO7raknWw7TEjzgvj3g1TP8YdOiugAJpjJX+oZ+pe64h6
        F5CptwkCL109LWVOP5XQyFKbHvG9oTzyuDRCICTUriEjuZKuCRDild9x4L27b5UjRDx9EddrNt9ag
        bmYMNTyLx25LOnkLrPLxkbRIexQa3ir8knQhOzIUdFX7HMy4MW7OGtVkahdQwGdTxD16o3eHHefoz
        ksvR618YytGFDdq/n3L0uHRVznNCNKBqx7N40tXhZQyMqRbz4ndXJd1P1eIpFUNgvEFxSpibVMxXg
        /5L75y5A==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:57774)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1nSN3B-0001Wc-HQ; Thu, 10 Mar 2022 17:58:09 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1nSN39-0000nD-Kr; Thu, 10 Mar 2022 17:58:07 +0000
Date:   Thu, 10 Mar 2022 17:58:07 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org, kishon@ti.com,
        vkoul@kernel.org, robh+dt@kernel.org, leoyang.li@nxp.com,
        linux-phy@lists.infradead.org, devicetree@vger.kernel.org,
        shawnguo@kernel.org, hongxing.zhu@nxp.com
Subject: Re: [PATCH net-next v3 2/8] dt-bindings: phy: add the "fsl,lynx-28g"
 compatible
Message-ID: <Yio8L2X0Wece2Uxm@shell.armlinux.org.uk>
References: <20220310145200.3645763-1-ioana.ciornei@nxp.com>
 <20220310145200.3645763-3-ioana.ciornei@nxp.com>
 <a32fa8df-bd07-8040-41cd-92484420756d@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a32fa8df-bd07-8040-41cd-92484420756d@canonical.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 10, 2022 at 05:47:31PM +0100, Krzysztof Kozlowski wrote:
> > +patternProperties:
> > +  '^phy@[0-9a-f]$':
> > +    type: object
> > +    properties:
> > +      reg:
> > +        description:
> > +          Number of the SerDes lane.
> > +        minimum: 0
> > +        maximum: 7
> > +
> > +      "#phy-cells":
> > +        const: 0
> 
> Why do you need all these children? You just enumerated them, without
> statuses, resources or any properties. This should be rather just index
> of lynx-28g phy.

There is good reason why the Marvell driver does it this way, and that
is because there are shared registers amongst all the comphys on the
SoC.

Where that isn't the case, and there is no other reason, I would suggest
creating multiple phy modes, one per physical PHY in DT, giving their
address would be a saner approach. That way, the driver isn't locked
in to a model of "we have N PHYs which are spaced by such-and-such
apart", and you don't have this "maximum: 7" thing above either.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
