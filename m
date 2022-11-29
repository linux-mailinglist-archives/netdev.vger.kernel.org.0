Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73F3963BB28
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 09:02:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229780AbiK2ICJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 03:02:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbiK2IBt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 03:01:49 -0500
Received: from sender4-op-o14.zoho.com (sender4-op-o14.zoho.com [136.143.188.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12ED01DF1E;
        Tue, 29 Nov 2022 00:01:47 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1669708863; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=Mt8zflQluXrktvTMy1+7/wqUymDJuNvxcCt9uUvUKw10sGTDK0MmA+82aNr+WwHy9LSPljlTOlsgEk2qQ+EFoOjz+teCuYjgTlWnrXhLgNnE8tc4Ud3W0t3AncJ7vXMDugqp76mqGhM2nALe85m0kzUnLVwq/PXuz8TkjBabTtQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1669708863; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=SFqgWmLTPu6Efm5uqI8QHWhAPlyBeMn1zR3+/c+MyV4=; 
        b=XrJLcU4oGZ6bewSlAoGFPefar0lVihXpG2DX7/j5p01eou8CQKfswf1NEdKjTW33pEsGgoBnOvPF1JHhQyILjBt9OXmPxSquYOZ1IP3sOuLQzdbv22MSDzh9ZRPSZDdndb8TawlE4FdHYC54PhKac4RuD6J1t+Fne3mLQOnEN/w=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1669708863;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
        bh=SFqgWmLTPu6Efm5uqI8QHWhAPlyBeMn1zR3+/c+MyV4=;
        b=NzMQ77o6X9I3VrDmPEHUQN1icfGztgC2EGc0z02LnLq1jMb3ZETBFPplSN2gf4gy
        SoLMOp5SVhwl/Ioye3A0wg2ZZtIwr++hN1PXGbga2DP1ttKOv/OC9+9KCKhrBTR8ucQ
        zyYoL7Sc7+oh6Um8H7311lXEphsGe+F/tIg5zvrU=
Received: from [10.10.10.3] (85.117.236.245 [85.117.236.245]) by mx.zohomail.com
        with SMTPS id 1669708862210987.5702214730692; Tue, 29 Nov 2022 00:01:02 -0800 (PST)
Message-ID: <25533005-60bf-a9bb-d6a0-d14e1804291a@arinc9.com>
Date:   Tue, 29 Nov 2022 11:00:53 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH v3 net-next 06/10] dt-bindings: net: dsa: mediatek,mt7530:
 fix port description location
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     linux-renesas-soc@vger.kernel.org,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        John Crispin <john@phrozen.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Marek Vasut <marex@denx.de>,
        Sean Wang <sean.wang@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>,
        =?UTF-8?Q?Alvin_=c5=a0ipraga?= <alsi@bang-olufsen.dk>,
        Linus Walleij <linus.walleij@linaro.org>,
        UNGLinuxDriver@microchip.com,
        Woojung Huh <woojung.huh@microchip.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        George McCollister <george.mccollister@gmail.com>,
        Rob Herring <robh@kernel.org>
References: <20221127224734.885526-1-colin.foster@in-advantage.com>
 <20221127224734.885526-7-colin.foster@in-advantage.com>
 <08784493-7e85-9224-acfa-9a87cbd325e7@arinc9.com> <Y4WnjiE2IxDgi5mc@euler>
Content-Language: en-US
From:   =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
In-Reply-To: <Y4WnjiE2IxDgi5mc@euler>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hey Colin,

On 29.11.2022 09:32, Colin Foster wrote:
> Hi Arınç,
> 
> On Mon, Nov 28, 2022 at 11:28:31AM +0300, Arınç ÜNAL wrote:
>> On 28.11.2022 01:47, Colin Foster wrote:
>>> The description property was located where it applies to every port, not
>>> just ports 5 or 6 (CPU ports). Fix this description.
>>
>> I'm not sure I understand. The description for reg does apply to every port.
>> Both CPU ports and user ports are described. This patch moves the
>> description to under CPU ports only.
> 
> You're right. I misinterpreted what Rob suggested, so the commit message
> isn't correct. I see now that reg applies to every port, but is only
> restricted for CPU ports (if: required: [ ethernet ]).  I'll clean this
> message up.
> 
>>
>>>
>>> Suggested-by: Rob Herring <robh@kernel.org>
>>> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
>>> ---
>>>
>>> v2 -> v3
>>>     * New patch.
>>>
>>> ---
>>>    .../bindings/net/dsa/mediatek,mt7530.yaml          | 14 +++-----------
>>>    1 file changed, 3 insertions(+), 11 deletions(-)
>>>
>>> diff --git a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
>>> index 7df4ea1901ce..415e6c40787e 100644
>>> --- a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
>>> +++ b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
>>> @@ -156,17 +156,6 @@ patternProperties:
>>>        patternProperties:
>>>          "^(ethernet-)?port@[0-9]+$":
>>> -        type: object
>>> -        description: Ethernet switch ports
>>> -
>>> -        unevaluatedProperties: false
>>> -
>>
>> Would be nice to mention these being removed on the patch log. Or remove
>> them while doing ("dt-bindings: net: dsa: utilize base definitions for
>> standard dsa switches").
> 
> Agreed. My gut is telling me this wants to be in a separate patch from
> the generic DSA base definitions patch... but I can't say why for
> certain. I'll plan to move these to the patch you suggest and add a comment

If I understand correctly, with ("dt-bindings: net: dsa: utilize base 
definitions for standard dsa switches"), these properties are now 
defined on dsa.yaml#/$defs/base and no longer needed to be defined here 
since mediatek,mt7530.yaml was also made to refer to it. It'd make sense 
to remove these properties there as there's continuity.

> in there about how the type, description, and unevaluatedProperties of
> mediatek,mt7530 is no longer needed as a result? Keep this patch as more
> of a "restrict custom port description to CPU ports only" patch?

I'd say get rid of this patch and do above. Trust your gut though. ;P

Arınç
