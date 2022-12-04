Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5136364207E
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 00:15:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230388AbiLDXNP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Dec 2022 18:13:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229954AbiLDXNO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Dec 2022 18:13:14 -0500
Received: from mail-oi1-x235.google.com (mail-oi1-x235.google.com [IPv6:2607:f8b0:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9931CF03D
        for <netdev@vger.kernel.org>; Sun,  4 Dec 2022 15:13:13 -0800 (PST)
Received: by mail-oi1-x235.google.com with SMTP id s186so11076647oia.5
        for <netdev@vger.kernel.org>; Sun, 04 Dec 2022 15:13:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=UJpyFvUyUtxsBTLM/XucvE7iM+6xRJD98sJzNgeyIJk=;
        b=20GQto+zPsCpJYQE8+PxT5z6UZTXvNSsYvpF5Kpg9wnnmHjBS93SuhUlVclyNaz4Te
         b34qTq/WgdTW/BMKwDZxlkPIExzsAKih7AEKqvRJFf0zr7O3Wrop8ormzP6vhZWae9Aq
         iv1VuFreWMEGcrEc4Np/9THe/ztZnTwX4WuGHOF0wRJOP4fCheah8b+34biVOg7yQhrS
         zqOmBbVFVOCx356XyZvNk14AtQYMjFozasU9vlsxaWYt/94u+Vfpd4qKFWRa6ZjnEFwu
         bI8I3veA1jE+DCkv5btiR5cQEus0hcvmsWEGCYeW/hTiwMeZDgMVHOKDdXtQBmet5pHo
         Zb3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UJpyFvUyUtxsBTLM/XucvE7iM+6xRJD98sJzNgeyIJk=;
        b=qqOT3AQ5DcPaIALH/ogr2eiBRDsn5vWXACBrfrGjsdWJn4lbwTptKv6ol5xLjAq6FE
         ZZ2vBejkhFss8+fCzVklJRtHmE+63l0neFTaQBjBX+17xKnQkcAVqhFv4U3BpP1HOf+G
         QiljGXLnxR0+6AB/uHHXyy/Q33JTO4hZxd+s+8rkGmCVV/n9z/P9Jor3mKee4vdM1hUc
         KoUVde1HLSKbwN6y4O4+MEIu0+EDjeW0IMi9nBKX2WfuLhyma3j7C/0P2TBmcxEoTEDi
         Sflv8xWTHvxLDYoDBfIWdJo7GyjSBaC6o5ZKWz9YdnzosrlO0/IAxWN1+1iTAm1f5T3J
         MFLA==
X-Gm-Message-State: ANoB5pk5oZYgHdz4SgrdBwfVqrWxf4ygUzpAzB6jUD1F+ElxJY6lNrPj
        NawnLqeff28TIAhhfxAIeZYwOA==
X-Google-Smtp-Source: AA0mqf4kUOqgS2tHCaRB6/T5xoTDh+La5KYHrzWR/sM1UgDFNv0ap7Zdfx/DytV03el7Xq/2nbmmsQ==
X-Received: by 2002:aca:e057:0:b0:35b:ae45:b9e9 with SMTP id x84-20020acae057000000b0035bae45b9e9mr17509031oig.201.1670195592936;
        Sun, 04 Dec 2022 15:13:12 -0800 (PST)
Received: from ?IPV6:2804:14d:5c5e:4698:8d0f:4b58:d430:8c9c? ([2804:14d:5c5e:4698:8d0f:4b58:d430:8c9c])
        by smtp.gmail.com with ESMTPSA id r41-20020a05687017a900b0014378df87cfsm8050543oae.33.2022.12.04.15.13.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 04 Dec 2022 15:13:12 -0800 (PST)
Message-ID: <dfa52acc-f95c-5e7e-b84b-b54b2903ac9f@mojatatu.com>
Date:   Sun, 4 Dec 2022 20:13:07 -0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH net-next v2 0/3] net/sched: retpoline wrappers for tc
Content-Language: en-US
To:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Pedro Tammela <pctammela@gmail.com>, netdev@vger.kernel.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, kuniyu@amazon.com
References: <20221128154456.689326-1-pctammela@mojatatu.com>
 <2e0a2888c89db8226578106b0a7a3eeda7c94582.camel@redhat.com>
 <CAM0EoM=5GZJMrEk8-T+rp+jFHzPy7jDqV_ogQ2p57x0KmnDvnQ@mail.gmail.com>
From:   Pedro Tammela <pctammela@mojatatu.com>
In-Reply-To: <CAM0EoM=5GZJMrEk8-T+rp+jFHzPy7jDqV_ogQ2p57x0KmnDvnQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 01/12/2022 09:34, Jamal Hadi Salim wrote:
> On Thu, Dec 1, 2022 at 6:05 AM Paolo Abeni <pabeni@redhat.com> wrote:
>>
>> On Mon, 2022-11-28 at 12:44 -0300, Pedro Tammela wrote:
> 
> [..]
> 
>>> We observed a 3-6% speed up on the retpoline CPUs, when going through 1
>>> tc filter,
>>
>> Do yu have all the existing filters enabled at build time in your test
>> kernel? the reported figures are quite higher then expected considering
>> there are 7th new unlikely branch in between.
>>
> 
> That can be validated with a test that compiles a kernel with a filter under
> test listed first then another kernel with the same filter last.
> 
> Also given these tests were using 64B pkts to achieve the highest pps, perhaps
> using MTU sized pkts with pktgen would give more realistic results?
> 
> In addition to the tests for 1 and 100 filters...
> 
>> Also it would be nice to have some figure for the last filter in the if
>> chain. I fear we could have some regressions there even for 'retpoline'
>> CPUs - given the long if chain - and u32 is AFAIK (not much actually)
>> still quite used.
>>
> 
> I would say flower and bpf + u32 are probably the highest used,
> but given no available data on this usage beauty is in the eye of
> the beholder. I hope it doesnt become a real estate battle like we
> have in which subsystem gets to see packets first or last ;->
> 
>> Finally, it looks like the filter order in patch 1/3 is quite relevant,
>> and it looks like you used the lexicographic order, I guess it should
>> be better to sort them by 'relevance', if someone could provide a
>> reasonable 'relevance' order. I personally would move ife, ipt and
>> simple towards the bottom.
> 
> I think we can come up with some reasonable order.
> 
> cheers,
> jamal

We got a new system with a 7950x and I had some free time today to test 
out the classifier order with v3, which I will post soon.

64b pps:
baseline - 5914980
first - 6397116 (+8.15%)
last - 6362476 (+7.5%)

1500b pps:
baseline - 6367965
first - 6754578 (+6.07%)
last - 6745576 (+5.9%)

The difference between first to last is minimal, but it exists.
DDR5 seems to give a nice boost on pps for this test, when compared to 
the 5950x. Which makes sense, since it's quite heavy on the memory 
allocator.
