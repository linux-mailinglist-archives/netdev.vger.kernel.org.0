Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FEC4204AA0
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 09:10:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731634AbgFWHJm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 03:09:42 -0400
Received: from new4-smtp.messagingengine.com ([66.111.4.230]:53919 "EHLO
        new4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731529AbgFWHJk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 03:09:40 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id D6F2E5801D8;
        Tue, 23 Jun 2020 03:09:38 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Tue, 23 Jun 2020 03:09:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=vP7+1x
        gtJefQEmjzJZ/9MYU1YuZA9S/Cob7pmsLGusg=; b=mpAICSbDUru7L6/Eh7wr00
        6Itpqp0VRlzYhzvgaWpOn3mOdKNP0v3EeMZAU83LOaaKIKLsZu951br23e+TJT4L
        5qdM0P6pwjJQMBgvea40zS3CgJ+/ztH7fAJ9BoSJ32eYFZ/cp856n9Qz9Y54K4Tx
        0bH7dtTaXJ92ZYtERM1pEXFx3THQ3aDRa861O6gf5OFB9jUeyjDsYoS7XVQ2+LjT
        bNLMxpYKOeR4/qCUEAlmbHaqqkxccxw4teq6KDYPNc2v/bgElhj+R2Ht5gk+uVuj
        bbCZJSFI/lFZOOgZehmirMSs078DYayjGBHtUKabN8pIOYtr/PXuGS/9xvAvrMCg
        ==
X-ME-Sender: <xms:sarxXpWhNz9rfomov_MIWMh2uXzqmU7s5GEZNVTo88SbNDxPWtOKIA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudekfedguddujecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrth
    htvghrnheptdffkeekfeduffevgeeujeffjefhtefgueeugfevtdeiheduueeukefhudeh
    leetnecukfhppeejledrudekfedrieehrdekjeenucevlhhushhtvghrufhiiigvpedtne
    curfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:sarxXpnGLVlkALorz-ndQUXmrv6Pm4tQVE5cZzLjGvu1pGjaJfZ7KA>
    <xmx:sarxXlZdV9PicYIrcrHXoCRmEnXHWFVNzXQHOoT5QBHNR6oavPVvRQ>
    <xmx:sarxXsVtOV5YPmoLylXoPgi5uCYsfom562SiQbr0CCugMrChPD-bCQ>
    <xmx:sqrxXlUqjuhT2sXAnSplm0YpKaG1eO19Av7LHrduUJq7ko7F4roecg>
Received: from localhost (bzq-79-183-65-87.red.bezeqint.net [79.183.65.87])
        by mail.messagingengine.com (Postfix) with ESMTPA id BEAB53280060;
        Tue, 23 Jun 2020 03:09:36 -0400 (EDT)
Date:   Tue, 23 Jun 2020 10:09:34 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Po Liu <po.liu@nxp.com>
Cc:     davem@davemloft.net, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, jiri@resnulli.us, vinicius.gomes@intel.com,
        vlad@buslov.dev, claudiu.manoil@nxp.com, vladimir.oltean@nxp.com,
        alexandru.marginean@nxp.com, michael.chan@broadcom.com,
        vishal@chelsio.com, saeedm@mellanox.com, leon@kernel.org,
        jiri@mellanox.com, idosch@mellanox.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        kuba@kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        simon.horman@netronome.com, pablo@netfilter.org,
        moshe@mellanox.com, m-karicheri2@ti.com,
        andre.guedes@linux.intel.com, stephen@networkplumber.org
Subject: Re: [v1,net-next 3/4] net: qos: police action add index for tc
 flower offloading
Message-ID: <20200623070934.GB575172@splinter>
References: <20200306125608.11717-7-Po.Liu@nxp.com>
 <20200623063412.19180-1-po.liu@nxp.com>
 <20200623063412.19180-3-po.liu@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200623063412.19180-3-po.liu@nxp.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 23, 2020 at 02:34:11PM +0800, Po Liu wrote:
> From: Po Liu <Po.Liu@nxp.com>
> 
> Hardware may own many entries for police flow. So that make one(or
>  multi) flow to be policed by one hardware entry. This patch add the
> police action index provide to the driver side make it mapping the
> driver hardware entry index.

Maybe first mention that it is possible for multiple filters in software
to share the same policer. Something like:

"
It is possible for several tc filters to share the same police action by
specifying the action's index when installing the filters.
    
Propagate this index to device drivers through the flow offload
intermediate representation, so that drivers could share a single
hardware policer between multiple filters.
"

> 
> Signed-off-by: Po Liu <Po.Liu@nxp.com>
> ---
>  include/net/flow_offload.h | 1 +
>  net/sched/cls_api.c        | 1 +
>  2 files changed, 2 insertions(+)
> 
> diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
> index c2ef19c6b27d..eed98075b1ae 100644
> --- a/include/net/flow_offload.h
> +++ b/include/net/flow_offload.h
> @@ -232,6 +232,7 @@ struct flow_action_entry {
>  			bool			truncate;
>  		} sample;
>  		struct {				/* FLOW_ACTION_POLICE */
> +			u32			index;
>  			s64			burst;
>  			u64			rate_bytes_ps;
>  			u32			mtu;
> diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
> index 6aba7d5ba1ec..fdc4c89ca1fa 100644
> --- a/net/sched/cls_api.c
> +++ b/net/sched/cls_api.c
> @@ -3659,6 +3659,7 @@ int tc_setup_flow_action(struct flow_action *flow_action,
>  			entry->police.rate_bytes_ps =
>  				tcf_police_rate_bytes_ps(act);
>  			entry->police.mtu = tcf_police_tcfp_mtu(act);
> +			entry->police.index = act->tcfa_index;
>  		} else if (is_tcf_ct(act)) {
>  			entry->id = FLOW_ACTION_CT;
>  			entry->ct.action = tcf_ct_action(act);
> -- 
> 2.17.1
> 
