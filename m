Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D61BB2994B4
	for <lists+netdev@lfdr.de>; Mon, 26 Oct 2020 19:01:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1788975AbgJZSBY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 14:01:24 -0400
Received: from mail-qv1-f66.google.com ([209.85.219.66]:34377 "EHLO
        mail-qv1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1781825AbgJZSBH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Oct 2020 14:01:07 -0400
Received: by mail-qv1-f66.google.com with SMTP id g13so4734466qvu.1
        for <netdev@vger.kernel.org>; Mon, 26 Oct 2020 11:01:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=LgEmvPnieTjZ9vkGwx+rj6nfhQfOzO1tc75gFUYXtjY=;
        b=z+6AFufIg/5jSTP8ub2to5a2LGG/wfnw8rMS1Remb4tDtTWcE78OEKuYBQE75zPg5c
         5+vw7KeZGpjzzx0XFF1QHRfKc5rTp0wb77BaISnSP1tumNLIITfCJb+5U7ne47KXSqRI
         f54FTv2dGiXTo3oF7tdZHtj+K+FpuhaNwBD+XEhcq0Y225pX3em2boerRaz/zpP7QcFx
         tbThXrxnHj00HB99Hwh3lObCHbD10ZXCSH+6k726GZZTnqx8XpLrlZTfDpbwiZ4JSfM2
         KHxx8iTXsSbDN9061b13Ryo0LVuLenNVdJY9IpxKsw7+bzdcss9tlHMV4B5Ao9/lTHnX
         iUKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LgEmvPnieTjZ9vkGwx+rj6nfhQfOzO1tc75gFUYXtjY=;
        b=IwfHrQVTOhlpOFBOxWadL4EF6LG2ZLDKgOskwLr+LFN2O8zgY3RI/AIaiPdQsNAYl/
         WY5BF147uHNvwLx/9KeQSWbXju1A+T20CH3+54PB3Q6huJYiL8nYdUArGX9Us+TzAvCm
         oojMTuEMkqPR594EYbxs09md92H+xf5eALFqiy2xgM2MpUq88epIJ7gpquVAbyYQImY4
         HqizgSqSgDraGOVdNtAkSYdqTYdGM+VX24pxcCu1hZLy+P750XAOstwNdW1iJXWn6eSC
         FpXwIDMvHI3Jejsqo50nMpGhUhgk6dq82s6YDGrx9u91otFZrMw01GoPk+Y8AbhJtkMl
         rACw==
X-Gm-Message-State: AOAM533hZqZ2u/4IIQiZx8GU5SLBo3IQaUMOl0QdfSzuMUUhfsTp+i44
        9D4mlgObwUIMCKWKf4XwXba4Jw==
X-Google-Smtp-Source: ABdhPJz+WpzILVLNZ1A8/fiKqTVNjRoPLNuQKmPHLlx3BsO/jgbUaApvKVPgRnLU+b7NbpDzyX9DRA==
X-Received: by 2002:a05:6214:1188:: with SMTP id t8mr14927453qvv.18.1603735266314;
        Mon, 26 Oct 2020 11:01:06 -0700 (PDT)
Received: from [192.168.2.28] (bras-base-kntaon1617w-grc-10-184-147-165-106.dsl.bell.ca. [184.147.165.106])
        by smtp.googlemail.com with ESMTPSA id 128sm6821627qkm.76.2020.10.26.11.01.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Oct 2020 11:01:04 -0700 (PDT)
Subject: Re: [PATCH iproute2-next v3 2/2] tc: implement support for terse dump
To:     Vlad Buslov <vladbu@nvidia.com>
Cc:     Vlad Buslov <vlad@buslov.dev>, dsahern@gmail.com,
        stephen@networkplumber.org, netdev@vger.kernel.org,
        davem@davemloft.net, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        ivecera@redhat.com, Vlad Buslov <vladbu@mellanox.com>
References: <20201016144205.21787-1-vladbu@nvidia.com>
 <20201016144205.21787-3-vladbu@nvidia.com>
 <0bb6f625-c987-03d7-7225-eee03345168e@mojatatu.com>
 <87a6wm15rz.fsf@buslov.dev>
 <ac25fd12-0ba9-47c2-25d7-7a6c01e94115@mojatatu.com>
 <877drn20h3.fsf@buslov.dev>
 <b8138715-8fd7-cbef-d220-76bdb8c52ba5@mojatatu.com>
 <87362a1byb.fsf@buslov.dev>
 <5c79152f-1532-141a-b1d3-729fdd798b3f@mojatatu.com>
 <ygnh8sc03s9u.fsf@nvidia.com>
 <e91b2fe6-e2ca-21c7-0d7e-714e5cccc28c@mojatatu.com>
 <ygnh4kml9kh3.fsf@nvidia.com>
 <89a5434b-06e9-947a-d364-acd2a306fc4d@mojatatu.com>
 <ygnh7drdz0nf.fsf@nvidia.com>
 <370dd8e0-315b-04a5-c137-3b4f3cbd02a0@mojatatu.com>
 <ygnhwnzc6ft5.fsf@nvidia.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <940495a7-d828-7439-a9c3-1e3bde6b02fb@mojatatu.com>
Date:   Mon, 26 Oct 2020 14:01:03 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <ygnhwnzc6ft5.fsf@nvidia.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-10-26 1:46 p.m., Vlad Buslov wrote:
> 
> On Mon 26 Oct 2020 at 19:12, Jamal Hadi Salim <jhs@mojatatu.com> wrote:
>> On 2020-10-26 7:28 a.m., Vlad Buslov wrote:
>>>
>>> On Sat 24 Oct 2020 at 20:40, Jamal Hadi Salim <jhs@mojatatu.com> wrote:
>>
>> [..]
>>>>>
>>>>> Yes, that makes sense. I guess introducing something like 'tc action -br
>>>>> ls ..' mode implemented by means of existing terse flag + new 'also
>>>>> output action index' flag would achieve that goal.
>>>>>
>>>>
>>>> Right. There should be no interest in the cookie here at all. Maybe
>>>> it could be optional with a flag indication.
>>>> Have time to cook a patch? I'll taste/test it.
>>>
>>> Patch to make cookie in filter terse dump optional? That would break
>>> existing terse dump users that rely on it (OVS).
>>
>> Meant patch for 'tc action -br ls'
>>
>> Which by default would not include the cookie.
> 
> So action-dump-specific flag that causes act api to output action index
> (via new attribute) and skips cookie?
> 

yeah, something like TCA_ACT_FLAGS_TERSE.

new tcf_action_dump_terse() takes one more field which says to
include or not the cookies since that is shared code and filters
can always include it.
The action index is already present in the passed tc_action
struct just needs a new TLV.


cheers,
jamal
