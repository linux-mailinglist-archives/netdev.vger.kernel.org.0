Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81C5267D7E1
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 22:43:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232770AbjAZVnS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 16:43:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbjAZVnR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 16:43:17 -0500
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6620F32511
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 13:43:14 -0800 (PST)
Received: by mail-wr1-x429.google.com with SMTP id b7so3272630wrt.3
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 13:43:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XUGErbOgJVSMo361k9NjkuT8ayd+OnuDR6IMwudTXmw=;
        b=pTnJgZMMfIMGt+K+AsSkbaNSghW+DYupH+GtYHfjvcZdJSWPxdzsZL9CE5lsSKSit9
         rL3EhuPz+y6qMfyUbPUjoBpsYuH52/9JlPJcRCRA9Vp3+t3fI/Q8szhQu4g83+K+fwzc
         zh7Qy86Ayzg2F2FjG5gO2MF/Umn2NE4LsXP9ryg7Bl0BWElXSF/SOwYDH9HpaTrGknqy
         rFtRvKjkTwEWj8QNWMJlM8FGweCCDXkUqzo+owil1/7NK66SRYO5nYOGOqHHlDnRFMm2
         AzJH3inJ2X7kLulnV/yJGUCcW4GpjJUoXdsPP71xHKjlCIDqmmSbDtu0jvwFYTCuuQln
         ZzhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XUGErbOgJVSMo361k9NjkuT8ayd+OnuDR6IMwudTXmw=;
        b=4ND6y6/UvhVboFJchjn0dJNSbbD8m6xBFKBXNwdYME0wQUtSEkziWmCcwxGrBIWoVD
         tu+3WLlbSmdLf2TwSKCLNBCotlPbZJPQ7KCNQTtoUklH30BYJjvF8Sfz9/H5dqtQNyKz
         5LnobaOEem3WGT22YXkl2qSzQVgTEk82i6uF4e7GXWQQ6ec4nAPmdzi09ozGu1+5yN16
         xOiw2GMIqul3MBZfbNf8rWH+EHhyJFySoM5z9WpexFWGnoD+u/p5qxg4nrj+mP1prvnI
         szbWaN8LwrAxiJh2N5KGt0zsqzFy+tXRoAGd0+PpiBrf5pc+3ocCocQyeNechkkCZigx
         Kk0w==
X-Gm-Message-State: AFqh2kp8pEwBCpG4MfJvq6hqEZ2UWGcE0nPl7uYJStIL3ZchtUYxG+Eb
        5Mme1WJl2ddCXTCOGFlVobTiB017taE=
X-Google-Smtp-Source: AMrXdXu8Pjc45vUeoQwHwkpxAukYei+GG1WuXm93ogdZgox+7/nVqZqF4Yncklfd9OhGMjvIRkubsA==
X-Received: by 2002:a5d:56d1:0:b0:242:ac3:87f4 with SMTP id m17-20020a5d56d1000000b002420ac387f4mr31940625wrw.50.1674769392722;
        Thu, 26 Jan 2023 13:43:12 -0800 (PST)
Received: from [192.168.1.9] ([88.118.3.238])
        by smtp.gmail.com with ESMTPSA id m14-20020a5d6a0e000000b002bfd09f2ca6sm461097wru.3.2023.01.26.13.43.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Jan 2023 13:43:12 -0800 (PST)
