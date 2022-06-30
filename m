Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 044FE5621B5
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 20:08:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235796AbiF3SIe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 14:08:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232937AbiF3SId (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 14:08:33 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DFDF2D1EA
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 11:08:32 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id q6so40451556eji.13
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 11:08:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=j9nxxeU6YahBlPI3fltsFIAQYvUShziYDUlxlVJ26QI=;
        b=s7/VHFicVnBs4CDWhCQ0pGpMWLIZSHESOOZqYY9o1QnXFH9b1V7ZMWT6hjoCjkI1qn
         fbchF1I675KOR1DeQOaW3s0GywbT++EH9hk/yr7Fl/gSztFmPYDkOYxT3d2tR8MvXzun
         MMua4OGm6vgAsbx1Yk8ywkMY4CczTbmz6u9aVy+w7lUTRwp7YRblXfuMmSXHkrG7zkQ4
         GCPhPq98aJRwmuUc1RVdJ0TuIIy3F5lLifLhpXtNCAAppn2oCZjuMe4rDvoXzL4KkbXV
         OoUtfsV8les8wEGdBGWXL3kPF+wBgiGrbj5f+sl460jiz29icwR57Iyr6Q/WfRjDP9LY
         kALA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=j9nxxeU6YahBlPI3fltsFIAQYvUShziYDUlxlVJ26QI=;
        b=jHLEi/RFPor9SwGGpn/IA30zGfqH0eFzel0LXpOcA1oGTuD56+J2eFYYWRT+kitq5p
         b18MeB2WjFXFsy545qNAmXR13ww/GO4RB/i0pDuryRcpeQnIcZ1YRe8SoA1OUYFTOCP5
         JzKwSRMv1gVmOnMrwcv6TrsFMl7F2dZ9MV2Y5sPdvbi9yYh+JN+FYjGjPW4As+vUQLxr
         MDnWzL1/bHckNQVyZqSp+2D9LRde+T1EdWY+4idqwv3ZpyV8k6+9sfXNffrs+Q+QXAvF
         /rBWm4SKh95tEeeE039QmIiyYQ4T04dBm9NOTVjtJdJ4zPGd7Fb/eLpxbOU11Ii2EGvd
         Pnxg==
X-Gm-Message-State: AJIora/K5oftzZ8iFkxwzf7kVKzerCGGCX1+YuqSxbwAGV0dmOxyaqUe
        ibPQsXMpcYirS4982dOQx8PA0A==
X-Google-Smtp-Source: AGRyM1sJdaf8gq6PHdDzpHLzfj8N8B+yZ1A+B1WdVVsBABfBd2PsxvWUCMFM/rwuYdwKoPz6aeHo7g==
X-Received: by 2002:a17:906:2001:b0:6f3:bd7f:d878 with SMTP id 1-20020a170906200100b006f3bd7fd878mr9869519ejo.133.1656612510651;
        Thu, 30 Jun 2022 11:08:30 -0700 (PDT)
Received: from [192.168.0.190] (xdsl-188-155-176-92.adslplus.ch. [188.155.176.92])
        by smtp.gmail.com with ESMTPSA id a18-20020a170906671200b00718e4e64b7bsm9382773ejp.79.2022.06.30.11.08.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Jun 2022 11:08:29 -0700 (PDT)
Message-ID: <db9d9455-37af-1616-8f7f-3d752e7930f1@linaro.org>
Date:   Thu, 30 Jun 2022 20:08:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH net-next v2 01/35] dt-bindings: phy: Add QorIQ SerDes
 binding
Content-Language: en-US
To:     Sean Anderson <sean.anderson@seco.com>,
        Rob Herring <robh@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>, netdev@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-arm-kernel@lists.infradead.org,
        Eric Dumazet <edumazet@google.com>,
        linux-kernel@vger.kernel.org,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Vinod Koul <vkoul@kernel.org>, devicetree@vger.kernel.org,
        linux-phy@lists.infradead.org
References: <20220628221404.1444200-1-sean.anderson@seco.com>
 <20220628221404.1444200-2-sean.anderson@seco.com>
 <20220630172713.GA2921749-robh@kernel.org>
 <7fe84856-7115-b0f4-b0e1-0b47acbddb7a@seco.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <7fe84856-7115-b0f4-b0e1-0b47acbddb7a@seco.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 30/06/2022 20:01, Sean Anderson wrote:
