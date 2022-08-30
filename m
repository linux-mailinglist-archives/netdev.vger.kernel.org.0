Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26EDE5A6CEF
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 21:16:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231303AbiH3TQt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 15:16:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231338AbiH3TQn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 15:16:43 -0400
Received: from relay3-d.mail.gandi.net (relay3-d.mail.gandi.net [217.70.183.195])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 598A070E62;
        Tue, 30 Aug 2022 12:16:29 -0700 (PDT)
Received: (Authenticated sender: maxime.chevallier@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 8744A60002;
        Tue, 30 Aug 2022 19:16:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1661886988;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pEs/624W+YKYvj5zK7eZjM1JCt8Sw3adqq+ghpUn+WU=;
        b=gAi2AYe+rzZDIMKdSyGAjdksSyWKke1CHDdI0PPJ1NnHrqIptMBcrgXs2kclPV9FvOh5uN
        TDcgLl/CrP49/ZS85XzgEsckc4qx7Ff/uq7oXEirfngVZsA3ZtFsKG9YSQYHot6OCkXygF
        jQji4IghD3zlXZeH+K6/fp8rftOMgcrhlLiJEjbvIRe6YHUcNKkx2jAo4aPkE6o8r/jYVI
        iE/Le2UxGMlFERgKFceBwAWKsPaT4DowtCgLnM32Kx80YDX/RbvhF2oqXWrzB06kF0B5/7
        UuoGCGt6fC+mJtVndhAfvDN2TTYBMZTyLy5Vm1fUUBNNTRQMLm8quq9+tDJjnw==
Date:   Tue, 30 Aug 2022 21:16:17 +0200
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
Subject: Re: [PATCH net-next v2 1/5] dt-bindings: net: Convert Altera TSE
 bindings to yaml
Message-ID: <20220830211617.54d2abc9@pc-10.home>
In-Reply-To: <4a37d318-8c83-148b-89b3-9729bc7c9761@linaro.org>
References: <20220830095549.120625-1-maxime.chevallier@bootlin.com>
        <20220830095549.120625-2-maxime.chevallier@bootlin.com>
        <4a37d318-8c83-148b-89b3-9729bc7c9761@linaro.org>
Organization: Bootlin
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 30 Aug 2022 20:13:56 +0300
Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org> wrote:

> On 30/08/2022 12:55, Maxime Chevallier wrote:
> > This converts the bindings for the Altera Triple-Speed Ethernet to
> > yaml.  
> 
> Do not use "This commit/patch".
> https://elixir.bootlin.com/linux/v5.17.1/source/Documentation/process/submitting-patches.rst#L95

ack

> > 
> > Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>  
> 
> Rebase your changes on some decent kernel and use
> get_maintainers.pl...

I'm rebased against net-next, so I don't understand how I'm supposed to
do for this series, should I sent binding patches separately and based
on another tree ?

I'll cc you next time, sorry about that.

> > ---
> > V1->V2:
> >  - Removed unnedded maxItems
> >  - Added missing minItems
> >  - Fixed typos in some properties names
> >  - Fixed the mdio subnode definition
> > 
> >  .../devicetree/bindings/net/altera_tse.txt    | 113 -------------
> >  .../devicetree/bindings/net/altr,tse.yaml     | 156
> > ++++++++++++++++++ 2 files changed, 156 insertions(+), 113
> > deletions(-) delete mode 100644
> > Documentation/devicetree/bindings/net/altera_tse.txt create mode
> > 100644 Documentation/devicetree/bindings/net/altr,tse.yaml 
> 
> (...)
> 
> > diff --git a/Documentation/devicetree/bindings/net/altr,tse.yaml
> > b/Documentation/devicetree/bindings/net/altr,tse.yaml new file mode
> > 100644 index 000000000000..1676e13b8c64
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/net/altr,tse.yaml
> > @@ -0,0 +1,156 @@
> > +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> > +%YAML 1.2
> > +---
> > +$id: http://devicetree.org/schemas/net/altr,tse.yaml#
> > +$schema: http://devicetree.org/meta-schemas/core.yaml#
> > +
> > +title: Altera Triple Speed Ethernet MAC driver (TSE)
> > +
> > +maintainers:
> > +  - Maxime Chevallier <maxime.chevallier@bootlin.com>
> > +
> > +allOf:  
> 
> Put allOf below "required".

Ack

> > +  - $ref: "ethernet-controller.yaml#"
> > +  - if:
> > +      properties:
> > +        compatible:
> > +          contains:
> > +            enum:
> > +              - altr,tse-1.0
> > +              - ALTR,tse-1.0
> > +    then:
> > +      properties:
> > +        reg:
> > +          minItems: 4
> > +        reg-names:
> > +          items:
> > +            - const: control_port
> > +            - const: rx_csr
> > +            - const: tx_csr
> > +            - const: s1
> > +
> > +  - if:
> > +      properties:
> > +        compatible:
> > +          contains:
> > +            enum:
> > +              - altr,tse-msgdma-1.0
> > +    then:
> > +      properties:
> > +        reg:
> > +          minItems: 6
> > +        reg-names:
> > +          minItems: 6  
> 
> No need for minItems.

Ok I'll remove it

> > +          items:
> > +            - const: control_port
> > +            - const: rx_csr
> > +            - const: rx_desc
> > +            - const: rx_resp
> > +            - const: tx_csr
> > +            - const: tx_desc
> > +
> > +properties:
> > +  compatible:
> > +    enum:
> > +      - altr,tse-1.0
> > +      - ALTR,tse-1.0  
> 
> This is deprecated compatible. You need oneOf and then deprecated:
> true.

Ok thanks for the tip

> > +      - altr,tse-msgdma-1.0
> > +
> > +  reg:
> > +    minItems: 4
> > +    maxItems: 6
> > +
> > +  reg-names:
> > +    minItems: 4
> > +    items:
> > +      - const: control_port
> > +      - const: rx_csr
> > +      - const: rx_desc
> > +      - const: rx_resp
> > +      - const: tx_csr
> > +      - const: tx_desc
> > +      - const: s1  
> 
> This is messed up. You allow only 6 items maximum, but list 7. It
> contradicts your other variants in allOf:if:then.

I'll remove that part then, apparently it's not needed at all if the
allOf:if:then cover all cases.

Thanks for the review,

Maxime
> 
> Best regards,
> Krzysztof

