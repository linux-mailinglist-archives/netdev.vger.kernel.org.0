Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96C725A6CF9
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 21:18:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230461AbiH3TSp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 15:18:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229808AbiH3TSh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 15:18:37 -0400
Received: from relay6-d.mail.gandi.net (relay6-d.mail.gandi.net [217.70.183.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 552A367C87;
        Tue, 30 Aug 2022 12:18:35 -0700 (PDT)
Received: (Authenticated sender: maxime.chevallier@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 54FF1C0007;
        Tue, 30 Aug 2022 19:18:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1661887113;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RP9MukXjGqIyLr5AlW9DcIAeUcb51pnZKdqEvgTxjz4=;
        b=bcButg8Oj1dC+1XpgnZvKko1SSZKrj7zqULopY2oEcYUUNFp6EOkSfkYWn2Zi1wGUSkpCv
        IiPln8/8eFmxA25/J8B9v1H8WLwbNpiASNLx5TvkmGHpIzE/HjeyaIHHpo35lbKGH3Czjk
        QOEYLVXREHUDyUHgYwF394ioScoxyBcFM65x4jV+RlGfD8doDkcG665wkxE1Mi2buSATZk
        qtcHp4K+QkiKoAHvg+esCwB1+EreMJG38OtrpHPlEhaUHEI+ZBIO/pWpuQFvAwt19BKOBl
        aFiV5PZ/LCYCBU8IXTh76A2DaJxLTOgwUCZDeEIqKr+h2JYc261i+zPV/OtZ0A==
Date:   Tue, 30 Aug 2022 21:18:28 +0200
From:   Maxime Chevallier <maxime.chevallier@bootlin.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     davem@davemloft.net, Rob Herring <robh+dt@kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        thomas.petazzoni@bootlin.com, Andrew Lunn <andrew@lunn.ch>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Subject: Re: [PATCH net-next v2 5/5] dt-bindings: net: altera: tse: add an
 optional pcs register range
Message-ID: <20220830211828.35971761@pc-10.home>
In-Reply-To: <c8236663-055c-d6da-64ed-ae3f7fb2e690@linaro.org>
References: <20220830095549.120625-1-maxime.chevallier@bootlin.com>
        <20220830095549.120625-6-maxime.chevallier@bootlin.com>
        <c8236663-055c-d6da-64ed-ae3f7fb2e690@linaro.org>
Organization: Bootlin
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 30 Aug 2022 20:14:52 +0300
Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org> wrote:

> On 30/08/2022 12:55, Maxime Chevallier wrote:
> > Some implementations of the TSE have their PCS as an external bloc,
> > exposed at its own register range. Document this, and add a new
> > example showing a case using the pcs and the new phylink conversion
> > to connect an sfp port to a TSE mac.
> > 
> > Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
> > ---
> > V1->V2 :
> >  - Fixed example
> > 
> >  .../devicetree/bindings/net/altr,tse.yaml     | 29
> > ++++++++++++++++++- 1 file changed, 28 insertions(+), 1 deletion(-)
> > 
> > diff --git a/Documentation/devicetree/bindings/net/altr,tse.yaml
> > b/Documentation/devicetree/bindings/net/altr,tse.yaml index
> > 1676e13b8c64..4b314861a831 100644 ---
> > a/Documentation/devicetree/bindings/net/altr,tse.yaml +++
> > b/Documentation/devicetree/bindings/net/altr,tse.yaml @@ -39,6
> > +39,7 @@ allOf: properties:
> >          reg:
> >            minItems: 6
> > +          maxItems: 7
> >          reg-names:
> >            minItems: 6
> >            items:
> > @@ -48,6 +49,7 @@ allOf:
> >              - const: rx_resp
> >              - const: tx_csr
> >              - const: tx_desc
> > +            - const: pcs
> >  
> >  properties:
> >    compatible:
> > @@ -58,7 +60,7 @@ properties:
> >  
> >    reg:
> >      minItems: 4
> > -    maxItems: 6
> > +    maxItems: 7
> >  
> >    reg-names:
> >      minItems: 4
> > @@ -69,6 +71,7 @@ properties:
> >        - const: rx_resp
> >        - const: tx_csr
> >        - const: tx_desc
> > +      - const: pcs
> >        - const: s1
> >    
> 
> So now 8 items?

I'll also remove that. My understanding was that on top of the
allOf:if/then, I was supposed to re-list all possible values. I got
that wrong, so that's not needed at all.

> 
> >    interrupts:
> > @@ -122,6 +125,30 @@ required:
> >  unevaluatedProperties: false
> >  
> >  examples:
> > +  - |
> > +    tse_sub_0: ethernet@c0100000 {
> > +        compatible = "altr,tse-msgdma-1.0";
> > +        reg = <0xc0100000 0x00000400>,
> > +              <0xc0101000 0x00000020>,
> > +              <0xc0102000 0x00000020>,
> > +              <0xc0103000 0x00000008>,
> > +              <0xc0104000 0x00000020>,
> > +              <0xc0105000 0x00000020>,
> > +              <0xc0106000 0x00000100>;
> > +        reg-names = "control_port", "rx_csr", "rx_desc",
> > "rx_resp", "tx_csr", "tx_desc", "pcs";
> > +        interrupt-parent = <&intc>;
> > +        interrupts = <0 44 4>,<0 45 4>;
> > +        interrupt-names = "rx_irq","tx_irq";
> > +        rx-fifo-depth = <2048>;
> > +        tx-fifo-depth = <2048>;
> > +        max-frame-size = <1500>;
> > +        local-mac-address = [ 00 0C ED 00 00 02 ];  
> 
> 00 00 00 00 00 00
> (easier to spot that it is invalid)

Ack, thanks !

Best regards,

Maxime

> 
> Best regards,
> Krzysztof

