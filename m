Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 098CC4715D1
	for <lists+netdev@lfdr.de>; Sat, 11 Dec 2021 20:52:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231911AbhLKTwK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Dec 2021 14:52:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231892AbhLKTwK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Dec 2021 14:52:10 -0500
Received: from mail-qk1-x729.google.com (mail-qk1-x729.google.com [IPv6:2607:f8b0:4864:20::729])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D66E8C061714
        for <netdev@vger.kernel.org>; Sat, 11 Dec 2021 11:52:09 -0800 (PST)
Received: by mail-qk1-x729.google.com with SMTP id l25so1519428qkl.5
        for <netdev@vger.kernel.org>; Sat, 11 Dec 2021 11:52:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=oUl3KB9nBgGHwP9XDw/2kp7IoOq8QUmHeGaFiFl1pXg=;
        b=G242VieoMNNndTVY6oLOlTAOQLeXSkHpU5u4Xr1InCDPuAneFowWMinhr4a990Ukyc
         SChOXsvcBDJ3URATMv1hc497mEBB6CbjRMLg42ZjtEFpSOVWyzdudibJFuLIDnxOu6fh
         2d6JZj1mACXzu5unUxVssHsJywh9w+k4IBpYR+Rb9VOPcy2QYl2J3Qv0IlbBDkLCNd3y
         m56utv+p41OKosLzkn/wkBadLJEJ0lDRvH/zTU9gJAxkOWIPZUvOzhCFUYbYCw1X6o7W
         LkuvtA9isIsbehmdGSMXjqx40BsaDPQ7Dq91Qv1HKR9D5E33PyNihYwF+QJ3J88jdeXz
         eciw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=oUl3KB9nBgGHwP9XDw/2kp7IoOq8QUmHeGaFiFl1pXg=;
        b=NlP2QyeVw10+HMZgJ18D7soTV+ZZaAKzMGDepkXCuofSADW5GSj4NwzmN0B/wjyPH7
         8F1udHjwf5o/zv2y2/0GOOPZc0kG1w6tVXfRR2Aiacxmj2gFECxd1+VfH1qNmlHLu1SY
         EdD2+vfVaEXVpXD8JoYmL+Q3MSaU0zCZ50jNekH8exU0Z8/iE2Uqkay1uDljRDjjOCuA
         esV4IhzIdoLF+dtS9gZVPdnwaiPfK0886Lr0SoM3FBgVXI4MBE7aq0+rIQs3+0C1kgvZ
         RU4x9aJsWqS4VqzCbxue0CeT3Dj3nolheIG/e8lCQJPkY6Na+7sGQ8NS54GElRJpFBY3
         yvrg==
X-Gm-Message-State: AOAM531B5aqEOXMu1EU7FBaPUnV2L4PKu55WLNHQ8hysvJ1CTy8NrDAJ
        r14SbFMG2oOWBylX1wB2R+Hq0g==
X-Google-Smtp-Source: ABdhPJz0c82WYYMEfJGvEYenpYT6TtX/X7bqhoOKlHgxuFJOqyR8FdNJ8hGgT/+1UW8ysvbKgMCc4g==
X-Received: by 2002:a37:89c7:: with SMTP id l190mr27072404qkd.492.1639252329085;
        Sat, 11 Dec 2021 11:52:09 -0800 (PST)
Received: from [192.168.1.173] (bras-base-kntaon1617w-grc-33-142-112-185-132.dsl.bell.ca. [142.112.185.132])
        by smtp.googlemail.com with ESMTPSA id y12sm3486629qko.36.2021.12.11.11.52.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 11 Dec 2021 11:52:08 -0800 (PST)
Message-ID: <c03a786e-6d21-1d93-2b97-9bf9a13250ef@mojatatu.com>
Date:   Sat, 11 Dec 2021 14:52:07 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [PATCH v6 net-next 08/12] flow_offload: add process to update
 action stats from hardware
Content-Language: en-US
To:     Simon Horman <simon.horman@corigine.com>, netdev@vger.kernel.org
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Jiri Pirko <jiri@resnulli.us>, Oz Shlomo <ozsh@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Louis Peens <louis.peens@corigine.com>,
        oss-drivers@corigine.com
References: <20211209092806.12336-1-simon.horman@corigine.com>
 <20211209092806.12336-9-simon.horman@corigine.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
In-Reply-To: <20211209092806.12336-9-simon.horman@corigine.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-12-09 04:28, Simon Horman wrote:
> include/net/act_api.h |  1 +
>   include/net/pkt_cls.h | 18 ++++++++++--------
>   net/sched/act_api.c   | 34 ++++++++++++++++++++++++++++++++++
>   3 files changed, 45 insertions(+), 8 deletions(-)
> 
> diff --git a/include/net/act_api.h b/include/net/act_api.h
> index 7e4e79b50216..ce094e79f722 100644
> --- a/include/net/act_api.h
> +++ b/include/net/act_api.h
> @@ -253,6 +253,7 @@ void tcf_action_update_stats(struct tc_action *a, u64 bytes, u64 packets,
>   			     u64 drops, bool hw);
>   int tcf_action_copy_stats(struct sk_buff *, struct tc_action *, int);
>   
> +int tcf_action_update_hw_stats(struct tc_action *action);
>   int tcf_action_check_ctrlact(int action, struct tcf_proto *tp,
>   			     struct tcf_chain **handle,
>   			     struct netlink_ext_ack *newchain);
> diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
> index 13f0e4a3a136..1942fe72b3e3 100644
> --- a/include/net/pkt_cls.h
> +++ b/include/net/pkt_cls.h
> @@ -269,18 +269,20 @@ tcf_exts_stats_update(const struct tcf_exts *exts,
>   #ifdef CONFIG_NET_CLS_ACT
>   	int i;
>   
> -	preempt_disable();
> -
>   	for (i = 0; i < exts->nr_actions; i++) {
>   		struct tc_action *a = exts->actions[i];
>   
> -		tcf_action_stats_update(a, bytes, packets, drops,
> -					lastuse, true);
> -		a->used_hw_stats = used_hw_stats;
> -		a->used_hw_stats_valid = used_hw_stats_valid;
> -	}
> +		/* if stats from hw, just skip */
> +		if (tcf_action_update_hw_stats(a)) {
> +			preempt_disable();
> +			tcf_action_stats_update(a, bytes, packets, drops,
> +						lastuse, true);
> +			preempt_enable();
>   
> -	preempt_enable();
> +			a->used_hw_stats = used_hw_stats;
> +			a->used_hw_stats_valid = used_hw_stats_valid;
> +		}
> +	}
>   #endif
>   }

Sorry - didnt quiet follow this one even after reading to the end.
I may have missed the obvious in the equivalence:
In the old code we did the preempt first then collect. The changed
version only does it if tcf_action_update_hw_stats() is true.

cheers,
jamal
