Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5978255FD2C
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 12:33:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232010AbiF2K3i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 06:29:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229828AbiF2K3h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 06:29:37 -0400
Received: from smtp14.infineon.com (smtp14.infineon.com [IPv6:2a00:18f0:1e00:4::6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FDEE3DDCB;
        Wed, 29 Jun 2022 03:29:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=infineon.com; i=@infineon.com; q=dns/txt; s=IFXMAIL;
  t=1656498576; x=1688034576;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=6z7jW+xFVUIPRN6xY5/GMDD9lYAIYUh7aTFgycfE2KY=;
  b=lLUEJcdx8FMANgi1s+66u7P8P+CawWgZtu7A0vOwMoYjq45TcoGLv6NS
   VXdo6QjrOp7To9u1SBbdOOqAFBUnZ+Sz1CJaeZK+ToG7Q2i7ZJuYSd3dZ
   g9Ot7jZW0NiIVQfXR1JYCrbxbzZ++HaYf5WTwXMH31ewXfOG7TBXRRjCg
   o=;
X-SBRS: None
X-IronPort-AV: E=McAfee;i="6400,9594,10392"; a="128909583"
X-IronPort-AV: E=Sophos;i="5.92,231,1650924000"; 
   d="scan'208";a="128909583"
Received: from unknown (HELO mucxv001.muc.infineon.com) ([172.23.11.16])
  by smtp14.infineon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2022 12:29:33 +0200
Received: from MUCSE803.infineon.com (MUCSE803.infineon.com [172.23.29.29])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mucxv001.muc.infineon.com (Postfix) with ESMTPS;
        Wed, 29 Jun 2022 12:29:33 +0200 (CEST)
Received: from MUCSE807.infineon.com (172.23.29.33) by MUCSE803.infineon.com
 (172.23.29.29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Wed, 29 Jun
 2022 12:29:33 +0200
Received: from [10.160.193.107] (172.23.8.247) by MUCSE807.infineon.com
 (172.23.29.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Wed, 29 Jun
 2022 12:29:32 +0200
Message-ID: <174363bc-e8e5-debd-f8f6-a252d2bbddb9@infineon.com>
Date:   Wed, 29 Jun 2022 12:29:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH 1/4] dt-bindings: net: broadcom-bluetooth: Add CYW55572 DT
 binding
Content-Language: en-US
To:     Rob Herring <robh@kernel.org>
CC:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "Luiz Augusto von Dentz" <luiz.dentz@gmail.com>,
        <linux-bluetooth@vger.kernel.org>
References: <cover.1655723462.git.hakan.jansson@infineon.com>
 <acd9e85b1ba82875e83ca68ae2aa62d828bfdfa3.1655723462.git.hakan.jansson@infineon.com>
 <2c753258-b68e-b2ad-c4cc-f0a437769bc2@linaro.org>
 <cb973352-36f9-8d70-95ac-5b63a566422c@infineon.com>
 <20220627173436.GA2616639-robh@kernel.org>
 <6e3a557a-fb0e-3b28-68f2-32804b071cfb@infineon.com>
 <20220628224110.GD963202-robh@kernel.org>
From:   Hakan Jansson <hakan.jansson@infineon.com>
In-Reply-To: <20220628224110.GD963202-robh@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [172.23.8.247]
X-ClientProxiedBy: MUCSE813.infineon.com (172.23.29.39) To
 MUCSE807.infineon.com (172.23.29.33)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/29/2022 12:41 AM, Rob Herring wrote:
> On Tue, Jun 28, 2022 at 04:03:57PM +0200, Hakan Jansson wrote:
>> Hi Rob,
>>
>> On 6/27/2022 7:34 PM, Rob Herring wrote:
>>> On Mon, Jun 20, 2022 at 04:06:25PM +0200, Hakan Jansson wrote:
>>>> Hi Krzysztof,
>>>>
>>>> Thanks for replying.
>>>>
>>>> On 6/20/2022 2:32 PM, Krzysztof Kozlowski wrote:
>>>>>> CYW55572 is a Wi-Fi + Bluetooth combo device from Infineon.
>>>>>> Extend the binding with its DT compatible.
>>>>>>
>>>>>> Signed-off-by: Hakan Jansson <hakan.jansson@infineon.com>
>>>>>> ---
>>>>>>     Documentation/devicetree/bindings/net/broadcom-bluetooth.yaml | 1 +
>>>>>>     1 file changed, 1 insertion(+)
>>>>>>
>>>>>> diff --git a/Documentation/devicetree/bindings/net/broadcom-bluetooth.yaml b/Documentation/devicetree/bindings/net/broadcom-bluetooth.yaml
>>>>>> index df59575840fe..71fe9b17f8f1 100644
>>>>>> --- a/Documentation/devicetree/bindings/net/broadcom-bluetooth.yaml
>>>>>> +++ b/Documentation/devicetree/bindings/net/broadcom-bluetooth.yaml
>>>>>> @@ -24,6 +24,7 @@ properties:
>>>>>>           - brcm,bcm43540-bt
>>>>>>           - brcm,bcm4335a0
>>>>>>           - brcm,bcm4349-bt
>>>>>> +      - infineon,cyw55572-bt
>>>>> Patch is okay, but just to be sure - is it entirely different device
>>>>> from Infineon or some variant of Broadcom block?
>>>> CYW55572 is a new device from Infineon. It is not the same as any Broadcom
>>>> device.
>>>>
>>>>>     Are all existing
>>>>> properties applicable to it as well?
>>>> Yes, all existing properties are applicable.
>>> Including 'brcm,bt-pcm-int-params'?
>> Yes, 'brcm,bt-pcm-int-params' is also applicable to CYW55572.
>>
>>> I don't see a BT reset signal
>>> either, but maybe that's not pinned out in the AzureWave module which
>>> was the only documentation details I could find[1].
>> That's correct, CYW55572 does not have a BT reset signal. Most of the
>> existing listed compatible devices does not seem to have a BT reset signal
>> either so I think this is in line with the intention of the existing
>> document and driver implementation.
>>
>>> I think a separate doc will be better as it can be more precise as to
>>> what's allowed or not. It's fine to reuse the same property names
>>> though.
>> I don't really see anything besides the optional BT reset property that
>> would be changed in a separate doc.  As a separate doc would mean a
>> duplication of data that would need to be maintained in two more or less
>> identical docs, perhaps it would be better to modify the existing doc to
>> clarify for which compatible devices that the BT reset property applies?
>> (Which I believe are only these three: bcm20702a1, bcm4329-bt and
>> bcm4330-bt)
> Okay, I guess this is fine in the same doc. Any conditionals to tighten
> up the constraints would be welcome.
>
> Rob

Ok, I'll add a patch with conditionals and resubmit a new rev of the 
patch series.

/Håkan
