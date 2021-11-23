Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1919E45ABF8
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 20:03:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238580AbhKWTHB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 14:07:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239776AbhKWTG6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Nov 2021 14:06:58 -0500
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B71BFC061748
        for <netdev@vger.kernel.org>; Tue, 23 Nov 2021 11:03:49 -0800 (PST)
Received: by mail-io1-xd2c.google.com with SMTP id p23so29344742iod.7
        for <netdev@vger.kernel.org>; Tue, 23 Nov 2021 11:03:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=KJrmW5XdQLwcnKOMG0QsEYRLbRCuD5zlYhN5nSR8U3Y=;
        b=VGXPeWLGBnX7xTQydySd2ciHG6fRAh3GafT4K83irgLKWRb1ZAu6xmPOLfYRWboYtg
         +1WfzO/JqwR9LEdtsYC7+ZOrShD2cjV0Y6fnEFNC2dUysqo0m56Im5e9vYsEVcPTLMoz
         7zsb07n93umuI0LTK5mHqNcGK5khGc0Ow3yA7ikZPaTO2MOCNtm1MxMG13BWBd05ilO1
         zCoF6avr94OjTblOhs8WRd+V33Yujh3Cp/7DYEdoJ2RdndM5nRO4fOt0GeI7HvJVKm86
         xUYaxAsCUzeSK/wpYViKl7n5XPWzFbwOaUrj4Y0BUDh3yj/YGz+72LTsvoymIMMQtLf1
         caiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=KJrmW5XdQLwcnKOMG0QsEYRLbRCuD5zlYhN5nSR8U3Y=;
        b=DXtjIN+SSmczsc5ynHF1YOJj9Zc02x22bJk3RYhcf5lRjaZg0uId6hJ9YE4QheOMu3
         BtFvB1zFxSaXCDq/Be+19irJXqsbVB8XsTg2KzcXhKnvATQrJ2dTUUg8KRbUv+WwIXjD
         ehuihJrKH8uvx37sjbi9HKr/IxuzXnyJzTbzgs8V7lMhxDivmWRUsB9A2rSkTyvbKAvq
         ylyc5zwxbLVbLb5EKh+b/nijrZMAQOEK6wcWafxHh0QNuYhOSrKvVNAUnSJJBruKdA1a
         9GCUjkiXW70gjUCa5dCI2n+RYP4Tr/NHflJhlMNZL8cFKqUp+pb4d6PPOlas4eJiA6LF
         RBoA==
X-Gm-Message-State: AOAM532lj+mjjE9VXZkBt5ikOMIBssqySor8D8P41+Q4h/HIincovDOQ
        Qohp4Gr88bCnY1rRWp3Q23xxZg==
X-Google-Smtp-Source: ABdhPJybiwJW1WS5c7aMtBirm+5pw65MCtZmVsrOXwEgcGfkOQpmIWohfp1HsiIttvYXSBCqUX7/3g==
X-Received: by 2002:a05:6602:2c83:: with SMTP id i3mr8610084iow.54.1637694229064;
        Tue, 23 Nov 2021 11:03:49 -0800 (PST)
Received: from [192.168.1.173] (bras-base-kntaon1617w-grc-33-142-112-185-132.dsl.bell.ca. [142.112.185.132])
        by smtp.googlemail.com with ESMTPSA id i26sm9671532ila.12.2021.11.23.11.03.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Nov 2021 11:03:48 -0800 (PST)
Message-ID: <404a4871-0e12-3cdc-e8c7-b0c85e068c53@mojatatu.com>
Date:   Tue, 23 Nov 2021 14:03:46 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Re: [PATCH v4 04/10] flow_offload: allow user to offload tc action to
 net device
Content-Language: en-US
To:     Baowen Zheng <baowen.zheng@corigine.com>,
        Simon Horman <simon.horman@corigine.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Jiri Pirko <jiri@resnulli.us>, Oz Shlomo <ozsh@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>,
        Louis Peens <louis.peens@corigine.com>,
        oss-drivers <oss-drivers@corigine.com>
