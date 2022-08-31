Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2CD15A7A96
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 11:51:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230144AbiHaJvT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 05:51:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbiHaJvR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 05:51:17 -0400
Received: from mail.3ffe.de (0001.3ffe.de [159.69.201.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D85BCA0311;
        Wed, 31 Aug 2022 02:51:15 -0700 (PDT)
Received: from 3ffe.de (0001.3ffe.de [IPv6:2a01:4f8:c0c:9d57::1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.3ffe.de (Postfix) with ESMTPSA id 95E94380;
        Wed, 31 Aug 2022 11:51:13 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2022082101;
        t=1661939473;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WLs6Onq3yh9Op5LQpak2LFOaNZmEuURyI/Mr9UssDGM=;
        b=pzSJm8uj7k/uDv24llR5/V99GkQF/kfK5TdL8JcOrWl/AhMpxLuc76fCbi45d1NgJJu97Q
        Xrf49LxwmSS+VNXizVhFJeZBc5zzihSfK67AIXTJc3qzjeKLs9z19rRDgwUkkFTjE2HWV8
        qsb/xVGgAfBbvUNFV8hXJfpzzNOXKUePz5DedALi9WVd0nheojAEhcaCfqHLmrti9Vk4ia
        ocLIfVA6aM7+lRfJV/Mk6IoJSbelvbrsGIgannZQgPpaEv4dExdFjnJTrGl2VW6D3Qhfxy
        H0L2oXQavQCwT+xAqzCrZcIA7DNyY22IAO4twrvDUqGZbcIJPfO64hMMC3glLA==
MIME-Version: 1.0
Date:   Wed, 31 Aug 2022 11:51:13 +0200
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
In-Reply-To: <4bf16e18-1591-8bc9-7c46-649391de3761@linaro.org>
References: <20220825214423.903672-1-michael@walle.cc>
 <20220825214423.903672-10-michael@walle.cc>
 <b85276ee-3e19-3adb-8077-c1e564e02eb3@linaro.org>
 <ddaf3328bc7d88c47517285a3773470f@walle.cc>
 <4bf16e18-1591-8bc9-7c46-649391de3761@linaro.org>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <1b06716690b0070c0c2b0985577763e3@walle.cc>
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

Am 2022-08-31 11:24, schrieb Krzysztof Kozlowski:
> On 31/08/2022 11:17, Michael Walle wrote:

>> First thing, this binding isn't like the usual ones, so it might be
>> totally wrong.
>> 
>> What I'd like to achieve here is the following:
>> 
>> We have the nvmem-consumer dt binding where you can reference a
>> nvmem cell in a consumer node. Example:
>>    nvmem-cells = <&base_mac_address 5>;
>>    nvmem-cell-names = "mac-address";
>> 
>> On the other end of the link we have the nvmem-provider. The dt
>> bindings works well if that one has individual cell nodes, like
>> it is described in the nvmem.yaml binding. I.e. you can give the
>> cell a label and make a reference to it in the consumer just like
>> in the example above.
> 
> You can also achieve it with phandle argument to the nvmwm controller,
> right? Just like most of providers are doing (clocks, resets). Having
> fake (empty) nodes just for that seems like overkill.

You mean like
  nvmem-cells = <&nvmem_device SERIAL_NUMBER>;

I'm not sure about the implications for now, because one is
referencing the device and not individal cells. Putting that
aside for now, there seems to be a problem with the index for
the base mac address: You will have different number of arguments
for the phandle. That doesn't work, right?

nvmem-cells = <&nvmem_device SERIAL_NUMBER>;
nvmem-cells = <&nvmem_device BASE_MAC_ADDRESS 1>;

>> Now comes the catch: what if there is no actual description of the
>> cell in the device tree, but is is generated during runtime. How
>> can I get a label to it.
> 
> Same as clocks, resets, power-domains and everyone else.

See
https://git.kernel.org/torvalds/c/084973e944bec21804f8afb0515b25434438699a

And I guess this discussion is relevant here:
https://lore.kernel.org/linux-devicetree/20220124160300.25131-1-zajec5@gmail.com/

>> Therefore, in this case, there is just
>> an empty node and the driver will associate it with the cell
>> created during runtime (see patch 10). It is not expected, that
>> is has any properties.
> 
> It cannot be even referenced as it does not have #cells property...

You mean "#nvmem-cell-cells"? See patch #2. None of the nvmem
cells had such a property for now.

>>>> +
>>>> +  base-mac-address:
>>> 
>>> Fields should be rather described here, not in top-level description.
>>> 
>>>> +    type: object
>>> 
>>> On this level:
>>>     additionalProperties: false
>>> 
>>>> +
>>>> +    properties:
>>>> +      "#nvmem-cell-cells":
>>>> +        const: 1
>>>> +
>>> 
>>> I also wonder why you do not have unit addresses. What if you want to
>>> have two base MAC addresses?
>> 
>> That would describe an offset within the nvmem device. But the offset
>> might not be constant, depending on the content. My understanding
>> so far was that in that case, you use the "-N" suffix.
>> 
>> base-mac-address-1
>> base-mac-address-2
>> 
>> (or maybe completely different names).
> 
> You do not allow "base-mac-address-1". Your binding explicitly accepts
> only "base-mac-address".

Because the binding matches the driver, which matches the driver
which matches the VPD data and there is only one base mac address.
Thus, no need for different ones.

-michael
