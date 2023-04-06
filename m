Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F6106DA0FA
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 21:20:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240445AbjDFTUN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 15:20:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240560AbjDFTUM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 15:20:12 -0400
Received: from sender4-op-o10.zoho.com (sender4-op-o10.zoho.com [136.143.188.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F20B2127;
        Thu,  6 Apr 2023 12:20:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1680808781; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=nR9wu0GaPDtlM/n0Ciyr3NBG+GKr2f00h/WVdyNtL4N/auupCP8SNs3ZVNrkiH9On229eSwxE871kPVVu9KB5y42cupkr8O7ZCUOBxcCUm7kJ2OxP80K3iEK/QweeSQr66c9RuXR4fnfgUOwfgIHcMx2Or9UHiUJwsnHVuPGM6s=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1680808781; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=ZvtMXQOFygVzd6rC5xXJigXvwo3VtQG7GnNY5k/L7fk=; 
        b=fp5RK/8GtgbZxrg9iNLI6ZgRAHdg99BvGiDx5dEZ7ZimMNadHfSRAtp/Gy1STy4WihLXoOreCDs8OVidvP/NJucX6B1rYFi/RiResnqao2jsRCBZkPq5lpNaSKgOhiRLSZrVK609MGDS4juYnMJw1sOac1dcJIT4EjGWrCdlYwY=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1680808780;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
        bh=ZvtMXQOFygVzd6rC5xXJigXvwo3VtQG7GnNY5k/L7fk=;
        b=Lfe5OiPEt+79gwiLCH+7hwWBzioyr6bbG/4PEseoB/eIvqlZYmCGB+mhnwaKA2Pj
        8FpC+up4VIENIGtGUzn6fPcUxEiooMzGY4isY4sukjvbL9yt2h4qkUulzkJCFEalPoC
        wU5KkDBSu0qD8ySe617JHJA3gWQi+eL5Pf/I+QdQ=
Received: from [10.10.10.3] (149.91.1.15 [149.91.1.15]) by mx.zohomail.com
        with SMTPS id 1680808777178442.3356841427701; Thu, 6 Apr 2023 12:19:37 -0700 (PDT)
Message-ID: <194d3bad-c30a-df07-5fab-3264f739c599@arinc9.com>
Date:   Thu, 6 Apr 2023 22:19:30 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH 5/7] dt-bindings: net: dsa: mediatek,mt7530: disallow
 reset without mediatek,mcm
Content-Language: en-US
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        arinc9.unal@gmail.com, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Daniel Golle <daniel@makrotopia.org>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>
Cc:     erkin.bozoglu@xeront.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
References: <20230406080141.22924-1-arinc.unal@arinc9.com>
 <20230406080141.22924-5-arinc.unal@arinc9.com>
 <d5769d8f-29f3-063e-0562-487b1b509d3c@linaro.org>
From:   =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
In-Reply-To: <d5769d8f-29f3-063e-0562-487b1b509d3c@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Spam-Status: No, score=-2.4 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6.04.2023 22:08, Krzysztof Kozlowski wrote:
> On 06/04/2023 10:01, arinc9.unal@gmail.com wrote:
>> From: Arınç ÜNAL <arinc.unal@arinc9.com>
>>
>> The resets and reset-names properties are used only if mediatek,mcm is
>> used. Set them to false if mediatek,mcm is not used.
>>
>> Remove now unnecessary 'reset-names: false' from MT7988.
>>
>> Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
>> ---
>>   .../devicetree/bindings/net/dsa/mediatek,mt7530.yaml         | 5 ++++-
>>   1 file changed, 4 insertions(+), 1 deletion(-)
>>
>> diff --git a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
>> index 9d99f7303453..3fd953b1453e 100644
>> --- a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
>> +++ b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
>> @@ -282,6 +282,10 @@ allOf:
>>         required:
>>           - resets
>>           - reset-names
>> +    else:
>> +      properties:
>> +        resets: false
>> +        reset-names: false
>>   
>>     - dependencies:
>>         interrupt-controller: [ interrupts ]
>> @@ -324,7 +328,6 @@ allOf:
>>         properties:
>>           gpio-controller: false
>>           mediatek,mcm: false
>> -        reset-names: false
> 
> I don't see such hunk in linux-next.

This was added very recently so it's only on net-next at the moment.

Arınç
