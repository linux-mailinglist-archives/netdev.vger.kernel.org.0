Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93DA8596536
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 00:10:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237638AbiHPWKH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 18:10:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237850AbiHPWKC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 18:10:02 -0400
Received: from sender4-op-o14.zoho.com (sender4-op-o14.zoho.com [136.143.188.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EF258671A;
        Tue, 16 Aug 2022 15:10:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1660687764; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=ELwQ/7/+HoV4zxcNv7CHt2Rj8JZBshtx3il1WX1Ei7Gp4pq8lZBjpEnc4jzgtJbQ0H3vPEskap1qBnrr8u1NZ3vwqT7dOT/6nNQ5OuQpcLo6bFut/rUrrgNLWgRd7KNhuo7dmDn2DafD84YiXvypKUpsc3TRc4WFf5C/q5S0hOQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1660687764; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=AhxeiWwAa0F3Ttv9kr0cvGflhoCH/1XjPY7zFl37TcQ=; 
        b=aHcWpdk4rMypwt2IASMrIIe4kX9LFFwnvhqNA/5LngB9Fn2M0btkGBXWqJ8A2FYVcwL3SgUYPqU48Rx3d8Qv+qs0wUzr2oOJl6T1YOgA3CUTXInu9tNo00Ij59/F3kdKdCAqOOdHbO8BqjKz4g17DVL1e6U14GimY06yeH8VSYU=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1660687764;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
        bh=AhxeiWwAa0F3Ttv9kr0cvGflhoCH/1XjPY7zFl37TcQ=;
        b=j3TicWQ8jpFSqaUr7Yxg4uVFxHP5YUa679t4Hrfn3m4AMwvzXOhTuK01vg5dn9V7
        lLaXW5j79jUkfKPtIhCP6LRIoApQj/mQ/95BC2bPjDva7qw1omBd46n4fQ8o7pmuttW
        vxOi0Dyw/YcGj073NBzu6G0LP7it0nmF0+VKruAM=
Received: from [10.10.10.3] (37.120.152.236 [37.120.152.236]) by mx.zohomail.com
        with SMTPS id 1660687763403186.45955867302928; Tue, 16 Aug 2022 15:09:23 -0700 (PDT)
Message-ID: <03852e07-9aee-8e0a-3a96-21a1f4f3bfe3@arinc9.com>
Date:   Wed, 17 Aug 2022 01:09:16 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v2 6/7] dt-bindings: net: dsa: mediatek,mt7530: define
 phy-mode for each compatible
Content-Language: en-US
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
 <20220813154415.349091-7-arinc.unal@arinc9.com>
 <20220816212135.GA2747439-robh@kernel.org>
From:   =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
In-Reply-To: <20220816212135.GA2747439-robh@kernel.org>
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

On 17.08.2022 00:21, Rob Herring wrote:
> On Sat, Aug 13, 2022 at 06:44:14PM +0300, Arınç ÜNAL wrote:
>> Define acceptable phy-mode values for CPU port of each compatible device.
>> Remove relevant information from the description of the binding.
> 
> I'm not really sure this is worth the complexity just to check
> 'phy-mode'...

I can describe it on the binding description but it won't be checked on 
DT bindings. phy-mode values are significantly different between mt7530 
and mt7531 so I think it's useful to have it.

> 
>>
>> Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
>> ---
>>   .../bindings/net/dsa/mediatek,mt7530.yaml     | 103 ++++++++++++++++--
>>   1 file changed, 92 insertions(+), 11 deletions(-)
>>
>> diff --git a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
>> index a27cb4fa490f..530ef5a75a2f 100644
>> --- a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
>> +++ b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
>> @@ -49,17 +49,6 @@ description: |
>>     * mt7621: phy-mode = "rgmii-txid";
>>     * mt7623: phy-mode = "rgmii";
>>   
>> -  CPU-Ports need a phy-mode property:
>> -    Allowed values on mt7530 and mt7621:
>> -      - "rgmii"
>> -      - "trgmii"
>> -    On mt7531:
>> -      - "1000base-x"
>> -      - "2500base-x"
>> -      - "rgmii"
>> -      - "sgmii"
>> -
>> -
>>   properties:
>>     compatible:
>>       oneOf:
>> @@ -177,6 +166,36 @@ allOf:
>>                           items:
>>                             - const: cpu
>>                     then:
>> +                    allOf:
>> +                      - if:
>> +                          properties:
>> +                            reg:
>> +                              const: 5
>> +                        then:
>> +                          properties:
>> +                            phy-mode:
>> +                              enum:
>> +                                - gmii
>> +                                - mii
>> +                                - rgmii
>> +
>> +                      - if:
>> +                          properties:
>> +                            reg:
>> +                              const: 6
>> +                        then:
> 
> You've restricted this to ports 5 or 6 already, so you just need an
> 'else' here. And you can then drop the 'allOf'.

Good thinking, will do.

> 
>> +                          properties:
>> +                            phy-mode:
>> +                              enum:
>> +                                - rgmii
>> +                                - trgmii
>> +
>> +                    properties:
>> +                      reg:
>> +                        enum:
>> +                          - 5
>> +                          - 6
>> +
>>                       required:
>>                         - phy-mode
>>   
>> @@ -206,6 +225,38 @@ allOf:
>>                           items:
>>                             - const: cpu
>>                     then:
>> +                    allOf:
>> +                      - if:
>> +                          properties:
>> +                            reg:
>> +                              const: 5
>> +                        then:
>> +                          properties:
>> +                            phy-mode:
>> +                              enum:
>> +                                - 1000base-x
>> +                                - 2500base-x
>> +                                - rgmii
>> +                                - sgmii
>> +
>> +                      - if:
>> +                          properties:
>> +                            reg:
>> +                              const: 6
>> +                        then:
>> +                          properties:
>> +                            phy-mode:
>> +                              enum:
>> +                                - 1000base-x
>> +                                - 2500base-x
>> +                                - sgmii
>> +
>> +                    properties:
>> +                      reg:
>> +                        enum:
>> +                          - 5
>> +                          - 6
>> +
>>                       required:
>>                         - phy-mode
>>   
>> @@ -235,6 +286,36 @@ allOf:
>>                           items:
>>                             - const: cpu
>>                     then:
>> +                    allOf:
>> +                      - if:
>> +                          properties:
>> +                            reg:
>> +                              const: 5
>> +                        then:
>> +                          properties:
>> +                            phy-mode:
>> +                              enum:
>> +                                - gmii
>> +                                - mii
>> +                                - rgmii
>> +
>> +                      - if:
>> +                          properties:
>> +                            reg:
>> +                              const: 6
>> +                        then:
>> +                          properties:
>> +                            phy-mode:
>> +                              enum:
>> +                                - rgmii
>> +                                - trgmii
>> +
>> +                    properties:
>> +                      reg:
>> +                        enum:
>> +                          - 5
>> +                          - 6
>> +
> 
> Looks like the same schema duplicated. You can put it under a '$defs'
> and reference it twice.

Great!

> 
>>                       required:
>>                         - phy-mode
>>   
>> -- 
>> 2.34.1
>>
>>
