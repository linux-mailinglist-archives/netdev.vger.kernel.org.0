Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15E143FC867
	for <lists+netdev@lfdr.de>; Tue, 31 Aug 2021 15:39:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238236AbhHaNjr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 09:39:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235838AbhHaNjq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Aug 2021 09:39:46 -0400
Received: from mail-qv1-xf34.google.com (mail-qv1-xf34.google.com [IPv6:2607:f8b0:4864:20::f34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44D7FC061575
        for <netdev@vger.kernel.org>; Tue, 31 Aug 2021 06:38:51 -0700 (PDT)
Received: by mail-qv1-xf34.google.com with SMTP id hu2so115411qvb.7
        for <netdev@vger.kernel.org>; Tue, 31 Aug 2021 06:38:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=4cVWPMLdDwe2dW8rgQ4O5ZdeEA9NF5jDi3TG/HjqIHs=;
        b=cbXk1iCt+OXs5GDhDkA23MEwInwGCBR9cNS96bqLK03L+Po0HLdBG1DUreWEh7GxFg
         EBvcXQvzgnSPD9hEUBJx2x/A4XrAAv8dIH7rxISBxUSHCbqJcBe9KTHURb2wNNIGkgvO
         kdcOmbarUx95IwcaHf2flxxK7gojU7+tuoAClZF5Sq0wlCZQi7mJqIKr2X1h/82q7A5A
         u7oCQPyff1dYPnyjb/H0/PBseZPjxh3Xi+EBwdygP86NymVgeF7HJOS5XtDW4W/0QDd/
         OURqKfoHKJ4SicHl36z6FkoArJmtdJ1CXgae9Ba9Ktr/uoBgC6ZBjNk/fop7NjqDZgs8
         nPDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4cVWPMLdDwe2dW8rgQ4O5ZdeEA9NF5jDi3TG/HjqIHs=;
        b=lBd2kMv/hOxpXU773XQwQo6t6FD2nlO1w86tk37kB9T2kwoB01n+eX9tghxzwNtJns
         +emMFBv6LzgOiKoaqTudcSXKORYQ6zC5wG4ab5AZqJkXb/ikR6v8IKGmq3eFtNWYFiNW
         qyQC6Bs1l6Jq7RUskClgrE1tE8MK2tbs3LviT3JZ6IhsJqIhT2jsSIBfgZG8kXSJyO27
         nSLSmjHrNzAnJ7tyTgaDWobvLQYJJx8EX9Yz//MHwWXXdtzqzYgkc3MZY3QG1Mt0larS
         STXfD/Efle5jv6PZkpPUVTJRPXeDnkD1Nmgtc5DQJKZ5CjfQ4qgvHpz461Nu6DYRQMex
         OUUg==
X-Gm-Message-State: AOAM5323f/n7S7J+aSs2xclQbnusQo/AFhCxIvEdf2e/Fd3lp1BK8p9O
        hZBALNrIgFI0xUHD1SogjokxwA==
X-Google-Smtp-Source: ABdhPJzW8Kv2XuLtrO1TP3JccBuX8ufuM05Cdx1pHoNxDG7KA6am7XjWWxGWv/IHTPiHCJjJ9yGviA==
X-Received: by 2002:ad4:5651:: with SMTP id bl17mr21719930qvb.49.1630417130490;
        Tue, 31 Aug 2021 06:38:50 -0700 (PDT)
Received: from [192.168.1.79] (bras-base-kntaon1617w-grc-28-184-148-47-47.dsl.bell.ca. [184.148.47.47])
        by smtp.googlemail.com with ESMTPSA id v3sm14063899qkd.20.2021.08.31.06.38.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 31 Aug 2021 06:38:50 -0700 (PDT)
Subject: Re: [PATCH bpf-next v2 00/13] bpfilter
To:     Dmitrii Banshchikov <me@ubique.spb.ru>
Cc:     bpf@vger.kernel.org, ast@kernel.org, davem@davemloft.net,
        daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, netdev@vger.kernel.org, rdna@fb.com
References: <20210829183608.2297877-1-me@ubique.spb.ru>
 <a4039e82-9184-45bf-6aee-e663766d655a@mojatatu.com>
 <20210831124856.fucr676zd365va7c@amnesia>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <ae2b3a81-acc2-39d1-2a89-ffea169e8230@mojatatu.com>
Date:   Tue, 31 Aug 2021 09:38:48 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210831124856.fucr676zd365va7c@amnesia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-08-31 8:48 a.m., Dmitrii Banshchikov wrote:
> On Mon, Aug 30, 2021 at 09:56:18PM -0400, Jamal Hadi Salim wrote:
>> On 2021-08-29 2:35 p.m., Dmitrii Banshchikov wrote:


>>
>> Something is not clear from your email:
>> You seem to indicate that no traffic was running in test 1.
>> If so, why would 32 rulesets give different results than 1?
> 
> I mentioned the lower and upper bound values for bogo-ops on the
> machine. The lower bound is when there is traffic and no firewall
> at all. The upper bound is when there is no firewall and no
> traffic. Then the first test measures bogo-ops for two rule sets
> when there is traffic for either iptables, nft or bpfilter.
> 

Thanks, I totally misread that. I did look at stress-ng initially
to use it to stress the system and emulate some real world
setup (polluting cache etc) while testing but the variability of
the results was bad - so dropped it earlier. Maybe we should look
at it again.

cheers,
jamal
