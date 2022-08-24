Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2426A5A0467
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 01:09:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229903AbiHXXJO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 19:09:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbiHXXJN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 19:09:13 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5C407645A;
        Wed, 24 Aug 2022 16:09:12 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id d71so16288418pgc.13;
        Wed, 24 Aug 2022 16:09:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=MasDOByTuNkNqgVy80wM555lG1WeG5ChqWXG/vtRRRs=;
        b=nFnJp6bHfEsklPqxP8ZMqc+/iWxAttaKFJg9hlm8afGmMmUx40GoH7BF/0Uu4dVZ4o
         kKeBbnUpz7MCQtfLb0sEK1YLmAwmUkEhRypNgCZjXeJiJRr7w+Fujh48bog6A230rdRq
         A3M7eX4sZusVl3bKknM3OUIXMvxt7l9h8D6whl63Og3o5UsY/NInG2NjDF1amA9ky//Q
         zPjvVn5I9nDHBVFmBVAfCISmbKVfCuFzKOmL3pOGFEL+tZmucdA2hijGrM0rR9ONNUnD
         RvAiI5Bl1SE/2pbuWwjXMsLYP1vbiDJC3UkwjUw+WgBJbPfHO9jofhXlmA9aVzyKEvGL
         LkcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=MasDOByTuNkNqgVy80wM555lG1WeG5ChqWXG/vtRRRs=;
        b=AMR0srZy4ODpt9S41zNLVukwXevaBXTrHDVjomWSxgt546GPBvIbzlsTgxz7lYgEqu
         uZmYGEavgSxDm3j/FvRr99uD3XHQEh3OfRpidGZWFcstUOGm/6A4jhMQq8jBO3xnJWO5
         ojXvfhiRam6V5czF6RkDC77OZiaPUUqOg5vTV43/Mj09WGIUOOZO9gtGAUgU5T5DQoMm
         GzOZRHc75QFvOpFdvJ7pHJgEg78wk/dLFLkMe+zJxl+Q/oLrB/zP9DBAHPb+m7EwvrsZ
         Zo+/IuQ/GKHxGWmJcBQdOeKct0caeoS62N4wJDmjZoSrkhnyhWvUtlnOf7qrGqIZLG5O
         IXHg==
X-Gm-Message-State: ACgBeo1bgq6/G9vaRhJjgmeC2+6cwSkhKPTbbA35Z8tNXQLjkwIWZGas
        +gFtEdUnx3DXmayrv7B0U7c=
X-Google-Smtp-Source: AA6agR53dlaZP4ggxAApUBoEbYZn1zSaPclAbdhemMzdAVwOQA6jCXt98aApQ5ASxUOgQj3znNtmdw==
X-Received: by 2002:a63:4f10:0:b0:426:9c61:5e48 with SMTP id d16-20020a634f10000000b004269c615e48mr911212pgb.360.1661382552003;
        Wed, 24 Aug 2022 16:09:12 -0700 (PDT)
Received: from ?IPV6:2620:10d:c083:3603:1885:b229:3257:6535? ([2620:10d:c090:500::1:4ba2])
        by smtp.gmail.com with ESMTPSA id y187-20020a6232c4000000b0052b9351737fsm13889937pfy.92.2022.08.24.16.09.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Aug 2022 16:09:11 -0700 (PDT)
Message-ID: <f479b419-b05d-2cae-4fd0-4e88707b8d8b@gmail.com>
Date:   Wed, 24 Aug 2022 16:09:09 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.1.2
Subject: Re: [net-next v2 0/6] net: support QUIC crypto
To:     Xin Long <lucien.xin@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, davem <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        David Ahern <dsahern@kernel.org>, shuah@kernel.org,
        imagedong@tencent.com, network dev <netdev@vger.kernel.org>,
        linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org
