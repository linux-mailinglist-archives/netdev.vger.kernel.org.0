Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3F1223231E
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 19:07:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726876AbgG2RHk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 13:07:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726365AbgG2RHj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jul 2020 13:07:39 -0400
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F3CAC061794
        for <netdev@vger.kernel.org>; Wed, 29 Jul 2020 10:07:39 -0700 (PDT)
Received: by mail-qt1-x844.google.com with SMTP id t23so15059247qto.3
        for <netdev@vger.kernel.org>; Wed, 29 Jul 2020 10:07:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=WSgZtxaXrJBPTybHb/aa50lgFU40We//b7DSuGt0iCM=;
        b=ai9uKykPCj4fI4ZrNO5ANHjXzYtmeQh2iSR2P9lU9N2B+J6TUHKfMQuJZ1sQ9ZUI3l
         C7pOhu3crGveC9WC5d9V841GnoXeYISRFkH+E/bNxdTD0o9Rd/lG2H3YFEf9i3j5T06u
         AJsnhotHxbuRSSTRwY+B6tlk47jzCPwhgzIGfKjathxBQH8kCwxPMcSZ4cZE7haY8bph
         RF7AZCTMNX1FnNriOU4liu+aI4DMMG/d/C7zSvWSsgx6me4mDQaFQ12tfr8q11PXG2e8
         qy1TVsLDBS+H0By3KjEekTRg6FpZar6E9p80s1/paXOHBchArVQJgKmtkGx4R7JgsxMk
         4yIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WSgZtxaXrJBPTybHb/aa50lgFU40We//b7DSuGt0iCM=;
        b=Z46atLdONmr6avvd3SZKmIdm+8PDlEudqbxp9UgpLxixIQh+6LPQ7zitXKsB5OTTeY
         kYhRJm4dn7YQck2ZXo8EvSOKdmALQ7HS3d2IUule5aD4Sa3moKUnDwW1q6Lv7/QPpw8S
         waLBvIRYFWCSg2Ulkg2YyJjoiXPynOnBt+nQxMmbIhpXrh83rPzaDF4zIW6JWrOB7htk
         Bp5nFGvrtaGkiwXgdgj1hQfGiM13ZQUToOzzJSUj88yNHCxCzQJZleEsWBBXwLqL6Ypa
         dRKw1tofdRhqOlsFVSbWoy4NmmYdd9aR64LO2Xtxfn5yAQBCkjw0WuGlbfiSS0qIaa6i
         FjDA==
X-Gm-Message-State: AOAM533d1UrJn0oyp3MazC3IdZxQA6kwy+lpFQNwrrnDWZ8bDRYQbord
        lnG2JaJdswWPqA12uOWnB0Ntu8Ju
X-Google-Smtp-Source: ABdhPJygJB0RfkNVCe+QBFLRJTXj5znQBCu2FiZaWZydyfgvkrJKxJptuXivLk7kcUAxNa/B3KsjtA==
X-Received: by 2002:ac8:1b0a:: with SMTP id y10mr20850153qtj.74.1596042458621;
        Wed, 29 Jul 2020 10:07:38 -0700 (PDT)
Received: from ?IPv6:2601:284:8202:10b0:c873:abf:83ee:21b3? ([2601:284:8202:10b0:c873:abf:83ee:21b3])
        by smtp.googlemail.com with ESMTPSA id h13sm2088524qtu.7.2020.07.29.10.07.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Jul 2020 10:07:37 -0700 (PDT)
Subject: Re: [PATCH iproute2] tc: Add space after format specifier
To:     Briana Oursler <briana.oursler@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Cc:     Petr Machata <petrm@mellanox.com>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Davide Caratti <dcaratti@redhat.com>,
        Stefano Brivio <sbrivio@redhat.com>, netdev@vger.kernel.org
References: <20200727164714.6ee94a11@hermes.lan>
 <20200728052048.7485-1-briana.oursler@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <0d69d2a3-189e-8e60-4342-1a4300e1f5bf@gmail.com>
Date:   Wed, 29 Jul 2020 11:07:35 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200728052048.7485-1-briana.oursler@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/27/20 11:20 PM, Briana Oursler wrote:
> Add space after format specifier in print_string call. Fixes broken
> qdisc tests within tdc testing suite. Per suggestion from Petr Machata,
> remove a space and change spacing in tc/q_event.c to complete the fix.
> 
> Tested fix in tdc using:
> ./tdc.py -c qdisc
> 
> All qdisc RED tests return ok.
> 
> Fixes: d0e450438571("tc: q_red: Add support for
> qevents "mark" and "early_drop")
> 
> Signed-off-by: Briana Oursler <briana.oursler@gmail.com>
> ---
>  tc/q_red.c     | 4 ++--
>  tc/tc_qevent.c | 3 ++-
>  2 files changed, 4 insertions(+), 3 deletions(-)
> 

Applied to iproute2-next after fixing the 'Fixes' line. It should be a
single line before the Signed-off-by

