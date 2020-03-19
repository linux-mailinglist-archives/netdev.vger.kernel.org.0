Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E52A18BCD5
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 17:41:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728184AbgCSQlF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 12:41:05 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:44113 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727877AbgCSQlE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Mar 2020 12:41:04 -0400
Received: by mail-pl1-f194.google.com with SMTP id h11so1275735plr.11;
        Thu, 19 Mar 2020 09:41:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=N+kUskOEAztsUSeY3dZT12vj2Ojdgoxn5lGNikj9z1U=;
        b=M5htu4nft5Wl6IcM9YkoOY+berCLoHv2KhBl4yrj1LNzgifwMLJSrdni4h36LM/3lz
         GpAJ5ITg6czoojg096Uk2x+lYbOv5TXYJB7cJ2e2r5YrBenRBz4ffpmtZW7bhsnnnOu8
         aTLLEiWr0fX2lRMHNEiflHuRhpMHBLZ+tmh5iGsVTcnv1JupoQ3UeDx6uVi2lUKv03ey
         KUQ3+6RG+3/hWTsXmjzqKyLi/Yv+qwOJJjNHxwWI7flOzjDo8meaPSU9Tv4HMbEvq47j
         +R/0JATKjdKC4FeQh92+4OnQce9B5jw3jO2fjWVNvqxWQ0WjX9nawSf0u8ZisB92IE76
         Zpmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=N+kUskOEAztsUSeY3dZT12vj2Ojdgoxn5lGNikj9z1U=;
        b=qYPwbxd1NetK822UJY+37f9H4qTQzkwfB+TPZfsnIS6zkrkZBwDmv6CbW/Muxk3EEg
         idiOHfD3EQJP4zr3k7M1foUmgwzwz56HDyaIl3bwPUsCerQqbfhKO7we1x13Y/NISsr/
         CHF2vhUb7iIuSi1A70Yx6qoeo28E4H5VSi4bHtNb6Y92rOnJHqcrV9t/rX6OvKB3Gjcn
         bhEEPzUfBExvGrcCV4FwqQjovCOwR3Jdv2zgH5jdXJD6MoaEthsFBCq7K2CoyV4Bdm9f
         j7qOO72R1p7qbMDtfaZbbcCcJeQdKBQzaY/ZxOwGMuGEkSJanGkKikNUYnE02Xr9W8Ks
         Ca2g==
X-Gm-Message-State: ANhLgQ2AwT+KMokiDRxX8FOREn2iPK4zOFJj15yioubzRRCW+88GAc4r
        RNOse8DtDGzbEZuJCqQp21mw1z+f
X-Google-Smtp-Source: ADFU+vuFp5ZNwIXfJTevssPDNf3T8CH3AaNlm9oYHgHSdzLv5seXgCry8wf8JOaObTMCI+Lt2p3iyA==
X-Received: by 2002:a17:902:eb49:: with SMTP id i9mr4148743pli.91.1584636063110;
        Thu, 19 Mar 2020 09:41:03 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id y18sm3008136pge.73.2020.03.19.09.41.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Mar 2020 09:41:02 -0700 (PDT)
Subject: Re: Bug URGENT Report with new kernel 5.5.10-5.6-rc6
To:     Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Martin Zaharinov <micron10@gmail.com>,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
References: <CALidq=XsQy66n-pTMOMN=B7nEsk7BpRZnUHery5RJyjnMsiXZQ@mail.gmail.com>
 <CALidq=VVpixeJFJFkUSeDqTW=OX0+dhA04ypE=y949B+Aqaq0w@mail.gmail.com>
 <CALidq=UXHz+rjiG5JxAz-CJ1mKsFLVupsH3W+z58L2nSPKE-7w@mail.gmail.com>
 <20200319003823.3b709ad8@elisabeth>
 <CALidq=Xow0EkAP4LkqvQiDOmVDduEwLKa4c-A54or3GMj6+qVw@mail.gmail.com>
 <20200319103438.GO979@breakpoint.cc> <20200319104750.x2zz7negjbm6lwch@salvia>
 <20200319105248.GP979@breakpoint.cc>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <fff10500-8b87-62f0-ec89-49453cf9ae57@gmail.com>
Date:   Thu, 19 Mar 2020 09:40:59 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200319105248.GP979@breakpoint.cc>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/19/20 3:52 AM, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>> On Thu, Mar 19, 2020 at 11:34:38AM +0100, Florian Westphal wrote:
>>> Martin Zaharinov <micron10@gmail.com> wrote:
>>>
>>> [ trimming CC ]
>>>
>>> Please revert
>>>
>>> commit 28f8bfd1ac948403ebd5c8070ae1e25421560059
>>> netfilter: Support iif matches in POSTROUTING
>>
>> Please, specify a short description to append to the revert.
> 
> TCP makes use of the rb_node in sk_buff for its retransmit queue,
> amongst others.


Only for master skbs kept in TCP internal queues (rtx rb tree)

However the packets leaving TCP stack are clones.

  skb->dev aliases to this storage, i.e., passing
> skb->dev as the input interface in postrouting may point to another
> sk_buff instead.
> This will cause crashes and data corruption with nf_queue, as we will
> attempt to increment a random pcpu variable when calling dev_hold().
> 
> Also, the memory address may also be free'd, which gives UAF splat.
> 

This seems to suggest clones skb->dev should be cleared before leaving TCP stack,
if some layer is confused because skb->dev has not yet been set by IP layer ?

Untested patch :

diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 306e25d743e8de1bfe23d6e3b3a9fb0f23664912..c40fb3880307aa3156d01a8b49f1296657346cfd 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -1228,6 +1228,7 @@ static int __tcp_transmit_skb(struct sock *sk, struct sk_buff *skb,
        /* Cleanup our debris for IP stacks */
        memset(skb->cb, 0, max(sizeof(struct inet_skb_parm),
                               sizeof(struct inet6_skb_parm)));
+       skb->dev = NULL;
 
        tcp_add_tx_delay(skb, tp);
 

