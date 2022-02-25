Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 739D74C40F4
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 10:09:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238903AbiBYJKA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 04:10:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238893AbiBYJJ6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 04:09:58 -0500
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCFAA251E70;
        Fri, 25 Feb 2022 01:09:25 -0800 (PST)
Received: by mail-lj1-x22e.google.com with SMTP id bn33so6506055ljb.6;
        Fri, 25 Feb 2022 01:09:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:to:cc:references
         :from:in-reply-to:content-transfer-encoding;
        bh=y04zq2uTKXLAwh7HStFPmnBzlgo0aDK3doeC+yWV3Lg=;
        b=ihcltXRbo3ARDVrZE1J9s3WjRL1HNRDcBaPnM606Uc5Fo79TwO7Yr2tR1m/ueRAqTG
         DF8xpFGmTcji8zcIPgm4fScAyHZcLNiLw1GhXfVvv8fLK1VV2jcZygmmLPV0zS0oSFFh
         aeONEmzSz819SpNryPowiF4K+8Nqn51WOX18iK86foWWMpVPJF5sloziuyCuGMMLLFCc
         TDB7Z0aJjgdkvMefUUWew8hRdZtnsd2WSeY0vR1Me8Humlfds8SZPfsb1JzCmUEd60SQ
         2KnbFlelJSMXtFxG0zk+ByYaj7sDLJPA9iSWGjBIBoF49nso16SAF2SrSWaSdbRlh2Vf
         O4+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :to:cc:references:from:in-reply-to:content-transfer-encoding;
        bh=y04zq2uTKXLAwh7HStFPmnBzlgo0aDK3doeC+yWV3Lg=;
        b=pzRUeY6l/V80QgDvt3oySDl4bs4ekKV2g0lY2shzPra8Mm1Kk9Rf+fHDUzsN5C8BuF
         MzbAfgG2XMKI+GGZLTq+lkrobUZmC/OO1N1UyCPxYOaBhI/+VmzdiUmwAyp9EEXH1ke7
         tkpXMzt69jtZvZl/o/XHPCzkvv7dghQL3EQlJNO7DoeRnvHHVZZz+Zaxz4FJjot3ZM0V
         rliutQz/3Z9cGxp1bxmLS4Slj2NUCQZ49px6zcq/GA6vo86tQeZNYVlenFnbnR81Jclt
         SzY/B7wvgqe/JlL15Q9tCgMIk9aO8Lq4RxJr4t6vMCUOGPwhFUgeOeD6HhnkRjpE3Bgq
         zcag==
X-Gm-Message-State: AOAM533F/iwEUKbhJ8njUfiD+ybqu1L5xFLv9f7kbij6tUeovWdS+/i6
        gPhfSMOWWCNbjwKX1OgUsfCy34qyqgc=
X-Google-Smtp-Source: ABdhPJxXr05gW0m8wN/bE8X5kn1638dMFPV6myXvvmQ1FgMW6sY5p7ksCcM0ZqeBC+yllrcx3z/uxQ==
X-Received: by 2002:a2e:5714:0:b0:246:4196:9c0b with SMTP id l20-20020a2e5714000000b0024641969c0bmr4779846ljb.473.1645780164007;
        Fri, 25 Feb 2022 01:09:24 -0800 (PST)
Received: from [192.168.26.149] (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.googlemail.com with ESMTPSA id f18-20020ac25332000000b00442e9987b7fsm146645lfh.106.2022.02.25.01.09.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Feb 2022 01:09:23 -0800 (PST)
Message-ID: <4871749f-4c1d-07a2-ff2e-793c967c1f32@gmail.com>
Date:   Fri, 25 Feb 2022 10:09:22 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:96.0) Gecko/20100101
 Thunderbird/96.0
Subject: Re: [PATCH REBASED 2/2] dt-bindings: nvmem: cells: add MAC address
 cell
To:     =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>,
        Rob Herring <robh@kernel.org>, Michael Walle <michael@walle.cc>
Cc:     Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        linux-mtd@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        netdev@vger.kernel.org, Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Shawn Guo <shawnguo@kernel.org>, Li Yang <leoyang.li@nxp.com>,
        Frank Rowand <frowand.list@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>
