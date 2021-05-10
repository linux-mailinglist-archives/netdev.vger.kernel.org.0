Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8211B379A3A
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 00:37:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231334AbhEJWiy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 May 2021 18:38:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231290AbhEJWit (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 May 2021 18:38:49 -0400
Received: from mail-qk1-x730.google.com (mail-qk1-x730.google.com [IPv6:2607:f8b0:4864:20::730])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 128FFC061761
        for <netdev@vger.kernel.org>; Mon, 10 May 2021 15:37:43 -0700 (PDT)
Received: by mail-qk1-x730.google.com with SMTP id a22so16476280qkl.10
        for <netdev@vger.kernel.org>; Mon, 10 May 2021 15:37:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=LFIY5DTUVOGEpqXJ1FuCnqeUpbxW+eDBJH0O73ZkNa4=;
        b=C4gSoR3v3S8trQRgm3KSJYsUenYWThMgbJrrP8OMw9lSjs5EQAHdeaHDUDm0Wcnxjg
         9RuUjNhVQbof2d6Cttcl45a+wTYfqOSsltaXAOj2+avfAGiB0YWu/SsElVC82Y0fzL7k
         Q4wD87zJZJtDT4W2qzCSVrdXmyx1lfdJA3RzL0LwSV+On5BL64ONc+lKcQkVVgnmdtx5
         b6FxjMGXLSMFf2qnwxMH2qvfSP76vmvhguT+P9xv1WlQaSIFbzITg6TwZIQteJBZBH2v
         F8lAgrIv0mkhFnyW24akqptP32D+2Q//uhe2AdaHFerV+dJI+7QTIZGVKORAFuoB+dfp
         9kbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LFIY5DTUVOGEpqXJ1FuCnqeUpbxW+eDBJH0O73ZkNa4=;
        b=V+6XOAWM3ajE78o4wbx1rPX3DZqdeVxC1UJ5WNwzanQ9Aa1rP47jlqO84d5lpL+zss
         RxthlxdZjLTBZqIHEOE05Xbn2Bb3xGRO364eu2Gca0A/za0LeqpAw/mo2ZDdz+XLSg2Z
         cgWgSM8H/JhRE44MBLqRc4S5gH3AurKb0gC1HfI+tZhcTZT6/lHP7wZLmfdnagNeAEc9
         fWNtTbaAvz8UbzMw6I/MgBjFGs2MMK/XrHQuztgwxYfN4t1Bs0aku/xTm1xHD0kN7Gow
         WYmKpybCtA0h8A9y74uFAYxOOAf8pVH6XHXlvRZv+01gNsdsVr2JPIi6Y3nzGyrXC1+h
         5ouA==
X-Gm-Message-State: AOAM530k7dhmHEcB7wS8qzN+SyFX6tnqGL+X5yDIsi06goP8t3cSrSsV
        xU/WJeVLGv0J2vuOuRL86tqlaw==
X-Google-Smtp-Source: ABdhPJy7wWkQqjjGFkwTgGyMk44ZZRngHK5fooC7Lg5QUiRDWMsHvsQOASmj/QyETuNoR7bh2TsfCw==
X-Received: by 2002:a05:620a:1f9:: with SMTP id x25mr25551059qkn.370.1620686262288;
        Mon, 10 May 2021 15:37:42 -0700 (PDT)
Received: from [192.168.1.79] (bras-base-kntaon1617w-grc-25-174-95-97-70.dsl.bell.ca. [174.95.97.70])
        by smtp.googlemail.com with ESMTPSA id a189sm12244851qkd.46.2021.05.10.15.37.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 May 2021 15:37:41 -0700 (PDT)
Subject: Re: [RFC net-next] net/flow_offload: allow user to offload tc action
 to net device
To:     Simon Horman <simon.horman@netronome.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Louis Peens <louis.peens@netronome.com>
References: <20210429081014.28498-1-simon.horman@netronome.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <2d2e4ae2-5de0-8c58-cd7a-ee3c841afd45@mojatatu.com>
Date:   Mon, 10 May 2021 18:37:41 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <20210429081014.28498-1-simon.horman@netronome.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-04-29 4:10 a.m., Simon Horman wrote:
> From: Baowen Zheng <baowen.zheng@corigine.com>
> 
> Allow use of flow_indr_dev_register/flow_indr_dev_setup_offload to offload
> tc actions independent of flows.
> 
> The motivation for this work is to prepare for using TC police action
> instances to provide hardware offload of OVS metering feature - which calls
> for policers that may be used my multiple flows and whose lifecycle is
> independent of any flows that use them.
> 

Finally! ;->
Happy to see this effort.

>   /* These structures hold the attributes of bpf state that are being passed
> diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
> index dc5c1e69cd9f..5fd8b5600b4a 100644
> --- a/include/net/flow_offload.h
> +++ b/include/net/flow_offload.h
> @@ -551,6 +551,21 @@ struct flow_cls_offload {
>   	u32 classid;
>   };
>   
> +enum flow_act_command {
> +	FLOW_ACT_REPLACE,
> +	FLOW_ACT_DESTROY,
> +	FLOW_ACT_STATS,
> +};
> +

Should that be CREATE as well as REPLACE/UPDATE?
Missing GET?


> +struct flow_offload_action {
> +	struct netlink_ext_ack *extack;
> +	enum flow_act_command command;
> +	struct flow_stats stats;
> +	struct flow_action action;
> +};

On this:

On 2021-04-29 12:49 p.m., Ido Schimmel wrote:
 > Can you share an example of the tc commands? You might be able to
 > achieve what you want by patching NFP to take into account the policer
 > index in 'struct flow_action_entry'. Seems that it currently assumes
 > that each policer is a new policer.
 >
 > FTR, I do support the overall plan to offload actions independent of
 > flows and to associate stats with actions.


I think Ido may be saying the same thing, but let me provide
my $0.02 Canadiana:

We generally need to identify the instance of a specific action i.e
its general attributes. In tc currently this maps to an index;

I would categorize two types of actions:
1) Stateless, example:

A lot of actions currently fall under this category.

--
sudo tc actions add action drop index 10
--

And later bound to say two flow entries by just specifying
the action {type id,index}:

---
sudo tc filter add dev XX parent ffff: protocol ip prio 8 \
u32 match ip dst 19.0.0.8/32 flowid 1:10 action gact index 10
#
sudo tc filter add dev XX parent ffff: protocol ip prio 7 \
u32 match ip src 10.0.0.0/24 flowid 1:11 action gact index 10
--

In such a case, in hardware this would typically map the specified
index to some hardware counter table index with the same index (10).

If user doesnt specify the index then either the hardware or the kernel
provides one. And user should be able to retrieve it with a GET.
[I have some patches that would actually return the index in the
extack somewhere]

2) stateful

There are other attributes other than counters that are updated
maintained. In this case i think the attribute id aka "index"
may be attribute specific:
Only example i can think of right now is policer (meters).

in hardware such an index will likely map to a meter index.
So for stateless actions i when i enter two commands

Same deal with config, i can create the policer, get,
update, delete it etc independently and maintain the binding
connection separately.

In both cases, dumping just the actions reduces the amount
of data crossing from hw->kernel->userspace.
If you have a lot of flows this becomes extremely valuable.

cheers,
jamal