References: <adel.abushaev@gmail.com>
 <20220817200940.1656747-1-adel.abushaev@gmail.com>
 <CADvbK_fVRVYjtSkn29ec70mko9aEwnwu+kHYx8bAAWm-n25mjA@mail.gmail.com>
Content-Language: en-US
From:   Adel Abouchaev <adel.abushaev@gmail.com>
In-Reply-To: <CADvbK_fVRVYjtSkn29ec70mko9aEwnwu+kHYx8bAAWm-n25mjA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 8/24/22 11:29 AM, Xin Long wrote:
> On Wed, Aug 17, 2022 at 4:11 PM Adel Abouchaev <adel.abushaev@gmail.com> wrote:
>> QUIC requires end to end encryption of the data. The application usually
>> prepares the data in clear text, encrypts and calls send() which implies
>> multiple copies of the data before the packets hit the networking stack.
>> Similar to kTLS, QUIC kernel offload of cryptography reduces the memory
>> pressure by reducing the number of copies.
>>
>> The scope of kernel support is limited to the symmetric cryptography,
>> leaving the handshake to the user space library. For QUIC in particular,
>> the application packets that require symmetric cryptography are the 1RTT
>> packets with short headers. Kernel will encrypt the application packets
>> on transmission and decrypt on receive. This series implements Tx only,
>> because in QUIC server applications Tx outweighs Rx by orders of
>> magnitude.
>>
>> Supporting the combination of QUIC and GSO requires the application to
>> correctly place the data and the kernel to correctly slice it. The
>> encryption process appends an arbitrary number of bytes (tag) to the end
>> of the message to authenticate it. The GSO value should include this
>> overhead, the offload would then subtract the tag size to parse the
>> input on Tx before chunking and encrypting it.
>>
>> With the kernel cryptography, the buffer copy operation is conjoined
>> with the encryption operation. The memory bandwidth is reduced by 5-8%.
>> When devices supporting QUIC encryption in hardware come to the market,
>> we will be able to free further 7% of CPU utilization which is used
>> today for crypto operations.
>>
>> Adel Abouchaev (6):
>>    Documentation on QUIC kernel Tx crypto.
>>    Define QUIC specific constants, control and data plane structures
>>    Add UDP ULP operations, initialization and handling prototype
>>      functions.
>>    Implement QUIC offload functions
>>    Add flow counters and Tx processing error counter
>>    Add self tests for ULP operations, flow setup and crypto tests
>>
>>   Documentation/networking/index.rst     |    1 +
>>   Documentation/networking/quic.rst      |  185 ++++
>>   include/net/inet_sock.h                |    2 +
>>   include/net/netns/mib.h                |    3 +
>>   include/net/quic.h                     |   63 ++
>>   include/net/snmp.h                     |    6 +
>>   include/net/udp.h                      |   33 +
>>   include/uapi/linux/quic.h              |   60 +
>>   include/uapi/linux/snmp.h              |    9 +
>>   include/uapi/linux/udp.h               |    4 +
>>   net/Kconfig                            |    1 +
>>   net/Makefile                           |    1 +
>>   net/ipv4/Makefile                      |    3 +-
>>   net/ipv4/udp.c                         |   15 +
>>   net/ipv4/udp_ulp.c                     |  192 ++++
>>   net/quic/Kconfig                       |   16 +
>>   net/quic/Makefile                      |    8 +
>>   net/quic/quic_main.c                   | 1417 ++++++++++++++++++++++++
>>   net/quic/quic_proc.c                   |   45 +
>>   tools/testing/selftests/net/.gitignore |    4 +-
>>   tools/testing/selftests/net/Makefile   |    3 +-
>>   tools/testing/selftests/net/quic.c     | 1153 +++++++++++++++++++
>>   tools/testing/selftests/net/quic.sh    |   46 +
>>   23 files changed, 3267 insertions(+), 3 deletions(-)
>>   create mode 100644 Documentation/networking/quic.rst
>>   create mode 100644 include/net/quic.h
>>   create mode 100644 include/uapi/linux/quic.h
>>   create mode 100644 net/ipv4/udp_ulp.c
>>   create mode 100644 net/quic/Kconfig
>>   create mode 100644 net/quic/Makefile
>>   create mode 100644 net/quic/quic_main.c
>>   create mode 100644 net/quic/quic_proc.c
>>   create mode 100644 tools/testing/selftests/net/quic.c
>>   create mode 100755 tools/testing/selftests/net/quic.sh
>>
>>
>> base-commit: fd78d07c7c35de260eb89f1be4a1e7487b8092ad
>> --
>> 2.30.2
>>
> Hi, Adel,
>
> I don't see how the key update(rfc9001#section-6) is handled on the TX
> path, which is not using TLS Key update, and "Key Phase" indicates
> which key will be used after rekeying. Also, I think it is almost
> impossible to handle the peer rekeying on the RX path either based on
> your current model in the future.

