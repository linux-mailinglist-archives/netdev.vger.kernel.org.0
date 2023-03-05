Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E6286AB173
	for <lists+netdev@lfdr.de>; Sun,  5 Mar 2023 17:58:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229698AbjCEQ6Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Mar 2023 11:58:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229693AbjCEQ6Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Mar 2023 11:58:24 -0500
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 994C7CA12
        for <netdev@vger.kernel.org>; Sun,  5 Mar 2023 08:58:22 -0800 (PST)
Received: by mail-il1-x12b.google.com with SMTP id y9so3979456ill.3
        for <netdev@vger.kernel.org>; Sun, 05 Mar 2023 08:58:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ieee.org; s=google; t=1678035502;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=aj+sCMCZSrVKo/Uw+s7aitBRb/4NWTM49sBMqERhEpg=;
        b=Ani9WhXYsvqGrbaM/ZwAoURorj6hFZNvybfaw90UB54nZEMgAdiyUOU1PiNPtRGQRa
         pj/lrqdmWvoC8qaZ28RSh1P0XlTwcNx8UTpfk6+2Nw0866SfRfwdqD4V0ysNB5yMhGBu
         2txFv7UUfQkC5ZQCH4nQrcfgaI+XomU50F+vM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678035502;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aj+sCMCZSrVKo/Uw+s7aitBRb/4NWTM49sBMqERhEpg=;
        b=Jmc62NsxCyPMj19DmXf5PWg+7/BOFY2dMeQCt+d0VsuAv58HPA/HnHsIcpAOBTnuSg
         pbyzMhOtqwPTkf/L/IkOakv0/5k+HHtzRZC0zxmK/xIKS4iCHOA9KMOCvAeH4gByphpk
         /Sh6xiPMjKFWwYWpBuhhup0YV1/GvbdlH/O9dtgXXWv1GBOfyiqGbkDaXOvCS9V3BxSR
         6u9pstTq0XELNk4AsdRVZNE5fUWeQP09r44poOn/iRrvGIOt3tsm/IpojUINFRHk569O
         bh5d9sv9eUdSrk6MAHeQDECkkw9Fm71rtO5J6Upel6CujQ5oNCoa3ZdIKHMC/9vzoWis
         CV8w==
X-Gm-Message-State: AO0yUKUAqw60H3yZ4/VnjfmHW97LF+mreWLBQrJdQGYrtWacDbBrlYAd
        tj01ll5d8UBelBOgYPCTa/M7sw==
X-Google-Smtp-Source: AK7set+rwXEfKWTFcnCQMZXRHbEdVRTYlTfIugZqOftJv3Qt3HR7/P2Gcd3pkLvWzm380at8+xIWIQ==
X-Received: by 2002:a05:6e02:1527:b0:317:e415:bc55 with SMTP id i7-20020a056e02152700b00317e415bc55mr8622126ilu.23.1678035501921;
        Sun, 05 Mar 2023 08:58:21 -0800 (PST)
Received: from [10.211.55.3] ([98.61.227.136])
        by smtp.googlemail.com with ESMTPSA id p17-20020a92da51000000b0031796c6d735sm2246671ilq.41.2023.03.05.08.58.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 05 Mar 2023 08:58:21 -0800 (PST)
Message-ID: <5d90b252-c650-9908-05d3-fbbfdf47aa38@ieee.org>
Date:   Sun, 5 Mar 2023 10:58:19 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH net-next 2/6] net: ipa: kill gsi->virt_raw
To:     Alex Elder <elder@linaro.org>,
        Alexander Lobakin <aleksander.lobakin@intel.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, caleb.connolly@linaro.org, mka@chromium.org,
        evgreen@chromium.org, andersson@kernel.org,
        quic_cpratapa@quicinc.com, quic_avuyyuru@quicinc.com,
        quic_jponduru@quicinc.com, quic_subashab@quicinc.com,
        elder@kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20230215195352.755744-1-elder@linaro.org>
 <20230215195352.755744-3-elder@linaro.org>
 <b0b2ae77-3311-34c8-d1a2-c6f30eca3f1e@intel.com>
 <c76bbb06-b6b0-8dae-965f-95e8af3634b6@linaro.org>
 <4c92160f-b2ea-c5ef-5647-6078ab47e518@intel.com>
 <a919afca-d33e-618d-5db3-17a08d90e8af@linaro.org>
Content-Language: en-US
From:   Alex Elder <elder@ieee.org>
In-Reply-To: <a919afca-d33e-618d-5db3-17a08d90e8af@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/17/23 7:04 AM, Alex Elder wrote:
> On 2/17/23 5:57 AM, Alexander Lobakin wrote:
>>>> just devm_platform_ioremap_resource_byname() be used here for 
>>>> simplicity?
>>> Previously, virt_raw would be the "real" re-mapped pointer, and then
>>> virt would be adjusted downward from that.  It was a weird thing to
>>> do, because the result pointed to a non-mapped address.  But all uses
>>> of the virt pointer added an offset that was enough to put the result
>>> into the mapped range.
>>>
>>> The new code updates all offsets to account for what the adjustment
>>> previously did.  The test that got removed isn't necessary any more.
>> Yeah I got it, just asked that maybe you can now use
>> platform_ioremap_resource_byname() instead of
>> platform_get_resource_byname() + ioremap() :)
> 
> Sorry, I focused on the "devm" part and not this part.
> Yes I like that, but let me do that as a follow-on
> patch, and I think I can do it in more than this
> spot (possibly three, but I have to look closely).

Looking at this today, the only OF functions that look up a
resource and I/O remap it in one call are devm_*() variants.
There is no platform_ioremap_resource_byname() function.

One that's available is devm_platform_ioremap_resource_byname(),
which could possibly be used in the two locations that call
platform_get_resource_byname() followed by ioremap().

As I said earlier, if I were to use any devm_*() function
calls the driver, I would want to convert *everything* to
use devm_*() variants, and I have no plans to do that at
this time.

So I will not be implementing your suggestion.

					-Alex

> Thanks.
> 
>                      -Alex
> 
> 

