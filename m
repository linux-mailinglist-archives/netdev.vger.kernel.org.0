Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1C074D52C6
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 21:03:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343828AbiCJUEM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 15:04:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244477AbiCJUEL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 15:04:11 -0500
Received: from mail-oo1-xc31.google.com (mail-oo1-xc31.google.com [IPv6:2607:f8b0:4864:20::c31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 187CFCE936
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 12:03:08 -0800 (PST)
Received: by mail-oo1-xc31.google.com with SMTP id w3-20020a4ac183000000b0031d806bbd7eso8056483oop.13
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 12:03:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=7sAijemEJPw+cp1BMJpDEun/0+s+Fr5dg7NjNUZm8iw=;
        b=Duqsqh1taKlufL5guliKzkrzQkz7QCl1SwCufdSrKCHhXPS4+cnhoHBgW64Erz9rrF
         mK3IJq3hA8VBntzsfPphchGXyacTSGUYbR+bo0iROtM18ygy6+b2BLoL3SRwrxlCGhi7
         oVgsjaAzvMYAHMcgXFqG0UPB7gTuofs9y29YL6sWN1t+z1j5kVIjJ58i41S8FGHs7SnY
         v/ExhjR9IV7aaAkIyKfPBNtAHXs24EAr0fIVGyBe1QPWQeH+ONuPWoX9U1grp8nu6Lpk
         EBgzEHWCkJQjXnIFR5EB2NIBzPztR52mptCy5oWXdSt3bsXcJbE2g28WENIHwGwPdKTt
         ctDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=7sAijemEJPw+cp1BMJpDEun/0+s+Fr5dg7NjNUZm8iw=;
        b=MpQigdsjLimQ48TqBHbQtbBbpEP5mBMR5fe1dCpFxnMHlxczYgpPKBIbHOqsi4lv7b
         jeY7cz8Fvfz+w9g0gjdYKB+JfIqw7FIiSZJnkJWjyfRkhAfETSwQQIsN1upFOyve7DRp
         cLWb0QzD5XgLfpwXN4NEyeHnfgZJ+/UzSB2sgm94ZWH5P7FrVRWjUyltvf8gEWYuFhxY
         CMZ8CzPH7hWcrPd4ww7b2Ycl0ig5dtteCiZcyoI9Iy0AP1NybpqYpN13tG2mzueQOccK
         HSg9rh228zQ5BNCpgWKDhk1rWcpVD/1zQZ1hd0UnWvkKGMv11IV3l+TtVCNYXvQvFv20
         gfKQ==
X-Gm-Message-State: AOAM532eobqdoCzT/Cp0869+ySce8JM+t8yfbIorm0etOhnPbRWTvLeV
        1jkaFiheDbxMLb73BpXqso4zDEgeWwPIyw==
X-Google-Smtp-Source: ABdhPJxX7NXvyXWtT62Z8lnkHZvJstJ9ZH/udlmU3v36ehF7vTdUHf2qb2wxyAWE56jQbBznu7Zpyw==
X-Received: by 2002:a05:6870:ac21:b0:da:b3f:2b63 with SMTP id kw33-20020a056870ac2100b000da0b3f2b63mr9399057oab.258.1646942587312;
        Thu, 10 Mar 2022 12:03:07 -0800 (PST)
Received: from [172.16.0.2] ([8.48.134.65])
        by smtp.googlemail.com with ESMTPSA id bq3-20020a05680823c300b002d4f8fe4881sm2929381oib.39.2022.03.10.12.03.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Mar 2022 12:03:06 -0800 (PST)
Message-ID: <38ecaaaf-1735-9023-2282-5feead8408b7@gmail.com>
Date:   Thu, 10 Mar 2022 13:03:05 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.2
Subject: Re: vrf and multicast problem
Content-Language: en-US
To:     Ben Greear <greearb@candelatech.com>,
        netdev <netdev@vger.kernel.org>
References: <1e7b1aec-401d-9e70-564a-4ce96e11e1be@candelatech.com>
 <4c4f21f3-75b5-5099-7ee8-28e3c4d6b465@gmail.com>
 <50f1a384-c312-d6ec-0f42-2b9ce3a48013@candelatech.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <50f1a384-c312-d6ec-0f42-2b9ce3a48013@candelatech.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/10/22 12:33 PM, Ben Greear wrote:
> On 3/9/22 7:54 PM, David Ahern wrote:
>> On 3/9/22 3:31 PM, Ben Greear wrote:
>>> [resend, sorry...sent to wrong mailing list the first time]
>>>
>>> Hello,
>>>
>>> We recently found a somewhat weird problem, and before I go digging into
>>> the kernel source, I wanted to see if someone had an answer already...
>>>
>>> I am binding (SO_BINDTODEVICE) a socket to an Ethernet port that is in a
>>> VRF with a second
>>> interface.  When I try to send mcast traffic out that eth port,
>>> nothing is
>>> seen on the wire.
>>>
>>> But, if I set up a similar situation with a single network port in
>>> a vrf and send multicast, then it does appear to work as I expected.
>>>
>>> I am not actually trying to do any mcast routing here, I simply want to
>>> send
>>> out mcast frames from a port that resides inside a vrf.
>>>
>>> Any idea what might be the issue?
>>>
>>
>> multicast with VRF works. I am not aware of any known issues
> 
> I set up a more controlled network to do some more testing.  I have eth2
> on 192.168.100.x/24 network, and eth1 on 172.16.0.1/16.
> 
> I bind the mcast transmitter to eth1:
> 
> 193 setsockopt(28, SOL_SOCKET, SO_BINDTODEVICE,
> "eth1\0\0\0\0\0\0\0\0\0\0\0\0", 16) = 0
> 194 setsockopt(28, SOL_SOCKET, SO_REUSEADDR, [1], 4) = 0
> 195 bind(28, {sa_family=AF_INET, sin_port=htons(8888),
> sin_addr=inet_addr("0.0.0.0")}, 16) = 0
> 196 fcntl(28, F_GETFL)                      = 0x2 (flags O_RDWR)
> 197 fcntl(28, F_SETFL, O_ACCMODE|O_NONBLOCK) = 0
> 198 setsockopt(28, SOL_SOCKET, SO_BROADCAST, [1], 4) = 0
> 199 setsockopt(28, SOL_SOCKET, SO_SNDBUF, [64000], 4) = 0
> 200 setsockopt(28, SOL_SOCKET, SO_RCVBUF, [128000], 4) = 0
> 201 getsockopt(28, SOL_SOCKET, SO_RCVBUF, [256000], [4]) = 0
> 202 getsockopt(28, SOL_SOCKET, SO_SNDBUF, [128000], [4]) = 0
> 203 write(3, "1646940176442:  BtbitsIpEndpoint"..., 69) = 69
> 204 setsockopt(28, SOL_IP, IP_TOS, [0], 4)  = 0
> 205 getsockopt(28, SOL_IP, IP_TOS, [0], [4]) = 0
> 206 setsockopt(28, SOL_SOCKET, SO_PRIORITY, [0], 4) = 0
> 207 getsockopt(28, SOL_SOCKET, SO_PRIORITY, [0], [4]) = 0
> 208 write(3, "1646940176442:  UdpEndpBase.cc 2"..., 148) = 148
> 209 setsockopt(28, SOL_IP, IP_MULTICAST_IF, [16781484], 4) = 0
> 210 setsockopt(28, SOL_IP, IP_MULTICAST_TTL, " ", 1) = 0
> 
> That IP_MULTICAST_IF ioctl should be assigning the IP address of
> eth1.
> 
> But when I sniff, I see the mcast packets going out of eth2:
> 
> [root@ct522-63e7 lanforge]# tshark -n -i eth2
> Running as user "root" and group "root". This could be dangerous.
> Capturing on 'eth2'
>     1 0.000000000 192.168.100.28 → 225.5.5.1    LANforge 1514 Seq: 474
>     2 0.060868103 192.168.100.226 → 192.168.100.255 ADwin Config 94
>     3 0.060900503 00:0d:b9:41:6a:90 → ff:ff:ff:ff:ff:ff 0x1111 92
> Ethernet II
>     4 0.209523669 192.168.100.28 → 225.5.5.1    LANforge 1514 Seq: 475
> 
> [root@ct522-63e7 lanforge]# ifconfig eth1
> eth1: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
>         inet 172.16.0.1  netmask 255.255.0.0  broadcast 172.16.255.255
>         inet6 fe80::230:18ff:fe01:63e8  prefixlen 64  scopeid 0x20<link>
>         ether 00:30:18:01:63:e8  txqueuelen 1000  (Ethernet)
>         RX packets 1972669  bytes 409744407 (390.7 MiB)
>         RX errors 0  dropped 0  overruns 0  frame 0
>         TX packets 5818525  bytes 7341747933 (6.8 GiB)
>         TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
>         device memory 0xdf740000-df75ffff
> 
> [root@ct522-63e7 lanforge]# ifconfig eth2
> eth2: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
>         inet 192.168.100.28  netmask 255.255.255.0  broadcast
> 192.168.100.255
>         inet6 fe80::230:18ff:fe01:63e9  prefixlen 64  scopeid 0x20<link>
>         ether 00:30:18:01:63:e9  txqueuelen 1000  (Ethernet)
>         RX packets 24638831  bytes 8874820766 (8.2 GiB)
>         RX errors 26712  dropped 6596663  overruns 0  frame 16757
>         TX packets 1753211  bytes 370552564 (353.3 MiB)
>         TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
>         device memory 0xdf720000-df73ffff
> 
> If I disable VRF and use routing-rules based approach, then it works
> as I expect (mcast frames go out of eth1).
> 
> We tested back to quite-old kernels with same symptom, so I think it is not
> a regression.
> 
> Any suggestions on where to start poking at this in the kernel?
> 

can you reproduce this using namespaces and veth pairs? if so, send me
the script and I will take a look.
