Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EA1F530C9D
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 12:40:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232952AbiEWJWB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 05:22:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232871AbiEWJWA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 05:22:00 -0400
Received: from smtp11.infineon.com (smtp11.infineon.com [IPv6:2a00:18f0:1e00:4::5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7135F18E20;
        Mon, 23 May 2022 02:21:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=infineon.com; i=@infineon.com; q=dns/txt; s=IFXMAIL;
  t=1653297719; x=1684833719;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=AqqWInH/uvloVFBojaLNSCFPdNJZctY6O5Ve4B8YJfc=;
  b=TFCUQtSsdIim14QjfDQMgV4SVWsL4xELclaoxCszXx+bzLu7nq3hGk4P
   Ql5VfQa8q5OX7QoU7KxUbqbrGCamJskMrAutL+kmj8Hz/qt7C3+i6DO54
   MnFQpyzRAmhojsyCcXmerJ17Zpek/qtLTwZEBFj8WDvZCCc/VXxHt2ZV6
   g=;
X-SBRS: None
X-IronPort-AV: E=McAfee;i="6400,9594,10355"; a="297247087"
X-IronPort-AV: E=Sophos;i="5.91,246,1647298800"; 
   d="scan'208";a="297247087"
Received: from unknown (HELO mucxv002.muc.infineon.com) ([172.23.11.17])
  by smtp11.infineon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2022 11:21:57 +0200
Received: from MUCSE819.infineon.com (MUCSE819.infineon.com [172.23.29.45])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mucxv002.muc.infineon.com (Postfix) with ESMTPS;
        Mon, 23 May 2022 11:21:56 +0200 (CEST)
Received: from MUCSE807.infineon.com (172.23.29.33) by MUCSE819.infineon.com
 (172.23.29.45) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Mon, 23 May
 2022 11:21:56 +0200
Received: from [10.160.230.235] (172.23.8.247) by MUCSE807.infineon.com
 (172.23.29.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Mon, 23 May
 2022 11:21:55 +0200
Message-ID: <b090ec5a-6d9a-71e3-d4d0-e491b14b558e@infineon.com>
Date:   Mon, 23 May 2022 11:21:54 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH v2 1/2] dt-bindings: net: broadcom-bluetooth: Add property
 for autobaud mode
Content-Language: en-US
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        "Krzysztof Kozlowski" <krzysztof.kozlowski+dt@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "Luiz Augusto von Dentz" <luiz.dentz@gmail.com>,
        <linux-bluetooth@vger.kernel.org>
References: <cover.1653057480.git.hakan.jansson@infineon.com>
 <cb20a6f49c91521d54c847ee4dc14451b0ee91dd.1653057480.git.hakan.jansson@infineon.com>
 <996ac5f2-3cf3-e67a-144b-4fdac9bbc20d@linaro.org>
From:   Hakan Jansson <hakan.jansson@infineon.com>
In-Reply-To: <996ac5f2-3cf3-e67a-144b-4fdac9bbc20d@linaro.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [172.23.8.247]
X-ClientProxiedBy: MUCSE824.infineon.com (172.23.29.55) To
 MUCSE807.infineon.com (172.23.29.33)
X-Spam-Status: No, score=-10.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Krzysztof,

Thanks for responding.

On 5/22/2022 10:14 AM, Krzysztof Kozlowski wrote:
>> Some devices (e.g. CYW5557x) require autobaud mode to enable FW loading.
> Which devices support this? You probably need allOf:if:then.

Most devices _support_ autobaud mode but I don't have a definitive list. 
The CYW5557x is the first device family to _require_ autobaud mode for 
FW loading as far as I know.

>> Autobaud mode can also be required on some boards where the controller
>> device is using a non-standard baud rate when first powered on.
>>
>> This patch adds a property, "brcm,uses-autobaud-mode", to enable autobaud
>> mode selection.
> Don't use "This patch":
> https://elixir.bootlin.com/linux/v5.17.1/source/Documentation/process/submitting-patches.rst#L95

Sorry, will change in next rev.

>> Signed-off-by: Hakan Jansson <hakan.jansson@infineon.com>
>> ---
>> V1 -> V2: Modify property description
>>
>>   .../devicetree/bindings/net/broadcom-bluetooth.yaml      | 9 +++++++++
>>   1 file changed, 9 insertions(+)
>>
>> diff --git a/Documentation/devicetree/bindings/net/broadcom-bluetooth.yaml b/Documentation/devicetree/bindings/net/broadcom-bluetooth.yaml
>> index 5aac094fd217..a29f059c21cc 100644
>> --- a/Documentation/devicetree/bindings/net/broadcom-bluetooth.yaml
>> +++ b/Documentation/devicetree/bindings/net/broadcom-bluetooth.yaml
>> @@ -92,6 +92,15 @@ properties:
>>          pcm-sync-mode: slave, master
>>          pcm-clock-mode: slave, master
>>
>> +  brcm,uses-autobaud-mode:
> Based on description, I understand the host triggers using autobaud.

Correct, the host triggers using autobaud.

> However here you word it as "uses", so it is independent of host, it
> looks like property of a device.

I've been thinking of it as a a property of a specific board HW, 
inherited either from a property of the device being used or from a 
property of the HW design (e.g. a PCB using an alternate crystal 
frequency yielding a non-standard baud rate).

>   The commit msg describes it even
> different - "require autobaud".

Yes, the commit message describes two separate reasons why autobaud mode 
would be required:

1. Requirement coming from Device: "Some devices (e.g. CYW5557x) require 
autobaud mode to enable FW loading."

2. Requirement coming from HW design: "Autobaud mode can also be 
required on some boards where the controller device is using a 
non-standard baud rate when first powered on."

> This leads to second issue - it looks like there is some hardware
> property (requiring to use autobaud) which should be described by
> bindings. But instead you describe desired operational feature.

Sorry about that. I've really been struggling with what should go into 
the description. Any suggestions or hints would be much appreciated.

How about, changing the property name to "brcm,requires-autobaud-mode" 
and the description to:
"Set this property if autobaud mode is required. Autobaud mode is 
required if the device's baud rate in normal mode is not supported by 
the host or if the device requires autobaud mode startup before loading FW."

Would that be an appropriate name and description?

>> +    type: boolean
>> +    description: >
> No need for '>'.

Ok, will remove in next rev.

>> +      Setting this property will make the host (driver) assert the controller
>> +      chip's BT_UART_CTS_N prior to asserting BT_REG_ON. This will make the
>> +      controller start up in autobaud mode. The controller will then detect the
>> +      baud rate of the first incoming (HCI Reset) command from the host and
>> +      subsequently use that baud rate.
>> +
>>     interrupts:
>>       items:
>>         - description: Handle to the line HOST_WAKE used to wake
>

Thanks,
Håkan
