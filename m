Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 118EC5F8C1D
	for <lists+netdev@lfdr.de>; Sun,  9 Oct 2022 17:49:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230193AbiJIPtk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Oct 2022 11:49:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230162AbiJIPth (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Oct 2022 11:49:37 -0400
Received: from mail-qt1-x829.google.com (mail-qt1-x829.google.com [IPv6:2607:f8b0:4864:20::829])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BC0A25C6D
        for <netdev@vger.kernel.org>; Sun,  9 Oct 2022 08:49:32 -0700 (PDT)
Received: by mail-qt1-x829.google.com with SMTP id g11so723742qts.1
        for <netdev@vger.kernel.org>; Sun, 09 Oct 2022 08:49:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rwytabPsxgVPIzcvGguH5woRpw9xe0j0YJV3+YNDSDw=;
        b=EaowqX7osedTxub6s6EJX8k+vS/EuzBM0LItM23pddO/E6iIyxoo85p8iKNYXlOIs9
         SzCeRyi++STB+ulphqhKSLxpEMNpfQ2mf9ARQhEeCt83pxL0ALfM3OmnWmL1lWe2Nd58
         BIXsPXQ3Og9gHBnzWPOkbh+x8rU4k0X0qdYZa6De+V5BtODu7DnBCXAXaKw+4/BfvV1I
         AX+9+cm/YUpv+oBxUh1CAVdd2QegZdeSCg65pHt6xcRunUPhgpMeWWneRtslsJUZPwU9
         9sgayG1o+Ymgi8iBtP2dcsr/Y9LJNzkUHGX4oRRi8s3AN+59rtpaRiem0jdOViPHyuc9
         DJ9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rwytabPsxgVPIzcvGguH5woRpw9xe0j0YJV3+YNDSDw=;
        b=rNZ6mu4mYVZokmeY9+XemcsrhGnoyNNsOVMboPVmpQzkvhKh+KxydPJ1qND3vmOJsw
         YaaBqdDiQ4ekvMIx8/psGVKhojwLy/aXv9FIMMqE9RPRgAn0Xqkc32CbvSzq+4E08O8H
         JzyKDLqD6hnxB0paJwtPvykQHGixZhQHsOoQEITNGo3Xc0dG7WZ/p8lsZysx+p27WcRk
         pF9ZlwLxC5QaDOJHLkeTpgxUP4TavQ/b7eHE+pxvkZvKu5qyj8k6dUoLRAzVofr1tbg4
         M1ksw2MEmx8+bBBonbP3RWWlIKYIoDUt8Jko8FSecELFeUj+/jm5cdtwaOD2WQssXwtS
         RK4g==
X-Gm-Message-State: ACrzQf0u3mpFWEm6k/pi42b83gL3USt2kuX+GjXxLKGgj3yob8I9F+D1
        W8sGHD8mnY3uiCAr+25qsF2l4w==
X-Google-Smtp-Source: AMsMyM65LNhX38XlWxvXWczbuggvPvUkQm/xzkjGyT8G2Z9me7mxwhPFX8rDh2cZcrdOiPNNTd/2KQ==
X-Received: by 2002:a05:622a:1207:b0:39a:76d4:74b1 with SMTP id y7-20020a05622a120700b0039a76d474b1mr279848qtx.244.1665330571782;
        Sun, 09 Oct 2022 08:49:31 -0700 (PDT)
Received: from [192.168.1.57] (cpe-72-225-192-120.nyc.res.rr.com. [72.225.192.120])
        by smtp.gmail.com with ESMTPSA id u10-20020a05620a430a00b006e702033b15sm7711740qko.66.2022.10.09.08.49.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 09 Oct 2022 08:49:31 -0700 (PDT)
Message-ID: <ce29fcfc-b73c-9ef3-3e61-29b7c0c06a99@linaro.org>
Date:   Sun, 9 Oct 2022 17:49:29 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: [PATCH v3 net-next 12/14] dt-bindings: net: dsa: ocelot: add
 ocelot-ext documentation
Content-Language: en-US
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Colin Foster <colin.foster@in-advantage.com>,
        linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Lee Jones <lee@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
References: <20220926002928.2744638-1-colin.foster@in-advantage.com>
 <20220926002928.2744638-13-colin.foster@in-advantage.com>
 <ec63b5aa-3dec-3c27-e987-25e36b1632ba@linaro.org>
 <20221004121517.4j5637hnioepsxgd@skbuf>
 <6444e5d1-0fc9-03e2-9b2a-ec19fa1e7757@linaro.org>
 <20221004160135.lqugs6cf5b7fwkxq@skbuf>
 <cae8e149-ef1e-66c6-20f5-067e3fd8c586@linaro.org>
 <20221007231009.qgcirfezgib5vu6y@skbuf>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20221007231009.qgcirfezgib5vu6y@skbuf>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08/10/2022 01:10, Vladimir Oltean wrote:
> On Wed, Oct 05, 2022 at 10:09:06AM +0200, Krzysztof Kozlowski wrote:
>>> The /spi/soc@0 node actually has a compatible of "mscc,vsc7512" which
>>> Colin did not show in the example (it is not "simple-bus"). It is covered
>>> by Documentation/devicetree/bindings/mfd/mscc,ocelot.yaml. Still waiting
>>> for a better suggestion for how to name the mfd container node.
>>
>> Then still the /spi node does not seem related. If I understand
>> correctly, your device described in this bindings is a child of soc@0.
>> Sounds fine. How that soc@0 is connected to the parent - via SPI or
>> whatever - is not related to this binding, is it? It is related to the
>> soc binding, but not here.
> 
> It's an example, it's meant to be informative. It is the first DSA
> driver of its kind. When everybody else ATM puts the ethernet-switch node
> under the &spi controller node, this puts it under &spi/soc@<chip-select>/,
> for reasons that have to do with scalability. If the examples aren't a
> good place to make this more obvious, I don't know why we don't just
> tell people to RTFD.

It still does not help me to understand why do you need that &spi. The
device is part of the soc@CS and that's it. Where the soc@ is located,
does not matter for this device, right? The example shows usage of this
device, not of the soc@CS. Bindings for soc@CS should show how to use it
inside spi etc.


> 
>>> Unrelated to your "existing soc example" (the VSC9953), but relevant and
>>> you may want to share your opinion on this:
>>>
>>> The same hardware present in the VSC7514 SoC can also be driven by an
>>> integrated MIPS processor, and in that case, it is indeed expected that
>>> the same dt-bindings cover both the /soc and the /spi/soc@0/ relative
>>> positioning of their OF node. This is true for simpler peripherals like
>>> "mscc,ocelot-miim", "mscc,ocelot-pinctrl", "mscc,ocelot-sgpio". However
>>> it is not true for the main switching IP of the SoC itself.
>>>
>>> When driven by a switchdev driver, by the internal MIPS processor (the
>>> DMA engine is what is used for packet I/O), the switching IP follows the
>>> Documentation/devicetree/bindings/net/mscc,vsc7514-switch.yaml binding
>>> document.
>>>
>>> When driven by a DSA driver (external processor, host frames are
>>> redirected through an Ethernet port instead of DMA controller),
>>> the switching IP follows the Documentation/devicetree/bindings/net/dsa/mscc,ocelot.yaml
>>> document.
>>>
>>> The switching IP is special in this regard because the hardware is not
>>> used in the same way. The DSA dt-binding also needs the 'ethernet'
>>> phandle to be present in a port node. The different placement of the
>>> bindings according to the use case of the hardware is a bit awkward, but
>>> is a direct consequence of the separation between DSA and pure switchdev
>>> drivers that has existed thus far (and the fact that DSA has its own
>>> folder in the dt-bindings, with common properties in dsa.yaml and
>>> dsa-port.yaml etc). It is relatively uncommon for a switching IP to have
>>> provisioning to be used in both modes, and for Linux to support both
>>> modes (using different drivers), yet this is what we have here.
>>
>> Is there a question here to me? What shall I do with this paragraph? You
>> know, I do not have a problem of lack of material to read...
> 
> For mscc,vsc7514-switch we have a switchdev driver. For mscc,vsc7512-switch,
> Colin is working on a DSA driver. Their dt-bindings currently live in
> different folders. The mscc,vsc7514-switch can also be used together
> with a DSA driver, and support for that will inevitably be added. When
> it will, how and where do you recommend the dt-bindings should be added?

The bindings should in general describe the hardware, not the Linux
drivers. I assume there is only one VSC7514 device, so there should be
only one binding file. If bindings are correct, then this one hardware
description can be used by two different driver implementations. That's
said, for practical reasons entirely different implementations might
require different bindings, but this should be rather exception
requiring serious reasons.

> In net/dsa/mscc,ocelot.yaml, together with the other switches used in
> DSA mode, or in net/mscc,vsc7514-switch.yaml, because its compatible
> string already exists there? We can't have a compatible string present
> in multiple schemas, right?

You can, if bindings are the same... but then why would you have the
same bindings in two files? Which leads to solution: have only one
binding file.

If bindings are entirely different (and not compatible to each other),
you cannot have same compatible in two different places... and this
leads to paragraph before - there should be only one binding, thus only
one place to document the compatible.

> 
> This matters because it has implications upon what Colin should do with
> the mscc,vsc7512-switch. If your answer to my question is "add $ref: dsa.yaml#
> to net/mscc,vsc7514-switch.yaml", then I don't see why we wouldn't do
> that now, and wait until the vsc7514 to make that move anyway.

Best regards,
Krzysztof

