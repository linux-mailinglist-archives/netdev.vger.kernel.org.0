Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2ED455E7B2
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 18:33:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347372AbiF1OEF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 10:04:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347363AbiF1OED (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 10:04:03 -0400
Received: from smtp2.infineon.com (smtp2.infineon.com [IPv6:2a00:18f0:1e00:4::4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8355723BF5;
        Tue, 28 Jun 2022 07:04:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=infineon.com; i=@infineon.com; q=dns/txt; s=IFXMAIL;
  t=1656425042; x=1687961042;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Nwmp6fTrRlPdkRkvJ5PRlNiLaOSIpMk1wa/T6KNjPRI=;
  b=EJqtDXbxaYFoLV+8+8RxYqMlEjmEq8Sxp/3Eg78Nh90+Fj8oRQxVN7Ds
   7y8eDU88j+7P0p2crsFG1R62S1oypm3Rsu8FWkDUEyG/1uCKeELN6rwgk
   0ItymCfDN8Qk0yC2XFweP20bXRk3R3d0//LUCxOs1yUGUG7i41nK8EOfg
   M=;
X-SBRS: None
X-IronPort-AV: E=McAfee;i="6400,9594,10391"; a="186094378"
X-IronPort-AV: E=Sophos;i="5.92,227,1650924000"; 
   d="scan'208";a="186094378"
Received: from unknown (HELO mucxv002.muc.infineon.com) ([172.23.11.17])
  by smtp2.infineon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2022 16:03:59 +0200
Received: from MUCSE805.infineon.com (MUCSE805.infineon.com [172.23.29.31])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mucxv002.muc.infineon.com (Postfix) with ESMTPS;
        Tue, 28 Jun 2022 16:03:59 +0200 (CEST)
Received: from MUCSE807.infineon.com (172.23.29.33) by MUCSE805.infineon.com
 (172.23.29.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Tue, 28 Jun
 2022 16:03:59 +0200
Received: from [10.160.193.107] (172.23.8.247) by MUCSE807.infineon.com
 (172.23.29.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Tue, 28 Jun
 2022 16:03:58 +0200
Message-ID: <6e3a557a-fb0e-3b28-68f2-32804b071cfb@infineon.com>
Date:   Tue, 28 Jun 2022 16:03:57 +0200
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
From:   Hakan Jansson <hakan.jansson@infineon.com>
In-Reply-To: <20220627173436.GA2616639-robh@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [172.23.8.247]
X-ClientProxiedBy: MUCSE803.infineon.com (172.23.29.29) To
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

Hi Rob,

On 6/27/2022 7:34 PM, Rob Herring wrote:
> On Mon, Jun 20, 2022 at 04:06:25PM +0200, Hakan Jansson wrote:
>> Hi Krzysztof,
>>
>> Thanks for replying.
>>
>> On 6/20/2022 2:32 PM, Krzysztof Kozlowski wrote:
>>>> CYW55572 is a Wi-Fi + Bluetooth combo device from Infineon.
>>>> Extend the binding with its DT compatible.
>>>>
>>>> Signed-off-by: Hakan Jansson <hakan.jansson@infineon.com>
>>>> ---
>>>>    Documentation/devicetree/bindings/net/broadcom-bluetooth.yaml | 1 +
>>>>    1 file changed, 1 insertion(+)
>>>>
>>>> diff --git a/Documentation/devicetree/bindings/net/broadcom-bluetooth.yaml b/Documentation/devicetree/bindings/net/broadcom-bluetooth.yaml
>>>> index df59575840fe..71fe9b17f8f1 100644
>>>> --- a/Documentation/devicetree/bindings/net/broadcom-bluetooth.yaml
>>>> +++ b/Documentation/devicetree/bindings/net/broadcom-bluetooth.yaml
>>>> @@ -24,6 +24,7 @@ properties:
>>>>          - brcm,bcm43540-bt
>>>>          - brcm,bcm4335a0
>>>>          - brcm,bcm4349-bt
>>>> +      - infineon,cyw55572-bt
>>> Patch is okay, but just to be sure - is it entirely different device
>>> from Infineon or some variant of Broadcom block?
>> CYW55572 is a new device from Infineon. It is not the same as any Broadcom
>> device.
>>
>>>    Are all existing
>>> properties applicable to it as well?
>> Yes, all existing properties are applicable.
> Including 'brcm,bt-pcm-int-params'?

Yes, 'brcm,bt-pcm-int-params' is also applicable to CYW55572.

> I don't see a BT reset signal
> either, but maybe that's not pinned out in the AzureWave module which
> was the only documentation details I could find[1].

That's correct, CYW55572 does not have a BT reset signal. Most of the 
existing listed compatible devices does not seem to have a BT reset 
signal either so I think this is in line with the intention of the 
existing document and driver implementation.

> I think a separate doc will be better as it can be more precise as to
> what's allowed or not. It's fine to reuse the same property names
> though.

I don't really see anything besides the optional BT reset property that 
would be changed in a separate doc.  As a separate doc would mean a 
duplication of data that would need to be maintained in two more or less 
identical docs, perhaps it would be better to modify the existing doc to 
clarify for which compatible devices that the BT reset property applies? 
(Which I believe are only these three: bcm20702a1, bcm4329-bt and 
bcm4330-bt)

> Rob
>
> [1] https://www.azurewave.com/img/infineon/AW-XH316_DS_DF_A_STD.pdf

Thanks,
Håkan
