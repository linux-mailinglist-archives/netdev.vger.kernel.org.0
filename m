Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E34E17E604
	for <lists+netdev@lfdr.de>; Mon,  9 Mar 2020 18:48:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726333AbgCIRsy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 13:48:54 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:45849 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726096AbgCIRsx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Mar 2020 13:48:53 -0400
Received: by mail-pg1-f194.google.com with SMTP id m15so5030503pgv.12
        for <netdev@vger.kernel.org>; Mon, 09 Mar 2020 10:48:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=uInS+AOGNe1v0SVJtaApL+/ZTOekEWuoPaqDPN1Su10=;
        b=bNhwoewQFyzLg3MuANNzSoekg9PK+ukIf3/KkaKejqFDNUdWOQ5i1ty/ES5SBHzcj7
         u4D/tD1ODwLnGzt70HBfQ81a2I1laj+Q9iAPZqRTrQXcLWIB7PNvyWrqH4jA1v8olKMR
         gShHjoxJzktHX7D2HiRi9pXHbetrUZTi2kiY+BouP0pfqkNHd9EK2dLOh3OQ4361OB2O
         +MLiiQQ3UYuahdNlVP/XGZRZL7llkJNhkkD0SntQPH8K26DlG4gC/pmOEhojGuxc8dst
         jCnyhxJZnmkF9ZQpOcbp4QIMT7klwgw/R/aO3Vc0oNlRo6Ex8pCz3h3Dk9MhRoHD1A6/
         Lfzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=uInS+AOGNe1v0SVJtaApL+/ZTOekEWuoPaqDPN1Su10=;
        b=JbyFKM9rKtXpIEOKtrypNRBrtW+bfZf1slvzR3uVvRTPPwSaWcmaAa5n9nZstwdwyw
         RuUcOtZ7EOBPg73a62jueB4/u0oHtehVKeGPnY8kKNQbYBiW6jh42a7lB3oUQ+/expIn
         PEhfcTKSIDZBzVyw7UgAhkQj5CTP96m53kitrg5ZJAHUIhDLcOU3XYxfpzuz0o7w3FZj
         ew/E3U5ak7E6L6FhARY1kVkZ8L+PWwU5JCkwG6pIdNXhsOlBEWpJzIZrWXnOO9f/tIaP
         OQbauI1Z5TY3908aqkjG6RipiWJqS3+B3wOLAYrKuXYZPjqxyLvsfTb75AJpSZWDLyan
         JS6A==
X-Gm-Message-State: ANhLgQ1aBbv9t+HmhDtQXdOWQ+/cmB3g2Y4oInRuHS15zG/4KL43xC30
        +tma4IjlDU0hvun2gaV3fHDddaEf
X-Google-Smtp-Source: ADFU+vuv+kW7VniJVtpky7+iUhpiK+zkA3uHeFRiNuyqFv5yYZ+T8IHzDntqxfWdNAXJbNSIdnIxAA==
X-Received: by 2002:a63:8b42:: with SMTP id j63mr2093582pge.27.1583776132636;
        Mon, 09 Mar 2020 10:48:52 -0700 (PDT)
Received: from ?IPv6:2620:15c:2c1:200:55c7:81e6:c7d8:94b? ([2620:15c:2c1:200:55c7:81e6:c7d8:94b])
        by smtp.gmail.com with ESMTPSA id l3sm191264pjt.13.2020.03.09.10.48.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Mar 2020 10:48:52 -0700 (PDT)
Subject: Re: [PATCH iproute2-next] tc: pie: change maximum integer value of
 tc_pie_xstats->prob
To:     David Ahern <dsahern@gmail.com>,
        Leslie Monis <lesliemonis@gmail.com>,
        Linux NetDev <netdev@vger.kernel.org>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        "Mohit P . Tahiliani" <tahiliani@nitk.edu.in>,
        Gautam Ramakrishnan <gautamramk@gmail.com>
References: <20200305162540.4363-1-lesliemonis@gmail.com>
 <37e346e2-beb6-5fcd-6b24-9cb1f001f273@gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <773f285c-f9f2-2253-6878-215a11ea2e67@gmail.com>
Date:   Mon, 9 Mar 2020 10:48:50 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <37e346e2-beb6-5fcd-6b24-9cb1f001f273@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/8/20 7:49 PM, David Ahern wrote:
> On 3/5/20 9:25 AM, Leslie Monis wrote:
>> Kernel commit 105e808c1da2 ("pie: remove pie_vars->accu_prob_overflows"),
>> changes the maximum value of tc_pie_xstats->prob from (2^64 - 1) to
>> (2^56 - 1).
>>
>> Signed-off-by: Mohit P. Tahiliani <tahiliani@nitk.edu.in>
>> Signed-off-by: Gautam Ramakrishnan <gautamramk@gmail.com>
>> Signed-off-by: Leslie Monis <lesliemonis@gmail.com>
>> ---
>>  tc/q_pie.c | 4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
> 
> applied to iproute2-next. Thanks
> 
> 

This means that iproute2 is incompatible with old kernels.

commit 105e808c1da2 ("pie: remove pie_vars->accu_prob_overflows") was wrong,
it should not have changed user ABI.

The rule is : iproute2 v-X should work with linux-<whatever-version>

Since pie MAX_PROB was implicitly in the user ABI, it can not be changed,
at least from user point of view.

