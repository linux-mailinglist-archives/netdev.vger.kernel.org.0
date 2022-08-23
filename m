Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C20F259E5A3
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 17:06:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241319AbiHWPGb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 11:06:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241191AbiHWPGI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 11:06:08 -0400
Received: from sender4-op-o14.zoho.com (sender4-op-o14.zoho.com [136.143.188.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 807688A1D3;
        Tue, 23 Aug 2022 05:30:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1661257822; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=kUK9R4fOwaIdguJnen90t1H1YQbeohUSP2LhXaNJx8e+EGaESiDQVSl46eS7CflyE3GlMPihP2qZm1bzEvbXb6WJ7/NTtG0+RB2LZVGcKaXeBOxtl0OvkR0I3/dbOOljLGKYYhjAy76G9yAugBB2VB4/5VY0GnyLxqSxZvBBPl0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1661257822; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=8bzMWkh3gW8Eu0SXEfwUMm4SsOe7CTvCWXHdr0YLwl0=; 
        b=NYszyn3Jo8l5YNCYoW3Wy9G+tFfarqC08HAObhTvO9HtrStza6CPsmX5qgq17HHe4HfdlBPyW68Nd6rs/e1cxyhxHOa4UFg1ywEAIgkbXwwkM/wsrq4OH5M+6fppcOWUg/9vx9E4Q5JOU2bEv9++dlA7h6lFYzjL1dqkKeVbf2w=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1661257822;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
        bh=8bzMWkh3gW8Eu0SXEfwUMm4SsOe7CTvCWXHdr0YLwl0=;
        b=GQGn9eXUWpek5t87stuU5SpJkW49SlhBluS2FgLOH1LPETIZWjitQ0DApqfjxnTn
        ncsT96dEzeclV0BIMljDx0sNLkOZTXsH9Nr64rxKCP8VPOHh197wTXypi59Kvi5w03V
        Uv+Zbc4l2nh4sNPBYvo1TH+48iudDowVpGgujxoM=
Received: from [10.10.10.3] (37.120.152.236 [37.120.152.236]) by mx.zohomail.com
        with SMTPS id 1661257819881912.5959120446157; Tue, 23 Aug 2022 05:30:19 -0700 (PDT)
Message-ID: <fed417ad-946e-64bd-0d7f-5183cc1e5cac@arinc9.com>
Date:   Tue, 23 Aug 2022 15:30:12 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v4 1/6] dt-bindings: net: dsa: mediatek,mt7530: make
 trivial changes
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
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        Rob Herring <robh@kernel.org>
References: <20220820080758.9829-1-arinc.unal@arinc9.com>
 <20220820080758.9829-2-arinc.unal@arinc9.com>
 <70ae25b9-0500-7539-d71f-52c685783554@linaro.org>
From:   =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
In-Reply-To: <70ae25b9-0500-7539-d71f-52c685783554@linaro.org>
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

On 23.08.2022 13:40, Krzysztof Kozlowski wrote:
> On 20/08/2022 11:07, Arınç ÜNAL wrote:
>> Make trivial changes on the binding.
>>
>> - Update title to include MT7531 switch.
>> - Add me as a maintainer. List maintainers in alphabetical order by first
>> name.
>> - Add description to compatible strings.
>> - Stretch descriptions up to the 80 character limit.
>> - Remove quotes from $ref: "dsa.yaml#".
>>
>> Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
>> Reviewed-by: Rob Herring <robh@kernel.org>
>> ---
>>   .../bindings/net/dsa/mediatek,mt7530.yaml     | 36 ++++++++++++-------
>>   1 file changed, 24 insertions(+), 12 deletions(-)
>>
>> diff --git a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
>> index 17ab6c69ecc7..edf48e917173 100644
>> --- a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
>> +++ b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
>> @@ -4,12 +4,13 @@
>>   $id: http://devicetree.org/schemas/net/dsa/mediatek,mt7530.yaml#
>>   $schema: http://devicetree.org/meta-schemas/core.yaml#
>>   
>> -title: Mediatek MT7530 Ethernet switch
>> +title: Mediatek MT7530 and MT7531 Ethernet Switches
>>   
>>   maintainers:
>> -  - Sean Wang <sean.wang@mediatek.com>
>> +  - Arınç ÜNAL <arinc.unal@arinc9.com>
>>     - Landen Chao <Landen.Chao@mediatek.com>
>>     - DENG Qingfang <dqfext@gmail.com>
>> +  - Sean Wang <sean.wang@mediatek.com>
>>   
>>   description: |
>>     Port 5 of mt7530 and mt7621 switch is muxed between:
>> @@ -61,10 +62,21 @@ description: |
>>   
>>   properties:
>>     compatible:
>> -    enum:
>> -      - mediatek,mt7530
>> -      - mediatek,mt7531
>> -      - mediatek,mt7621
>> +    oneOf:
>> +      - description:
>> +          Standalone MT7530 and multi-chip module MT7530 in MT7623AI SoC
>> +        items:
> 
> You have one item, so don't make it a list. Just const:xxxxx
> 
> Same in other places.

Will do.

Arınç
