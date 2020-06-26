Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC80820B8D3
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 20:56:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726175AbgFZSz4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 14:55:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726073AbgFZSzy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 14:55:54 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B769C03E979;
        Fri, 26 Jun 2020 11:55:53 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id n24so10378278ejd.0;
        Fri, 26 Jun 2020 11:55:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=IQwkxOOhqcLU58zMWRLZm0lsX7lS4aR3d1Ike0aCDWE=;
        b=YbHSthgBD0hCv2+QKG0oolKQJ1JEHalVYH8VJn/pyW2gpQKO71nOf8BHHfHgD+fi2I
         GaiNfuv2NzQFqEnQ6zoTFLsSRcSACLgKJA+xBY2FS9hX0JS/PNk1cdCj59JnnFoYtybv
         A0mowpuUgXnQqFZVwQb4UZr5KZjgRwnW9g1FLR/cqOt5uHCGl9gBPiywBI0uSK7Pr/j/
         MkGv9F5tHO7zm5aaJ6PU6rQocL5Ci6umepSaK1LX/pw8RGrI3TROu345GeviF8wXYQkH
         b+fYC8xbVtrfK8KnF++csX2Iv19tZ6iFskBA3TOIIXtj5WUsfxQX2Yn+4ngKA30+hHIe
         iRLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=IQwkxOOhqcLU58zMWRLZm0lsX7lS4aR3d1Ike0aCDWE=;
        b=i9U38mYHziLByl1tHWO3imZIqwUulA3fdBJf0vx7UMJP06y+mrIgTEfR3MXi5v5PP2
         9jTaPHUUNIlYu2zPaGpw/JWYXi6ME0xPHGau0BK4BgbDAiziviC3OIqlYwMaWNpLMcj8
         PinLORMtHxHrxKuKYmla0hgrhGbdnyOSdWfnM6ymVjNkbumu2HDpR0saOXbBroyGY4Gg
         Kop8UB1F8FoSzvL1ePt+BVBOXQiZeGDlTQmpfWgAcZ8xd1IXfM1dr4+/bQxOWCqfsTql
         d4mEt2LFwxRoiva8TmTgHfSLsRhkEKjF/ihD2rbx21QP68oHOWDUAoQ65epX6yT1S6Ra
         Z1Sg==
X-Gm-Message-State: AOAM531oWFAPWaWm7DDm2BKbGnBDgLtj2DqQ9ijrWfR9M/VYgvVTwNOu
        Uns1BUd6QHTGM+BrfE4V5pxDpWeU
X-Google-Smtp-Source: ABdhPJzU3b90aYYQmZjbXp6nxucMm4gApi0XOaXCCMONRIczHtQEKs7lnenefjdnIPECNZjPwpVvUg==
X-Received: by 2002:a17:906:c155:: with SMTP id dp21mr3645756ejc.92.1593197751899;
        Fri, 26 Jun 2020 11:55:51 -0700 (PDT)
Received: from [10.67.50.75] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id oz7sm6490168ejb.96.2020.06.26.11.55.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Jun 2020 11:55:51 -0700 (PDT)
Subject: Re: [EXT] Re: [PATCH net-next v3 2/7] dt-bindings: net: add backplane
 dt bindings
To:     Florinel Iordache <florinel.iordache@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>
Cc:     "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "shawnguo@kernel.org" <shawnguo@kernel.org>,
        Leo Li <leoyang.li@nxp.com>,
        "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1592832924-31733-1-git-send-email-florinel.iordache@nxp.com>
 <1592832924-31733-3-git-send-email-florinel.iordache@nxp.com>
 <7035531d-3e74-6fd4-0df6-fa730998b065@gmail.com>
 <AM0PR04MB5443F5EDD551C7613AF21EF4FB950@AM0PR04MB5443.eurprd04.prod.outlook.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; prefer-encrypt=mutual; keydata=
 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
 G10n8gCguORqNGMsVRxrlLs7/himep7MrCc=
