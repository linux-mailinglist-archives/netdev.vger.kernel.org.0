Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C673A36791C
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 07:12:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230319AbhDVFMr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 01:12:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229608AbhDVFMp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 01:12:45 -0400
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE979C06174A
        for <netdev@vger.kernel.org>; Wed, 21 Apr 2021 22:12:11 -0700 (PDT)
Received: by mail-il1-x12c.google.com with SMTP id y10so14913234ilv.0
        for <netdev@vger.kernel.org>; Wed, 21 Apr 2021 22:12:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Uk1m6FVN01BjE65BAT59UtqyKgiAvef6wZqwRHRypDc=;
        b=pA8mzz4QCMi/xc9pHHHZRx8y0eJgBtvOT7XCngUfCVsCYhVa3FyHNH1hlX197SOKIJ
         vL/xNb/NRMyZ/fzYvlJ/btMHc+PdHg6Q4taZAk7kjvu2iqvv6nZhTIM5BtE89nWSmxLS
         HLmx7geNwV1gt07b3owRobqQbcGg0G6A+1rhFajavJvj/UPJlX5fQbkBdFBbw/v4u/HB
         1NQDegYMCdHm+mG0337Jtpg1CTEVdT1GRVcAZkuJf5nhtcaF8MBHB3/SpadJsHEiRDrZ
         9nkUkmftFpZvI50MJnTPw8aJoc/QnS0MtJ0EDcmZ77OLEo5FtA7rgHd1sR4D4Smb0YfZ
         Z/2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Uk1m6FVN01BjE65BAT59UtqyKgiAvef6wZqwRHRypDc=;
        b=CsAznovmKUSqMEOIWYE4KRuGnjUa/X5yL55OqxnuvikWomX0u1XT4V7xtgIY6JLe7c
         HSGMku/Ul7B+8iztGxHn2c3uPt62KfVOX0RQ36MUzblmiDgKyXFnLYOTs5B8m6ka+r6i
         XHHho7fokwyMeiopjCrSYjjkUgvZ00SRP12ll/RIERAxgUF2lNXR/dl1gjf7K6Ga4f3S
         cIqkoWRqcA7qMFZm+pWtYgimpLZyTuvu/F87Ubl9/+CdDhg46nvncMxDjm9uIcjM4v7i
         ZQ1qS8WKIicYuff7mKa0G1CoSpI4IAPdfn80opMFuq1qEp20nS4JRiaUj3+BbTlHJ+GI
         QwCg==
X-Gm-Message-State: AOAM531w1iY4bkTgg8li42r8Wkdd5cJXOH69cpHYoDDh7mn/R5wBdMfU
        OK8HVhy41y4PRnGFkhDyw4wa0nJ0dcE=
X-Google-Smtp-Source: ABdhPJyUAQvCv2Dt5wqoFClx1h/QuhlDZ0R04s53LQ6c8vha++9cUL2eJzR9/YRu8dIaB8BxEG/thA==
X-Received: by 2002:a92:3002:: with SMTP id x2mr1321189ile.116.1619068330650;
        Wed, 21 Apr 2021 22:12:10 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.45.42.15])
        by smtp.googlemail.com with ESMTPSA id o6sm840618ioa.21.2021.04.21.22.12.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Apr 2021 22:12:10 -0700 (PDT)
Subject: Re: [PATCH iproute2] mptcp: add support for event monitoring
To:     Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org
Cc:     mptcp@lists.linux.dev, dsahern@gmail.com,
        stephen@networkplumber.org
References: <20210416135930.9480-1-fw@strlen.de>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <dfc7151c-4796-1039-d023-f94ac6de30d2@gmail.com>
Date:   Wed, 21 Apr 2021 22:12:07 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <20210416135930.9480-1-fw@strlen.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/16/21 6:59 AM, Florian Westphal wrote:
> This adds iproute2 support for mptcp event monitoring, e.g. creation,
> establishment, address announcements from the peer, subflow establishment
> and so on.
> 
> While the kernel-generated events are primarily aimed at mptcpd (e.g. for
> subflow management), this is also useful for debugging.
> 
> This adds print support for the existing events.
> 
> Sample output of 'ip mptcp monitor':
> [       CREATED] token=83f3a692 remid=0 locid=0 saddr4=10.0.1.2 daddr4=10.0.1.1 sport=58710 dport=10011
> [   ESTABLISHED] token=83f3a692 remid=0 locid=0 saddr4=10.0.1.2 daddr4=10.0.1.1 sport=58710 dport=10011
> [SF_ESTABLISHED] token=83f3a692 remid=0 locid=1 saddr4=10.0.2.2 daddr4=10.0.1.1 sport=40195 dport=10011 backup=0
> [        CLOSED] token=83f3a692
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  include/libgenl.h          |   1 +
>  include/uapi/linux/mptcp.h |   2 +
>  ip/ipmptcp.c               | 113 +++++++++++++++++++++++++++++++++++++
>  lib/libgenl.c              |  66 ++++++++++++++++++++++
>  man/man8/ip-mptcp.8        |   8 +++
>  5 files changed, 190 insertions(+)
> 

applied to iproute2-next. Thanks,

