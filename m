Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D0A339D331
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 04:56:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230210AbhFGC6E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Jun 2021 22:58:04 -0400
Received: from mail-ot1-f45.google.com ([209.85.210.45]:34604 "EHLO
        mail-ot1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230145AbhFGC6D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Jun 2021 22:58:03 -0400
Received: by mail-ot1-f45.google.com with SMTP id v27-20020a056830091bb02903cd67d40070so12250179ott.1
        for <netdev@vger.kernel.org>; Sun, 06 Jun 2021 19:56:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=uiiYrpL7FXQjGSnYQ2QKy8kcA4uka04ISkOAd+xSZIU=;
        b=s27/1wuzdNNy+nx0m2gftnlp5G/45vhlezw86AXhWkABoRDPxutCwDyROaRo5azEXn
         tFcnx9q4tRu91A0uF1j5pG52m5zpOTbQVt9PwpDcG05NT/6AK9vMNfdz88dufHeYSwcT
         o+hbo2laSciMtlU8dM84SDH8p3MvR0HTYc6QPTTj2vDeJ9Mz3uCDnKHgc1pcPFlOsA/X
         kVmrc9ct6MqxjHZT0wBLs3V5uWoTtOwzn3ilhNlhQV/SPq1ve6hXPwwLwcCIGukCJjb+
         jj3uNuKWWDpvnNoiG3mTrPMeDsVnWtGJiw1wdf7hQtrLkY6ecBTwncWCSBSFIUjhyzSw
         HoLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=uiiYrpL7FXQjGSnYQ2QKy8kcA4uka04ISkOAd+xSZIU=;
        b=GzTfHIbiqyy5LFGTrJyD+41CvSLP3+dOCkojheojB6kiPk6MgWHiCmWEz/4rXMrv7r
         YVM3lHuO+Vd+cgedSBkaTu/JwwvhvLUsP67P+Rk4ePdMKEK822iE3XSc1WAMkiiQIzqd
         svBaEPlQuPv9yeqbqI8tiiwAqhVzGjoffYP+oS+lVqTRjRxlJf3UcXaMKr0nDTHxAhXE
         wEwGuSlEY1IQsJYvQ+GvsRlILTZq/nuWdAmwj5foD9LTjM7OKgTl2YlFhpCxQ9IXXOIv
         PrSA+aAGYeqto0zuWrOX31O1NxHNtLB13uuJ7nRJwtJD6dBMktsnAH1qvGl/xCcoTS71
         olOQ==
X-Gm-Message-State: AOAM5333pXYLqrBNSkVQZFTNG2dzN058+SKy+W7My+EUg9NXwbtfMyin
        hHDpbuGm4MrgJVUaDEXVNsI=
X-Google-Smtp-Source: ABdhPJz7toIV/XZlTpZWKETMpxQFLqMtGAV2BRu0+eOYSspz1kOha3P28eeIx87PFsV1rwhT6hul3g==
X-Received: by 2002:a05:6830:16cd:: with SMTP id l13mr1314538otr.171.1623034512937;
        Sun, 06 Jun 2021 19:55:12 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.22])
        by smtp.googlemail.com with ESMTPSA id m66sm2019052oia.28.2021.06.06.19.55.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 06 Jun 2021 19:55:12 -0700 (PDT)
Subject: Re: [PATCH iproute2] tc: fq: add horizon attributes
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev <netdev@vger.kernel.org>, Eric Dumazet <edumazet@google.com>
References: <20210604160041.3877465-1-eric.dumazet@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <6b1ed570-72f0-7f1d-c5eb-96b3dfa5674d@gmail.com>
Date:   Sun, 6 Jun 2021 20:55:11 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210604160041.3877465-1-eric.dumazet@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/4/21 10:00 AM, Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> Commit 39d010504e6b ("net_sched: sch_fq: add horizon attribute")
> added kernel support for horizon attributes in linux-5.8
> 
> $ tc -s -d qd sh dev wlp2s0
> qdisc fq 8006: root refcnt 2 limit 10000p flow_limit 100p buckets 1024 orphan_mask 1023 quantum 3028b initial_quantum 15140b low_rate_threshold 550Kbit refill_delay 40ms timer_slack 10us horizon 10s horizon_drop
>  Sent 690924 bytes 3234 pkt (dropped 0, overlimits 0 requeues 0)
>  backlog 0b 0p requeues 0
>   flows 112 (inactive 104 throttled 0)
>   gc 0 highprio 0 throttled 2 latency 8.25us
> 
> $ tc qd change dev wlp2s0 root fq horizon 500ms horizon_cap
> 
> $ tc -s -d qd sh dev wlp2s0
> qdisc fq 8006: root refcnt 2 limit 10000p flow_limit 100p buckets 1024 orphan_mask 1023 quantum 3028b initial_quantum 15140b low_rate_threshold 550Kbit refill_delay 40ms timer_slack 10us horizon 500ms horizon_cap
>  Sent 831220 bytes 3844 pkt (dropped 0, overlimits 0 requeues 0)
>  backlog 0b 0p requeues 0
>   flows 122 (inactive 120 throttled 0)
>   gc 0 highprio 0 throttled 2 latency 8.25us
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> ---
>  tc/q_fq.c | 66 ++++++++++++++++++++++++++++++++++++++++++++++++++-----
>  1 file changed, 60 insertions(+), 6 deletions(-)
> 

applied to iproute2-next. Thanks,

