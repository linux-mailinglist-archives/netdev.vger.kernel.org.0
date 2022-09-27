Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02B455ECAD4
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 19:28:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232459AbiI0R2M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 13:28:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232476AbiI0R2F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 13:28:05 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96FBBEFA49;
        Tue, 27 Sep 2022 10:28:04 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id 3so10029627pga.1;
        Tue, 27 Sep 2022 10:28:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=zla6Qs6yG7clbRIXNZn6O9quBpFp4NDojYjnbnXhw1o=;
        b=mPsjOW6YmE8PRHBOZ/AmgxBCyDzFm4E1eItZMvi5J0kVSt0kTPBvSH4tTD6QuttZMd
         t0MWIOUZFGUxAQxbNwhKL4bzYZEMpRjZQKiES+g3ygwesuU4Y6X095dGZ0mGaJnelUB1
         eCFZIX11Q7s1ZneDAVFNCHSixORKEkCN3DVEJ1r1zhy2RxQfv8GcdNZvVwd1qNIRvsY2
         GuezPV6daG7DII9grV+rDFIqCwCEgkOyZPIQETd+Wy5B/Wyg6JWDsvEToBlwvFHpdVmQ
         VKb7IQe0h7I8d3CrvpEFLxg4fakZzNEyvgqflccujYyHfcp7aSTheQL7RRjUyBW2Egmb
         VJbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=zla6Qs6yG7clbRIXNZn6O9quBpFp4NDojYjnbnXhw1o=;
        b=sEa0uTD596n+w8xuo4dK6D8fc3lQfYBBM/jT/mlVD9RajLM6SzLyPrY6heH3jAVI8P
         pV/rY5/5tBxCRsbKOYzPaO2EGM8cdLUjch2TI5WrzL/H49jOLeMOrCe8YXr9lgXyC3zm
         NpyvSPJOtkG0Q6ChhUs36zHqhCagVLY4yC7uh+aBKvhFY6r58ZsZkgjL5kOl+qyZWcBc
         KWt5BGG3Y04nrmtKbkYAzuuDedw8pMEGkH3Q66PQTT++G8hJlNMtV6E/+rEgFJ3yOqt2
         KFYLWyUKPYuIRkZhMLTm4haLJlpQs633YVGcTlSTYjPMpmp5yc977JBJoMiMBjaZdwmJ
         PUmA==
X-Gm-Message-State: ACrzQf1DXFJBf4Q94a6sjS0oj4+7rkeJPpKc+LJvn5eOPZySR4WG5RqD
        L/+ykS67ExAptPmzVJmLc1s=
X-Google-Smtp-Source: AMsMyM5CRNN59FcEHqTl8Jdxo1AuhtdyDMwAMmdPCfja70L15ER+ssFUY6H6VA84Zk8j9joogHqwBg==
X-Received: by 2002:aa7:8d05:0:b0:557:f0c1:6413 with SMTP id j5-20020aa78d05000000b00557f0c16413mr15173752pfe.19.1664299683610;
        Tue, 27 Sep 2022 10:28:03 -0700 (PDT)
Received: from ?IPV6:2620:10d:c083:3603:1885:b229:3257:6535? ([2620:10d:c090:500::1:5b3])
        by smtp.gmail.com with ESMTPSA id z6-20020a170902ccc600b00177f25f8ab3sm1820431ple.89.2022.09.27.10.28.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Sep 2022 10:28:03 -0700 (PDT)
Message-ID: <6cfd7080-1cab-b611-4fae-f9b26f45cc1b@gmail.com>
Date:   Tue, 27 Sep 2022 10:28:01 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.3.0
Subject: Re: [net-next v2 0/6] net: support QUIC crypto
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Xin Long <lucien.xin@gmail.com>, Jakub Kicinski <kuba@kernel.org>,
        davem <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        David Ahern <dsahern@kernel.org>, shuah@kernel.org,
        imagedong@tencent.com, network dev <netdev@vger.kernel.org>,
        linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org
References: <adel.abushaev@gmail.com>
 <20220817200940.1656747-1-adel.abushaev@gmail.com>
 <CADvbK_fVRVYjtSkn29ec70mko9aEwnwu+kHYx8bAAWm-n25mjA@mail.gmail.com>
 <f479b419-b05d-2cae-4fd0-4e88707b8d8b@gmail.com>
 <CA+FuTSf_8MjF4jeUjEqDrOwqXzf485jX_GJyVP5kPUDzOFezkg@mail.gmail.com>
 <0c989c58-2aa6-eca6-2bb9-24b1ae71694a@gmail.com>
 <CA+FuTSdCmWu5w09KZshCv=TVugf_x5NUY1xjv4X8kgbEQ+WbHQ@mail.gmail.com>
