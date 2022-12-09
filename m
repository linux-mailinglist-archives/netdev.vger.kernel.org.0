Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD222647CAE
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 05:05:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229989AbiLIDnU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 22:43:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229902AbiLIDnQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 22:43:16 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A449CFA;
        Thu,  8 Dec 2022 19:43:10 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id a14so2824897pfa.1;
        Thu, 08 Dec 2022 19:43:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KzTx46VsPlNBtMUazlqoN2pJfqj2F09S8xX/pSLFCGo=;
        b=i/JQjYIhPgIflT4dl1HEXlY0uLvEHEF1mcMgqGuRA7RIkSIll5DO0xBsbhMAxHrw/f
         OSEikPHufGbEG5aMghcO5x9TVB/Wym3Qtxi4pqF5VmIkEooHc3aWbZvLcbut4yQSupN/
         laSxPa7V2i4PI/8OEE7Yna3Mt7uapNgALsQt1yZWVgmInywCKp6uzOLNvwau/PNIwWET
         1oG8Ra5ao8UhUjOtJu8KMmps1mMTnNYSjuDZ7sHdShKrlPlq0ITl4d5uS8KogVl2J2i0
         bfJ3ppD5nwXwnSrq9uS5b+XE5YWsZ3t2CbghLsPuEOITFcUcSu8/oVrym7ALIxrnvOxF
         OSYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KzTx46VsPlNBtMUazlqoN2pJfqj2F09S8xX/pSLFCGo=;
        b=NvK3GDgaT/8rVen869P/RzHh5RHmiQs5ILQQT6evVMcMiyYIEgM6NP2jQ1s09VHL5F
         SKR1UiGRe+p5vOM/RiDwGu+jTfOi9JfKiE6pmuE5+cjH0p66hEAaf2jMf8YMNOnR43xT
         XiiZpmI4i/0uV7kJ3xidkkgqXCM/cmXIa2PDjIOnWBu3t4br2gY9yVrEf/51ij47KKB8
         /Bh/MDdegxpNFDeTFdpI+3DyEX7zh/3JPAFOKuwp6G1mqAjsheXNew9WJqsc3zXBbpuk
         FQGzORg+cTjpp1A1WmMc47fejk7f4Q4/lnHc1pjiAdyPred7skibwI9+b5guYTZTuZHX
         Qk2g==
X-Gm-Message-State: ANoB5pko4ENh+4oeOdluPxH6hUVQZxZi5rfPlHjbBYM3tOMngF1cnQW9
        8tkq4z5IOF6bKFZBwIzcx6LWQD72jdWeZA==
X-Google-Smtp-Source: AA0mqf4Xv5B508LHmEcNLP3bfnRlnLKzbtTqCexJYTKcyQr7BN6m+nxHrlQoWXwmg//WwYPTBeYsug==
X-Received: by 2002:aa7:858a:0:b0:56e:705e:3608 with SMTP id w10-20020aa7858a000000b0056e705e3608mr3904227pfn.31.1670557389598;
        Thu, 08 Dec 2022 19:43:09 -0800 (PST)
Received: from [10.230.29.214] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id u82-20020a627955000000b00571cdbd0771sm238815pfc.102.2022.12.08.19.43.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Dec 2022 19:43:09 -0800 (PST)
Message-ID: <af8093e9-11a5-930d-6dc5-2387195446b1@gmail.com>
Date:   Thu, 8 Dec 2022 19:43:06 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH net 1/2] MAINTAINERS: Update NXP FEC maintainer
Content-Language: en-US
To:     Clark Wang <xiaoning.wang@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Wei Fang <wei.fang@nxp.com>,
        Shenwei Wang <shenwei.wang@nxp.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <maz@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Shawn Guo <shawnguo@kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        "open list:IRQCHIP DRIVERS" <linux-kernel@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        "moderated list:ARM/FREESCALE IMX / MXC ARM ARCHITECTURE" 
        <linux-arm-kernel@lists.infradead.org>
References: <20221205212340.1073283-1-f.fainelli@gmail.com>
 <20221205212340.1073283-2-f.fainelli@gmail.com>
 <HE1PR0402MB2939AE5C96DE9ECD183D5522F31C9@HE1PR0402MB2939.eurprd04.prod.outlook.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <HE1PR0402MB2939AE5C96DE9ECD183D5522F31C9@HE1PR0402MB2939.eurprd04.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/8/2022 6:01 PM, Clark Wang wrote:
> Hi Florian,
> 
> 
>> -----Original Message-----
>> From: Florian Fainelli <f.fainelli@gmail.com>
>> Sent: 2022年12月6日 5:24
>> To: netdev@vger.kernel.org
>> Cc: Florian Fainelli <f.fainelli@gmail.com>; Thomas Gleixner
>> <tglx@linutronix.de>; Marc Zyngier <maz@kernel.org>; Rob Herring
>> <robh+dt@kernel.org>; Krzysztof Kozlowski
>> <krzysztof.kozlowski+dt@linaro.org>; Shawn Guo <shawnguo@kernel.org>;
>> dl-linux-imx <linux-imx@nxp.com>; David S. Miller <davem@davemloft.net>;
>> Eric Dumazet <edumazet@google.com>; Jakub Kicinski <kuba@kernel.org>;
>> Paolo Abeni <pabeni@redhat.com>; Sascha Hauer <s.hauer@pengutronix.de>;
>> Pengutronix Kernel Team <kernel@pengutronix.de>; Fabio Estevam
>> <festevam@gmail.com>; open list:IRQCHIP DRIVERS
>> <linux-kernel@vger.kernel.org>; open list:OPEN FIRMWARE AND FLATTENED
>> DEVICE TREE BINDINGS <devicetree@vger.kernel.org>; moderated
>> list:ARM/FREESCALE IMX / MXC ARM ARCHITECTURE
>> <linux-arm-kernel@lists.infradead.org>
>> Subject: [PATCH net 1/2] MAINTAINERS: Update NXP FEC maintainer
>>
>> Emails to Joakim Zhang bounce, add Shawn Guo (i.MX architecture
>> maintainer) and the NXP Linux Team exploder email.
>>
>> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
>> ---
>>   MAINTAINERS | 3 ++-
>>   1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/MAINTAINERS b/MAINTAINERS
>> index 256f03904987..ba25d5af51a0 100644
>> --- a/MAINTAINERS
>> +++ b/MAINTAINERS
>> @@ -8187,7 +8187,8 @@ S:	Maintained
>>   F:	drivers/i2c/busses/i2c-cpm.c
>>
>>   FREESCALE IMX / MXC FEC DRIVER
>> -M:	Joakim Zhang <qiangqing.zhang@nxp.com>
>> +M:	Shawn Guo <shawnguo@kernel.org>
>> +M:	NXP Linux Team <linux-imx@nxp.com>
> 
> For FEC driver, please change as follows. Thanks.
> M: Wei Fang <wei.fang@nxp.com>
> R: Shenwei Wang <shenwei.wang@nxp.com>
> R: Clark Wang <xiaoning.wang@nxp.com>
> R: NXP Linux Team <linux-imx@nxp.com>
> 
> Best Regards,
> Clark Wang

Will do, thanks for stepping in.
-- 
Florian
