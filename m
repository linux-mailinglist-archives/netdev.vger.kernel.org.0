Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 727D25911B7
	for <lists+netdev@lfdr.de>; Fri, 12 Aug 2022 15:49:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237644AbiHLNtA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Aug 2022 09:49:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237117AbiHLNs6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Aug 2022 09:48:58 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FF8AA405A
        for <netdev@vger.kernel.org>; Fri, 12 Aug 2022 06:48:55 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id f20so1408711lfc.10
        for <netdev@vger.kernel.org>; Fri, 12 Aug 2022 06:48:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=C60Y/Psn2DfbYSl6cZKqaTCQ7Sgqzh8lKtssMlfhgdo=;
        b=pWbMOWv12SncgQnIuIVOZIuOGhZs9m4NIgAH4gt6ZLQlOYjrJkkrpfmGlGCsIisBzI
         x/v8DlJwMigklZslZraUmAV3o3EudTu6miObF37SapiaOyQ7qROqopSG36e739kWIR7w
         JJD6EAb9D0Wzj4lYQx6qyLJVCE8AOvJfpDEYCmPZeUn+tmgP3zoa9TCJ3qI4TQidCQzh
         A3WWOzYXKKX64DYzpcg9y635CEsUDPsNh/89xvbckuKi0dbRGta8wpqRK3MSOwQcj2ka
         jioKGTP+gwvfVng2HwS+LbU1WM/BicwUT0gtxiXvDGzrnx51rOIp5qDvT7EuLpFj65Eq
         45Ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=C60Y/Psn2DfbYSl6cZKqaTCQ7Sgqzh8lKtssMlfhgdo=;
        b=XbXx+h9Sc1EyTKlM5j31AvPL7e0958MPBTMelJjBd/XRPbn3bNQtZRG3HWVDzUey1/
         FmBAhWvt3Oa5nYy4DO5fBrLatcQdJx4rZIHdGn43TaemtZopHo8zwovbEqn+eWeA5MSB
         FdaBRCioOtWmSTyuoin1hkOhvCbFm9C/8KBJL3e00Jk3/eHsEbvPKnOnLkCzMpfS/cCA
         acjryGmVQhU9IFEJx30FP1OWtoyZSrnMyqNT+/MZ+b8dciTH+xxbumTqeqDWXYVA7vFB
         6DIfI3ZWpI14ftOUHamr7SKCNJAs+gCKuRY82b/2dKHC/aUra1BRP5Hv4MSZGYHbq343
         UTrw==
X-Gm-Message-State: ACgBeo1zyhDmiWXqAU6bntKEDnQ3EBrF9mmc5fLJdx2/ahCPud+KkxDV
        4r1+b2op2exvAvjH2mxtYP/oOg==
X-Google-Smtp-Source: AA6agR64G+c5wbFPsOJpNw8i8kydU4HW7gKVfY0L7wZs/5J9GKNtG7Gd/wPYjnf5eFU18oI1+UgbUQ==
X-Received: by 2002:a05:6512:1155:b0:48a:fb9a:32d8 with SMTP id m21-20020a056512115500b0048afb9a32d8mr1340962lfg.672.1660312133710;
        Fri, 12 Aug 2022 06:48:53 -0700 (PDT)
Received: from [192.168.1.39] ([83.146.140.105])
        by smtp.gmail.com with ESMTPSA id b19-20020ac24113000000b0048b03d1ca4asm221323lfi.161.2022.08.12.06.48.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Aug 2022 06:48:53 -0700 (PDT)
Message-ID: <3731cd56-f7e8-6807-06b5-b8b176b078b6@linaro.org>
Date:   Fri, 12 Aug 2022 16:48:43 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH 4/4] dt-bindings: net: dsa: mediatek,mt7530: update
 json-schema
Content-Language: en-US
To:     =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>,
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
 <70e246af-c336-0896-95b5-9e42a17a239d@arinc9.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <70e246af-c336-0896-95b5-9e42a17a239d@arinc9.com>
Content-Type: text/plain; charset=UTF-8
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

On 12/08/2022 16:41, Arınç ÜNAL wrote:
> On 12.08.2022 10:01, Krzysztof Kozlowski wrote:
>> On 12/08/2022 09:57, Krzysztof Kozlowski wrote:
>>> On 12/08/2022 01:09, Arınç ÜNAL wrote:
>>>>>> -patternProperties:
>>>>>> -  "^(ethernet-)?ports$":
>>>>>> -    type: object
>>>>>
>>>>> Actually four patches...
>>>>>
>>>>> I don't find this change explained in commit msg. What is more, it looks
>>>>> incorrect. All properties and patternProperties should be explained in
>>>>> top-level part.
>>>>>
>>>>> Defining such properties (with big piece of YAML) in each if:then: is no
>>>>> readable.
>>>>
>>>> I can't figure out another way. I need to require certain properties for
>>>> a compatible string AND certain enum/const for certain properties which
>>>> are inside patternProperties for "^(ethernet-)?port@[0-9]+$" by reading
>>>> the compatible string.
>>>
>>> requiring properties is not equal to defining them and nothing stops you
>>> from defining all properties top-level and requiring them in
>>> allOf:if:then:patternProperties.
>>>
>>>
>>>> If I put allOf:if:then under patternProperties, I can't do the latter.
>>>
>>> You can.
> 
> Am I supposed to do something like this:
> 
> patternProperties:
>    "^(ethernet-)?ports$":
>      type: object
> 
>      patternProperties:
>        "^(ethernet-)?port@[0-9]+$":
>          type: object
>          description: Ethernet switch ports
> 
>          unevaluatedProperties: false
> 
>          properties:
>            reg:
>              description:
>                Port address described must be 5 or 6 for CPU port and
>                from 0 to 5 for user ports.
> 
>          allOf:
>            - $ref: dsa-port.yaml#
>            - if:
>                properties:
>                  label:
>                    items:
>                      - const: cpu
>              then:
>                allOf:
>                  - if:
>                      properties:

Not really, this is absolutely unreadable.

Usually the way it is handled is:

patternProperties:
   "^(ethernet-)?ports$":
     type: object

     patternProperties:
       "^(ethernet-)?port@[0-9]+$":
         type: object
         description: Ethernet switch ports
         unevaluatedProperties: false
         ... regular stuff follows

allOf:
 - if:
     properties:
       compatible:
         .....
   then:
     patternProperties:
       "^(ethernet-)?ports$":
         patternProperties:
           "^(ethernet-)?port@[0-9]+$":
             properties:
               reg:
                 const: 5


I admit that it is still difficult to parse, which could justify
splitting to separate schema. Anyway the point of my comment was to
define all properties in top level, not in allOf.

allOf should be used to constrain these properties.

Best regards,
Krzysztof
