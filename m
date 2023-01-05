Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AF5A65E9F8
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 12:34:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233291AbjAELd6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 06:33:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233315AbjAELdh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 06:33:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EF5011A27;
        Thu,  5 Jan 2023 03:33:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CC122619C9;
        Thu,  5 Jan 2023 11:33:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE274C433D2;
        Thu,  5 Jan 2023 11:33:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672918414;
        bh=GZ/oxElBbGOcTDLAg4QnaapTHh9nj+beO5PtIB3KxK0=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=uP45hb1MDd2Xiwn2n/0fQ6fDLt1SWtUHLBBCMAAOZIkwhpui/fNQoma//RC5zOh9s
         QPTdx0+TOuRGLI3TgIf2P3m7delgJfMr+hgpKmTDozNMBw005PBU9QNTj1Nnonu/RO
         mqTbUciS8tBHStdLY6MLVfqH3cVX+PeQY/u5pou1Ii8twEET1DdERG8oMlEYPcco7K
         u+Q1gpRriUiKlZipx4CJwNyk2DL/BjQIHf4ffD16LSpjhwgcqDJbjBziFGvJ/uGHYw
         WRYhVkDZ7rcovEAHnR4krtEzibu9JWGwqKnuj22DAuYA2T37CmgACn4EG/BhmJFoHt
         /3HPtklGezGkQ==
Message-ID: <b55dec4b-4fd5-71fa-4073-b5793cafdee7@kernel.org>
Date:   Thu, 5 Jan 2023 13:33:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH v3 1/2] dt-bindings: net: Add ICSSG Ethernet Driver
 bindings
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>, Md Danish Anwar <danishanwar@ti.com>
Cc:     "Andrew F. Davis" <afd@ti.com>, Tero Kristo <t-kristo@ti.com>,
        Suman Anna <s-anna@ti.com>, YueHaibing <yuehaibing@huawei.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>, nm@ti.com,
        ssantosh@kernel.org, srk@ti.com, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
References: <20221223110930.1337536-1-danishanwar@ti.com>
 <20221223110930.1337536-2-danishanwar@ti.com> <Y6W7FNzJEHYt6URg@lunn.ch>
 <620ce8e6-2b40-1322-364a-0099a6e2af26@kernel.org> <Y7Mjx8ZEVEcU2mK8@lunn.ch>
From:   Roger Quadros <rogerq@kernel.org>
In-Reply-To: <Y7Mjx8ZEVEcU2mK8@lunn.ch>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-10.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 02/01/2023 20:34, Andrew Lunn wrote:
> On Mon, Jan 02, 2023 at 03:04:19PM +0200, Roger Quadros wrote:
>>
>>
>> On 23/12/2022 16:28, Andrew Lunn wrote:
>>>> +        ethernet-ports {
>>>> +            #address-cells = <1>;
>>>> +            #size-cells = <0>;
>>>> +            pruss2_emac0: port@0 {
>>>> +                reg = <0>;
>>>> +                phy-handle = <&pruss2_eth0_phy>;
>>>> +                phy-mode = "rgmii-rxid";
>>>
>>> That is unusual. Where are the TX delays coming from?
>>
>> >From the below property
>>
>> +                ti,syscon-rgmii-delay = <&scm_conf 0x4120>;
>>
>> The TX delay can be enabled/disabled from within the ICSSG block.
>>
>> If this property exists and PHY mode is neither PHY_INTERFACE_MODE_RGMII_ID
>> nor PHY_INTERFACE_MODE_RGMII_TXID then the internal delay is enabled.
>>
>> This logic is in prueth_config_rgmiidelay() function in the introduced driver.
> 
> What nearly every other MAC driver does is pass the phy-mode to the
> PHY and lets the PHY add the delays. I would recommend you do that,
> rather than be special and different.


If I remember right we couldn't disable MAC TX delay on some earlier silicon
so had to take this route. I don't remember why we couldn't disable it though.

In more recent Silicon Manuals I do see that MAC TX delay can be enabled/disabled.
If this really is the case then we should change to

 phy-mode = "rgmii-id";

And let PHY handle the TX+RX delays.

Danish,
could you please make the change and test if it works on current silicon?

cheers,
-roger