Message-ID: <13c8d54c-897d-7e4e-cad5-4d7919c92f66@gmail.com>
Date:   Thu, 26 Jan 2023 23:43:10 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.0
Subject: Re: traceroute failure in kernel 6.1 and 6.2
To:     Eric Dumazet <edumazet@google.com>
Cc:     netdev@vger.kernel.org
References: <f171a249-1529-4095-c631-f9f54d996b90@gmail.com>
 <CANn89iK1aPiystTAk2qTnzsN-LFskJ4BxL=XgTk2aLpExrWFEw@mail.gmail.com>
 <eaab7495-53d5-0026-842c-acb420408cd0@gmail.com>
 <CANn89iLQeHsf9=ZqUvU0Y_CVsHbzvd07sdFfOH-poFmGqtn0cA@mail.gmail.com>
 <168aa9cf-d80a-9c1b-887f-97015a0473dc@gmail.com>
 <CANn89iK7nn6tdQg9QZO_Gudx1BvLxhoLaNYmnOLb6ccYQnLGwg@mail.gmail.com>
 <b2ecff1c-91ad-4217-7fd5-d7bbd5704abe@gmail.com>
 <CANn89iLV3NDiEA4tPWUxjqoHNx1pv=SEpXd1b38NXU=TK13=tg@mail.gmail.com>
 <CANn89iLKQB=9rYyKXVH=hd2aBUjzhhjXA0FOdSvN3reH+k9cMQ@mail.gmail.com>
