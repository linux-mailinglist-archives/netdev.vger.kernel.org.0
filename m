Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB7D659656F
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 00:22:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237882AbiHPWWM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 18:22:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237893AbiHPWVx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 18:21:53 -0400
Received: from sender4-op-o14.zoho.com (sender4-op-o14.zoho.com [136.143.188.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F083A7C519;
        Tue, 16 Aug 2022 15:21:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1660688477; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=NDa+061Xblq9xAwNXmKcv17QPR2sLX3FhHhmESb1b8pgFXJpC4RsjI6lshyl5b8uGAnsfd0VenkgKfQmvlvUb4xb3FzeG6IQ1y5bDzj8igQsM3qWAMtf530W0VzbQSx6WOHGxZA4EIUnEURTp+yCWpEaKfu4OBzi5zaWlBXiUIk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1660688477; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=nDTa5//nWj0Esms9kmwbp72Q9GG2XuE8CLV0rVm05OU=; 
        b=FNd0K0wsnycSXgfDGw+2jBnr+YiOBQNV87VdOrVPrP0D+a1Hh71XiBgKM0a0QPiJOei3knCh+ZBA5tvjEB82nv1wnAkmTtswjDCpzlfOCx6tv5ByV+AX8yJ7vaL81xV9DuxtPm4rnwyPgvELLuaMUuBBEnl4UY2pKdy2C52nwOc=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1660688477;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=Message-ID:Date:Date:MIME-Version:From:From:Subject:Subject:To:To:Cc:Cc:References:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
        bh=nDTa5//nWj0Esms9kmwbp72Q9GG2XuE8CLV0rVm05OU=;
        b=PrUQ84eiaZMAzNAz87ySIRMyHo6lq90+7mpr+fefTGiTteckeRDGLgem3+0MIEcn
        +lIjubL1TdKrUwk5E/B95tNIdkQxoGNppf9KeaMv3OGMAInBY0JBY+Vo+z9aXcL637X
        iJUiy5lrPhl4XRPkWO6CvObCMpF66Drzb0FlyfP4=
Received: from [10.10.10.3] (37.120.152.236 [37.120.152.236]) by mx.zohomail.com
        with SMTPS id 1660688475774900.170062109623; Tue, 16 Aug 2022 15:21:15 -0700 (PDT)
Message-ID: <5d51394b-cef2-6bb2-763c-e801994f67ea@arinc9.com>
Date:   Wed, 17 Aug 2022 01:21:09 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
From:   =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Subject: Re: [PATCH v2 5/7] dt-bindings: net: dsa: mediatek,mt7530: remove
 unnecesary lines
To:     Rob Herring <robh@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
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
        Sergio Paracuellos <sergio.paracuellos@gmail.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20220813154415.349091-1-arinc.unal@arinc9.com>
 <20220813154415.349091-6-arinc.unal@arinc9.com>
 <20220816211454.GA2734299-robh@kernel.org>
Content-Language: en-US
In-Reply-To: <20220816211454.GA2734299-robh@kernel.org>
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

On 17.08.2022 00:14, Rob Herring wrote:
> On Sat, Aug 13, 2022 at 06:44:13PM +0300, Arınç ÜNAL wrote:
>> Remove unnecessary lines as they are already included from the referred
>> dsa.yaml.
> 
> You are duplicating the schema and then removing parts twice. I would
> combine patches 4 and 5 or reverse the order.

Will combine.

> 
>>
>> Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
>> ---
>>   .../bindings/net/dsa/mediatek,mt7530.yaml     | 27 -------------------
>>   1 file changed, 27 deletions(-)
>>
>> diff --git a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
>> index ff51a2f6875f..a27cb4fa490f 100644
>> --- a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
>> +++ b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
>> @@ -162,15 +162,8 @@ allOf:
>>   
>>         patternProperties:
>>           "^(ethernet-)?ports$":
>> -          type: object
>> -
>>             patternProperties:
>>               "^(ethernet-)?port@[0-9]+$":
>> -              type: object
>> -              description: Ethernet switch ports
>> -
>> -              unevaluatedProperties: false
>> -
>>                 properties:
>>                   reg:
>>                     description:
>> @@ -178,7 +171,6 @@ allOf:
>>                       0 to 5 for user ports.
>>   
>>                 allOf:
>> -                - $ref: dsa-port.yaml#
>>                   - if:
> 
> This 'if' schema is the only part you need actually (though you have to
> create the node structure).

Do you mean that I should take "if:" out of allOf?

> 
>>                       properties:
>>                         label:
>> @@ -186,7 +178,6 @@ allOf:
>>                             - const: cpu
>>                     then:
>>                       required:
>> -                      - reg
>>                         - phy-mode
>>   
>>     - if:
>> @@ -200,15 +191,8 @@ allOf:
>>   
>>         patternProperties:
>>           "^(ethernet-)?ports$":
>> -          type: object
>> -
>>             patternProperties:
>>               "^(ethernet-)?port@[0-9]+$":
>> -              type: object
>> -              description: Ethernet switch ports
>> -
>> -              unevaluatedProperties: false
>> -
>>                 properties:
>>                   reg:
>>                     description:
>> @@ -216,7 +200,6 @@ allOf:
>>                       0 to 5 for user ports.
>>   
>>                 allOf:
>> -                - $ref: dsa-port.yaml#
>>                   - if:
>>                       properties:
>>                         label:
>> @@ -224,7 +207,6 @@ allOf:
>>                             - const: cpu
>>                     then:
>>                       required:
>> -                      - reg
>>                         - phy-mode
>>   
>>     - if:
>> @@ -238,15 +220,8 @@ allOf:
>>   
>>         patternProperties:
>>           "^(ethernet-)?ports$":
>> -          type: object
>> -
>>             patternProperties:
>>               "^(ethernet-)?port@[0-9]+$":
>> -              type: object
>> -              description: Ethernet switch ports
>> -
>> -              unevaluatedProperties: false
>> -
>>                 properties:
>>                   reg:
>>                     description:
>> @@ -254,7 +229,6 @@ allOf:
>>                       0 to 5 for user ports.
>>   
>>                 allOf:
>> -                - $ref: dsa-port.yaml#
>>                   - if:
>>                       properties:
>>                         label:
>> @@ -262,7 +236,6 @@ allOf:
>>                             - const: cpu
>>                     then:
>>                       required:
>> -                      - reg
>>                         - phy-mode
>>   
>>   unevaluatedProperties: false
>> -- 
>> 2.34.1
>>
>>
