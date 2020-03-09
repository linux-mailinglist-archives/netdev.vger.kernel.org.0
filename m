Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 123B017E624
	for <lists+netdev@lfdr.de>; Mon,  9 Mar 2020 18:55:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726295AbgCIRyu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 13:54:50 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:42312 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726170AbgCIRyt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Mar 2020 13:54:49 -0400
Received: by mail-pg1-f194.google.com with SMTP id h8so5045371pgs.9
        for <netdev@vger.kernel.org>; Mon, 09 Mar 2020 10:54:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=mnxkcqYnzX4jvavmFTLSAMX9c5tW1SHyfd89yzhh7UE=;
        b=hA7aiLFqDAZgf12KD040mOCd2IkLaiMjSIC8a3/Cqtr4TL2cTQAYXDY6qiSVxnps7v
         MQ4Syn2jWUSDjy92i4O+miMLvpAOywvbqdK1UaoyDkzovoyLmsnzZSf+FvRZkTXIDJuP
         cGc3Zb11WGNkYcWem2vN7YD7Gqgn4jPusDccpJ9kHwQwmWVKykQCy/xr5DG5rVPY3Dlg
         JZ2DmtQM2j62fhlTlnsmNDSIHdOWkVtl7IrMr2wmoAPLlEm8n+n5XGU+D7w9XZt0tEAV
         7ZVvi/sMkjtWq3llzp5LxFRYRKGjVWp9BdtZcbp+qS3+ydlRnh5QS/KU/Kub7exe178t
         3haA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mnxkcqYnzX4jvavmFTLSAMX9c5tW1SHyfd89yzhh7UE=;
        b=bzEelRXYOscOZ5ftAqLmvqs4Vni2EinMEgkm0DmI4ruk27cuZUZefneFQGLpNiB4ni
         jCq4Ripsn5avpRXi5xx4FFjztsEL/X3rKVw8htJ1OAG7518m+dAfKLH202ea0sSoXTdn
         cP2IpjHOgk7P8w0NjbdDzEE1W6L58eLQpz9qn3tbHmlcX/F+sHILNSqWOJ2wNQYnX8ft
         MDnx2riE0QKwSqqgb8znWA6zI0w+8wR4mEO16kyddho/kdv4l8cfp9YRBnEdIIBn/EzS
         Tp+YS46zvoDmnJrv4I57IbsnCxFS3Rk3xDg+KNWA8DiDx1llPIsyRJLqCY7u3m8i22D9
         kICA==
X-Gm-Message-State: ANhLgQ206eK7PUHhiAJlW6+NG8+NtUT7ZPCtkCCWbLOfjV+nXBtD1q7x
        R+d93bWVmGOWQttw4AIFQXY=
X-Google-Smtp-Source: ADFU+vsIUJDiS8Ny2j6sYIgDTaxNXaz7UbK5baoiFg7ltDbXw8Ga8nJewVEX1SuCswDklJMC+/bcRw==
X-Received: by 2002:aa7:94a5:: with SMTP id a5mr7255042pfl.67.1583776488375;
        Mon, 09 Mar 2020 10:54:48 -0700 (PDT)
Received: from ?IPv6:2620:15c:2c1:200:55c7:81e6:c7d8:94b? ([2620:15c:2c1:200:55c7:81e6:c7d8:94b])
        by smtp.gmail.com with ESMTPSA id j8sm210331pjb.4.2020.03.09.10.54.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Mar 2020 10:54:47 -0700 (PDT)
Subject: Re: [PATCH iproute2-next] tc: pie: change maximum integer value of
 tc_pie_xstats->prob
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     David Ahern <dsahern@gmail.com>,
        Leslie Monis <lesliemonis@gmail.com>,
        Linux NetDev <netdev@vger.kernel.org>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        "Mohit P . Tahiliani" <tahiliani@nitk.edu.in>,
        Gautam Ramakrishnan <gautamramk@gmail.com>
References: <20200305162540.4363-1-lesliemonis@gmail.com>
 <37e346e2-beb6-5fcd-6b24-9cb1f001f273@gmail.com>
 <773f285c-f9f2-2253-6878-215a11ea2e67@gmail.com>
Message-ID: <e1ad29bb-7766-7c9d-3191-47a5e866e07e@gmail.com>
Date:   Mon, 9 Mar 2020 10:54:45 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <773f285c-f9f2-2253-6878-215a11ea2e67@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/9/20 10:48 AM, Eric Dumazet wrote:
> 
> 
> On 3/8/20 7:49 PM, David Ahern wrote:
>> On 3/5/20 9:25 AM, Leslie Monis wrote:
>>> Kernel commit 105e808c1da2 ("pie: remove pie_vars->accu_prob_overflows"),
>>> changes the maximum value of tc_pie_xstats->prob from (2^64 - 1) to
>>> (2^56 - 1).
>>>
>>> Signed-off-by: Mohit P. Tahiliani <tahiliani@nitk.edu.in>
>>> Signed-off-by: Gautam Ramakrishnan <gautamramk@gmail.com>
>>> Signed-off-by: Leslie Monis <lesliemonis@gmail.com>
>>> ---
>>>  tc/q_pie.c | 4 ++--
>>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>>
>>
>> applied to iproute2-next. Thanks
>>
>>
> 
> This means that iproute2 is incompatible with old kernels.
> 
> commit 105e808c1da2 ("pie: remove pie_vars->accu_prob_overflows") was wrong,
> it should not have changed user ABI.
> 
> The rule is : iproute2 v-X should work with linux-<whatever-version>
> 
> Since pie MAX_PROB was implicitly in the user ABI, it can not be changed,
> at least from user point of view.
> 

So this kernel patch might be needed :

diff --git a/net/sched/sch_pie.c b/net/sched/sch_pie.c
index f52442d39bf57a7cf7af2595638a277e9c1ecf60..c65077f0c0f39832ee97f4e89f25639306b19281 100644
--- a/net/sched/sch_pie.c
+++ b/net/sched/sch_pie.c
@@ -493,7 +493,7 @@ static int pie_dump_stats(struct Qdisc *sch, struct gnet_dump *d)
 {
        struct pie_sched_data *q = qdisc_priv(sch);
        struct tc_pie_xstats st = {
-               .prob           = q->vars.prob,
+               .prob           = q->vars.prob << BITS_PER_BYTE,
                .delay          = ((u32)PSCHED_TICKS2NS(q->vars.qdelay)) /
                                   NSEC_PER_USEC,
                .packets_in     = q->stats.packets_in,