References: <20211118130805.23897-1-simon.horman@corigine.com>
 <20211118130805.23897-5-simon.horman@corigine.com>
 <cf194dc4-a7c9-5221-628b-ab26ceca9583@mojatatu.com>
 <DM5PR1301MB2172EFE3AC44E84D89D3D081E7609@DM5PR1301MB2172.namprd13.prod.outlook.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
In-Reply-To: <DM5PR1301MB2172EFE3AC44E84D89D3D081E7609@DM5PR1301MB2172.namprd13.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-11-23 03:23, Baowen Zheng wrote:
> On November 22, 2021 8:25 PM, Jamal Hadi Salim wrote:
>> On 2021-11-18 08:07, Simon Horman wrote:
>>
>> [..]
>>
>>> --- a/net/sched/act_api.c
>>> +++ b/net/sched/act_api.c
>>> @@ -21,6 +21,19 @@
>>> +#include <net/tc_act/tc_pedit.h>
>>> +#include <net/tc_act/tc_mirred.h>
>>> +#include <net/tc_act/tc_vlan.h>
>>> +#include <net/tc_act/tc_tunnel_key.h> #include <net/tc_act/tc_csum.h>
>>> +#include <net/tc_act/tc_gact.h> #include <net/tc_act/tc_police.h>
>>> +#include <net/tc_act/tc_sample.h> #include <net/tc_act/tc_skbedit.h>
>>> +#include <net/tc_act/tc_ct.h> #include <net/tc_act/tc_mpls.h>
>>> +#include <net/tc_act/tc_gate.h> #include <net/flow_offload.h>
>>>
>>>    #ifdef CONFIG_INET
>>>    DEFINE_STATIC_KEY_FALSE(tcf_frag_xmit_count);
>>> @@ -129,8 +142,157 @@ static void free_tcf(struct tc_action *p)
>>>    	kfree(p);
>>>    }
>>>
>>> +static int flow_action_init(struct flow_offload_action *fl_action,
>>> +			    struct tc_action *act,
>>> +			    enum flow_act_command cmd,
>>> +			    struct netlink_ext_ack *extack) {
>>> +	if (!fl_action)
>>> +		return -EINVAL;
>>> +
>>> +	fl_action->extack = extack;
>>> +	fl_action->command = cmd;
>>> +	fl_action->index = act->tcfa_index;
>>> +
>>> +	if (is_tcf_gact_ok(act)) {
>>> +		fl_action->id = FLOW_ACTION_ACCEPT;
>>> +	} else if (is_tcf_gact_shot(act)) {
>>> +		fl_action->id = FLOW_ACTION_DROP;
>>> +	} else if (is_tcf_gact_trap(act)) {
>>> +		fl_action->id = FLOW_ACTION_TRAP;
>>> +	} else if (is_tcf_gact_goto_chain(act)) {
>>> +		fl_action->id = FLOW_ACTION_GOTO;
>>> +	} else if (is_tcf_mirred_egress_redirect(act)) {
>>> +		fl_action->id = FLOW_ACTION_REDIRECT;
>>> +	} else if (is_tcf_mirred_egress_mirror(act)) {
>>> +		fl_action->id = FLOW_ACTION_MIRRED;
>>> +	} else if (is_tcf_mirred_ingress_redirect(act)) {
>>> +		fl_action->id = FLOW_ACTION_REDIRECT_INGRESS;
>>> +	} else if (is_tcf_mirred_ingress_mirror(act)) {
>>> +		fl_action->id = FLOW_ACTION_MIRRED_INGRESS;
>>> +	} else if (is_tcf_vlan(act)) {
>>> +		switch (tcf_vlan_action(act)) {
>>> +		case TCA_VLAN_ACT_PUSH:
>>> +			fl_action->id = FLOW_ACTION_VLAN_PUSH;
>>> +			break;
>>> +		case TCA_VLAN_ACT_POP:
>>> +			fl_action->id = FLOW_ACTION_VLAN_POP;
>>> +			break;
>>> +		case TCA_VLAN_ACT_MODIFY:
>>> +			fl_action->id = FLOW_ACTION_VLAN_MANGLE;
>>> +			break;
>>> +		default:
>>> +			return -EOPNOTSUPP;
>>> +		}
>>> +	} else if (is_tcf_tunnel_set(act)) {
>>> +		fl_action->id = FLOW_ACTION_TUNNEL_ENCAP;
>>> +	} else if (is_tcf_tunnel_release(act)) {
>>> +		fl_action->id = FLOW_ACTION_TUNNEL_DECAP;
>>> +	} else if (is_tcf_csum(act)) {
>>> +		fl_action->id = FLOW_ACTION_CSUM;
>>> +	} else if (is_tcf_skbedit_mark(act)) {
>>> +		fl_action->id = FLOW_ACTION_MARK;
>>> +	} else if (is_tcf_sample(act)) {
>>> +		fl_action->id = FLOW_ACTION_SAMPLE;
>>> +	} else if (is_tcf_police(act)) {
>>> +		fl_action->id = FLOW_ACTION_POLICE;
>>> +	} else if (is_tcf_ct(act)) {
>>> +		fl_action->id = FLOW_ACTION_CT;
>>> +	} else if (is_tcf_mpls(act)) {
>>> +		switch (tcf_mpls_action(act)) {
>>> +		case TCA_MPLS_ACT_PUSH:
>>> +			fl_action->id = FLOW_ACTION_MPLS_PUSH;
>>> +			break;
>>> +		case TCA_MPLS_ACT_POP:
>>> +			fl_action->id = FLOW_ACTION_MPLS_POP;
>>> +			break;
>>> +		case TCA_MPLS_ACT_MODIFY:
>>> +			fl_action->id = FLOW_ACTION_MPLS_MANGLE;
>>> +			break;
>>> +		default:
>>> +			return -EOPNOTSUPP;
>>> +		}
>>> +	} else if (is_tcf_skbedit_ptype(act)) {
>>> +		fl_action->id = FLOW_ACTION_PTYPE;
>>> +	} else if (is_tcf_skbedit_priority(act)) {
>>> +		fl_action->id = FLOW_ACTION_PRIORITY;
>>> +	} else if (is_tcf_gate(act)) {
>>> +		fl_action->id = FLOW_ACTION_GATE;
>>> +	} else {
>>> +		return -EOPNOTSUPP;
>>> +	}
>>> +
>>> +	return 0;
>>> +}
>>> +
>>
>> The challenge with this is now it is impossible to write an action as a
>> standalone module (which works today).
>> One resolution to this is to either reuse or introduce a new ops in struct
>> tc_action_ops.
>> Then flow_action_init() would just invoke this act->ops() which will do action
>> specific setup.
>>
> Thanks for bringing this to us.
> As my understanding, for this issue, we are facing the same fact with What we do in function tc_setup_flow_action.
> If we add a filter with a new added action, we will also fail to offload the filter.
> For a new added action, if we aim to offload the action to hardware, then we definitely need a
> init fction and setup function for action/filter offload. We can add a ops for the new added action to init or setup the action.
> 

The simplest approach seems to be adding a field in ops struct and call
it hw_id (we already have id which represents the s/w side).
All your code in flow_action_init() then becomes something like:

         if (!fl_action)
                 return -EINVAL;

         fl_action->extack = extack;
         fl_action->command = cmd;
         fl_action->index = act->tcfa_index;


         fl_action->id = act->hwid;

And modules continue to work. Did i miss something?


> Do you think it is proper to include this implement in our patch series or we can delivery a new patch for this?

Unless I am missing something basic, I dont see this as hard to do as
explained above in this patch series.

BTW: shouldnt extack be used here instead of returning just -EINVAL?
I didnt stare long enough but it seems extack is not passed when
deleting from hardware? I saw a NULL being passed in one of the patches.

cheers,
jamal
