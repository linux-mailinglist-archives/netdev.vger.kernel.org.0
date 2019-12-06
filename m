Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF68C115137
	for <lists+netdev@lfdr.de>; Fri,  6 Dec 2019 14:41:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726317AbfLFNlE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Dec 2019 08:41:04 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:33763 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726245AbfLFNlE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Dec 2019 08:41:04 -0500
Received: by mail-pg1-f193.google.com with SMTP id 6so3352177pgk.0;
        Fri, 06 Dec 2019 05:41:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=3EFCJeRV2jMf+iQ+j1NhNnzIhn47IDN/JAAO+nGlAGU=;
        b=rn0r9y4MNjQb5vsu88mzLjNm0oUlpl/NY+ttecEbHb2mr82tElxKnFHiEE49UMuLFu
         2GDmEqj7H+Z/pNuhLTQzgpzB1xoQ3LseCus1xviES7APeu2ZPo/piNpI70zRsqe8jYI4
         n9lxAtkegvvyEBBZk4Tyk2RA6FpoC1ExcvjEhFnAmHWJdz558NEYdaackd3r6HQmbfDF
         KZRF4RTuB0zhQ8uP3bmAFrKd2GSdxq5cxrmqinmkjOSmGNzRoW6S1RD1b2xpPXBDBmJL
         X7NHGhNHXMELfqLJSSxwEikYAF97tpZD8svdq3TCzvPna+21CSwqgWUALGjWX6DcITNq
         NZ1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3EFCJeRV2jMf+iQ+j1NhNnzIhn47IDN/JAAO+nGlAGU=;
        b=FCbCzRpFvFZ2UyV8fe1kRc316Eemcs3wZuQUrOH5sb2oCrHfxe1ADOh3eHv/PYgcJc
         7ROBvMqbolwX6Mg75pAToF+M6arEltKDfip4dIjVUBvxQoE5y4F+aAJtMXlgwHYQ/Mlx
         e6rmOpSeLxbBOnMzlHRpBPqroRRV29O8aiVuqrLwKm9l1Z3b5R+q4hzguj0Ym8A+iJ+k
         YW/Cp02yFXuTEtRQFuWywo0cE1KqGWlaZzvW5phtXKV36eTDdgzP6qhkMlBZQUIb62aD
         mu0mAlGs4K2cCqcHw1dsiH9v2v3c17Mzj/ePn0u2VfaR9nvls3vCOT6EdlWg8jPMswNk
         W18Q==
X-Gm-Message-State: APjAAAUzSla3A49oNY0dENjHdW03fNbrIQnScPx67jNnkbJFZp4t4K+U
        gF7Ou8E+Y1FJcI/ydStRs8k=
X-Google-Smtp-Source: APXvYqy+STqdn3H3r8DJnP94GB2uQbw7gMpPHzPAmc32MRNlyiXZJqgSHJ+AG0RxOsAQuQNQp/BUIQ==
X-Received: by 2002:a62:ea19:: with SMTP id t25mr14534879pfh.74.1575639663699;
        Fri, 06 Dec 2019 05:41:03 -0800 (PST)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id f24sm3398977pjp.12.2019.12.06.05.41.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Dec 2019 05:41:02 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH] selftests: net: ip_defrag: increase netdev_max_backlog
To:     Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, shuah@kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        posk@google.com
References: <20191204195321.406365-1-cascardo@canonical.com>
 <483097a3-92ec-aedd-60d9-ab7f58b9708d@gmail.com>
 <20191206121707.GC5083@calabresa>
Message-ID: <d2dddb34-f126-81f8-cbf7-04635f04795a@gmail.com>
Date:   Fri, 6 Dec 2019 05:41:01 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191206121707.GC5083@calabresa>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/6/19 4:17 AM, Thadeu Lima de Souza Cascardo wrote:
> On Wed, Dec 04, 2019 at 12:03:57PM -0800, Eric Dumazet wrote:
>>
>>
>> On 12/4/19 11:53 AM, Thadeu Lima de Souza Cascardo wrote:
>>> When using fragments with size 8 and payload larger than 8000, the backlog
>>> might fill up and packets will be dropped, causing the test to fail. This
>>> happens often enough when conntrack is on during the IPv6 test.
>>>
>>> As the larger payload in the test is 10000, using a backlog of 1250 allow
>>> the test to run repeatedly without failure. At least a 1000 runs were
>>> possible with no failures, when usually less than 50 runs were good enough
>>> for showing a failure.
>>>
>>> As netdev_max_backlog is not a pernet setting, this sets the backlog to
>>> 1000 during exit to prevent disturbing following tests.
>>>
>>
>> Hmmm... I would prefer not changing a global setting like that.
>> This is going to be flaky since we often run tests in parallel (using different netns)
>>
>> What about adding a small delay after each sent packet ?
>>
>> diff --git a/tools/testing/selftests/net/ip_defrag.c b/tools/testing/selftests/net/ip_defrag.c
>> index c0c9ecb891e1d78585e0db95fd8783be31bc563a..24d0723d2e7e9b94c3e365ee2ee30e9445deafa8 100644
>> --- a/tools/testing/selftests/net/ip_defrag.c
>> +++ b/tools/testing/selftests/net/ip_defrag.c
>> @@ -198,6 +198,7 @@ static void send_fragment(int fd_raw, struct sockaddr *addr, socklen_t alen,
>>                 error(1, 0, "send_fragment: %d vs %d", res, frag_len);
>>  
>>         frag_counter++;
>> +       usleep(1000);
>>  }
>>  
>>  static void send_udp_frags(int fd_raw, struct sockaddr *addr,
>>
> 
> That won't work because the issue only shows when we using conntrack, as the
> packet will be reassembled on output, then fragmented again. When this happens,
> the fragmentation code is transmitting the fragments in a tight loop, which
> floods the backlog.

Interesting !

So it looks like the test is correct, and exposed a long standing problem in this code.

We should not adjust the test to some kernel-of-the-day-constraints, and instead fix the kernel bug ;)

Where is this tight loop exactly ?

If this is feeding/bursting ~1000 skbs via netif_rx() in a BH context, maybe we need to call a variant
that allows immediate processing instead of (ab)using the softnet backlog.

Thanks !
