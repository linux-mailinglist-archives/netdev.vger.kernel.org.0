Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B8C25A8143
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 17:29:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231777AbiHaP3a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 11:29:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231776AbiHaP32 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 11:29:28 -0400
Received: from mail.3ffe.de (0001.3ffe.de [159.69.201.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3915D99D9;
        Wed, 31 Aug 2022 08:29:24 -0700 (PDT)
Received: from 3ffe.de (0001.3ffe.de [IPv6:2a01:4f8:c0c:9d57::1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.3ffe.de (Postfix) with ESMTPSA id 0468D380;
        Wed, 31 Aug 2022 17:29:22 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2022082101;
        t=1661959762;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gSbky8Lam7huFBL5HxqWMBd+/fwVdIExZD6UKAZ75EU=;
        b=rjN/z49Rv8Kd5VtxGT13sCMwk1VJRviaTSI7hu33m88PzUxo/Q2A8KzExUXhrUVHGhA0C1
        8z9Jc7GWtf3I6tNenf99UVdYYT6SVCyaieJ46RjxQx7rCSsGToUtv+5BHG3r6utGme+DCl
        dNm0eoP092aq1KC36Ubln4XMBufObhuDaj6srJVTIyKuOmSZ1lCmJwg5VRHFSzdLM1Hao5
        SMXBdZiOwx48BxI5Rk0GSBn/C309h3RA9ZIP/Scuc0M2t3IdJCYi0GWaCesy8U8wuT7cFn
        1Vr7Gs4JWo7/nJtL+pLDYJFqZtsJVrB5di9J2zcDQwQZKnpaOPSESunBcAyh3w==
MIME-Version: 1.0
Date:   Wed, 31 Aug 2022 17:29:21 +0200
From:   Michael Walle <michael@walle.cc>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Shawn Guo <shawnguo@kernel.org>, Li Yang <leoyang.li@nxp.com>,
        =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <rafal@milecki.pl>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Frank Rowand <frowand.list@gmail.com>,
        linux-mtd@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        netdev@vger.kernel.org, Ahmad Fatoum <a.fatoum@pengutronix.de>
Subject: Re: [PATCH v1 09/14] dt-bindings: nvmem: add YAML schema for the sl28
 vpd layout
In-Reply-To: <66076594-6745-e2d9-afff-03b9266f31bd@linaro.org>
References: <20220825214423.903672-1-michael@walle.cc>
 <20220825214423.903672-10-michael@walle.cc>
 <b85276ee-3e19-3adb-8077-c1e564e02eb3@linaro.org>
 <ddaf3328bc7d88c47517285a3773470f@walle.cc>
 <4bf16e18-1591-8bc9-7c46-649391de3761@linaro.org>
 <1b06716690b0070c0c2b0985577763e3@walle.cc>
 <66076594-6745-e2d9-afff-03b9266f31bd@linaro.org>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <aeb3e08be6f134d3e42256d59bc56110@walle.cc>
X-Sender: michael@walle.cc
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 2022-08-31 15:07, schrieb Krzysztof Kozlowski:
> On 31/08/2022 12:51, Michael Walle wrote:
>> Am 2022-08-31 11:24, schrieb Krzysztof Kozlowski:
>>> On 31/08/2022 11:17, Michael Walle wrote:
>> 
>>>> First thing, this binding isn't like the usual ones, so it might be
>>>> totally wrong.
>>>> 
>>>> What I'd like to achieve here is the following:
>>>> 
>>>> We have the nvmem-consumer dt binding where you can reference a
>>>> nvmem cell in a consumer node. Example:
>>>>    nvmem-cells = <&base_mac_address 5>;
>>>>    nvmem-cell-names = "mac-address";
>>>> 
>>>> On the other end of the link we have the nvmem-provider. The dt
>>>> bindings works well if that one has individual cell nodes, like
>>>> it is described in the nvmem.yaml binding. I.e. you can give the
>>>> cell a label and make a reference to it in the consumer just like
>>>> in the example above.
>>> 
>>> You can also achieve it with phandle argument to the nvmwm 
>>> controller,
>>> right? Just like most of providers are doing (clocks, resets). Having
>>> fake (empty) nodes just for that seems like overkill.
>> 
>> You mean like
>>   nvmem-cells = <&nvmem_device SERIAL_NUMBER>;
> 
> Yes.
> 
>> 
>> I'm not sure about the implications for now, because one is
>> referencing the device and not individal cells. Putting that
>> aside for now, there seems to be a problem with the index for
>> the base mac address: You will have different number of arguments
>> for the phandle. That doesn't work, right?
>> 
>> nvmem-cells = <&nvmem_device SERIAL_NUMBER>;
>> nvmem-cells = <&nvmem_device BASE_MAC_ADDRESS 1>;
> 
> It could work, but looks poor, however it could be still nicely 
> extended
> with new defines and renames later:
> 
> Once:
> nvmem-cells = <&nvmem_device BASE_MAC_ADDRESS>;
> 
> Later renamed to (with some ABI impact, but in theory names are not 
> part
> of ABI, but numbers are):
> nvmem-cells = <&nvmem_device BASE_MAC_ADDRESS_1>;
> nvmem-cells = <&nvmem_device BASE_MAC_ADDRESS_2>;

Ah I think I didn't express correctly what I want to achieve:

nvmem-cells = <&nvmem_device BASE_MAC_ADDRESS 1>;

means "take base mac address and add one to it". the first
argument is treated as the offset. i.e.
   nvmem-cells = <&nvmem_device BASE_MAC_ADDRESS 5>;
would be "base_mac + 5". It is not another base mac address.

whereas, the serial number doesn't take an argument.

I think it could be achieved with some preprocessor magic
like:
#define SL28VPD_SERIAL_NUMBER   (0 << 8)
#define SL28VPD_MAC_ADDRESS(x)  (1 << 8) + (x & 0xff)
#define SL28VPD_ANOTHER_THING   (2 << 8)

I'm not sure if that is any better.

Also the whole binding around nvmem is that it references the cells,
not the device. So if you insist on using the phandle to the
nvmem device, I'll really have to check if that is something which
could be done. I.e. have a look at
   
https://elixir.bootlin.com/linux/latest/source/drivers/nvmem/core.c#L1242

It assumes the reference phandle points to a cell and fetches
the parent to get the nvmem device. We could try to get a device
by the current handle and if that succeeds use that one. But I
*think* it doesn't work with the EPROBE_DEFERRED. I.e. the device
might not be there, because it wasn't probed yet.

> (or even skip renaming and just add suffix _2)
> 
> You cannot rename device nodes, without deprecating them.
> 
>> 
>>>> Now comes the catch: what if there is no actual description of the
>>>> cell in the device tree, but is is generated during runtime. How
>>>> can I get a label to it.
>>> 
>>> Same as clocks, resets, power-domains and everyone else.
>> 
>> See
>> https://git.kernel.org/torvalds/c/084973e944bec21804f8afb0515b25434438699a
>> 
>> And I guess this discussion is relevant here:
>> https://lore.kernel.org/linux-devicetree/20220124160300.25131-1-zajec5@gmail.com/
> 
> Eh, ok, I jumped in the middle of something and seems Rob was fine with
> these empty nodes. Looks weird and overkill too me (imagine defining 
> 500
> clocks in clock-controller like that), but I am here still learning. :)
> 
> I guess it makes sense for the cases when OTP/nvmem cells are not
> controller specific, not fixed for given OTP controller but rather 
> board
> specific and having defined them in header would not make sense.
> 
> But then if they are strictly/statically defined as children of a
> device, means they are fixed for given OTP and effort is the same as
> having them in header...
> 
>>>> Therefore, in this case, there is just
>>>> an empty node and the driver will associate it with the cell
>>>> created during runtime (see patch 10). It is not expected, that
>>>> is has any properties.
>>> 
>>> It cannot be even referenced as it does not have #cells property...
>> 
>> You mean "#nvmem-cell-cells"? See patch #2. None of the nvmem
>> cells had such a property for now.
> 
> Oh, so so how do you reference them? Users of this seems to be missing,
> so I am guessing that directly via phandle to label and nvmem maps them
>  with nvmem_find_cell_of_node()?

Mh? there are plenty of users which references a nvmem cell. E.g.
https://elixir.bootlin.com/linux/v5.19.5/source/arch/arm64/boot/dts/freescale/imx8mm.dtsi#L76
https://elixir.bootlin.com/linux/v5.19.5/source/arch/arm64/boot/dts/freescale/imx8mm.dtsi#L1080

The entry point for the "fetch mac address" is here:
https://elixir.bootlin.com/linux/v5.19.5/source/net/ethernet/eth.c#L550

And the relevant functions is:
https://elixir.bootlin.com/linux/v5.19.5/source/drivers/nvmem/core.c#L1226
which uses of_parse_phandle(), which don't need the "#-cells" property, 
but
is limited to no arguments. Thus the new function in patch #2.

>>>>>> +
>>>>>> +  base-mac-address:
>>>>> 
>>>>> Fields should be rather described here, not in top-level 
>>>>> description.
>>>>> 
>>>>>> +    type: object
>>>>> 
>>>>> On this level:
>>>>>     additionalProperties: false
>>>>> 
>>>>>> +
>>>>>> +    properties:
>>>>>> +      "#nvmem-cell-cells":
>>>>>> +        const: 1
>>>>>> +
>>>>> 
>>>>> I also wonder why you do not have unit addresses. What if you want 
>>>>> to
>>>>> have two base MAC addresses?
>>>> 
>>>> That would describe an offset within the nvmem device. But the 
>>>> offset
>>>> might not be constant, depending on the content. My understanding
>>>> so far was that in that case, you use the "-N" suffix.
>>>> 
>>>> base-mac-address-1
>>>> base-mac-address-2
>>>> 
>>>> (or maybe completely different names).
>>> 
>>> You do not allow "base-mac-address-1". Your binding explicitly 
>>> accepts
>>> only "base-mac-address".
>> 
>> Because the binding matches the driver, which matches the driver
>> which matches the VPD data and there is only one base mac address.
>> Thus, no need for different ones.
> 
> True, but it is also not extensible, so you have to be sure you covered
> 100% of this device. And then if you have a new, slightly different
> device, you need entirely new schema, because this one is not reusable
> at all.
> 
> It's ok, it just has some drawbacks/limitations.

But isn't that the whole thing around the specific compatible?
And you can still add subnodes if there is a new version of
the vpd. The driver will figure that out and add the cells.

-michael
