Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81976180655
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 19:30:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727414AbgCJSar (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 14:30:47 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:41218 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726283AbgCJSar (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 14:30:47 -0400
Received: by mail-qt1-f194.google.com with SMTP id l21so10399670qtr.8
        for <netdev@vger.kernel.org>; Tue, 10 Mar 2020 11:30:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Gp0MFkHfA6keWCu5UGwSfo+Vg8USvF7Ugp44kgvCA5w=;
        b=X/66w/eC3X+UngurAfj0ATCg7wLTG2hXCWZBGgdTwhYU8ruCS1k92ubCZY6QsHy/Vz
         wBoocatR/MOcQVw+Z4h6m18i0SbLicblS0o1WIewZCke49u1ZDyZdQ8cQK2ZVaSfzA9b
         fEVCfY4qLUzU8Ypgy359QuOkUX2own38nfo1LPEec6nEzBEFPDW0hFp/DxEqp6hqVFMl
         jC9yF4FlwApfim/F8HV3iUOKJQQvFUaZIqr5A5iR46Uzo5cLw7m+0J8jTlygSqfxYD2E
         ZvR1JktW/bumG6GLE2rKWgwa+kObp5SpLgVWFoksjPN3UOPK/t02ToBJj+dunPsV0IH6
         0WNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Gp0MFkHfA6keWCu5UGwSfo+Vg8USvF7Ugp44kgvCA5w=;
        b=CPM4xV66ac3AAhIk6ceVmwoGo1xJLEWGurfCgq0BhSrxCtetwZRokpTYOMLY0E94j9
         j5i6RQZ3em7AmnXPlqRRYbLRxITEvjhY8Z0BPoJsaLSrsu9jedXeANxK30XGtE5SD6SN
         cT0cXqJg4dAHWawo86YMxMn9SS6k4kaH54gHevURKrSpmMwDE7ndV0j4MSGBGaAE16rI
         KvCrH3uoOc0GaOJdJt+crARpVGaggzIG0hk4JYixTKhirotHToJC0uWqU7FwQgVkLv1H
         5Gj+FmvAYmrH5oANJx/vDPlTDVjR092DQ6D6dx/wvfL4h8COUn3nGYpolH7Un4jOCTM5
         xU8w==
X-Gm-Message-State: ANhLgQ30WzRXA1/2sGJCtuwFoT19rflT3RA9tzsM5xztKIBZph7P60MH
        w2RUZ2Ieky3MBb/6cvCvf8I=
X-Google-Smtp-Source: ADFU+vssYNVy+Pbwz1I/1pslNuEt42dyLM7tcWDSR+DmeTSKSGeQN7tAVnl4FAx+3e73GJXaSsHxHQ==
X-Received: by 2002:ac8:76d7:: with SMTP id q23mr20071814qtr.198.1583865046158;
        Tue, 10 Mar 2020 11:30:46 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:b876:5d04:c7e4:4480? ([2601:282:803:7700:b876:5d04:c7e4:4480])
        by smtp.googlemail.com with ESMTPSA id x127sm2745688qke.135.2020.03.10.11.30.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Mar 2020 11:30:44 -0700 (PDT)
Subject: Re: [PATCH iproute2-next] Revert "tc: pie: change maximum integer
 value of tc_pie_xstats->prob"
To:     Leslie Monis <lesliemonis@gmail.com>,
        Linux NetDev <netdev@vger.kernel.org>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        "Mohit P . Tahiliani" <tahiliani@nitk.edu.in>,
        Gautam Ramakrishnan <gautamramk@gmail.com>,
        Eric Dumazet <edumazet@google.com>
References: <20200310181549.2689-1-lesliemonis@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <1122d071-7728-94fc-a32a-f2cf31102312@gmail.com>
Date:   Tue, 10 Mar 2020 12:30:42 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200310181549.2689-1-lesliemonis@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/10/20 12:15 PM, Leslie Monis wrote:
> This reverts commit 92cfe3260e9110c3d33627847b6eaa153664c79c.
> 
> Kernel commit 3f95f55eb55d ("net: sched: pie: change tc_pie_xstats->prob")
> removes the need to change the maximum integer value of
> tc_pie_stats->prob here.
> 
> Suggested-by: Eric Dumazet <edumazet@google.com>
> Signed-off-by: Leslie Monis <lesliemonis@gmail.com>
> ---
>  tc/q_pie.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/tc/q_pie.c b/tc/q_pie.c
> index e6939652..709a78b4 100644
> --- a/tc/q_pie.c
> +++ b/tc/q_pie.c
> @@ -223,9 +223,9 @@ static int pie_print_xstats(struct qdisc_util *qu, FILE *f,
>  
>  	st = RTA_DATA(xstats);
>  
> -	/* prob is returned as a fracion of (2^56 - 1) */
> +	/* prob is returned as a fracion of maximum integer value */
>  	print_float(PRINT_ANY, "prob", "  prob %lg",
> -		    (double)st->prob / (double)(UINT64_MAX >> 8));
> +		    (double)st->prob / (double)UINT64_MAX);
>  	print_uint(PRINT_JSON, "delay", NULL, st->delay);
>  	print_string(PRINT_FP, NULL, " delay %s", sprint_time(st->delay, b1));
>  
> 

applied to iproute2-next. Thanks

