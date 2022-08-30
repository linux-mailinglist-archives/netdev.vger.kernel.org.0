Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B12B65A6740
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 17:23:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230435AbiH3PXa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 11:23:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230323AbiH3PX2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 11:23:28 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C39831286E0
        for <netdev@vger.kernel.org>; Tue, 30 Aug 2022 08:23:25 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id e13so13786825wrm.1
        for <netdev@vger.kernel.org>; Tue, 30 Aug 2022 08:23:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=yLvDBHWvpDIDxAvVlBZQf8gRsiHpZNmu2F53o7FHjx8=;
        b=WcBAjT/Fmk/p8NMZFiek7pi28xrSdKWEIsJnw8E6BU/6zrdbZ899MCguFl5DFvowEZ
         bxDj7PH7fs0eZeVFDLQtvY0Mi/DTErk1C92bjg3XhuXUD1L4Djcl8f5I+IpbiKXKJsv9
         7Iy4eOX2cxC6yAG8nDmtCvjEDvlkUptjQ+kHKwtizODeXjFGn3rD2Vk2dvOBX/BBmUwK
         YebTbOvFE7qqAeIF6fi1TnoHAq8JZv3UczRDFOowWKxXOjyFZgZvFcj8xXuBF9we+Gt3
         gNwCJ4fNVYtOn55f8fhJqUO/yFyWHUdbDYOtCXtI8TgLmgIfTUk4bdv/ZPumztnH6obf
         Fctg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=yLvDBHWvpDIDxAvVlBZQf8gRsiHpZNmu2F53o7FHjx8=;
        b=q3sruX4Dg2LUm4MfH7R0lehEFQ1xNNN6sCiRfQTutBO6UVpShl4bz/rlv8XLwIunIm
         WskehSq+jk2cOz6IQuQ4+9XEX1ZSfg3poQVGJCdAnnBKwUzGhcYjJ6Ko8/S9SPw3DdlB
         qysLIDssJGdicFcN70lL8JiOJlSvFpKHq4OHQnNkXLyVHCdoH61wu9Iv6ShPooSzxAE/
         DbvaBvjTy7iCBgBa3co+cMe+9EGiC88ojSqdap9SERvi7ooXoyEnd6XfGK1veP3UYqMu
         dQ46caPA8ItfyOtZlW7AWu3plRLVQ1CGkUob2+GQo07Bp6IYBrEAvWB/2Mpmgn747IuF
         IXRw==
X-Gm-Message-State: ACgBeo02Bv/pLidoemny4RDgK0Uwu3ZJm27TMdN5UCUcP/cAdZvYguHk
        KvMbm5VQdctfuivjAupl9iLi3A==
X-Google-Smtp-Source: AA6agR7eYGv+NukFzkM7WWtG7U1wN/FA5XCAoBqskFXNotnVjkirf60+8Ht+FIoJOGmBrOQfJoF9QQ==
X-Received: by 2002:a05:6000:144:b0:226:da62:6d90 with SMTP id r4-20020a056000014400b00226da626d90mr6202972wrx.609.1661873003800;
        Tue, 30 Aug 2022 08:23:23 -0700 (PDT)
Received: from [192.168.86.238] (cpc90716-aztw32-2-0-cust825.18-1.cable.virginm.net. [86.26.103.58])
        by smtp.googlemail.com with ESMTPSA id l7-20020a05600c088700b003a5260b8392sm12698585wmp.23.2022.08.30.08.23.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Aug 2022 08:23:23 -0700 (PDT)
Message-ID: <f79b7992-2170-bc31-74ca-4767ba870791@linaro.org>
Date:   Tue, 30 Aug 2022 16:23:22 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v1 06/14] nvmem: core: introduce NVMEM layouts
Content-Language: en-US
To:     Michael Walle <michael@walle.cc>
Cc:     Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
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
 <20220825214423.903672-7-michael@walle.cc>
 <e2d91011-583e-a88d-94f9-beb194416326@linaro.org>
 <ae27e9d300a9c9eca4e9ec0c702b5e0a@walle.cc>
 <815f8e22-3a23-ebdb-7476-14682d0b3287@linaro.org>
 <c2e3a05339d54123de539fd124e874bb@walle.cc>
