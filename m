Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 103145908A2
	for <lists+netdev@lfdr.de>; Fri, 12 Aug 2022 00:13:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236395AbiHKWKc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 18:10:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230006AbiHKWKb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 18:10:31 -0400
Received: from sender4-op-o14.zoho.com (sender4-op-o14.zoho.com [136.143.188.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 230202180C;
        Thu, 11 Aug 2022 15:10:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1660255791; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=iE8grvsCnrxhND8Ci8GE2szYS3shYc0BUkcpZ4TS95GKI4N4tWIrspdhgK/v4wfURD7/2UAW+dhHebKq+F+LXDOhJxifp2nVVCtIMXKVbUWpi9nbe89YZH31CccVn02IDayXyjMz92sb6gQm7I+s8xF1QoI5zzO3uSYRmYLKT+I=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1660255791; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=eq/dAcQtE1Y4TfQ8R5bKdQmC1VzV3q/WEua24jSmXJk=; 
        b=g0rU/BeZEvJkmA5I447+dfONyZzBX3NFPzvhFIoI+Xyq25nIWMufgBhBavb8tdHpOD6TRzzNLQOtGP0n731ipfejhpebys5JBFOyFIB5UEHOCJYXZWwQVBK22G/tDflkaDKG7swikloj9oNLwgg0pC41NWGP/QPP5ILsqEyobds=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1660255791;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
        bh=eq/dAcQtE1Y4TfQ8R5bKdQmC1VzV3q/WEua24jSmXJk=;
        b=KrHw/neHkeX8N9mdDRpYoWO36BGFB4oqIUeKbIwJ9zSsIJqVpOHa01yMD6hzxxVn
        Wt0om9rHtPn3BP4CpvuiN5m4X6ZfE0eTqDqVm3ad7MztHXx1DxVBydrC/rXdj34qT0s
        NdqzfNQbly3CTK7nnWzYLd3cd/RtjRpr1XSDc7YU=
Received: from [10.10.10.3] (37.120.152.236 [37.120.152.236]) by mx.zohomail.com
        with SMTPS id 1660255788665258.4580356686007; Thu, 11 Aug 2022 15:09:48 -0700 (PDT)
Message-ID: <bb60608a-7902-99fa-72aa-5765adabd300@arinc9.com>
Date:   Fri, 12 Aug 2022 01:09:41 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 4/4] dt-bindings: net: dsa: mediatek,mt7530: update
 json-schema
Content-Language: en-US
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        Sander Vanheule <sander@svanheule.net>,
        =?UTF-8?Q?Ren=c3=a9_van_Dorst?= <opensource@vdorst.com>,
        Daniel Golle <daniel@makrotopia.org>, erkin.bozoglu@xeront.com,
        Sergio Paracuellos <sergio.paracuellos@gmail.com>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20220730142627.29028-1-arinc.unal@arinc9.com>
 <20220730142627.29028-5-arinc.unal@arinc9.com>
 <e5cf8a19-637c-95cf-1527-11980c73f6c0@linaro.org>
From:   =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
In-Reply-To: <e5cf8a19-637c-95cf-1527-11980c73f6c0@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2.08.2022 11:46, Krzysztof Kozlowski wrote:
> On 30/07/2022 16:26, Arınç ÜNAL wrote:
>> Update the json-schema for compatible devices.
>>
>> - Define acceptable phy-mode values for CPU port of each compatible device.
>> - Remove requiring the "reg" property since the referred dsa-port.yaml
>> already does that.
>> - Require mediatek,mcm for the described MT7621 SoCs as the compatible
>> string is only used for MT7530 which is a part of the multi-chip module.
> 
> 3 separate patches.

Roger.

> 
>>
>> Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
>> ---
>>   .../bindings/net/dsa/mediatek,mt7530.yaml     | 220 +++++++++++++++---
>>   1 file changed, 191 insertions(+), 29 deletions(-)
>>
>> diff --git a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
>> index a88e650e910b..a37a14fba9f6 100644
>> --- a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
>> +++ b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
>> @@ -135,35 +135,6 @@ properties:
>>         the ethsys.
>>       maxItems: 1
>>   
>> -patternProperties:
>> -  "^(ethernet-)?ports$":
>> -    type: object
> 
> Actually four patches...
> 
> I don't find this change explained in commit msg. What is more, it looks
> incorrect. All properties and patternProperties should be explained in
> top-level part.
> 
> Defining such properties (with big piece of YAML) in each if:then: is no
> readable.

I can't figure out another way. I need to require certain properties for 
a compatible string AND certain enum/const for certain properties which 
are inside patternProperties for "^(ethernet-)?port@[0-9]+$" by reading 
the compatible string.

If I put allOf:if:then under patternProperties, I can't do the latter.

Other than readability to human eyes, binding check works as intended, 
in case there's no other way to do it.

Arınç