Content-Language: en-US
From:   =?UTF-8?Q?Mantas_Mikul=c4=97nas?= <grawity@gmail.com>
In-Reply-To: <CANn89iLKQB=9rYyKXVH=hd2aBUjzhhjXA0FOdSvN3reH+k9cMQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 24/01/2023 10.57, Eric Dumazet wrote:
> On Tue, Jan 24, 2023 at 7:03 AM Eric Dumazet <edumazet@google.com> wrote:
>>
>> On Tue, Jan 24, 2023 at 6:34 AM Mantas Mikulėnas <grawity@gmail.com> wrote:
>>>
>>>
>>>
>>> On 24/01/2023 00.26, Eric Dumazet wrote:
>>>> On Mon, Jan 23, 2023 at 10:45 PM Mantas Mikulėnas <grawity@gmail.com> wrote:
>>>>>
>>>>> On 23/01/2023 22.56, Eric Dumazet wrote:
>>>>>> On Mon, Jan 23, 2023 at 8:25 PM Mantas Mikulėnas <grawity@gmail.com> wrote:
>>>>>>>
>>>>>>> On 2023-01-23 17:21, Eric Dumazet wrote:
>>>>>>>> On Sat, Jan 21, 2023 at 7:09 PM Mantas Mikulėnas <grawity@gmail.com> wrote:
>>>>>>>>>
>>>>>>>>> Hello,
>>>>>>>>>
>>>>>>>>> Not sure whether this has been reported, but:
>>>>>>>>>
>>>>>>>>> After upgrading from kernel 6.0.7 to 6.1.6 on Arch Linux, unprivileged
>>>>>>>>> ICMP traceroute using the `traceroute -I` tool stopped working – it very
>>>>>>>>> reliably fails with a "No route to host" at some point:
>>>>>>>>>
>>>>>>>>>             myth> traceroute -I 83.171.33.188
>>>>>>>>>             traceroute to 83.171.33.188 (83.171.33.188), 30 hops max, 60
>>>>>>>>>             byte packets
>>>>>>>>>              1  _gateway (192.168.1.1)  0.819 ms
>>>>>>>>>             send: No route to host
>>>>>>>>>             [exited with 1]
>>>>>>>>>
>>>>>>>>> while it still works for root:
>>>>>>>>>
>>>>>>>>>             myth> sudo traceroute -I 83.171.33.188
>>>>>>>>>             traceroute to 83.171.33.188 (83.171.33.188), 30 hops max, 60
>>>>>>>>>             byte packets
>>>>>>>>>              1  _gateway (192.168.1.1)  0.771 ms
>>>>>>>>>              2  * * *
>>>>>>>>>              3  10.69.21.145 (10.69.21.145)  47.194 ms
>>>>>>>>>              4  82-135-179-168.static.zebra.lt (82.135.179.168)  49.124 ms
>>>>>>>>>              5  213-190-41-3.static.telecom.lt (213.190.41.3)  44.211 ms
>>>>>>>>>              6  193.219.153.25 (193.219.153.25)  77.171 ms
>>>>>>>>>              7  83.171.33.188 (83.171.33.188)  78.198 ms
>>>>>>>>>
>>>>>>>>> According to `git bisect`, this started with:
>>>>>>>>>
>>>>>>>>>             commit 0d24148bd276ead5708ef56a4725580555bb48a3
>>>>>>>>>             Author: Eric Dumazet <edumazet@google.com>
>>>>>>>>>             Date:   Tue Oct 11 14:27:29 2022 -0700
>>>>>>>>>
>>>>>>>>>                 inet: ping: fix recent breakage
>>>>>>>>>
>>>>>>>>>
>>>>>>>>>
>>>>>>>>>
>>>>>>>>> It still happens with a fresh 6.2rc build, unless I revert that commit.
>>>>>>>>>
>>>>>>>>> The /bin/traceroute is the one that calls itself "Modern traceroute for
>>>>>>>>> Linux, version 2.1.1", on Arch Linux. It seems to use socket(AF_INET,
>>>>>>>>> SOCK_DGRAM, IPPROTO_ICMP), has neither setuid nor file capabilities.
>>>>>>>>> (The problem does not occur if I run it as root.)
>>>>>>>>>
>>>>>>>>> This version of `traceroute` sends multiple probes at once (with TTLs
>>>>>>>>> 1..16); according to strace, the first approx. 8-12 probes are sent
>>>>>>>>> successfully, but eventually sendto() fails with EHOSTUNREACH. (Though
>>>>>>>>> if I run it on local tty as opposed to SSH, it fails earlier.) If I use
>>>>>>>>> -N1 to have it only send one probe at a time, the problem doesn't seem
>>>>>>>>> to occur.
>>>>>>>>
>>>>>>>>
>>>>>>>>
>>>>>>>> I was not able to reproduce the issue (downloading
>>>>>>>> https://sourceforge.net/projects/traceroute/files/latest/download)
>>>>>>>>
>>>>>>>> I suspect some kind of bug in this traceroute, when/if some ICMP error
>>>>>>>> comes back.
>>>>>>>>
>>>>>>>> Double check by
>>>>>>>>
>>>>>>>> tcpdump -i ethXXXX icmp
>>>>>>>>
>>>>>>>> While you run traceroute -I ....
>>>>>>>
>>>>>>> Hmm, no, the only ICMP errors I see in tcpdump are "Time exceeded in
>>>>>>> transit", which is expected for traceroute. Nothing else shows up.
>>>>>>>
>>>>>>> (But when I test against an address that causes *real* ICMP "Host
>>>>>>> unreachable" errors, it seems to handle those correctly and prints "!H"
>>>>>>> as usual -- that is, if it reaches that point without dying.)
>>>>>>>
>>>>>>> I was able to reproduce this on a fresh Linode 1G instance (starting
>>>>>>> with their Arch image), where it also happens immediately:
>>>>>>>
>>>>>>>            # pacman -Sy archlinux-keyring
>>>>>>>            # pacman -Syu
>>>>>>>            # pacman -Sy traceroute strace
>>>>>>>            # reboot
>>>>>>>            # uname -r
>>>>>>>            6.1.7-arch1-1
>>>>>>>            # useradd foo
>>>>>>>            # su -c "traceroute -I 8.8.8.8" foo
>>>>>>>            traceroute to 8.8.8.8 (8.8.8.8), 30 hops max, 60 byte packets
>>>>>>>             1  10.210.1.195 (10.210.1.195)  0.209 ms
>>>>>>>            send: No route to host
>>>>>>>
>>>>>>> So now I'm fairly sure it is not something caused by my own network, either.
>>>>>>>
>>>>>>> On one system, it seems to work properly about half the time, if I keep
>>>>>>> re-running the same command.
>>>>>>>
>>>>>>
>>>>>> Here, running the latest  upstream tree and latest traceroute, I have no issue.
>>>>>>
>>>>>> Send us :
>>>>>>
>>>>>> 1) strace output
>>>>>> 2) icmp packet capture.
>>>>>>
>>>>>> Thanks.
>>>>>
>>>>> Attached both.
>>>>
>>>> Thanks.
>>>>
>>>> I think it is a bug in this traceroute version, pushing too many
>>>> sendmsg() at once and hitting socket SNDBUF limit
>>>>
>>>> If the sendmsg() is blocked in sock_alloc_send_pskb, it might abort
>>>> because an incoming ICMP message sets sk->sk_err
>>>>
>>>> It might have worked in the past, by pure luck.
>>>>
>>>> Try to increase /proc/sys/net/core/wmem_default
>>>>
>>>> If this solves the issue, I would advise sending a patch to traceroute to :
>>>>
>>>> 1) attempt to increase SO_SNDBUF accordingly
>>>> 2) use non blocking sendmsg() api to sense how many packets can be
>>>> queued in qdisc/NIC queues
>>>> 3) reduce number of parallel messages (current traceroute behavior
>>>> looks like a flood to me)
>>>
>>> It doesn't solve the issue; I tried bumping it from the default of
>>> 212992 to 4096-times-that, with exactly the same results.
>>>
>>> The amount of packets it's able to send is variable, For example, right
>>> now, on my regular VM (which is smaller than the PC that yesterday's
>>> trace was done on), the program very consistently fails on the *second*
>>> sendto() call -- I don't think two packets is an unreasonable amount.
>>>
>>> The program has -q and -N options to reduce the number of simultaneous
>>> probes, but the only effect it has is if I reduce the packets all the
>>> way down to just one at a time.
>>
>> Problem is : if we revert the patch, unpriv users can trivially crash a host.
>>
>> Also, sent ICMP packets  look just fine to me, and the patch is
>> changing tx path.
>>
>> The reported issue seems more like rx path related to me.
>> Like IP_RECVERR being not handled correctly.
>>
>> I think more investigations are needed. Maybe contact Pavel Begunkov
>> <asml.silence@gmail.com>
>> because the initial crash issue came with
>> 47cf88993c91 ("net: unify alloclen calculation for paged requests")
> 
> I am reasonably confident this is a bug in this traceroute binary.
> 
> It sets
>   setsockopt(3, SOL_IP, IP_RECVERR, [1], 4) = 0
> 
> So a sendto() can absolutely return the error set by last received
> ICMP (cf ping_err()) on the socket,
> as per RFC1122 4.1.3.3
> 
>   4.1.3.3  ICMP Messages
> 
>              UDP MUST pass to the application layer all ICMP error
>              messages that it receives from the IP layer.  Conceptually
>              at least, this may be accomplished with an upcall to the
>              ERROR_REPORT routine (see Section 4.2.4.1).
> 
>              DISCUSSION:
>                   Note that ICMP error messages resulting from sending a
>                   UDP datagram are received asynchronously.  A UDP-based
>                   application that wants to receive ICMP error messages
>                   is responsible for maintaining the state necessary to
>                   demultiplex these messages when they arrive; for
>                   example, the application may keep a pending receive
>                   operation for this purpose.  The application is also
>                   responsible to avoid confusion from a delayed ICMP
>                   error message resulting from an earlier use of the same
> 
> 
> Fix would be
> 
> diff traceroute/traceroute.c.orig traceroute/traceroute.c
> 1657c1657
> <     if (errno == EMSGSIZE)
> ---
>>      if (errno == EMSGSIZE || errno == EHOSTUNREACH)
> 
> or to collect a pending socket error (but that would be racy), using
> SO_ERROR getsockopt()

Yes, this seems to solve the problem. I guess now I need to figure out 
where to report it to the traceroute developers...
