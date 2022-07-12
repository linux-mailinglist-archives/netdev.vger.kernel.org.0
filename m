Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D1E5572021
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 18:00:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233027AbiGLQAB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 12:00:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229813AbiGLQAA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 12:00:00 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A586FBFADF;
        Tue, 12 Jul 2022 08:59:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=Noa21biYShxdCO0+5k8GjeB31+A2tADbHyxeUmcBaPQ=; b=mAbVR09UJuICbVejnpNHu9anjz
        4xDWtKlUnRWqYzVFx1kiXoDrvTHfX2JSZneJq4xmpZ54lAoq+TRnohAU3bT7+zCN2tcU3ygzA+qxr
        ozPCs+zDx4P3HPpeCG+c5Bz7sYqBu7Ys0dfcYjPn+B5/MvobDiT2Z41ifMa05Fk14LMuJ+WswZEwz
        M2Ajzx5wML8Ktabp6d3m6y20QNp6mt3WY4Ei1FH7toHS2JD08Li3Gd8WvICWmvrXRGyp3Iwah6c95
        fagtxJwzXPtJ3aeYFPjLVqnGdf9VYU8E19apu6e3llTFWqOEemIg1GGr+5xnZIb1UklfA9xTc9Z/B
        4rAhcdmw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:33306)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1oBIIk-00032t-Mn; Tue, 12 Jul 2022 16:59:54 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1oBIIj-0004oF-5z; Tue, 12 Jul 2022 16:59:53 +0100
Date:   Tue, 12 Jul 2022 16:59:53 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     Sean Anderson <sean.anderson@seco.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        linux-kernel@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Subject: Re: [RFC PATCH net-next 2/9] dt-bindings: net: Expand pcs-handle to
 an array
Message-ID: <Ys2aeRBGGv6ajMZ5@shell.armlinux.org.uk>
References: <20220711160519.741990-1-sean.anderson@seco.com>
 <20220711160519.741990-3-sean.anderson@seco.com>
 <ecaf9d0f-6ddb-5842-790e-3d5ee80e2a77@linaro.org>
 <fdd34075-4e5e-a617-696d-15c5ac6e9bfe@seco.com>
 <d84899e7-06f7-1a20-964f-90b6f0ff96fd@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d84899e7-06f7-1a20-964f-90b6f0ff96fd@linaro.org>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 12, 2022 at 05:18:05PM +0200, Krzysztof Kozlowski wrote:
> On 12/07/2022 17:06, Sean Anderson wrote:
> > Hi Krzysztof,
> > 
> > On 7/12/22 4:51 AM, Krzysztof Kozlowski wrote:
> >> On 11/07/2022 18:05, Sean Anderson wrote:
> >>> This allows multiple phandles to be specified for pcs-handle, such as
> >>> when multiple PCSs are present for a single MAC. To differentiate
> >>> between them, also add a pcs-names property.
> >>>
> >>> Signed-off-by: Sean Anderson <sean.anderson@seco.com>
> >>> ---
> >>>
> >>>  .../devicetree/bindings/net/ethernet-controller.yaml       | 7 ++++++-
> >>>  1 file changed, 6 insertions(+), 1 deletion(-)
> >>>
> >>> diff --git a/Documentation/devicetree/bindings/net/ethernet-controller.yaml b/Documentation/devicetree/bindings/net/ethernet-controller.yaml
> >>> index 4f15463611f8..c033e536f869 100644
> >>> --- a/Documentation/devicetree/bindings/net/ethernet-controller.yaml
> >>> +++ b/Documentation/devicetree/bindings/net/ethernet-controller.yaml
> >>> @@ -107,11 +107,16 @@ properties:
> >>>      $ref: "#/properties/phy-connection-type"
> >>>  
> >>>    pcs-handle:
> >>> -    $ref: /schemas/types.yaml#/definitions/phandle
> >>> +    $ref: /schemas/types.yaml#/definitions/phandle-array
> >>>      description:
> >>>        Specifies a reference to a node representing a PCS PHY device on a MDIO
> >>>        bus to link with an external PHY (phy-handle) if exists.
> >>
> >> You need to update all existing bindings and add maxItems:1.
> >>
> >>>  
> >>> +  pcs-names:
> >>
> >> To be consistent with other properties this should be "pcs-handle-names"
> >> and the other "pcs-handles"... and then actually drop the "handle".
> > 
> > Sorry, I'm not sure what you're recommending in the second half here.
> 
> I would be happy to see consistent naming with other xxxs/xxx-names
> properties, therefore I recommend to:
> 1. deprecate pcs-handle because anyway the naming is encoding DT spec
> into the name ("handle"),
> 2. add new property 'pcs' or 'pcss' (the 's' at the end like clocks but
> maybe that's too much) with pcs-names.
> 
> However before implementing this, please wait for more feedback. Maybe
> Rob or net folks will have different opinions.

We decided on "pcs-handle" for PCS for several drivers, to be consistent
with the situation for network PHYs (which are "phy-handle", settled on
after we also had "phy" and "phy-device" and decided to deprecate these
two.

Surely we should have consistency within the net code - so either "phy"
and "pcs" or "phy-handle" and "pcs-handle" but not a mixture of both?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
