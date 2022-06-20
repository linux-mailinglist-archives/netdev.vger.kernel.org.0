Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E391551F4F
	for <lists+netdev@lfdr.de>; Mon, 20 Jun 2022 16:48:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241436AbiFTOrK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jun 2022 10:47:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240916AbiFTOqy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jun 2022 10:46:54 -0400
Received: from smtp11.infineon.com (smtp11.infineon.com [IPv6:2a00:18f0:1e00:4::5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BAF337BF2;
        Mon, 20 Jun 2022 07:07:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=infineon.com; i=@infineon.com; q=dns/txt; s=IFXMAIL;
  t=1655734065; x=1687270065;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=WFUlWOfqcV+dfLqXHwjqs/AJN8x0qxLjeeFqsnGEuGs=;
  b=oYvOkfi/U6TLnjaze31CPCWSoZXnPb0nj/Mui9YDETfduwPJdeViNR68
   bKOqtyj7NTO5ZQ1Aru1A+mtstjecVPJq88tosHzu3JbwLCXJcEEauXryJ
   a0w3XZgyRQf8ccdd/j3f9vldIgugIsD4VxCWrxqesAz5LXedn2/kOcmNj
   4=;
X-SBRS: None
X-IronPort-AV: E=McAfee;i="6400,9594,10380"; a="301914076"
X-IronPort-AV: E=Sophos;i="5.92,306,1650924000"; 
   d="scan'208";a="301914076"
Received: from unknown (HELO mucxv003.muc.infineon.com) ([172.23.11.20])
  by smtp11.infineon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2022 16:06:28 +0200
Received: from MUCSE812.infineon.com (MUCSE812.infineon.com [172.23.29.38])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mucxv003.muc.infineon.com (Postfix) with ESMTPS;
        Mon, 20 Jun 2022 16:06:27 +0200 (CEST)
Received: from MUCSE807.infineon.com (172.23.29.33) by MUCSE812.infineon.com
 (172.23.29.38) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Mon, 20 Jun
 2022 16:06:27 +0200
Received: from [10.160.196.13] (172.23.8.247) by MUCSE807.infineon.com
 (172.23.29.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Mon, 20 Jun
 2022 16:06:26 +0200
Message-ID: <cb973352-36f9-8d70-95ac-5b63a566422c@infineon.com>
Date:   Mon, 20 Jun 2022 16:06:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH 1/4] dt-bindings: net: broadcom-bluetooth: Add CYW55572 DT
 binding
Content-Language: en-US
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
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
From:   Hakan Jansson <hakan.jansson@infineon.com>
In-Reply-To: <2c753258-b68e-b2ad-c4cc-f0a437769bc2@linaro.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [172.23.8.247]
X-ClientProxiedBy: MUCSE812.infineon.com (172.23.29.38) To
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

Hi Krzysztof,

Thanks for replying.

On 6/20/2022 2:32 PM, Krzysztof Kozlowski wrote:
>> CYW55572 is a Wi-Fi + Bluetooth combo device from Infineon.
>> Extend the binding with its DT compatible.
>>
>> Signed-off-by: Hakan Jansson <hakan.jansson@infineon.com>
>> ---
>>   Documentation/devicetree/bindings/net/broadcom-bluetooth.yaml | 1 +
>>   1 file changed, 1 insertion(+)
>>
>> diff --git a/Documentation/devicetree/bindings/net/broadcom-bluetooth.yaml b/Documentation/devicetree/bindings/net/broadcom-bluetooth.yaml
>> index df59575840fe..71fe9b17f8f1 100644
>> --- a/Documentation/devicetree/bindings/net/broadcom-bluetooth.yaml
>> +++ b/Documentation/devicetree/bindings/net/broadcom-bluetooth.yaml
>> @@ -24,6 +24,7 @@ properties:
>>         - brcm,bcm43540-bt
>>         - brcm,bcm4335a0
>>         - brcm,bcm4349-bt
>> +      - infineon,cyw55572-bt
> Patch is okay, but just to be sure - is it entirely different device
> from Infineon or some variant of Broadcom block?

CYW55572 is a new device from Infineon. It is not the same as any 
Broadcom device.

>   Are all existing
> properties applicable to it as well?

Yes, all existing properties are applicable.


Regards,
Håkan
