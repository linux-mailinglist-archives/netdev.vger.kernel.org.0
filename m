Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B75E27328B
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 21:12:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727830AbgIUTMA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 15:12:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726969AbgIUTMA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 15:12:00 -0400
Received: from mail-oi1-x241.google.com (mail-oi1-x241.google.com [IPv6:2607:f8b0:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09F05C061755;
        Mon, 21 Sep 2020 12:12:00 -0700 (PDT)
Received: by mail-oi1-x241.google.com with SMTP id x14so18189205oic.9;
        Mon, 21 Sep 2020 12:11:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=/y+LkHjWQTZUko9s0+CjWc8l1gB+JOW4CZS5IAT4wnM=;
        b=P7al9HtzZyEWdlh510LGblrPQfQjscmVoDNeRTxPng6nwexTzcJwZNeBZs0lqOS5u+
         lV/icK9G5ChiCcCTqTZFnuyuUBRy16ww3x2LOKSi79x+goLpty383gnAj6w9zGbZNjBO
         zbgQ2X7ClJkJw0eHgrWgX3pc4wFwbMe377Vkw+yREpDXCrGu47beux4+sNJB4gvQ1az8
         lyPBsRj/M4I7c7nfcbBBVoPsJZKlg5GshdZfuJxrR+KPmp8Ax+d6taeM0UspnTJlzz56
         gbXFPqKMjd1EmRxn5WdhmDS73x2b3JYCOjOv4WgqdbwU99gH0b9z0wqvepfBGoyodCq3
         S5jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/y+LkHjWQTZUko9s0+CjWc8l1gB+JOW4CZS5IAT4wnM=;
        b=pmMkBSDDk1o2opiJ519OWvZ6f0FaRIrmxsA9SXSH2n3UM3nv658X4cZIiGtl/j1gX0
         eRnAXySPIExw+ygoMK97yq5Jje6cUHMALDACBfLSW6MWd/wFNkT+ZbBNdvCQi4jbkrOL
         QIej6oeplCzQzGmjatxNr2vNve2ph6i/qju3lI0E+M+Euo86kt5sCxPyhv1DM/D/kLwq
         umQIoSiXeUzUPoBskwMFm5Gko71xjmlPPessZSbJKv+JJ3UvEaRHgT2q3DLnCc9SD/Qg
         lMct/NMF0Pc2l+6txPSn98APs5E3vYOP9MCWjHuj/dlNxftfmwPdPDP2u8mMyCNbEatp
         rLaQ==
X-Gm-Message-State: AOAM531YmrIjHP3VDGjpCfvJ59hd82KQX1LO7zSynscyijN3aa9Wwc4r
        o/5Do09UVcniGyUFJueS/g6JnU2UrEwnyQ==
X-Google-Smtp-Source: ABdhPJzKgpG7rjqi1AD6iI4rtY2Z5SWOwk5khwHidL1O1jr9w3YDTWMDQyHNNbvX9l2tGp2GfL6KFA==
X-Received: by 2002:a05:6808:245:: with SMTP id m5mr520988oie.155.1600715519177;
        Mon, 21 Sep 2020 12:11:59 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:284:8202:10b0:55c1:8bf2:4210:9084])
        by smtp.googlemail.com with ESMTPSA id h28sm6503773ote.28.2020.09.21.12.11.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Sep 2020 12:11:58 -0700 (PDT)
Subject: Re: [RFC PATCH v2 0/3] l3mdev icmp error route lookup fixes
To:     Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
References: <20200918181801.2571-1-mathieu.desnoyers@efficios.com>
 <390b230b-629b-7f96-e7c9-b28f8b592102@gmail.com>
 <1453768496.36855.1600713879236.JavaMail.zimbra@efficios.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <dd1caf15-2ef0-f557-b9a8-26c46739f20b@gmail.com>
Date:   Mon, 21 Sep 2020 13:11:56 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <1453768496.36855.1600713879236.JavaMail.zimbra@efficios.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/21/20 12:44 PM, Mathieu Desnoyers wrote:
> ----- On Sep 21, 2020, at 2:36 PM, David Ahern dsahern@gmail.com wrote:
> 
>> On 9/18/20 12:17 PM, Mathieu Desnoyers wrote:
>>> Hi,
>>>
>>> Here is an updated series of fixes for ipv4 and ipv6 which which ensure
>>> the route lookup is performed on the right routing table in VRF
>>> configurations when sending TTL expired icmp errors (useful for
>>> traceroute).
>>>
>>> It includes tests for both ipv4 and ipv6.
>>>
>>> These fixes address specifically address the code paths involved in
>>> sending TTL expired icmp errors. As detailed in the individual commit
>>> messages, those fixes do not address similar issues related to network
>>> namespaces and unreachable / fragmentation needed messages, which appear
>>> to use different code paths.
>>>
>>
>> New selftests are failing:
>> TEST: Ping received ICMP frag needed                       [FAIL]
>>
>> Both IPv4 and IPv6 versions are failing.
> 
> Indeed, this situation is discussed in each patch commit message:
> 
> ipv4:
> 
> [ It has also been pointed out that a similar issue exists with
>   unreachable / fragmentation needed messages, which can be triggered by
>   changing the MTU of eth1 in r1 to 1400 and running:
> 
>   ip netns exec h1 ping -s 1450 -Mdo -c1 172.16.2.2
> 
>   Some investigation points to raw_icmp_error() and raw_err() as being
>   involved in this last scenario. The focus of this patch is TTL expired
>   ICMP messages, which go through icmp_route_lookup.
>   Investigation of failure modes related to raw_icmp_error() is beyond
>   this investigation's scope. ]
> 
> ipv6:
> 
> [ Testing shows that similar issues exist with ipv6 unreachable /
>   fragmentation needed messages.  However, investigation of this
>   additional failure mode is beyond this investigation's scope. ]
> 
> I do not have the time to investigate further unfortunately, so I
> thought it best to post what I have.
> 

the test setup is bad. You have r1 dropping the MTU in VRF red, but not
telling VRF red how to send back the ICMP. e.g., for IPv4 add:

    ip -netns r1 ro add vrf red 172.16.1.0/24 dev blue

do the same for v6.

Also, I do not see a reason for r2; I suggest dropping it. What you are
testing is icmp crossing VRF with route leaking, so there should not be
a need for r2 which leads to asymmetrical routing (172.16.1.0 via r1 and
the return via r2).
