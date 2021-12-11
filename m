Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DED304715C4
	for <lists+netdev@lfdr.de>; Sat, 11 Dec 2021 20:42:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231899AbhLKTm3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Dec 2021 14:42:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231892AbhLKTm2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Dec 2021 14:42:28 -0500
Received: from mail-qk1-x734.google.com (mail-qk1-x734.google.com [IPv6:2607:f8b0:4864:20::734])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BC7BC061714
        for <netdev@vger.kernel.org>; Sat, 11 Dec 2021 11:42:28 -0800 (PST)
Received: by mail-qk1-x734.google.com with SMTP id 132so10785034qkj.11
        for <netdev@vger.kernel.org>; Sat, 11 Dec 2021 11:42:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=MgCfb7bjZq8jGT43jHVhjxHRaIKdUKHZwpDmAbGToDk=;
        b=78vFd2va8M3Gd9vae8zIS2I2AlfDZMVs8jrZiB3icVlPAUtP2jsIqNK9O28UUneZHW
         Kk8MIwln61HG9TFZ4G4hzAzZhxWUGxsE9KjGB1WdCOaNqcdbsQR3jXkVWiOoYZpxk7Nr
         1OicY9kSH/tzLQj3wuhJq8vsj5v84cLwUZaflSivi6RFUH9QRQ8uY3DSJJUifjQ6Cstz
         026zT+Y/w6Iot1tkEqArElpuDmdCSmUERZ0XWTlxail7iCmUiSumg7Zv9cxV8UjySSbq
         pBljQDBWFnws5hqyd1qbzelbOSBu1dZm+vmWfLBWeAOvopT+n7SVAydapolcFWuKQfXL
         Y6OA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=MgCfb7bjZq8jGT43jHVhjxHRaIKdUKHZwpDmAbGToDk=;
        b=Yvo1sjPr7l98gXRn3MEfrLK1OIZc4H6QU9CwF7WPkImS3AY0uXVLB+BpuJoxcmZRhh
         0l5HXNdhldaouUaf/A2Hno/m3nezpM9aMrJxPW8Jk69vuhzMA3UPI9lvY4z0xlgl6Ewe
         lDtJr+ykqB4m0TQh9j0qyyz97mz72vYz2ExVPGtxUV5i8I+mEGE3EOk+tsUSXNStEmJH
         IHJiBdalBhKwPYh0UjDDOBQ42zI2HwKL/tbNxcgKr8+FOD/FdOYnTybwRIEn9LzX9AfS
         j623/ojeOcWgQmGQ1U2+wmEQ2m195EPLn2tCrgGY2L2ri5pSWsztJFA3Yto+OSWJAP8f
         xAVw==
X-Gm-Message-State: AOAM533a9hrG/FHFl1cCImfgIS26phE/LnmVRiQjgAILOKBjneX+lhsh
        ct9Le9grR+399+ogZOehS3HIUA==
X-Google-Smtp-Source: ABdhPJyDkdxvm9oJ5XZ3K0WQLSW/Ej95pG+mC9ju6BPYH+hZyI/qwcBqeHgksM5GFQPtV014b49FLg==
X-Received: by 2002:a37:a611:: with SMTP id p17mr27176870qke.669.1639251747463;
        Sat, 11 Dec 2021 11:42:27 -0800 (PST)
Received: from [192.168.1.173] (bras-base-kntaon1617w-grc-33-142-112-185-132.dsl.bell.ca. [142.112.185.132])
        by smtp.googlemail.com with ESMTPSA id o21sm5071612qta.89.2021.12.11.11.42.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 11 Dec 2021 11:42:26 -0800 (PST)
Message-ID: <a262c1ba-27e4-25cb-460c-c168a938f70e@mojatatu.com>
Date:   Sat, 11 Dec 2021 14:42:25 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [PATCH v6 net-next 06/12] flow_offload: allow user to offload tc
 action to net device
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
 <20211209092806.12336-7-simon.horman@corigine.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