Content-Language: en-US
From:   Adel Abouchaev <adel.abushaev@gmail.com>
In-Reply-To: <CA+FuTSdCmWu5w09KZshCv=TVugf_x5NUY1xjv4X8kgbEQ+WbHQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 9/27/22 10:12 AM, Willem de Bruijn wrote:
> On Tue, Sep 27, 2022 at 12:45 PM Adel Abouchaev <adel.abushaev@gmail.com> wrote:
>>
>> On 9/25/22 11:04 AM, Willem de Bruijn wrote:
>>>>> The patch seems to get the crypto_ctx by doing a connection hash table
>>>>> lookup in the sendmsg(), which is not good from the performance side.
>>>>> One QUIC connection can go over multiple UDP sockets, but I don't
>>>>> think one socket can be used by multiple QUIC connections. So why not
>>>>> save the ctx in the socket instead?
>>>> A single socket could have multiple connections originated from it,
>>>> having different destinations, if the socket is not connected. An
>>>> optimization could be made for connected sockets to cache the context
>>>> and save time on a lookup. The measurement of kernel operations timing
>>>> did not reveal a significant amount of time spent in this lookup due to
>>>> a relatively small number of connections per socket in general. A shared
>>>> table across multiple sockets might experience a different performance
>>>> grading.
>>> I'm late to this patch series, sorry. High quality implementation. I
>>> have a few design questions similar to Xin.
>>>
>>> If multiplexing, instead of looking up a connection by { address, port
>>> variable length connection ID }, perhaps return a connection table
>>> index on setsockopt and use that in sendmsg.
>>
>> It was deliberate to not to return anything other than 0 from
>> setsockopt() as defined in the spec for the function. Despite that it
>> says "shall", the doc says that 0 is the only value for successful
>> operation. This was the reason not to use setsockopt() for any
>> bidirectional transfers of data and or status. A more sophisticated
>> approach with netlink sockets would be more suitable for it. The second
>> reason is the API asymmetry for Tx and Rx which will be introduced - the
> I thought the cover letter indicated that due to asymmetry of most
> QUIC workloads, only Tx offload is implemented. You do intend to add
> Rx later?
We are planning to include Rx later as well, Tx is more compelling from 
use case perspective as the main application of this would go to an 
Edge, where Tx is heavy and Rx is much lighter.
>> Rx will still need to match on the address, port and cid. The third
>> reason is that in current implementations there are no more than a few
>> connections per socket,
> This is very different from how we do QUIC at Google. There we
> definitely multiplex many connections across essentially a socket per
> CPU IIRC.
Ian mentioned that for such a case, while using a zero length QUIC CID, 
the remote ends are ephemeral ports and are different. In which case 
each connection will have its own context and yes, it will load the hash 
table quite a bit for a socket. The limiting factor is still a BSD4.4 
interface and returning a value from setsockopt() with the entry ID. It 
might be more suitable once a standard netlink interface is available 
for this to easily plug in. However, this will further complicate a 
userspace library integration which is a not so trivial task today too.
>
>> which does not abuse the rhashtable that does a
>> lookup, although it takes time to hash the key into a hash for a seek.
>> The performance measurement ran against the runtime and did not flag
>> this path as underperforming either, there were other parts that
>> substantially add to the runtime, not the key lookup though.
>>
>>
>>>>> The patch is to reduce the copying operations between user space and
>>>>> the kernel. I might miss something in your user space code, but the
>>>>> msg to send is *already packed* into the Stream Frame in user space,
>>>>> what's the difference if you encrypt it in userspace and then
>>>>> sendmsg(udp_sk) with zero-copy to the kernel.
>>>> It is possible to do it this way. Zero-copy works best with packet sizes
>>>> starting at 32K and larger.  Anything less than that would consume the
>>>> improvements of zero-copy by zero-copy pre/post operations and needs to
>>>> align memory.
>>> Part of the cost of MSG_ZEROCOPY is in mapping and unmapping user
>>> pages. This series re-implements that with its own get_user_pages.
>>> That is duplicative non-trivial code. And it will incur the same cost.
>>> What this implementation saves is the (indeed non-trivial)
>>> asynchronous completion notification over the error queue.
>>>
>>> The cover letter gives some performance numbers against a userspace
>>> implementation that has to copy from user to kernel. It might be more
>>> even to compare against an implementation using MSG_ZEROCOPY and
>>> UDP_SEGMENT. A userspace crypto implementation may have other benefits
>>> compared to a kernel implementation, such as not having to convert to
>>> crypto API scatter-gather arrays and back to network structures.
>>>
>>> A few related points
>>>
>>> - The implementation support multiplexed connections, but only one
>>> crypto sendmsg can be outstanding at any time:
>>>
>>>     + /**
>>>     + * To synchronize concurrent sendmsg() requests through the same socket
>>>     + * and protect preallocated per-context memory.
>>>     + **/
>>>     + struct mutex sendmsg_mux;
>>>
>>> That is quite limiting for production workloads.
>> The use case that we have with MVFST library currently runs a single
>> worker for a connection and has a single socket attached to it. QUIC
>> allows simultaneous use of multiple connection IDs to swap them in
>> runtime, and implementation would request only a handful of these. The
>> MVFST batches writes into a block of about 8Kb and then uses GSO to send
>> them all at once.
>>
>>> - Crypto operations are also executed synchronously, using
>>> crypto_wait_req after each operationn. This limits throughput by using
>>> at most one core per UDP socket. And adds sendmsg latency (which may
>>> or may not be important to the application). Wireguard shows an
>>> example of how to parallelize software crypto across cores.
>>>
>>> - The implementation avoids dynamic allocation of cipher text pages by
>>> using a single ctx->cipher_page. This is protected by sendmsg_mux (see
>>> above). Is that safe when packets leave the protocol stack and are
>>> then held in a qdisc or when being processed by the NIC?
>>> quic_sendmsg_locked will return, but the cipher page is not free to
>>> reuse yet.
>> There is currently no use case that we have in hands that requires
>> parallel transmission of data for the same connection. Multiple
>> connections would have no issue running in parallel as each of them will
>> have it's own preallocated cipher_page in the context.
> This still leaves the point that sendmsg may return and the mutex
> released while the cipher_page is still associated with an skb in the
> transmit path.
Correct, there is a further copy from the cipher buffer into fragmented 
pieces done by ip_generic_getfrag(). Am I reading it wrong that it would 
not need the cipher text allocated buffer after that is done and all the 
data is copied from it into further structures using copy_from_iter()? 
The skb would be built upon a different buffer space than the encrypted 
data. The udp_sendmsg() assumes that it receives the memory from 
userspace and does all these ops to move stuff from userspace. While 
doing that, it would omit tons of it's checks as the memory is already 
in kernel and still execute quickly.
>
>> There is a fragmentation further down the stack with
>> ip_generic_getfrag() that eventually does copy_from_iter() and makea a
>> copy of the data. This is executed as part of __ip_append_data() called
>> from udp_sendmsg() in ipv4/udp.c. The assumption was that this is
>> executed synchronously and the queues and NIC will see a mapping of a
>> different memory area than the ciphertext in the pre-allocated page.
>>
>>> - The real benefit of kernel QUIC will come from HW offload. Would it
>>> be better to avoid the complexity of an in-kernel software
>>> implementation and only focus on HW offload? Basically, pass the
>>> plaintext QUIC packets over a standard UDP socket and alongside in a
>>> cmsg pass either an index into a HW security association database or
>>> the immediate { key, iv } connection_info (for stateless sockets), to
>>> be encoded into the descriptor by the device driver.
>> Hardware usually targets a single ciphersuite such as AES-GCM-128/256,
>> while QUIC also supports Chacha20-Poly1305 and AES-CCM. The generalized
>> support for offload prompted implementation of these ciphers in kernel
>> code.
> All userspace libraries also support all protocols as fall-back. No
> need for two fall-backs if HW support is missing?
Could be done that way. Looking at TLS - it has fallback to kernel 
though in tls_sw, although that is a dual purpose code.
>> The kernel code could also engage if the future hardware has
>> capacity caps preventing it from handling all requests in the hardware.
>>> - With such a simpler path, could we avoid introducing ULP and just
>>> have udp [gs]etsockopt CRYPTO_STATE. Where QUIC is the only defined
>>> state type yet.
>>>
>>> - Small aside: as the series introduces new APIs with non-trivial
>>> parsing in the kernel, it's good to run a fuzzer like syzkaller on it
>>> (if not having done so yet).
>> Agreed.
>>>> The other possible obstacle would be that eventual support
>>>> of QUIC encryption and decryption in hardware would integrate well with
>>>> this current approach.
>>>>> Didn't really understand the "GSO" you mentioned, as I don't see any
>>>>> code about kernel GSO, I guess it's just "Fragment size", right?
>>>>> BTW, it‘s not common to use "//" for the kernel annotation.
>>> minor point: fragment has meaning in IPv4. For GSO, prefer gso_size.
>> Sure, will change it to gso_size.
>>>> Once the payload arrives into the kernel, the GSO on the interface would
>>>> instruct L3/L4 stack on fragmentation. In this case, the plaintext QUIC
>>>> packets should be aligned on the GSO marks less the tag size that would
>>>> be added by encryption. For GSO size 1000, the QUIC packets in the batch
>>>> for transmission should all be 984 bytes long, except maybe the last
>>>> one. Once the tag is attached, the new size of 1000 will correctly split
>>>> the QUIC packets further down the stack for transmission in individual
>>>> IP/UDP packets. The code is also saving processing time by sending all
>>>> packets at once to UDP in a single call, when GSO is enabled.
>>>>> I'm not sure if it's worth adding a ULP layer over UDP for this QUIC
>>>>> TX only. Honestly, I'm more supporting doing a full QUIC stack in the
>>>>> kernel independently with socket APIs to use it:
>>>>> https://github.com/lxin/tls_hs.
>>>>>
>>>>> Thanks.