> Hi Rob,
> 
> On 6/30/22 1:27 PM, Rob Herring wrote:
>> On Tue, Jun 28, 2022 at 06:13:30PM -0400, Sean Anderson wrote:
>>> This adds a binding for the SerDes module found on QorIQ processors. The
>>> phy reference has two cells, one for the first lane and one for the
>>> last. This should allow for good support of multi-lane protocols when
>>> (if) they are added. There is no protocol option, because the driver is
>>> designed to be able to completely reconfigure lanes at runtime.
>>> Generally, the phy consumer can select the appropriate protocol using
>>> set_mode. For the most part there is only one protocol controller
>>> (consumer) per lane/protocol combination. The exception to this is the
>>> B4860 processor, which has some lanes which can be connected to
>>> multiple MACs. For that processor, I anticipate the easiest way to
>>> resolve this will be to add an additional cell with a "protocol
>>> controller instance" property.
>>>
>>> Each serdes has a unique set of supported protocols (and lanes). The
>>> support matrix is stored in the driver and is selected based on the
>>> compatible string. It is anticipated that a new compatible string will
>>> need to be added for each serdes on each SoC that drivers support is
>>> added for. There is no "generic" compatible string for this reason.
>>>
>>> There are two PLLs, each of which can be used as the master clock for
>>> each lane. Each PLL has its own reference. For the moment they are
>>> required, because it simplifies the driver implementation. Absent
>>> reference clocks can be modeled by a fixed-clock with a rate of 0.
>>>
>>> Signed-off-by: Sean Anderson <sean.anderson@seco.com>
>>> ---
>>>
>>> Changes in v2:
>>> - Add #clock-cells. This will allow using assigned-clocks* to configure
>>>   the PLLs.
>>> - Allow a value of 1 for phy-cells. This allows for compatibility with
>>>   the similar (but according to Ioana Ciornei different enough) lynx-28g
>>>   binding.
>>> - Document phy cells in the description
>>> - Document the structure of the compatible strings
>>> - Fix example binding having too many cells in regs
>>> - Move compatible first
>>> - Refer to the device in the documentation, rather than the binding
>>> - Remove minItems
>>> - Rename to fsl,lynx-10g.yaml
>>> - Use list for clock-names
>>>
>>>  .../devicetree/bindings/phy/fsl,lynx-10g.yaml | 93 +++++++++++++++++++
>>>  1 file changed, 93 insertions(+)
>>>  create mode 100644 Documentation/devicetree/bindings/phy/fsl,lynx-10g.yaml
>>>
>>> diff --git a/Documentation/devicetree/bindings/phy/fsl,lynx-10g.yaml b/Documentation/devicetree/bindings/phy/fsl,lynx-10g.yaml
>>> new file mode 100644
>>> index 000000000000..b5a6f631df9f
>>> --- /dev/null
>>> +++ b/Documentation/devicetree/bindings/phy/fsl,lynx-10g.yaml
>>> @@ -0,0 +1,93 @@
>>> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
>>> +%YAML 1.2
>>> +---
>>> +$id: http://devicetree.org/schemas/phy/fsl,lynx-10g.yaml#
>>> +$schema: http://devicetree.org/meta-schemas/core.yaml#
>>> +
>>> +title: NXP Lynx 10G SerDes
>>> +
>>> +maintainers:
>>> +  - Sean Anderson <sean.anderson@seco.com>
>>> +
>>> +description: |
>>> +  These Lynx "SerDes" devices are found in NXP's QorIQ line of processors. The
>>> +  SerDes provides up to eight lanes. Each lane may be configured individually,
>>> +  or may be combined with adjacent lanes for a multi-lane protocol. The SerDes
>>> +  supports a variety of protocols, including up to 10G Ethernet, PCIe, SATA, and
>>> +  others. The specific protocols supported for each lane depend on the
>>> +  particular SoC.
>>> +
>>> +properties:
>>> +  compatible:
>>> +    description: |
>>> +      Each compatible is of the form "fsl,<soc-name>-serdes-<instance>".
>>> +      Although many registers are compatible between different SoCs, the
>>> +      supported protocols and lane assignments tend to be unique to each SerDes.
>>> +      Additionally, the method of activating protocols may also be unique.
>>
>> We typically have properties for handling these variables. Numbering 
>> instances is something we avoid.
> 
> On v1, Krzysztof said that this was a better route...

I commented about "-1" and "-2" saying you have to make them properties.
You disagreed and with long messages were convincing me that "-1" and
"-2" is the only reasonable approach. I never said it is a better route.
I explicitly asked in several places for defining these as properties,
not as compatibles.

You are twisting the entire discussion now.

Best regards,
Krzysztof
