Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 691AA46DFB
	for <lists+netdev@lfdr.de>; Sat, 15 Jun 2019 05:16:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726369AbfFODQ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 23:16:57 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:44207 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726046AbfFODQ5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 23:16:57 -0400
Received: by mail-io1-f68.google.com with SMTP id s7so9932333iob.11
        for <netdev@vger.kernel.org>; Fri, 14 Jun 2019 20:16:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=5tL4WFNQR8OOgQFHElmQh4NcW3lzJFVO3hur8s0n3vU=;
        b=mlsqaIuQnXwk2VlFQmi38IHt1My+YyPahWvsiEedvehzZhFCwM5Z8MR/Kc9jz5hX/3
         fdcOqLxOp8LM9fKfg9G6Pr6qyd6z0p1m86cRu4zLplJF0ic5i4eYXBzzRnTGgNH4MTWR
         XRqCpM8txTr05FgNEgp76IgDowJ9kGGNGH38XRmLvZ5u72hD1Yqzj1lZrejyJnh4Xf/I
         HnrE61czBTFRt338/SkekzENU7dqFWX2udZjnIJqPb+JGI/w4yHPkfpi9ClMt8G2yPxt
         PlKRyRuorYDA071BAzJDJdy/WyvxSYH/MWbJRncP7kGryH/wEnuJ203d/gClP7MHIA/z
         QvJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5tL4WFNQR8OOgQFHElmQh4NcW3lzJFVO3hur8s0n3vU=;
        b=Ks2iYeuCE+LMLIjT3CCyN9czhZUBGKJZdI28f86hN4h2Gh3KyiLcDTrWL9oDTjJMHw
         jhLY/5octeA6rngHjCv96iCaDRgIRBpwE429TW1JxiY8zMjcTBOX3vrpIH8Jn175bjSe
         5u8AhFyoEKJ7CvkETcCku504e9NBmQxWDuka+ceGRkRCrTIZM241FhuHGq1PYWLUabfT
         sK8vO4LXug+Xn2adjAyBIQbDOoqCSD20hzRjyJp6WbylPtZMngWsqhhJO/jfpL4WZEm1
         yXKKbCb6p8Pyl5FBeykoFLAuXqkFuXqfTTT9Em8EuPjCw1Y30vjbASNoa0B3ccpZ4RCd
         mklg==
X-Gm-Message-State: APjAAAUPsnZuF9eV2TrmL7E8x2ug5hI2rmvibZDlBjhtk2pPGQ/wiOot
        SUJBP2rYrqDTGNlP8P7lUjVKJClpQLM=
X-Google-Smtp-Source: APXvYqxDekxZOpvKwObWfpr8s7WAqJgrOcxNIqTxnpqlu/J7BV6TyCos11R6a8xUJ2nSA2ttMWO9vQ==
X-Received: by 2002:a6b:d809:: with SMTP id y9mr6628255iob.301.1560568616414;
        Fri, 14 Jun 2019 20:16:56 -0700 (PDT)
Received: from ?IPv6:2601:282:800:fd80:6878:c29b:781:b371? ([2601:282:800:fd80:6878:c29b:781:b371])
        by smtp.googlemail.com with ESMTPSA id e84sm7908729iof.39.2019.06.14.20.16.55
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 14 Jun 2019 20:16:55 -0700 (PDT)
Subject: Re: [PATCH net v4 1/8] ipv4/fib_frontend: Rename
 ip_valid_fib_dump_req, provide non-strict version
To:     Stefano Brivio <sbrivio@redhat.com>
Cc:     David Miller <davem@davemloft.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Jianlin Shi <jishi@redhat.com>, Wei Wang <weiwan@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>,
        netdev@vger.kernel.org
References: <cover.1560561432.git.sbrivio@redhat.com>
 <fb2bbc9568a7d7d21a00b791a2d4f488cfcd8a50.1560561432.git.sbrivio@redhat.com>
 <4dfbaf6a-5cff-13ea-341e-2b1f91c25d04@gmail.com>
 <20190615051342.7e32c2bb@redhat.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <d780b664-bdbd-801f-7c61-d4854ff26192@gmail.com>
Date:   Fri, 14 Jun 2019 21:16:54 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190615051342.7e32c2bb@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/14/19 9:13 PM, Stefano Brivio wrote:
> On Fri, 14 Jun 2019 20:54:49 -0600
> David Ahern <dsahern@gmail.com> wrote:
> 
>> On 6/14/19 7:32 PM, Stefano Brivio wrote:
>>> ip_valid_fib_dump_req() does two things: performs strict checking on
>>> netlink attributes for dump requests, and sets a dump filter if netlink
>>> attributes require it.
>>>
>>> We might want to just set a filter, without performing strict validation.
>>>
>>> Rename it to ip_filter_fib_dump_req(), and add a 'strict' boolean
>>> argument that must be set if strict validation is requested.
>>>
>>> This patch doesn't introduce any functional changes.
>>>
>>> Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
>>> ---
>>> v4: New patch
>>>   
>>
>> Can you explain why this patch is needed? The existing function requires
>> strict mode and is needed to enable any of the kernel side filtering
>> beyond the RTM_F_CLONED setting in rtm_flags.
> 
> It's mostly to have proper NLM_F_MATCH support. Let's pick an iproute2
> version without strict checking support (< 5.0), that sets NLM_F_MATCH
> though. Then we need this check:
> 
> 	if (nlh->nlmsg_len < nlmsg_msg_size(sizeof(*rtm)))

but that check existed long before any of the strict checking and kernel
side filtering was added.

> 
> and to set filter parameters not just based on flags (i.e. RTM_F_CLONED),
> but also on table, protocol, etc.

and to do that you *must* have strict checking. There is no way to trust
userspace without that strict flag set because iproute2 for the longest
time sent the wrong header for almost all dump requests.

> 
> For example one might want to: 'ip route list cache table main', and this
> is then taken into account in fn_trie_dump_leaf() and rt6_dump_route().
> 
> Reusing this function avoids a nice amount of duplicated code and allows
> to have an almost common path with strict checking.
> 