References: <20220125180114.12286-1-zajec5@gmail.com>
 <20220126070745.32305-1-zajec5@gmail.com>
 <20220126070745.32305-2-zajec5@gmail.com>
 <YflX6kxWTD6qMnhJ@robh.at.kernel.org>
 <1dd3522d9c7cfcb40f4f8198d4d35118@milecki.pl>
From:   =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
In-Reply-To: <1dd3522d9c7cfcb40f4f8198d4d35118@milecki.pl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1.02.2022 17:49, Rafał Miłecki wrote:
> On 2022-02-01 16:55, Rob Herring wrote:
>> On Wed, Jan 26, 2022 at 08:07:45AM +0100, Rafał Miłecki wrote:
>>> From: Rafał Miłecki <rafal@milecki.pl>
>>>
>>> This adds support for describing details of NVMEM cell containing MAC
>>> address. Those are often device specific and could be nicely stored in
>>> DT.
>>>
>>> Initial documentation includes support for describing:
>>> 1. Cell data format (e.g. Broadcom's NVRAM uses ASCII to store MAC)
>>> 2. Reversed bytes flash (required for i.MX6/i.MX7 OCOTP support)
>>> 3. Source for multiple addresses (very common in home routers)
>>>
>>> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
>>> ---
>>>  .../bindings/nvmem/cells/mac-address.yaml     | 94 +++++++++++++++++++
>>>  1 file changed, 94 insertions(+)
>>>  create mode 100644 Documentation/devicetree/bindings/nvmem/cells/mac-address.yaml
>>>
>>> diff --git a/Documentation/devicetree/bindings/nvmem/cells/mac-address.yaml b/Documentation/devicetree/bindings/nvmem/cells/mac-address.yaml
>>> new file mode 100644
>>> index 000000000000..f8d19e87cdf0
>>> --- /dev/null
>>> +++ b/Documentation/devicetree/bindings/nvmem/cells/mac-address.yaml
>>> @@ -0,0 +1,94 @@
>>> +# SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause
>>> +%YAML 1.2
>>> +---
>>> +$id: http://devicetree.org/schemas/nvmem/cells/mac-address.yaml#
>>> +$schema: http://devicetree.org/meta-schemas/core.yaml#
>>> +
>>> +title: NVMEM cell containing a MAC address
>>> +
>>> +maintainers:
>>> +  - Rafał Miłecki <rafal@milecki.pl>
>>> +
>>> +properties:
>>> +  compatible:
>>> +    const: mac-address
>>> +
>>> +  format:
>>> +    description: |
>>> +      Some NVMEM cells contain MAC in a non-binary format.
>>> +
>>> +      ASCII should be specified if MAC is string formatted like:
>>> +      - "01:23:45:67:89:AB" (30 31 3a 32 33 3a 34 35 3a 36 37 3a 38 39 3a 41 42)
>>> +      - "01-23-45-67-89-AB"
>>> +      - "0123456789AB"
>>> +    enum:
>>> +      - ascii
>>> +
>>> +  reversed-bytes:
>>> +    type: boolean
>>> +    description: |
>>> +      MAC is stored in reversed bytes order. Example:
>>> +      Stored value: AB 89 67 45 23 01
>>> +      Actual MAC: 01 23 45 67 89 AB
>>> +
>>> +  base-address:
>>> +    type: boolean
>>> +    description: |
>>> +      Marks NVMEM cell as provider of multiple addresses that are relative to
>>> +      the one actually stored physically. Respective addresses can be requested
>>> +      by specifying cell index of NVMEM cell.
>>
>> While a base address is common, aren't there different ways the base is
>> modified.
>>
>> The problem with these properties is every new variation results in a
>> new property and the end result is something not well designed. A unique
>> compatible string, "#nvmem-cell-cells" and code to interpret the data is
>> more flexible.
>>
>> For something like this to fly, I need some level of confidence this is
>> enough for everyone for some time (IOW, find all the previous attempts
>> and get those people's buy-in). You have found at least 3 cases, but I
>> seem to recall more.
> 
> For base address I thought of dealing with base + offset only. I'm not
> sure what are other cases.
> 
> I read few old threads:
> https://lore.kernel.org/lkml/20211228142549.1275412-1-michael@walle.cc/T/
> https://lore.kernel.org/linux-devicetree/20211123134425.3875656-1-michael@walle.cc/
> https://lore.kernel.org/all/20210414152657.12097-2-michael@walle.cc/
> https://lore.kernel.org/linux-devicetree/362f1c6a8b0ec191b285ac6a604500da@walle.cc/
> 
> but didn't find other required /transformations/ except for offset and
> format. Even "reversed-bytes" wasn't widely discussed (or I missed that)
> and I just came with it on my own.
> 
> If anyone knows other cases: please share so we have a complete view.
> 
> 
> I tried to Cc all previously invovled people but it seems only me and
> Michael remained active in this subject. If anyone knows other
> interested please Cc them and let us know.
> 
> 
> Rob: instead of me and Michael sending patch after patch let me try to
> gather solutions I can think of / I recall. Please kindly review them
> and let us know what do you find the cleanest.
> 
> 
> 1. NVMEM specific "compatible" string
> 
> Example:
> 
> partition@f00000 {
>      compatible = "brcm,foo-cells", "nvmem-cells";
>      label = "calibration";
>      reg = <0xf00000 0x100000>;
>      ranges = <0 0xf00000 0x100000>;
>      #address-cells = <1>;
>      #size-cells = <1>;
> 
>      mac@100 {
>          reg = <0x100 0x6>;
>          [optional: #nvmem-cell-cells = <1>;]
>      };
> };
> 
> A minimalistic binding proposed by Michael. DT doesn't carry any
> information on NVMEM cell format. Specific drivers (e.g. one handling
> "brcm,foo-cells") have to know how to handle specific cell.
> 
> Cell handling conditional code can depend on cell node name ("mac" in
> above case) OR on value of "nvmem-cell-names" in cell consumer (e.g.
> nvmem-cell-names = "mac-address").
> 
> 
> 2. NVMEM specific "compatible" string + cells "compatible"s
> 
> Example:
> 
> partition@f00000 {
>      compatible = "brcm,foo-cells", "nvmem-cells";
>      label = "calibration";
>      reg = <0xf00000 0x100000>;
>      ranges = <0 0xf00000 0x100000>;
>      #address-cells = <1>;
>      #size-cells = <1>;
> 
>      mac@100 {
>          compatible = "mac-address";
>          reg = <0x100 0x6>;
>          [optional: #nvmem-cell-cells = <1>;]
>      };
> };
> 
> Similar to the first case but cells that require special handling are
> marked with NVMEM device specific "compatible" values. Details of handling
> cells are still hardcoded in NVMEM driver. Different cells with
> compatible = "mac-address";
> may be handled differencly - depending on parent NVMEM device.
> 
> 
> 3. Flexible properties in NVMEM cells
> 
> Example:
> 
> partition@f00000 {
>      compatible = "brcm,foo-cells", "nvmem-cells";
>      label = "calibration";
>      reg = <0xf00000 0x100000>;
>      ranges = <0 0xf00000 0x100000>;
>      #address-cells = <1>;
>      #size-cells = <1>;
> 
>      mac@100 {
>          compatible = "mac-address";
>          reg = <0x100 0x6>;
>          [optional: #nvmem-cell-cells = <1>;]
>      };
> 
>      mac@200 {
>          compatible = "mac-address";
>          reg = <0x200 0x6>;
>          reversed-bytes;
>          [optional: #nvmem-cell-cells = <1>;]
>      };
> 
>      mac@300 {
>          compatible = "mac-address";
>          reg = <0x300 0x11>;
>          format = "ascii";
>          [optional: #nvmem-cell-cells = <1>;]
>      };
> };
> 
> This moves details into DT and requires more shared properties. It helps
> avoiding duplicated code for common cases (like base MAC address).
> 
> It's what I proposed in the
> [PATCH 0/2] dt-bindings: nvmem: support describing cells

Rob: could you review for us 3 above examples, please?