From:   Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
In-Reply-To: <c2e3a05339d54123de539fd124e874bb@walle.cc>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 30/08/2022 16:02, Michael Walle wrote:
> Am 2022-08-30 16:43, schrieb Srinivas Kandagatla:
> 
>>>>> diff --git a/drivers/nvmem/layouts/Makefile 
>>>>> b/drivers/nvmem/layouts/Makefile
>>>>> new file mode 100644
>>>>> index 000000000000..6fdb3c60a4fa
>>>>> --- /dev/null
>>>>> +++ b/drivers/nvmem/layouts/Makefile
>>>>> @@ -0,0 +1,4 @@
>>>>> +# SPDX-License-Identifier: GPL-2.0
>>>>> +#
>>>>> +# Makefile for nvmem layouts.
>>>>> +#
>>>>> diff --git a/include/linux/nvmem-provider.h 
>>>>> b/include/linux/nvmem-provider.h
>>>>> index e710404959e7..323685841e9f 100644
>>>>> --- a/include/linux/nvmem-provider.h
>>>>> +++ b/include/linux/nvmem-provider.h
>>>>> @@ -127,6 +127,28 @@ struct nvmem_cell_table {
>>>>>       struct list_head    node;
>>>>>   };
>>>>>   +/**
>>>>> + * struct nvmem_layout - NVMEM layout definitions
>>>>> + *
>>>>> + * @name:        Layout name.
>>>>> + * @of_match_table:    Open firmware match table.
>>>>> + * @add_cells:        Will be called if a nvmem device is found which
>>>>> + *            has this layout. The function will add layout
>>>>> + *            specific cells with nvmem_add_one_cell().
>>>>> + * @node:        List node.
>>>>> + *
>>>>> + * A nvmem device can hold a well defined structure which can just be
>>>>> + * evaluated during runtime. For example a TLV list, or a list of 
>>>>> "name=val"
>>>>> + * pairs. A nvmem layout can parse the nvmem device and add 
>>>>> appropriate
>>>>> + * cells.
>>>>> + */
>>>>> +struct nvmem_layout {
>>>>> +    const char *name;
>>>>> +    const struct of_device_id *of_match_table;
>>>>
>>>> looking at this, I think its doable to convert the existing
>>>> cell_post_process callback to layouts by adding a layout specific
>>>> callback here.
>>>
>>> can you elaborate on that?
>>
>> If we relax add_cells + add nvmem_unregister_layout() and update
>> struct nvmem_layout to include post_process callback like
>>
>> struct nvmem_layout {
>>     const char *name;
>>     const struct of_device_id *of_match_table;
>>     int (*add_cells)(struct nvmem_device *nvmem, struct nvmem_layout 
>> *layout);
>>     struct list_head node;
>>     /* default callback for every cell */
>>     nvmem_cell_post_process_t post_process;
>> };
>>
>> then we can move imx-ocotp to this layout style without add_cell
>> callback, and finally get rid of cell_process_callback from both
>> nvmem_config and nvmem_device.
>>
>> If layout specific post_process callback is available and cell does
>> not have a callback set then we can can be either updated cell
>> post_process callback with this one or invoke layout specific callback
>> directly.
>>
>> does that make sense?
> 
> Yes I get what you mean. BUT I'm not so sure; it mixes different
> things together. Layouts will add cells, analogue to
> nvmem_add_cells_from_of() or nvmem_add_cells_from_table(). With
> the hook above, the layout mechanism is abused to add post
> processing to cells added by other means.

We are still defining what layout exactly mean w.r.t to nvmem :-)

> 

There are two aspects to this as nvmem core is concerned

1> parse and add cells based on some provider specific algo/stucture.
2> post process cell data before user can see it.

In some cases we need 1 and 2 while in other cases we just need 1 or 2.

Having an unified interface would help with maintenance and removing 
duplication.

> What is then the difference to the driver having that "global"
> post process hook?

w.r.t post processing there should be no difference.

cell can have no post-processing or a default post processing or a 
specific one depending on its configuration.

> 
> The correct place to add the per-cell hook in this case would be
> nvmem_add_cells_from_of().

yes, that is the place where it should go. we have to work on the 
details but if provider is associated with a layout then this should be 
doable.


--srini
> 
> -michael