In-Reply-To: <20211209092806.12336-7-simon.horman@corigine.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-12-09 04:28, Simon Horman wrote:
> From: Baowen Zheng <baowen.zheng@corigine.com>


>   
>   /* These structures hold the attributes of bpf state that are being passed
> diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
> index f6970213497a..15662cad5bca 100644
> --- a/include/net/flow_offload.h
> +++ b/include/net/flow_offload.h
> @@ -551,6 +551,23 @@ struct flow_cls_offload {
>   	u32 classid;
>   };
>   
> +enum flow_act_command {

Readability:
flow_offload_act_command?


> +
> +struct flow_offload_action *flow_action_alloc(unsigned int num_actions);

Same here:
s/flow_action_alloc/offload_action_alloc

> +struct flow_offload_action *flow_action_alloc(unsigned int num_actions)
> +{




>   
> +static unsigned int tcf_act_num_actions_single(struct tc_action *act)
> +{
> +	if (is_tcf_pedit(act))
> +		return tcf_pedit_nkeys(act);
> +	else
> +		return 1;
> +}

Again - above only seems needed for offload. Could we name this
appropriately?

> +
> +static int flow_action_init(struct flow_offload_action *fl_action,


I think i mentioned this earlier:

> +
> +static int tcf_action_offload_cmd(struct flow_offload_action *fl_act,
> +				  struct netlink_ext_ack *extack)\

nice


> +
> +/* offload the tc command after inserted */

"after it is inserted"

> +static int tcf_action_offload_add(struct tc_action *action,

nice.

\
> +	err = tcf_action_offload_cmd(fl_action, extack);
> +	tc_cleanup_flow_action(&fl_action->action);

tc_cleanup_offload_action()?


> +static int tcf_action_offload_del(struct tc_action *action)

nice.

> +{
> +	struct flow_offload_action fl_act = {};
> +	int err = 0;
> +
> +	err = flow_action_init(&fl_act, action, FLOW_ACT_DESTROY, NULL);
> +	if (err)
> +		return err;
> +
> +	return tcf_action_offload_cmd(&fl_act, NULL);
> +}
> +
>   static void tcf_action_cleanup(struct tc_action *p)
>   {

mention offload somewhere there?



> diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
> index 33b81c867ac0..2a1cc7fe2dd9 100644
> --- a/net/sched/cls_api.c
> +++ b/net/sched/cls_api.c
> @@ -3488,8 +3488,8 @@ static int tc_setup_flow_act(struct tc_action *act,
>   #endif
>   }
>   
> -int tc_setup_flow_action(struct flow_action *flow_action,
> -			 const struct tcf_exts *exts)
> +int tc_setup_action(struct flow_action *flow_action,
> +		    struct tc_action *actions[])
>   {
>   	int i, j, index, err = 0;
>   	struct tc_action *act;
> @@ -3498,11 +3498,11 @@ int tc_setup_flow_action(struct flow_action *flow_action,
>   	BUILD_BUG_ON(TCA_ACT_HW_STATS_IMMEDIATE != FLOW_ACTION_HW_STATS_IMMEDIATE);
>   	BUILD_BUG_ON(TCA_ACT_HW_STATS_DELAYED != FLOW_ACTION_HW_STATS_DELAYED);
>   
> -	if (!exts)
> +	if (!actions)
>   		return 0;
>   
>   	j = 0;
> -	tcf_exts_for_each_action(i, act, exts) {
> +	tcf_act_for_each_action(i, act, actions) {
>   		struct flow_action_entry *entry;
>   
>   		entry = &flow_action->entries[j];
> @@ -3531,6 +3531,19 @@ int tc_setup_flow_action(struct flow_action *flow_action,
>   	spin_unlock_bh(&act->tcfa_lock);
>   	goto err_out;
>   }
> +
> +int tc_setup_flow_action(struct flow_action *flow_action,
> +			 const struct tcf_exts *exts)
> +{

I think i mentioned this one earlier:
tc_setup_offload_action()

cheers,
jamal
