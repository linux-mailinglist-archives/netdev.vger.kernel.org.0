Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 929123A3617
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 23:38:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230077AbhFJVko (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 17:40:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229961AbhFJVkn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 17:40:43 -0400
Received: from mail-ot1-x329.google.com (mail-ot1-x329.google.com [IPv6:2607:f8b0:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BAE2C061574
        for <netdev@vger.kernel.org>; Thu, 10 Jun 2021 14:38:47 -0700 (PDT)
Received: by mail-ot1-x329.google.com with SMTP id 6-20020a9d07860000b02903e83bf8f8fcso1126757oto.12
        for <netdev@vger.kernel.org>; Thu, 10 Jun 2021 14:38:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ieee.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=SpNN+AXXHfxpEVep3vQpF/ecsEUb6Lp2ZvyEY9AUsEg=;
        b=HECdxmdMMOIliEYytMoL2cIUIemVwiFqYGmrsJaFWjN+mv9JNwZQwgZWePouI/ubo0
         oqs5LSbc27ytGu2DvDTs876tt2OkaQnStdNT3Gl3NdXk1Tfucxlp2Hq1a/MmZW9nbCCo
         peg4HaEO/cf1Sjz1YQiRTsZUwCCt/mvOL/rl0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SpNN+AXXHfxpEVep3vQpF/ecsEUb6Lp2ZvyEY9AUsEg=;
        b=MTlt9Hc6+RsUqttdFEsRDkpDx1Epcbng/RRL8iFRmzuSZEekgUg3F28XrNIRMkuCm5
         VFfvRQ5nxLa9coYeW2SAF2IAGrUgzftf4UoMfeLA1sIcv7ck8Ga6xy/LaqGOSM0BFs6s
         vwXeUCYasZOMWUCbpOWG3vQU2qw6wgR3qxn32+5vHu/QfMak/+MBnnmkQUP0G/8OpgIj
         /ZWqTP2SNEUFOWmkgujKTr6R0ipIOeIPgmWjySGVFEtorQDjXJKY8MqD9ih5luI7Jcxq
         q5Mzfffz1MpfFLkK55UVnQlBp3K7BYfIYIsDafFM0OgRB0oG2afVLvq/6VC7yIhhvn+K
         xSEg==
X-Gm-Message-State: AOAM531wYezsNgxSVFCFdaKzYCl0JSxTBdOXpPfHi7YBLXkEsLhS1MUP
        PS9j4sw45SqHc8kKB0cGfB7Iyg==
X-Google-Smtp-Source: ABdhPJywu9SyHkna+eTSCkc4gDKPf1YqdnpsFOyutZ8FRoRFghL3mNFAeyzGwVbek/pqPieT4QSqQQ==
X-Received: by 2002:a9d:a78:: with SMTP id 111mr362764otg.93.1623361126070;
        Thu, 10 Jun 2021 14:38:46 -0700 (PDT)
Received: from [172.22.22.4] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id p25sm772788ood.4.2021.06.10.14.38.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Jun 2021 14:38:45 -0700 (PDT)
Subject: Re: [PATCH] soc: qcom: ipa: Remove superfluous error message around
 platform_get_irq()
To:     David Miller <davem@davemloft.net>, hbut_tan@163.com
Cc:     elder@kernel.org, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, tanzhongjun@yulong.com
References: <20210610140118.1437-1-hbut_tan@163.com>
 <20210610.141142.1384244468678097702.davem@davemloft.net>
From:   Alex Elder <elder@ieee.org>
Message-ID: <a3765a86-bb9e-b5f8-32a1-3c3fa939bb4e@ieee.org>
Date:   Thu, 10 Jun 2021 16:38:43 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210610.141142.1384244468678097702.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/10/21 4:11 PM, David Miller wrote:
> From:  Zhongjun Tan <hbut_tan@163.com>
> Date: Thu, 10 Jun 2021 22:01:18 +0800
> 
>> diff --git a/drivers/net/ipa/ipa_smp2p.c b/drivers/net/ipa/ipa_smp2p.c
>> index 34b68dc43886..93270e50b6b3 100644
>> --- a/drivers/net/ipa/ipa_smp2p.c
>> +++ b/drivers/net/ipa/ipa_smp2p.c
>> @@ -177,11 +177,8 @@ static int ipa_smp2p_irq_init(struct ipa_smp2p *smp2p, const char *name,
>>   	int ret;
>>   
>>   	ret = platform_get_irq_byname(smp2p->ipa->pdev, name);
>> -	if (ret <= 0) {
>> -		dev_err(dev, "DT error %d getting \"%s\" IRQ property\n",
>> -			ret, name);
>> +	if (ret <= 0)
> Applied, but this code still rejects an irq of zero which is a valid irq number.

It rejects IRQ 0 intentionally.  And if 0 is returned, there
will now be no message printed by the platform code.

As I recall, I looked for a *long* time to see whether IRQ 0
was a valid IRQ number in Linux.  One reason I even questioned
it is that NO_IRQ is defined with value 0 on some architectures
(though not for Arm).  I even asked Rob Herring about privately
it a few years back and he suggested I shouldn't allow 0.

Yes, it *looked* like IRQ 0 could be a valid return.  But I
decided it was safer to just reject it, on the assumption
that it's unlikely to be returned (I don't believe it is
or ever will be used as the IRQ for SMP2P).

If you are certain it's valid, and should be allowed, I
have no objection to changing that "<=" to be "<".

					-Alex

PS  A quick search found this oldie:
       https://yarchive.net/comp/linux/no_irq.html
