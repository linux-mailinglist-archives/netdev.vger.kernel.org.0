Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 810C25911AE
	for <lists+netdev@lfdr.de>; Fri, 12 Aug 2022 15:42:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238726AbiHLNmd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Aug 2022 09:42:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236979AbiHLNmb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Aug 2022 09:42:31 -0400
Received: from sender4-op-o14.zoho.com (sender4-op-o14.zoho.com [136.143.188.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A54E79F752;
        Fri, 12 Aug 2022 06:42:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1660311705; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=RCWQQd2W+BbLuz5xnRGzN5nde0a/4N8SOuCNOPnBrFQK5sIwKtHtZl7jj5J0U4E+f6AWv7ZpvlvVdIPu9yzlhtCaNP0RWBwoDUQAV5PiMGZEUP2t+bdCMOhv6BesuSMCznMByJY1ilDUseRlneb9dT9R6X7XK0FJWDsWZvAIRcM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1660311705; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=Lj0r/qXRysJ3YO0LbUMCHmWO7t0y8zEQ459Z3a0BMSw=; 
        b=J6VOKszni1qY2HvcyxWkl0LEFBaGYm18L11gkaXfy4anMBXOdrqm8jiHzB4xCNUpajuDKijpYTItAxe1fLUrzG7OTPdygMHOEo0Y3Opp1Bm1SB63oi6egkPDoTphGCjmP9GDPbqznX5DdDMyX0g6bqQOR/z7DovGvSplzvg2jbo=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1660311705;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
        bh=Lj0r/qXRysJ3YO0LbUMCHmWO7t0y8zEQ459Z3a0BMSw=;
        b=C0IsFf4zWi3W9Ou+RjcsTpTsDYH6IbhIOwlh4d/oRqjlPsR/GPYf7uDlCp6TlXjw
        QGOgZkFWCk1NQyFgebl+KO4LxVmWTNycgpW0SSsLCoGizt5969njm4XfGrU2ehF3uBt
        XIJseeo3eomKasB85Xo4xtvOSRT9V85s1xe0NGrs=
Received: from [10.10.10.3] (37.120.152.236 [37.120.152.236]) by mx.zohomail.com
        with SMTPS id 1660311704339513.651743389957; Fri, 12 Aug 2022 06:41:44 -0700 (PDT)
Message-ID: <70e246af-c336-0896-95b5-9e42a17a239d@arinc9.com>
Date:   Fri, 12 Aug 2022 16:41:37 +0300
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
 <bb60608a-7902-99fa-72aa-5765adabd300@arinc9.com>
 <8a665b7a-bbd0-99ce-658e-bc78568bdca2@linaro.org>
 <40130c63-1e36-bb43-43b4-444a8f287226@linaro.org>
From:   =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
In-Reply-To: <40130c63-1e36-bb43-43b4-444a8f287226@linaro.org>
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

On 12.08.2022 10:01, Krzysztof Kozlowski wrote:
> On 12/08/2022 09:57, Krzysztof Kozlowski wrote:
>> On 12/08/2022 01:09, Arınç ÜNAL wrote:
>>>>> -patternProperties:
>>>>> -  "^(ethernet-)?ports$":
>>>>> -    type: object
>>>>
>>>> Actually four patches...
>>>>
>>>> I don't find this change explained in commit msg. What is more, it looks
>>>> incorrect. All properties and patternProperties should be explained in
>>>> top-level part.
>>>>
>>>> Defining such properties (with big piece of YAML) in each if:then: is no
>>>> readable.
>>>
>>> I can't figure out another way. I need to require certain properties for
>>> a compatible string AND certain enum/const for certain properties which
>>> are inside patternProperties for "^(ethernet-)?port@[0-9]+$" by reading
>>> the compatible string.
>>
>> requiring properties is not equal to defining them and nothing stops you
>> from defining all properties top-level and requiring them in
>> allOf:if:then:patternProperties.
>>
>>
>>> If I put allOf:if:then under patternProperties, I can't do the latter.
>>
>> You can.

Am I supposed to do something like this:

patternProperties:
   "^(ethernet-)?ports$":
     type: object

     patternProperties:
       "^(ethernet-)?port@[0-9]+$":
         type: object
         description: Ethernet switch ports

         unevaluatedProperties: false

         properties:
           reg:
             description:
               Port address described must be 5 or 6 for CPU port and
               from 0 to 5 for user ports.

         allOf:
           - $ref: dsa-port.yaml#
           - if:
               properties:
                 label:
                   items:
                     - const: cpu
             then:
               allOf:
                 - if:
                     properties:
                       compatible:
                         items:
                           - const: mediatek,mt7530
                           - const: mediatek,mt7621
                   then:
                     allOf:
                       - if:
                           properties:
                             reg:
                               const: 5
                         then:
                           properties:
                             phy-mode:
                               enum:
                                 - gmii
                                 - mii
                                 - rgmii

                       - if:
                           properties:
                             reg:
                               const: 6
                         then:
                           properties:
                             phy-mode:
                               enum:
                                 - rgmii
                                 - trgmii

                 - if:
                     properties:
                       compatible:
                         items:
                           - const: mediatek,mt7531
                   then:
                     allOf:
                       - if:
                           properties:
                             reg:
                               const: 5
                         then:
                           properties:
                             phy-mode:
                               enum:
                                 - 1000base-x
                                 - 2500base-x
                                 - rgmii
                                 - sgmii

                       - if:
                           properties:
                             reg:
                               const: 6
                         then:
                           properties:
                             phy-mode:
                               enum:
                                 - 1000base-x
                                 - 2500base-x
                                 - sgmii

               properties:
                 reg:
                   enum:
                     - 5
                     - 6

               required:
                 - phy-mode

>>
>>>
>>> Other than readability to human eyes, binding check works as intended,
>>> in case there's no other way to do it.
>>
>> I don't see the problem in doing it and readability is one of main
>> factors of code admission to Linux kernel.
> 
> One more thought - if your schema around allOf:if:then grows too much,
> it is actually a sign that it might benefit from splitting. Either into
> two separate schemas or into common+two separate.
> 
> Best regards,
> Krzysztof

Arınç
