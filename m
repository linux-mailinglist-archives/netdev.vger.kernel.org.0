Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7B675A7A25
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 11:25:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231472AbiHaJZL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 05:25:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231877AbiHaJYs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 05:24:48 -0400
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC25812D37
        for <netdev@vger.kernel.org>; Wed, 31 Aug 2022 02:24:30 -0700 (PDT)
Received: by mail-lj1-x232.google.com with SMTP id s15so8837328ljp.5
        for <netdev@vger.kernel.org>; Wed, 31 Aug 2022 02:24:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=VI4eDETT6Huw+TXcdbmKbmIcm3NDxGv5vFpEfsxIq2o=;
        b=BzB+y2h79du3jsoSjssbNYv8xTbQTSRuFeiLqZlVVfHai6OszIUB9Z9vyLHiW6yVC0
         mFhcQSdm34Q70qsG1M0wyhsJNo4/chInLydmy0chTTagCzpzi3ssLByjyxwzhbNJmd/8
         ZijvyCeY2O+BgxO2HWF3wrEBJuMo4f/EUf6ZOXYor3ya+Tk0OYf8e9pmfjXWnQ1kaX2k
         Ifak1XhbuK3l0enEpdUuv8W8/d3iTI2d1VbGfb/a3EEtRllZcz/6FwD7ueWqITyM2gG1
         ixN4VLOXZr9LDYMP4/wDk3Bgnb4f9IuE6r2p5QCSoDJMD2sT0T/cg44zYUDju53PrfuL
         yC+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=VI4eDETT6Huw+TXcdbmKbmIcm3NDxGv5vFpEfsxIq2o=;
        b=OBf7i4+xB3tKt5jlquPNoePmsuIwUIDAGusC/mx0QSFFjbeVwcg639kAYyE3fAtl6K
         sND3djidpzg9zXGKUpIy9wUPI+MlE6B4ID8s2CIaHMHB0h7grxP88Fh1NeiCdf/ypiDu
         uzc5y0wciBYX95VUyoysIigksWopEvMsxSrn452Nn3BqjeH24BrAIGGTYPtaKJb2eAIQ
         LqzrW4yVONzX7zrfSqzE4qmI7ayws++9gxZKAmycWDGbDuamOddKZwrHyi642rNI9jxk
         WkPS8wJTbTYwvW8rmf7sNzaJHTPHNTDVgzQHIi163Om5cAIPmZh9Wbq/ZCXSB1KzBV9R
         KSXw==
X-Gm-Message-State: ACgBeo2K06pk4TyPRGl1e0VQiOE4R9ROovGO3Qx3SSKawEnOLLuH86sB
        K6IGl8IviTcTr6bfzDiT+j0d0g==
X-Google-Smtp-Source: AA6agR4P4GFoVNfQygaB/IJ2Yvm/5Y5Zaf2SFn3mFBsY32pgqCAUC3wvgOs2U5P/ncXj79cCDpTOlw==
X-Received: by 2002:a05:651c:1cf:b0:266:ec0f:6d8e with SMTP id d15-20020a05651c01cf00b00266ec0f6d8emr2450900ljn.347.1661937869103;
        Wed, 31 Aug 2022 02:24:29 -0700 (PDT)
Received: from [192.168.28.124] (balticom-73-99-134.balticom.lv. [109.73.99.134])
        by smtp.gmail.com with ESMTPSA id w23-20020a05651c119700b002666ab94a84sm822220ljo.84.2022.08.31.02.24.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 31 Aug 2022 02:24:28 -0700 (PDT)
Message-ID: <4bf16e18-1591-8bc9-7c46-649391de3761@linaro.org>
Date:   Wed, 31 Aug 2022 12:24:27 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH v1 09/14] dt-bindings: nvmem: add YAML schema for the sl28
 vpd layout
Content-Language: en-US
To:     Michael Walle <michael@walle.cc>
Cc:     Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Shawn Guo <shawnguo@kernel.org>, Li Yang <leoyang.li@nxp.com>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Frank Rowand <frowand.list@gmail.com>,
        linux-mtd@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        netdev@vger.kernel.org, Ahmad Fatoum <a.fatoum@pengutronix.de>
References: <20220825214423.903672-1-michael@walle.cc>
 <20220825214423.903672-10-michael@walle.cc>
 <b85276ee-3e19-3adb-8077-c1e564e02eb3@linaro.org>
 <ddaf3328bc7d88c47517285a3773470f@walle.cc>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <ddaf3328bc7d88c47517285a3773470f@walle.cc>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 31/08/2022 11:17, Michael Walle wrote:
