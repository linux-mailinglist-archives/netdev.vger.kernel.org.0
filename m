Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E279F643779
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 22:55:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233602AbiLEVzA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 16:55:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233529AbiLEVyh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 16:54:37 -0500
Received: from mail.3ffe.de (0001.3ffe.de [159.69.201.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D625FF01E;
        Mon,  5 Dec 2022 13:53:16 -0800 (PST)
Received: from 3ffe.de (0001.3ffe.de [IPv6:2a01:4f8:c0c:9d57::1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.3ffe.de (Postfix) with ESMTPSA id 7B275124C;
        Mon,  5 Dec 2022 22:53:14 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2022082101;
        t=1670277194;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9JU4/lrJ7GV2uyecrNqE/O11dV0jCnMb8hnnKpYJnPk=;
        b=eeakvmE97XoN1a1Ouy/oA2+t53U/cPndIPxffhCQyZ1L9EO/gOBdLUtZ35wpWSr0oNwcR+
        uWGeGKm1SAh0Zeepd7ULB1HF6Cyou499gUlQAVVjDvnc13juDEX5QVwuB5R95S8RUOlYuD
        j4+i4LCNij4SqE9O6Ps++GsgtK2stPTtTH8mNQg3ThveCZXONYJcwKtkfq336tGOCc2J3B
        6zq0vugkJSqmUOU1Bx4ldrJhqRuET4d4RmvUVHOJxBnAdLNn9hi1GqGTKqmr/V4qrap0A+
        9g89MYCR3eP5Uj5xoGehbMde4L1WMzHKPR9KkEyc/GREdZMncwwpT77bqoTKCA==
MIME-Version: 1.0
Date:   Mon, 05 Dec 2022 22:53:14 +0100
From:   Michael Walle <michael@walle.cc>
To:     Rob Herring <robh@kernel.org>
Cc:     Xu Liang <lxu@maxlinear.com>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH net-next v1 3/4] dt-bindings: net: phy: add MaxLinear
 GPY2xx bindings
In-Reply-To: <20221205212924.GA2638223-robh@kernel.org>
References: <20221202151204.3318592-1-michael@walle.cc>
 <20221202151204.3318592-4-michael@walle.cc>
 <20221205212924.GA2638223-robh@kernel.org>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <99d4f476d4e0ce5945fa7e1823d9824a@walle.cc>
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

Am 2022-12-05 22:29, schrieb Rob Herring:
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
> 
> Just omit the interrupt property if you don't want interrupts and add 
> it
> if you do.

How does that work together with "the device tree describes
the hardware and not the configuration". The interrupt line
is there, its just broken sometimes and thus it's disabled
by default for these PHY revisions/firmwares. With this
flag the user can say, "hey on this hardware it is not
relevant because we don't have shared interrupts or because
I know what I'm doing".

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
> 
> This is never actually checked by be schema because there is nothing to
> match on. If you want custom properties, then you need a compatible.

This seems to be a problem for any phy bindings then.

-michael
