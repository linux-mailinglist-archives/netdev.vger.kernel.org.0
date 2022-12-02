Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 502E06410E6
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 23:50:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234550AbiLBWuZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 17:50:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234500AbiLBWuV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 17:50:21 -0500
Received: from mail.3ffe.de (0001.3ffe.de [IPv6:2a01:4f8:c0c:9d57::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E476BA055F;
        Fri,  2 Dec 2022 14:50:20 -0800 (PST)
Received: from 3ffe.de (0001.3ffe.de [IPv6:2a01:4f8:c0c:9d57::1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.3ffe.de (Postfix) with ESMTPSA id B22F988;
        Fri,  2 Dec 2022 23:50:18 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2022082101;
        t=1670021418;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Mjsu+evAmepCPPj590qtkov3/RbCbRcbfbTD/ow3mtQ=;
        b=kuVq8IdxgW2SgKUo3r2wc6G5LkO2eMYpujGmzZ4w1S21st++GQF0cR4U+Htdt5ygSOtFKx
        XKVzpEqH6+yV+RANL538B3/OdC++8RQ26+j4R5hsqvAKZgiWf1tfdmjVBk7GygfsUd2c7M
        b/4NaJIOZl1N8b2mE0HoacLq9dYmMVqtsZ6aM2tVUhXx3f3lGYlwsa9seFN0/Iu5f2w2oP
        XSxj0X444ad8aZESZCzckOb9q0TiKCJOw5en4tWVuYbHke/BtlkfU1K9B3N3QiGaZzOdD+
        t4Qz+OYdXpL6E5LewoO3QUEsomEFv5xP9DBqA7G/tNvgAoH7q6ObhzJCRRZW0w==
MIME-Version: 1.0
Date:   Fri, 02 Dec 2022 23:50:18 +0100
From:   Michael Walle <michael@walle.cc>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Xu Liang <lxu@maxlinear.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH net-next v1 3/4] dt-bindings: net: phy: add MaxLinear
 GPY2xx bindings
In-Reply-To: <Y4pEhjDOGmpmj/Kk@lunn.ch>
References: <20221202151204.3318592-1-michael@walle.cc>
 <20221202151204.3318592-4-michael@walle.cc> <Y4pEhjDOGmpmj/Kk@lunn.ch>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <56d66e0da56b33d668362e5701399499@walle.cc>
X-Sender: michael@walle.cc
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 2022-12-02 19:31, schrieb Andrew Lunn:
> On Fri, Dec 02, 2022 at 04:12:03PM +0100, Michael Walle wrote:
>> Add the device tree bindings for the MaxLinear GPY2xx PHYs.
>> 
>> Signed-off-by: Michael Walle <michael@walle.cc>
>> ---
>> 
>> Is the filename ok? I was unsure because that flag is only for the 
>> GPY215
>> for now. But it might also apply to others. Also there is no 
>> compatible
>> string, so..
>> 
>>  .../bindings/net/maxlinear,gpy2xx.yaml        | 47 
>> +++++++++++++++++++
>>  1 file changed, 47 insertions(+)
>>  create mode 100644 
>> Documentation/devicetree/bindings/net/maxlinear,gpy2xx.yaml
>> 
>> diff --git 
>> a/Documentation/devicetree/bindings/net/maxlinear,gpy2xx.yaml 
>> b/Documentation/devicetree/bindings/net/maxlinear,gpy2xx.yaml
>> new file mode 100644
>> index 000000000000..d71fa9de2b64
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/net/maxlinear,gpy2xx.yaml
>> @@ -0,0 +1,47 @@
>> +# SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause
>> +%YAML 1.2
>> +---
>> +$id: http://devicetree.org/schemas/net/maxlinear,gpy2xx.yaml#
>> +$schema: http://devicetree.org/meta-schemas/core.yaml#
>> +
>> +title: MaxLinear GPY2xx PHY
>> +
>> +maintainers:
>> +  - Andrew Lunn <andrew@lunn.ch>
>> +  - Michael Walle <michael@walle.cc>
>> +
>> +allOf:
>> +  - $ref: ethernet-phy.yaml#
>> +
>> +properties:
>> +  maxlinear,use-broken-interrupts:
>> +    description: |
>> +      Interrupts are broken on some GPY2xx PHYs in that they keep the
>> +      interrupt line asserted even after the interrupt status 
>> register is
>> +      cleared. Thus it is blocking the interrupt line which is 
>> usually bad
>> +      for shared lines. By default interrupts are disabled for this 
>> PHY and
>> +      polling mode is used. If one can live with the consequences, 
>> this
>> +      property can be used to enable interrupt handling.
>> +
>> +      Affected PHYs (as far as known) are GPY215B and GPY215C.
>> +    type: boolean
>> +
>> +dependencies:
>> +  maxlinear,use-broken-interrupts: [ interrupts ]
>> +
>> +unevaluatedProperties: false
>> +
>> +examples:
>> +  - |
>> +    ethernet {
>> +        #address-cells = <1>;
>> +        #size-cells = <0>;
>> +
>> +        ethernet-phy@0 {
>> +            reg = <0>;
>> +            interrupts-extended = <&intc 0>;
>> +            maxlinear,use-broken-interrupts;
>> +        };
>> +    };
> 
> I'm wondering if we want this in the example. We probably don't want
> people to use this property by accident, i.e. copy/paste without
> reading the rest of the document. This will becomes a bigger problem
> if more properties are added, RGMII delays etc.
> 
> So maybe just skip the example?

I agree. Let's wait what the device tree maintainers say.

-michael
