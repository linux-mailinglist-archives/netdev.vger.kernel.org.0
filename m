Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A63DF4A4F8D
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 20:38:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377172AbiAaTiE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 14:38:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377169AbiAaTh7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 14:37:59 -0500
Received: from mail-qt1-x82a.google.com (mail-qt1-x82a.google.com [IPv6:2607:f8b0:4864:20::82a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 208E3C061714
        for <netdev@vger.kernel.org>; Mon, 31 Jan 2022 11:37:59 -0800 (PST)
Received: by mail-qt1-x82a.google.com with SMTP id r14so12426413qtt.5
        for <netdev@vger.kernel.org>; Mon, 31 Jan 2022 11:37:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=W43Azmt4hVs3M3A/l5UhCA/0dpd57oBu82PIuZI4sCg=;
        b=UioOxDzDDYC16M7LVhz0vrAiGuYYV57ecFBeT9uHQsSuZOAENCViopFiGjPZtzrO9B
         3Vg/Pi7V7nbyn8ZBouTt+N/qajrvWbUSmM0GT6Cg4WWaQ3FLgIgL391iOB81NwRx9KI9
         kL2NBb25ls2+LjSmg5NgDUhfkOFhZ1f9XSgU8LRpfUdkdyDl9DxBLtBNXyi+5GFNsJC3
         bzQv1hx8tUgn/B9GqnHwwdyow2ytt+7G0lBnNhu89/4c2OCV91i4zXCrXbf2iF4ZH13l
         SR2R5QCuWUWzzF5Rn0cgN4woZsIBRWh/xk2CM1AblqQCmdfklxMI7f/JKEyuzlXGEhQV
         20Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=W43Azmt4hVs3M3A/l5UhCA/0dpd57oBu82PIuZI4sCg=;
        b=Wo0th3x03gq3okmGuFeFlgmD9TiWtf67traIJUOiDAj8dND9uyGT5tUUF9KOb06ADz
         q5fWCvcajwArJMRl3wbVYpbMkuIBDgFl2849frQ4c125+YdRdSew045XiX02Aj0y79z6
         EOr9NfcJBcIFYXCCvhoJfCnBh4N7ANYxSkRW1761yr4ivGN+VAKcGi1M6cv6qJ6zAX4V
         hYJ1d0XyF7nOSJQc3Ru4v+7shENg1rvyuXnzsa8+1fCIydepAWrlhvb4fm9wL5wL6BhP
         Se8lhVXSNv96WWIwAsjBFhY+HyAUWv2bTN966Jyfm0yuMGlMVRWR1qidarb3foP3DFBo
         5t4A==
X-Gm-Message-State: AOAM5334uIKxPOUT8iChBN1bWh9ZfEdTV16nAGPkoM0Asj3/N8niTkR5
        /LopLQ03cXCZsxcsp7yBZJ/saP407lGzbw==
X-Google-Smtp-Source: ABdhPJwAF37676CvlgfyY61B9NhZqSN83BWXKuSWWsXw9DDcRZyfhrr9SWpNZj8XLrdRpEt8dC2BwQ==
X-Received: by 2002:a05:622a:11ca:: with SMTP id n10mr16134077qtk.567.1643657878234;
        Mon, 31 Jan 2022 11:37:58 -0800 (PST)
Received: from [192.168.1.173] (bras-base-kntaon1617w-grc-28-184-148-47-74.dsl.bell.ca. [184.148.47.74])
        by smtp.googlemail.com with ESMTPSA id w5sm9391471qko.34.2022.01.31.11.37.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 31 Jan 2022 11:37:57 -0800 (PST)
Message-ID: <20320139-9b94-8c64-21e9-2fb2f2b34943@mojatatu.com>
Date:   Mon, 31 Jan 2022 14:37:56 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [PATCH iproute2 v3 1/2] tc: u32: add support for json output
Content-Language: en-US
To:     David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Andrea Claudi <aclaudi@redhat.com>
Cc:     netdev@vger.kernel.org, Wen Liang <wenliang@redhat.com>,
        David Ahern <dsahern@kernel.org>,
        Victor Nogueira <victor@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Davide Caratti <dcaratti@redhat.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Vlad Buslov <vladbu@nvidia.com>
References: <cover.1641493556.git.liangwen12year@gmail.com>
 <0670d2ea02d2cbd6d1bc755a814eb8bca52ccfba.1641493556.git.liangwen12year@gmail.com>
 <20220106143013.63e5a910@hermes.local> <Ye7vAmKjAQVEDhyQ@tc2>
 <20220124105016.66e3558c@hermes.local> <Ye8abWbX5TZngvIS@tc2>
 <20220124164354.7be21b1c@hermes.local>
 <848d9baa-76d1-0a60-c9e4-7d59efbc5cbc@mojatatu.com>
 <a7ec49d5-8969-7999-43c4-12247decae9e@gmail.com>
 <78ac271a-7d00-7526-54b5-2aabb5b3a3ba@mojatatu.com>
 <72312384-7b8d-5c14-4e23-ed92be41ff53@gmail.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
In-Reply-To: <72312384-7b8d-5c14-4e23-ed92be41ff53@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-01-31 10:50, David Ahern wrote:
> On 1/31/22 5:54 AM, Jamal Hadi Salim wrote:
>>>> Do you need a patch for that in some documentation?
>>>>
>>>
>>> How about adding some comments to README.devel?
>>
>>
>> Sure - but it wont be sufficient IMO.
>> Best course of action is for the maintainers to remind people to run
>> tests.
> 
> Above, you said the tests were meant for bots.
> 

The invocation that tdc.sh makes is targeted for the bots.
It only tests actions and qdiscs.
If you run  ./tdc.py -h you'll see more options.

>>
>> BTW: We found out that Stephen's patches still break the latest -next.
>>
> 
> ugh. I committed them after running tdc.sh and not seeing a change in
> output. We'll need fixup patches then.
> 
> Clearly some work is needed on getting the test suite usable by a wider
> audience. I am new to running those tests as well and probably had some
> pilot errors running them.
> 

One of the issues is sometimes some of the tests take a while to
complete, so some tweaking of the timer may be needed depending on your
setup etc. Probably that is what you may be running into.

> I do wait for ACKs from tc folks, but can't wait forever. Right now
> there is the 'skip_hw' and 'skip_sw' patch that Victor sent a Tested-by.
> When I apply that v2 patch, I see errors in the tdc.sh output so my
> mileage varies from Victor's. There is also the v5 of this set which I
> have no applied yet; it could use some acks and tdc testing as well.

ok. Punting to Victor for testing the v5 - was it posted on the list?
I will Ack Bowen's patch.

cheers,
jamal