Message-ID: <b62166dc-c38c-3287-f469-342ca81b4f6f@gmail.com>
Date:   Fri, 26 Jun 2020 11:55:47 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <AM0PR04MB5443F5EDD551C7613AF21EF4FB950@AM0PR04MB5443.eurprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/24/20 5:55 AM, Florinel Iordache wrote:
>> -----Original Message-----
>> From: Florian Fainelli <f.fainelli@gmail.com>
>> Sent: Tuesday, June 23, 2020 1:21 AM
>> To: Florinel Iordache <florinel.iordache@nxp.com>; davem@davemloft.net;
>> netdev@vger.kernel.org; andrew@lunn.ch; hkallweit1@gmail.com;
>> linux@armlinux.org.uk
>> Cc: devicetree@vger.kernel.org; linux-doc@vger.kernel.org;
>> robh+dt@kernel.org; mark.rutland@arm.com; kuba@kernel.org;
>> corbet@lwn.net; shawnguo@kernel.org; Leo Li <leoyang.li@nxp.com>; Madalin
>> Bucur (OSS) <madalin.bucur@oss.nxp.com>; Ioana Ciornei
>> <ioana.ciornei@nxp.com>; linux-kernel@vger.kernel.org
>> Subject: [EXT] Re: [PATCH net-next v3 2/7] dt-bindings: net: add backplane dt
>> bindings
>>
>> Caution: EXT Email
>>
>> On 6/22/20 6:35 AM, Florinel Iordache wrote:
>>> Add ethernet backplane device tree bindings
>>>
>>> Signed-off-by: Florinel Iordache <florinel.iordache@nxp.com>
>>> ---
>>
>> [snip]
>>
>>> +properties:
>>> +  $nodename:
>>> +    pattern: "^serdes(@[a-f0-9]+)?$"
>>> +
>>> +  compatible:
>>> +    oneOf:
>>> +      - const: serdes-10g
>>> +        description: SerDes module type of 10G
>>
>> Since this appears to be memory mapped in your case, it does not sound like
>> "serdes-10g" alone is going to be sufficient, should not we have a SoC specific
>> compatible string if nothing else?
> 
> My intention was to make it generic enough to be used by any SerDes (Serializer/Deserializer) block.
> So I was thinking that specifying serdes as HW block and the type: 10g (or 28g for example) should be enough.
> I could add SoC specific (or family of SoC) to the compatible string
> like for example Freescale/NXP QorIQ Soc: "fsl,ls1046a-serdes-10g" or "fsl,qoriq-serdes-10g"

It does not seem to me that the register interface is going to be
anything but generic, therefore using SoC specific compatible strings
would be a safer and forward looking approach. If a generic/fall back
compatibility string can be added, it can be added later on, that is
much less problematic than the opposite.

> 
>>
>>> +
>>> +  reg:
>>> +    description:
>>> +      Registers memory map offset and size for this serdes module
>>> +
>>> +  reg-names:
>>> +    description:
>>> +      Names of the register map given in "reg" node.
>>
>> You would also need to describe how many of these two properties are
>> expected.
> 
> Only one memory map is required since the memory maps for lanes are individually described
> (as it is documented in serdes-lane.yaml).
> I will specify this.

Then I believe you need to advertise that with maxItems property to
denote how many.

> 
>>
>>> +
>>> +  little-endian:
>>> +    description:
>>> +      Specifies the endianness of serdes module
>>> +      For complete definition see
>>> +      Documentation/devicetree/bindings/common-properties.txt
>>
>> This is redundant with the default binding then, and if it is not already in the
>> common YAML binding, can you please add little-endian and native-endian
>> added there?
> 
> The endianness of the serdes block must be specified as little-endian or big-endian.
> The serdes endianness may be different than the cores endianness.
> This is also the case for QorIQ LS1043/LS1046 platforms with ARM cores which
> are little endian but serdes block is big endian.
> So endianness must be specified in device tree in order for the driver to know how to access it.

I understand that part, my point was more than these properties are
generic properties, therefore it should not be necessary to provide a
description, and their definition belongs in the common properties
binding. If the common binding does not have a definition for those
(that is, in a YAML way), then please add them there.
-- 
Florian
