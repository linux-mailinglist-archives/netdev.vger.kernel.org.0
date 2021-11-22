Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 179FD458E39
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 13:24:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232866AbhKVM1s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 07:27:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233015AbhKVM1s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Nov 2021 07:27:48 -0500
Received: from mail-qv1-xf2b.google.com (mail-qv1-xf2b.google.com [IPv6:2607:f8b0:4864:20::f2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5A49C061714
        for <netdev@vger.kernel.org>; Mon, 22 Nov 2021 04:24:41 -0800 (PST)
Received: by mail-qv1-xf2b.google.com with SMTP id g1so12266443qvd.2
        for <netdev@vger.kernel.org>; Mon, 22 Nov 2021 04:24:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=0+kYaF2n9uaqz0Wz/HzpDJi5IH0A+ernOQVwbB/S3xk=;
        b=iC8ZKheR0OHcNPw7L3i28SdZuoewsG9VKK4obQcO4qS6gzKTGNqAPKjDzsUGw4w6JU
         RkutFjKFyU7/FJGHWfOyYAqg0ddWCybwQJA5SnQJOcmbMYsLDaYKrhy4CAFH45xNW44+
         v/QITD0l6vvNWiF9ODcY/KB0NVhnEPQIx8Gbs/QwMkxZxf5rrXcNvAlb42JKWt9ah9wl
         2ftnqXPF2o70+9t3vk7rmGiR02b2Spjm6iEFe6v2yHBYNn/QqtHDB0hdCU9NYSygUdD7
         qkPWElRTlIrpe+h2m6jtfImMPOW9m7s30BySws5HnIlw58ptsNmFAafqTf5w7oJF2jXf
         W01g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=0+kYaF2n9uaqz0Wz/HzpDJi5IH0A+ernOQVwbB/S3xk=;
        b=7UpR4ER2PrFXz19ganlhIhvtyzbjg6omGsIATJX1UkSF5U60zXtGczz9dQZPhJxDqb
         S4rYYLK4Cb9Y9Eiyeu+zTMQibLivUyp+WoJV7uhKnfCv8fDBvGCJOcWGTTuI1nkdnfKT
         gBcZ80WctLHW6Vgyrm7EXFv7YTS5H32CVkzdikmTO3OLUycrzd35iTrA4waB48EmBUJe
         H2KgJttEJKZJ/Cdkrz0tjxv0jAnVyiY7y/zQn0qzKQNemCxkgR2sdzIFnDpVavQ57mhq
         GnW9IfCkOoRO0PdjWNWrdP6W6VbjbtP1mIO7SvsC8UY1Ll39FnygrEEIk/QSlZsidGjH
         7HfQ==
X-Gm-Message-State: AOAM532fTlCutKG+uG3L1NB5wYk4DvbYlX7lM2TQ6CQcyM93MFuUw1qG
        oXgBume+QPkNNF9567kNhHJrLQ==
X-Google-Smtp-Source: ABdhPJw4nwh/kNIOovRAx/DwuKnMssg+52WG9umbxDfTHqBN7XXGWT+PgU3fouG2MxeknztXXkRzpA==
X-Received: by 2002:a05:6214:1c8a:: with SMTP id ib10mr101437684qvb.46.1637583880927;
        Mon, 22 Nov 2021 04:24:40 -0800 (PST)
Received: from [192.168.1.173] (bras-base-kntaon1617w-grc-33-142-112-185-132.dsl.bell.ca. [142.112.185.132])
        by smtp.googlemail.com with ESMTPSA id u27sm4594819qtc.58.2021.11.22.04.24.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Nov 2021 04:24:40 -0800 (PST)
Message-ID: <cf194dc4-a7c9-5221-628b-ab26ceca9583@mojatatu.com>
Date:   Mon, 22 Nov 2021 07:24:39 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Re: [PATCH v4 04/10] flow_offload: allow user to offload tc action to
 net device
Content-Language: en-US
To:     Simon Horman <simon.horman@corigine.com>, netdev@vger.kernel.org
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Jiri Pirko <jiri@resnulli.us>, Oz Shlomo <ozsh@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Louis Peens <louis.peens@corigine.com>,
        oss-drivers@corigine.com
References: <20211118130805.23897-1-simon.horman@corigine.com>
 <20211118130805.23897-5-simon.horman@corigine.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
In-Reply-To: <20211118130805.23897-5-simon.horman@corigine.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-11-18 08:07, Simon Horman wrote:

[..]

 > --- a/net/sched/act_api.c
 > +++ b/net/sched/act_api.c
 > @@ -21,6 +21,19 @@
> +#include <net/tc_act/tc_pedit.h>
> +#include <net/tc_act/tc_mirred.h>
> +#include <net/tc_act/tc_vlan.h>
> +#include <net/tc_act/tc_tunnel_key.h>
> +#include <net/tc_act/tc_csum.h>
> +#include <net/tc_act/tc_gact.h>
> +#include <net/tc_act/tc_police.h>
> +#include <net/tc_act/tc_sample.h>
> +#include <net/tc_act/tc_skbedit.h>
> +#include <net/tc_act/tc_ct.h>
> +#include <net/tc_act/tc_mpls.h>
> +#include <net/tc_act/tc_gate.h>
> +#include <net/flow_offload.h>
>   
>   #ifdef CONFIG_INET
>   DEFINE_STATIC_KEY_FALSE(tcf_frag_xmit_count);
> @@ -129,8 +142,157 @@ static void free_tcf(struct tc_action *p)
>   	kfree(p);
>   }
>   
> +static int flow_action_init(struct flow_offload_action *fl_action,
> +			    struct tc_action *act,
> +			    enum flow_act_command cmd,
> +			    struct netlink_ext_ack *extack)
> +{
> +	if (!fl_action)
> +		return -EINVAL;
> +
> +	fl_action->extack = extack;
> +	fl_action->command = cmd;
> +	fl_action->index = act->tcfa_index;
> +
> +	if (is_tcf_gact_ok(act)) {
> +		fl_action->id = FLOW_ACTION_ACCEPT;
> +	} else if (is_tcf_gact_shot(act)) {
> +		fl_action->id = FLOW_ACTION_DROP;
> +	} else if (is_tcf_gact_trap(act)) {
> +		fl_action->id = FLOW_ACTION_TRAP;
> +	} else if (is_tcf_gact_goto_chain(act)) {
> +		fl_action->id = FLOW_ACTION_GOTO;
> +	} else if (is_tcf_mirred_egress_redirect(act)) {
> +		fl_action->id = FLOW_ACTION_REDIRECT;
> +	} else if (is_tcf_mirred_egress_mirror(act)) {
> +		fl_action->id = FLOW_ACTION_MIRRED;
> +	} else if (is_tcf_mirred_ingress_redirect(act)) {
> +		fl_action->id = FLOW_ACTION_REDIRECT_INGRESS;
> +	} else if (is_tcf_mirred_ingress_mirror(act)) {
> +		fl_action->id = FLOW_ACTION_MIRRED_INGRESS;
> +	} else if (is_tcf_vlan(act)) {
> +		switch (tcf_vlan_action(act)) {
> +		case TCA_VLAN_ACT_PUSH:
> +			fl_action->id = FLOW_ACTION_VLAN_PUSH;
> +			break;
> +		case TCA_VLAN_ACT_POP:
> +			fl_action->id = FLOW_ACTION_VLAN_POP;
> +			break;
> +		case TCA_VLAN_ACT_MODIFY:
> +			fl_action->id = FLOW_ACTION_VLAN_MANGLE;
> +			break;
> +		default:
> +			return -EOPNOTSUPP;
> +		}
> +	} else if (is_tcf_tunnel_set(act)) {
> +		fl_action->id = FLOW_ACTION_TUNNEL_ENCAP;
> +	} else if (is_tcf_tunnel_release(act)) {
> +		fl_action->id = FLOW_ACTION_TUNNEL_DECAP;
> +	} else if (is_tcf_csum(act)) {
> +		fl_action->id = FLOW_ACTION_CSUM;
> +	} else if (is_tcf_skbedit_mark(act)) {
> +		fl_action->id = FLOW_ACTION_MARK;
> +	} else if (is_tcf_sample(act)) {
> +		fl_action->id = FLOW_ACTION_SAMPLE;
> +	} else if (is_tcf_police(act)) {
> +		fl_action->id = FLOW_ACTION_POLICE;
> +	} else if (is_tcf_ct(act)) {
> +		fl_action->id = FLOW_ACTION_CT;
> +	} else if (is_tcf_mpls(act)) {
> +		switch (tcf_mpls_action(act)) {
> +		case TCA_MPLS_ACT_PUSH:
> +			fl_action->id = FLOW_ACTION_MPLS_PUSH;
> +			break;
> +		case TCA_MPLS_ACT_POP:
> +			fl_action->id = FLOW_ACTION_MPLS_POP;
> +			break;
> +		case TCA_MPLS_ACT_MODIFY:
> +			fl_action->id = FLOW_ACTION_MPLS_MANGLE;
> +			break;
> +		default:
> +			return -EOPNOTSUPP;
> +		}
> +	} else if (is_tcf_skbedit_ptype(act)) {
> +		fl_action->id = FLOW_ACTION_PTYPE;
> +	} else if (is_tcf_skbedit_priority(act)) {
> +		fl_action->id = FLOW_ACTION_PRIORITY;
> +	} else if (is_tcf_gate(act)) {
> +		fl_action->id = FLOW_ACTION_GATE;
> +	} else {
> +		return -EOPNOTSUPP;
> +	}
> +
> +	return 0;
> +}
> +

The challenge with this is now it is impossible to write an action
as a standalone module (which works today).
One resolution to this is to either reuse or introduce a new ops in
struct tc_action_ops.
Then flow_action_init() would just invoke this act->ops() which will
do action specific setup.

cheers,
jamal
