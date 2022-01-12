Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81FE648CA8C
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 19:01:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355862AbiALSBf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 13:01:35 -0500
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.48]:43316 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1348660AbiALSBN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 13:01:13 -0500
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.202])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 49E2C2007E;
        Wed, 12 Jan 2022 18:01:11 +0000 (UTC)
Received: from mail3.candelatech.com (mail2.candelatech.com [208.74.158.173])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 973F2800AF;
        Wed, 12 Jan 2022 18:01:10 +0000 (UTC)
Received: from [192.168.1.115] (unknown [98.97.67.209])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail3.candelatech.com (Postfix) with ESMTPSA id DCCD713C2B0;
        Wed, 12 Jan 2022 10:01:09 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com DCCD713C2B0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
        s=default; t=1642010470;
        bh=/2pmvodx4C94mfMl6LbkvNEeKhQmSTHTGSZHgKh09JI=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=G7XQElhpvfwgG/G4DT2IjPClGdgPa16wcsiOPnlac1AJj1K58RP4flp/x1P8nKFlk
         oUJ1zJ9RdW5IQ/IVb7fudoSggDDU5zkQBTOneHBQyZI0aW4kyMV6EdkUoGYBiJKyVW
         Rw9/PTbjmP84yZNO9nyBRiu1b8gky8pZLw0qC7E0=
Subject: Re: Debugging stuck tcp connection across localhost [snip]
To:     Eric Dumazet <edumazet@google.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        Neal Cardwell <ncardwell@google.com>,
        netdev <netdev@vger.kernel.org>
References: <38e55776-857d-1b51-3558-d788cf3c1524@candelatech.com>
 <CADVnQyn97m5ybVZ3FdWAw85gOMLAvPSHiR8_NC_nGFyBdRySqQ@mail.gmail.com>
 <b3e53863-e80e-704f-81a2-905f80f3171d@candelatech.com>
 <CADVnQymJaF3HoxoWhTb=D2wuVTpe_fp45tL8g7kaA2jgDe+xcQ@mail.gmail.com>
 <a6ec30f5-9978-f55f-f34f-34485a09db97@candelatech.com>
 <CADVnQym9LTupiVCTWh95qLQWYTkiFAEESv9Htzrgij8UVqSHBQ@mail.gmail.com>
 <b60aab98-a95f-d392-4391-c0d5e2afb2cd@candelatech.com>
 <9330e1c7-f7a2-0f1e-0ede-c9e5353060e3@candelatech.com>
 <0b2b06a8-4c59-2a00-1fbc-b4734a93ad95@gmail.com>
 <c84d0877-43a1-9a52-0046-e26b614a5aa6@candelatech.com>
 <CANn89iL=690zdpCS7g1vpZdZCHsj0O1MrOjGkcg0GPLVhjr4RQ@mail.gmail.com>
 <a7056912-213d-abb9-420d-b7741ae5db8a@candelatech.com>
 <CANn89i+HnhfCKUVxtVhQ1vv74zO1tEwT2yXcCX_OoXf14WGAQg@mail.gmail.com>
From:   Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
Message-ID: <a503d7b8-b015-289c-1a8a-eb4d5df7fb12@candelatech.com>
Date:   Wed, 12 Jan 2022 10:01:09 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <CANn89i+HnhfCKUVxtVhQ1vv74zO1tEwT2yXcCX_OoXf14WGAQg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-MW
Content-Transfer-Encoding: 7bit
X-MDID: 1642010471-LgdMSmaCU-3p
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/12/22 9:12 AM, Eric Dumazet wrote:
> On Wed, Jan 12, 2022 at 6:52 AM Ben Greear <greearb@candelatech.com> wrote:
>>
>> On 1/11/22 11:41 PM, Eric Dumazet wrote:
>>> On Tue, Jan 11, 2022 at 1:35 PM Ben Greear <greearb@candelatech.com> wrote:
>>>>
>>>> On 1/11/22 2:46 AM, Eric Dumazet wrote:
>>>>>

>>> Just to clarify:
>>>
>>> Have you any qdisc on lo interface ?
>>>
>>> Can you try:
>>> diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
>>> index 5079832af5c1090917a8fd5dfb1a3025e2d85ae0..81a26ce4d79fd48f870b5c1d076a9082950e2a57
>>> 100644
>>> --- a/net/ipv4/tcp_output.c
>>> +++ b/net/ipv4/tcp_output.c
>>> @@ -2769,6 +2769,7 @@ bool tcp_schedule_loss_probe(struct sock *sk,
>>> bool advancing_rto)
>>>    static bool skb_still_in_host_queue(struct sock *sk,
>>>                                       const struct sk_buff *skb)
>>>    {
>>> +#if 0
>>>           if (unlikely(skb_fclone_busy(sk, skb))) {
>>>                   set_bit(TSQ_THROTTLED, &sk->sk_tsq_flags);
>>>                   smp_mb__after_atomic();
>>> @@ -2778,6 +2779,7 @@ static bool skb_still_in_host_queue(struct sock *sk,
>>>                           return true;
>>>                   }
>>>           }
>>> +#endif
>>>           return false;
>>>    }
>>>
>>
>> I will try that today.
>>
>> I don't think I have qdisc on lo:
>>
>> # tc qdisc show|grep 'dev lo'
>> qdisc noqueue 0: dev lo root refcnt 2
> 
> Great, I wanted to make sure you were not hitting some bug there
> (pfifo_fast has been buggy for many kernel versions)
> 
>>
>> The eth ports are using fq_codel, and I guess they are using mq as well.
>>
>> We moved one of the processes off of the problematic machine so that it communicates over
>> Ethernet instead of 'lo', and problem seems to have gone away.  But, that also
>> changes system load, so it could be coincidence.
>>
>> Also, conntrack -L showed nothing on a machine with simpler config where the two problematic processes
>> are talking over 'lo'.  The machine that shows problem does have a lot of conntrack entries because it
>> is also doing some NAT for other data connections, but I don't think this should affect the 127.0.0.1 traffic.
>> There is a decent chance I mis-understand your comment about conntrack though...
> 
> This was a wild guess. Honestly, I do not have a smoking gun yet.

I tried your patch above, it did not help.

Also, looks like maybe we reproduced same issue with processes on different
machines, but I was not able to verify it was the same root cause, and at
least, it was harder to reproduce.

I'm back to testing in the easily reproducible case now.

I have a few local patches in the general networking path, I'm going to
attempt to back those out just in case my patches are buggy.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
