Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A74E36EE63
	for <lists+netdev@lfdr.de>; Thu, 29 Apr 2021 18:49:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240760AbhD2QuU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Apr 2021 12:50:20 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:44937 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232724AbhD2QuT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Apr 2021 12:50:19 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id B38245C007C;
        Thu, 29 Apr 2021 12:49:30 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Thu, 29 Apr 2021 12:49:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=HpsYWI
        D6hnhQVRcvAfZaZ6lMNhq8mlgwJSwUpnpRD8s=; b=IuXPtcHOKYJfXp3qmU8Vyf
        e+f2Tnvk7HRqB7GTn1GBHYSBPIhiwKBSr7U2im9Ngb4cPDHRSbj40FiAUSRLEIRx
        /v7Ay9OBWq3FwVcqUqLpFKGvHuPptBT/vtbuj6UO/wQ/gQ6w1uRvbkfnxptmbknb
        bokUedB0Eutaan82o0rUFuaVPQrQIDVvcaFViL085jUH9HmJm90GLhgjOI0MZxM1
        TvMQvAqy6sne9yMJlAvw5dLpMfVQ3jUOytU9RJfUsUj92m5VUCh1cDauo+TJnwrW
        0Pw9Y8Oz7XxyswLM2ww7LlSQIjyB4FMIsqOsH2yoka5ESqmhGVtP6lDamBpnUx/A
        ==
X-ME-Sender: <xms:muOKYOIuusDPhshDJzgzP59CrII6IzLOMbGegrfLvXryWA-hnvFPKA>
    <xme:muOKYGIes9Fke_mI-rr2ImRuXS-wCUoYmfaRezvpGUOC_MAwE4zS5Uiv26iR2tMoB
    6AyC4Lm8xSgflo>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvddvgedguddtjecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrth
    htvghrnheptdffkeekfeduffevgeeujeffjefhtefgueeugfevtdeiheduueeukefhudeh
    leetnecukfhppeekgedrvddvledrudehfedrudekjeenucevlhhushhtvghrufhiiigvpe
    dtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:muOKYOtTSCxrggz4jgMZXtJW6fugwnsez37LVCp5TGC2CryZkqq_8w>
    <xmx:muOKYDZJuEEDezvZELxYwCAT-Qw9eltpGlMTRbaU0_5kru4aAOEpPQ>
    <xmx:muOKYFZ0SRulzmvY32cBDda9H49H3o0QEGN8p1SjKkwcOxAmh5Z_FQ>
    <xmx:muOKYEVvcdnb69rTR39vehZZnszpmFLgowSDFaTycwY3zHqxoC5TiQ>
Received: from localhost (igld-84-229-153-187.inter.net.il [84.229.153.187])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Thu, 29 Apr 2021 12:49:29 -0400 (EDT)
Date:   Thu, 29 Apr 2021 19:49:25 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Simon Horman <simon.horman@netronome.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>, netdev@vger.kernel.org,
        oss-drivers@netronome.com,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Louis Peens <louis.peens@netronome.com>
Subject: Re: [RFC net-next] net/flow_offload: allow user to offload tc action
 to net device
Message-ID: <YIrjlR+eAvvVCnXy@shredder.lan>
References: <20210429081014.28498-1-simon.horman@netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210429081014.28498-1-simon.horman@netronome.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 29, 2021 at 10:10:14AM +0200, Simon Horman wrote:
> From: Baowen Zheng <baowen.zheng@corigine.com>
> 
> Allow use of flow_indr_dev_register/flow_indr_dev_setup_offload to offload
> tc actions independent of flows.
> 
> The motivation for this work is to prepare for using TC police action
> instances to provide hardware offload of OVS metering feature - which calls
> for policers that may be used my multiple flows and whose lifecycle is

s/my/by/

> independent of any flows that use them.

Can you share an example of the tc commands? You might be able to
achieve what you want by patching NFP to take into account the policer
index in 'struct flow_action_entry'. Seems that it currently assumes
that each policer is a new policer.

FTR, I do support the overall plan to offload actions independent of
flows and to associate stats with actions.

> 
> This patch includes basic changes to offload drivers to return EOPNOTSUPP
> if this feature is used - it is not yet supported by any driver.
> 
> Signed-off-by: Baowen Zheng <baowen.zheng@corigine.com>
> Signed-off-by: Louis Peens <louis.peens@netronome.com>
> Signed-off-by: Simon Horman <simon.horman@netronome.com>

[...]

> diff --git a/include/net/tc_act/tc_police.h b/include/net/tc_act/tc_police.h
> index 72649512dcdd..6309519bf9d4 100644
> --- a/include/net/tc_act/tc_police.h
> +++ b/include/net/tc_act/tc_police.h
> @@ -53,6 +53,11 @@ static inline bool is_tcf_police(const struct tc_action *act)
>  	return false;
>  }
>  
> +static inline u32 tcf_police_index(const struct tc_action *act)
> +{
> +	return act->tcfa_index;
> +}

Any reason this is part of the patch? Looks like nobody is using it.

> +
>  static inline u64 tcf_police_rate_bytes_ps(const struct tc_action *act)
>  {
>  	struct tcf_police *police = to_police(act);
