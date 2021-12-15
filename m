Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 752FB475BF3
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 16:39:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243993AbhLOPip (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 10:38:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243796AbhLOPil (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Dec 2021 10:38:41 -0500
Received: from mail-oi1-x22e.google.com (mail-oi1-x22e.google.com [IPv6:2607:f8b0:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED5ADC061574
        for <netdev@vger.kernel.org>; Wed, 15 Dec 2021 07:38:40 -0800 (PST)
Received: by mail-oi1-x22e.google.com with SMTP id bk14so32193099oib.7
        for <netdev@vger.kernel.org>; Wed, 15 Dec 2021 07:38:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=9bLtqmrW0I+Ylv6Sscrfhj/u3Fsm6Ow3Su5mGygQREo=;
        b=HnKOs2EcFEPBybmkhXLj/ryMJj10bTn1unznUxAgh4Lbvi9xONpL7qGNH4OqY48x/s
         ZtdjK8RZzRMGHHwYN1S2tb+zHOhQVRuDA936F1xFD9AQtuqTNUvrxPSBDhDdiXlaPOsV
         ztv3W1+PKDOjpGuAnnihpL4AE/ApOMVe/XK77DeXhC3v16sYoGOoHpyPVlngRTW/nvPU
         NdMMfkFmoNR2VT4/Q7uhvKdlG0EW/KUPqtGhrdOM0AL1nad3BU0PjYtCD8vJKW79BJDl
         f3sd4QYyjBYhG8UYaTJyhI72ePja+BulyXgabHNiaJ4UIDd/eg0qU31YRX2DaunhOPdb
         rrCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=9bLtqmrW0I+Ylv6Sscrfhj/u3Fsm6Ow3Su5mGygQREo=;
        b=kgVMk4ZwS8D1yuJ6iNmn8sWnmmwEacfGly5n01E498BBM6swTkz27bvFXdBw72JmAP
         5QnkPW2PBj2b16U7mEvFGmYjA/mhKV53TTCKkucMXA+LW78XJ4m1Scibh3EQdsM3C3t5
         hq9XdtoKiye/m1o57g51GQizRe8AGUV9YboNrFEq2FZ7h+u5xm6pSL46IqB18v1UUqE+
         ifPKM7ljTCgv/0dyLpH2UP1Qn6VFZDTIB75WRQU7u0IAgpNuQcNPtWRT8Me9SRap9gSG
         dFYu6XXEoXKFZVk4HMzaQnoHpozMzSHHUBUZ91qJrkC7cbVjbozY5Mndzs5IKbuMS0Kc
         EJAQ==
X-Gm-Message-State: AOAM530n4/sQEkpqQO1F4YjGUWsDbiqf2Ni0NgKFCXiCtZj98uZzavqu
        2oDjaCUgtZu6JEKXvaMU3Q3aBpieZKI=
X-Google-Smtp-Source: ABdhPJwo2FFaWFgQQUqipICmhmFoombkl+DJpdsQ/BVWVJ1+RdgmHBoGptGFdcGNi6tzfUmkpo8dNA==
X-Received: by 2002:a05:6808:11c1:: with SMTP id p1mr291679oiv.113.1639582720337;
        Wed, 15 Dec 2021 07:38:40 -0800 (PST)
Received: from [172.16.0.2] ([8.48.134.30])
        by smtp.googlemail.com with ESMTPSA id bp11sm405778oib.38.2021.12.15.07.38.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Dec 2021 07:38:39 -0800 (PST)
Message-ID: <d09956b9-bf36-fe05-8170-cd73ccc91ee0@gmail.com>
Date:   Wed, 15 Dec 2021 08:38:37 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.0
Subject: Re: [PATCH v3 net-next 1/2] fib: rules: remove duplicated nla
 policies
Content-Language: en-US
To:     Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, dsahern@kernel.org
References: <20211215113242.8224-1-fw@strlen.de>
 <20211215113242.8224-2-fw@strlen.de>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20211215113242.8224-2-fw@strlen.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/15/21 4:32 AM, Florian Westphal wrote:
> The attributes are identical in all implementations so move the ipv4 one
> into the core and remove the per-family nla policies.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  resend without changes.
> 
>  include/net/fib_rules.h | 1 -
>  net/core/fib_rules.c    | 9 +++++++--
>  net/decnet/dn_rules.c   | 5 -----
>  net/ipv4/fib_rules.c    | 6 ------
>  net/ipv4/ipmr.c         | 5 -----
>  net/ipv6/fib6_rules.c   | 5 -----
>  net/ipv6/ip6mr.c        | 5 -----
>  7 files changed, 7 insertions(+), 29 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>

The extra FRA_FLOW across rule sets should be fine since it is using
nlmsg_parse_deprecated.
