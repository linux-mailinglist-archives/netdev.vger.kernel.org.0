Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 181186243D0
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 15:06:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229995AbiKJOGC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 09:06:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230078AbiKJOGB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 09:06:01 -0500
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF2996F344
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 06:05:57 -0800 (PST)
Received: by mail-lf1-x12a.google.com with SMTP id g7so3443879lfv.5
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 06:05:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mU1T17TmUMKJ1FQ3DqAQW105Hs0gFl2y7tVhnhRI/Pc=;
        b=TB/vlAiX1GaWtQtKZx92rFo7cAYyi7aiddPgCvt8+fucqf+/SW3ZmGdWeNWdfad+kY
         +ZPQT12nxPZrd/UJrsgOSzEKNWgsHWYZfs1ynhOkN2a1xER4lSEeuwU1V5ZWP3JRq0zJ
         hTphh2uY4UQT4ihCMuRPzvE7JY9w6yGEx7vVBTU4F3Q3S1/REOL8szTSk/7YaDu+OfxZ
         t7oPmrtLCOIjG59YpyjWMB2IHddqtpqXByi+/zMY2cRkDRmUKzVCcV9Xp2GTlqt+W1aR
         V03dtiOcFoxLSYxjrDOL6jRL/CL8hR51BW/m9JRFWuasiJLE7Z5Mew5D50RGu1+eCJbW
         C6ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mU1T17TmUMKJ1FQ3DqAQW105Hs0gFl2y7tVhnhRI/Pc=;
        b=1mRwhJ+lSNNOMRZ5drz/QOzxoTdM3lx+kQNJXlH6DAPIIyHU6gUjdxMAVqge8nhp9Q
         aP3hrLdgicP/txixcMyQYB9Rbf6z9j1lt2Amzj9K0fbAfm3gOtEwzh+vz5Gbergu1In1
         mCCeR3IruLuEXfFtNujCojcW2BxTSA74M8/0RtLFiQa4PW74NhnpPDYms4QMQvMJGyd4
         p4zEU+heHn/6HUBx9fOyEibho0LAkpslJM+8eI/+PfKKM+pVQXGL9bDH86YBuRUsbvXU
         0DBH+btMrHBfqo3RYBEXxJOXAfgZApHYgAXZYfl4mFOxuvqlrQlpORMHHx4f2MhtwsO4
         25rg==
X-Gm-Message-State: ACrzQf2LUmZiKPVtqZ4TVF6w7E8D0bgZ/qbgGiRGlINckoh2ZE1623St
        0b0nQ9seqqdGmMvzr7G5m8HzRwU8ppiB3A==
X-Google-Smtp-Source: AMsMyM5s03xz7K8V7wRjPw62PqrykcpGllOh53A5mlcV8u+2k6r4RX8HHjGD+srWOSlqw51wIIai/g==
X-Received: by 2002:a05:6512:1303:b0:4ab:4bef:b3db with SMTP id x3-20020a056512130300b004ab4befb3dbmr24104861lfu.592.1668089156138;
        Thu, 10 Nov 2022 06:05:56 -0800 (PST)
Received: from [192.168.0.20] (088156142199.dynamic-2-waw-k-3-2-0.vectranet.pl. [88.156.142.199])
        by smtp.gmail.com with ESMTPSA id bp9-20020a056512158900b004b19f766b07sm2776842lfb.91.2022.11.10.06.05.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Nov 2022 06:05:55 -0800 (PST)
Message-ID: <f338976e-40eb-5171-c14d-952d07d67730@linaro.org>
Date:   Thu, 10 Nov 2022 15:05:54 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH net-next V2] dt-bindings: net: ethernet-controller: Add
 ptp-hardware-clock
Content-Language: en-US
To:     "Gaddam, Sarath Babu Naidu" <sarath.babu.naidu.gaddam@amd.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>
Cc:     "krzysztof.kozlowski+dt@linaro.org" 
        <krzysztof.kozlowski+dt@linaro.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "yangbo.lu@nxp.com" <yangbo.lu@nxp.com>,
        "Pandey, Radhey Shyam" <radhey.shyam.pandey@amd.com>,
        "Sarangi, Anirudha" <anirudha.sarangi@amd.com>,
        "Katakam, Harini" <harini.katakam@amd.com>,
        "git (AMD-Xilinx)" <git@amd.com>
References: <20221021054111.25852-1-sarath.babu.naidu.gaddam@amd.com>
 <cfbde0da-9939-e976-52c1-88577de7d4cb@linaro.org>
 <MW5PR12MB559842AC3B0D4E539D653B3D87019@MW5PR12MB5598.namprd12.prod.outlook.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <MW5PR12MB559842AC3B0D4E539D653B3D87019@MW5PR12MB5598.namprd12.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/11/2022 10:57, Gaddam, Sarath Babu Naidu wrote:
>>>
>>> +  ptp-hardware-clock:
>>> +    $ref: /schemas/types.yaml#/definitions/phandle
>>> +    description:
>>> +      Specifies a reference to a node representing a IEEE1588 timer.
>>
>> Drop "Specifies a reference to". It's obvious from the schema.
>>
>> Aren't you expecting here some specific Devicetree node of IEEE1588 timer?
>> IOW, you expect to point to timer, but what this timer must provide? How is
>> this generic?
> 
> Thanks for review comments.
>  Format can be as documented by users Documentation/devicetree/bindings/ptp/ members. The node should be accessible to derive the index but the format of the PTP clock node is upto the vendor.

I am not sure what do you mean here. Anyway description might need
something more specific.

> 
> 
>>
>> In your commit msg you use multiple times "driver", so are you adding it only
>> to satisfy Linux driver requirements? What about other drivers, e.g. on BSD
>> or U-Boot?
> 
> AFAIK this is for Linux. It is not relevant to uboot as there's no PTP support there.

And BSD? Bindings are not for Linux only. Please abstract from any OS
specifics.

Also your messages needs wrapping. Use mailing list reply style.

Best regards,
Krzysztof