The update is not present in these patches, but it is an important part 
of the QUIC functionality. As this patch is only storing a single key, 
you are correct that this approach does not handle the key rotation. To 
implement re-keying on Tx and on Rx a rolling secret will need to be 
stored in kernel. In that case, the subsequent 1RTT (Application space) 
keys will be refreshed by the kernel. After all, when the hardware is 
mature enough to support QUIC encryption and decryption - the secret 
will need to be kept in the hardware to react on time on Rx, especially. 
Tx path could solicit the re-key at any point or by the exhaustion of 
the counter of GCM (packet number in this case). The RFC expects the 
implementation to retain 2 keys, at least, while keeping 3 (old, current 
and next) is not prohibited either. Keeping more is not necessary.

>
> The patch seems to get the crypto_ctx by doing a connection hash table
> lookup in the sendmsg(), which is not good from the performance side.
> One QUIC connection can go over multiple UDP sockets, but I don't
> think one socket can be used by multiple QUIC connections. So why not
> save the ctx in the socket instead?
A single socket could have multiple connections originated from it, 
having different destinations, if the socket is not connected. An 
optimization could be made for connected sockets to cache the context 
and save time on a lookup. The measurement of kernel operations timing 
did not reveal a significant amount of time spent in this lookup due to 
a relatively small number of connections per socket in general. A shared 
table across multiple sockets might experience a different performance 
grading.
>
> The patch is to reduce the copying operations between user space and
> the kernel. I might miss something in your user space code, but the
> msg to send is *already packed* into the Stream Frame in user space,
> what's the difference if you encrypt it in userspace and then
> sendmsg(udp_sk) with zero-copy to the kernel.
It is possible to do it this way. Zero-copy works best with packet sizes 
starting at 32K and larger.  Anything less than that would consume the 
improvements of zero-copy by zero-copy pre/post operations and needs to 
align memory. The other possible obstacle would be that eventual support 
of QUIC encryption and decryption in hardware would integrate well with 
this current approach.
>
> Didn't really understand the "GSO" you mentioned, as I don't see any
> code about kernel GSO, I guess it's just "Fragment size", right?
> BTW, it‘s not common to use "//" for the kernel annotation.
Once the payload arrives into the kernel, the GSO on the interface would 
instruct L3/L4 stack on fragmentation. In this case, the plaintext QUIC 
packets should be aligned on the GSO marks less the tag size that would 
be added by encryption. For GSO size 1000, the QUIC packets in the batch 
for transmission should all be 984 bytes long, except maybe the last 
one. Once the tag is attached, the new size of 1000 will correctly split 
the QUIC packets further down the stack for transmission in individual 
IP/UDP packets. The code is also saving processing time by sending all 
packets at once to UDP in a single call, when GSO is enabled.
>
> I'm not sure if it's worth adding a ULP layer over UDP for this QUIC
> TX only. Honestly, I'm more supporting doing a full QUIC stack in the
> kernel independently with socket APIs to use it:
> https://github.com/lxin/tls_hs.
>
> Thanks.