> Am 2022-08-31 09:45, schrieb Krzysztof Kozlowski:
>> On 26/08/2022 00:44, Michael Walle wrote:
>>> Add a schema for the NVMEM layout on Kontron's sl28 boards.
>>>
>>> Signed-off-by: Michael Walle <michael@walle.cc>
>>> ---
>>>  .../nvmem/layouts/kontron,sl28-vpd.yaml       | 52 
>>> +++++++++++++++++++
>>>  1 file changed, 52 insertions(+)
>>>  create mode 100644 
>>> Documentation/devicetree/bindings/nvmem/layouts/kontron,sl28-vpd.yaml
>>>
>>> diff --git 
>>> a/Documentation/devicetree/bindings/nvmem/layouts/kontron,sl28-vpd.yaml 
>>> b/Documentation/devicetree/bindings/nvmem/layouts/kontron,sl28-vpd.yaml
>>> new file mode 100644
>>> index 000000000000..e4bc2d9182db
>>> --- /dev/null
>>> +++ 
>>> b/Documentation/devicetree/bindings/nvmem/layouts/kontron,sl28-vpd.yaml
>>> @@ -0,0 +1,52 @@
>>> +# SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)
>>> +%YAML 1.2
>>> +---
>>> +$id: 
>>> http://devicetree.org/schemas/nvmem/layouts/kontron,sl28-vpd.yaml#
>>> +$schema: http://devicetree.org/meta-schemas/core.yaml#
>>> +
>>> +title: NVMEM layout of the Kontron SMARC-sAL28 vital product data
>>> +
>>> +maintainers:
>>> +  - Michael Walle <michael@walle.cc>
>>> +
>>> +description:
>>> +  The vital product data (VPD) of the sl28 boards contains a serial
>>> +  number and a base MAC address. The actual MAC addresses for the
>>> +  on-board ethernet devices are derived from this base MAC address by
>>> +  adding an offset.
>>> +
>>> +properties:
>>> +  compatible:
>>> +    items:
>>> +      - const: kontron,sl28-vpd
>>> +      - const: user-otp
>>> +
>>> +  serial-number:
>>> +    type: object
>>
>> You should define the contents of this object. I would expect this to 
>> be
>> uint32 or string. I think you also need description, as this is not
>> really standard field.
> 
> First thing, this binding isn't like the usual ones, so it might be
> totally wrong.
> 
> What I'd like to achieve here is the following:
> 
> We have the nvmem-consumer dt binding where you can reference a
> nvmem cell in a consumer node. Example:
>    nvmem-cells = <&base_mac_address 5>;
>    nvmem-cell-names = "mac-address";
> 
> On the other end of the link we have the nvmem-provider. The dt
> bindings works well if that one has individual cell nodes, like
> it is described in the nvmem.yaml binding. I.e. you can give the
> cell a label and make a reference to it in the consumer just like
> in the example above.

You can also achieve it with phandle argument to the nvmwm controller,
right? Just like most of providers are doing (clocks, resets). Having
fake (empty) nodes just for that seems like overkill.

> 
> Now comes the catch: what if there is no actual description of the
> cell in the device tree, but is is generated during runtime. How
> can I get a label to it.

Same as clocks, resets, power-domains and everyone else.


> Therefore, in this case, there is just
> an empty node and the driver will associate it with the cell
> created during runtime (see patch 10). It is not expected, that
> is has any properties.

It cannot be even referenced as it does not have #cells property...

> 
>>> +
>>> +  base-mac-address:
>>
>> Fields should be rather described here, not in top-level description.
>>
>>> +    type: object
>>
>> On this level:
>>     additionalProperties: false
>>
>>> +
>>> +    properties:
>>> +      "#nvmem-cell-cells":
>>> +        const: 1
>>> +
>>
>> I also wonder why you do not have unit addresses. What if you want to
>> have two base MAC addresses?
> 
> That would describe an offset within the nvmem device. But the offset
> might not be constant, depending on the content. My understanding
> so far was that in that case, you use the "-N" suffix.
> 
> base-mac-address-1
> base-mac-address-2
> 
> (or maybe completely different names).

You do not allow "base-mac-address-1". Your binding explicitly accepts
only "base-mac-address".

Best regards,
Krzysztof
