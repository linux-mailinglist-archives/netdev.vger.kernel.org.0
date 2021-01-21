Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C4392FE9E7
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 13:23:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729662AbhAUMWz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 07:22:55 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:40255 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730887AbhAUMWo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jan 2021 07:22:44 -0500
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.nyi.internal (Postfix) with ESMTP id C6D495C0106;
        Thu, 21 Jan 2021 07:21:55 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Thu, 21 Jan 2021 07:21:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=35dUu6
        5MsnVGQNQpk5IA0MJIGJFHur99khWXzABWaNQ=; b=Zfr9txXl5mvA3MvwZ+LSSC
        5LuXFrQ+c4v8t+S1eSBrcFJhtWRsT3XaiP1eKE2ZUQXvrICy/tuhmp0ZGByZF7A9
        gaVCuC7vEvIjDZDbgY34UUfk+4aJk6FTruuEL1oKZPjahj2KLiMiQVcUF7sIYwAl
        5LWUwga5rXIQY6qPQ34y/gKJHPlenvxxoPtqF6WpLqF95kwKw6eeErg+cvlDjjal
        r4NmRDf3VkmO1mqVXdSoMCkp/C5TPeUYRelMxSDutV08ySdUqTeV1/h4x3JoCinL
        kiiP3qymw7otHBV28Y0wnRXaiWkVkYKP8qs/4st8Lx2xjEf8toV0tSrXLLBP9Yxg
        ==
X-ME-Sender: <xms:43EJYCnJpRwI03FSFnzjPbwjGuqqoNqQ1u7ZZxVizSRGHD0vFEl8OA>
    <xme:43EJYBR079atc3KcHgrbG-LsdeQmdmZHVTy6vb30yNwTLlwzTyDbEXBRMBQN8IJaD
    SbffbKfkv3k2H0>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudeggdegudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcuufgt
    hhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrthhtvg
    hrnheptdffkeekfeduffevgeeujeffjefhtefgueeugfevtdeiheduueeukefhudehleet
    necukfhppeekgedrvddvledrudehfedrgeegnecuvehluhhsthgvrhfuihiivgeptdenuc
    frrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:43EJYOBsLDXBIgnJXXWFAQ__kZ04Z4GRHaM9ZrD3oFhJXnbxbTjOyw>
    <xmx:43EJYAQfBhVNNm4gZkk7GTp6jlQxGdEixZ7kgrouKpYUkJoP1wrY5Q>
    <xmx:43EJYEpIiu00-2ucqJmDvtiUe-AiVzuWCEameP3f-n-kBHg8kuiYPw>
    <xmx:43EJYOzYunHzoghpGdxdUcfWx3OMzqH02b7zo87n_OtjSIeva7RCbg>
Received: from localhost (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id 191661080064;
        Thu, 21 Jan 2021 07:21:54 -0500 (EST)
Date:   Thu, 21 Jan 2021 14:21:52 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Cc:     netdev@vger.kernel.org, jiri@nvidia.com, davem@davemloft.net,
        linux-kernel@vger.kernel.org, kuba@kernel.org
Subject: Re: [PATCH net-next] net: core: devlink: add new trap action
 HARD_DROP
Message-ID: <20210121122152.GA2647590@shredder.lan>
References: <20210121112937.30989-1-oleksandr.mazur@plvision.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210121112937.30989-1-oleksandr.mazur@plvision.eu>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 21, 2021 at 01:29:37PM +0200, Oleksandr Mazur wrote:
> Add new trap action HARD_DROP, which can be used by the
> drivers to register traps, where it's impossible to get
> packet reported to the devlink subsystem by the device
> driver, because it's impossible to retrieve dropped packet
> from the device itself.
> In order to use this action, driver must also register
> additional devlink operation - callback that is used
> to retrieve number of packets that have been dropped by
> the device.

Are these global statistics about number of packets the hardware dropped
for a specific reason or are these per-port statistics?

It's a creative use of devlink-trap interface, but I think it makes
sense. Better to re-use an existing interface than creating yet another
one.

Anyway, this patch really needs to be marked as "RFC" since we cannot
add infrastructure without anyone using it.

Additionally, the documentation
(Documentation/networking/devlink/devlink-trap.rst) needs to be updated,
netdevsim needs to be patched and the test over netdevsim
(tools/testing/selftests/drivers/net/netdevsim/devlink_trap.sh) needs to
be extended to cover the new functionality.

More comments below.

> 
> Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
> ---
>  include/net/devlink.h        | 10 ++++++++
>  include/uapi/linux/devlink.h |  4 ++++
>  net/core/devlink.c           | 44 +++++++++++++++++++++++++++++++++++-
>  3 files changed, 57 insertions(+), 1 deletion(-)
> 
> diff --git a/include/net/devlink.h b/include/net/devlink.h
> index f466819cc477..6811a614f6fd 100644
> --- a/include/net/devlink.h
> +++ b/include/net/devlink.h
> @@ -1294,6 +1294,16 @@ struct devlink_ops {
>  				     const struct devlink_trap_group *group,
>  				     enum devlink_trap_action action,
>  				     struct netlink_ext_ack *extack);
> +	/**
> +	 * @trap_hard_drop_counter_get: Trap hard drop counter get function.
> +	 *
> +	 * Should be used by device drivers to report number of packets dropped
> +	 * by the underlying device, that have been dropped because device
> +	 * failed to pass the trapped packet.
> +	 */
> +	int (*trap_hard_drop_counter_get)(struct devlink *devlink,
> +					  const struct devlink_trap *trap,
> +					  u64 *p_drops);
>  	/**
>  	 * @trap_policer_init: Trap policer initialization function.
>  	 *
> diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
> index cf89c318f2ac..9247d9c7db03 100644
> --- a/include/uapi/linux/devlink.h
> +++ b/include/uapi/linux/devlink.h
> @@ -261,12 +261,16 @@ enum {
>   * enum devlink_trap_action - Packet trap action.
>   * @DEVLINK_TRAP_ACTION_DROP: Packet is dropped by the device and a copy is not
>   *                            sent to the CPU.
> + * @DEVLINK_TRAP_ACTION_HARD_DROP: Packet was dropped by the underlying device,
> + *                                 and device cannot report packet to devlink
> + *                                 (or inject it into the kernel RX path).
>   * @DEVLINK_TRAP_ACTION_TRAP: The sole copy of the packet is sent to the CPU.
>   * @DEVLINK_TRAP_ACTION_MIRROR: Packet is forwarded by the device and a copy is
>   *                              sent to the CPU.
>   */
>  enum devlink_trap_action {
>  	DEVLINK_TRAP_ACTION_DROP,
> +	DEVLINK_TRAP_ACTION_HARD_DROP,

This breaks uAPI. New values should be added at the end.

>  	DEVLINK_TRAP_ACTION_TRAP,
>  	DEVLINK_TRAP_ACTION_MIRROR,
>  };
> diff --git a/net/core/devlink.c b/net/core/devlink.c
> index ee828e4b1007..5a06e00429e1 100644
> --- a/net/core/devlink.c
> +++ b/net/core/devlink.c
> @@ -6732,6 +6732,7 @@ devlink_trap_action_get_from_info(struct genl_info *info,
>  	val = nla_get_u8(info->attrs[DEVLINK_ATTR_TRAP_ACTION]);
>  	switch (val) {
>  	case DEVLINK_TRAP_ACTION_DROP:
> +	case DEVLINK_TRAP_ACTION_HARD_DROP:
>  	case DEVLINK_TRAP_ACTION_TRAP:
>  	case DEVLINK_TRAP_ACTION_MIRROR:
>  		*p_trap_action = val;
> @@ -6820,6 +6821,37 @@ static int devlink_trap_stats_put(struct sk_buff *msg,
>  	return -EMSGSIZE;
>  }
>  
> +static int
> +devlink_trap_hard_drop_stats_put(struct sk_buff *msg,
> +				 struct devlink *devlink,
> +				 const struct devlink_trap_item *trap_item)
> +{
> +	struct nlattr *attr;
> +	u64 drops;
> +	int err;
> +
> +	err = devlink->ops->trap_hard_drop_counter_get(devlink, trap_item->trap,
> +						       &drops);
> +	if (err)
> +		return err;
> +
> +	attr = nla_nest_start(msg, DEVLINK_ATTR_STATS);
> +	if (!attr)
> +		return -EMSGSIZE;
> +
> +	if (nla_put_u64_64bit(msg, DEVLINK_ATTR_STATS_RX_DROPPED, drops,
> +			      DEVLINK_ATTR_PAD))
> +		goto nla_put_failure;
> +
> +	nla_nest_end(msg, attr);
> +
> +	return 0;
> +
> +nla_put_failure:
> +	nla_nest_cancel(msg, attr);
> +	return -EMSGSIZE;
> +}
> +
>  static int devlink_nl_trap_fill(struct sk_buff *msg, struct devlink *devlink,
>  				const struct devlink_trap_item *trap_item,
>  				enum devlink_command cmd, u32 portid, u32 seq,
> @@ -6857,7 +6889,10 @@ static int devlink_nl_trap_fill(struct sk_buff *msg, struct devlink *devlink,
>  	if (err)
>  		goto nla_put_failure;
>  
> -	err = devlink_trap_stats_put(msg, trap_item->stats);
> +	if (trap_item->action == DEVLINK_TRAP_ACTION_HARD_DROP)
> +		err = devlink_trap_hard_drop_stats_put(msg, devlink, trap_item);
> +	else
> +		err = devlink_trap_stats_put(msg, trap_item->stats);
>  	if (err)
>  		goto nla_put_failure;
>  
> @@ -9697,6 +9732,10 @@ devlink_trap_register(struct devlink *devlink,
>  	if (devlink_trap_item_lookup(devlink, trap->name))
>  		return -EEXIST;
>  
> +	if (trap->init_action == DEVLINK_TRAP_ACTION_HARD_DROP &&
> +	    !devlink->ops->trap_hard_drop_counter_get)
> +		return -EINVAL;
> +
>  	trap_item = kzalloc(sizeof(*trap_item), GFP_KERNEL);
>  	if (!trap_item)
>  		return -ENOMEM;
> @@ -9876,6 +9915,9 @@ void devlink_trap_report(struct devlink *devlink, struct sk_buff *skb,
>  {
>  	struct devlink_trap_item *trap_item = trap_ctx;
>  
> +	if (trap_item->action == DEVLINK_TRAP_ACTION_HARD_DROP)
> +		return;

How can this happen?

> +
>  	devlink_trap_stats_update(trap_item->stats, skb->len);
>  	devlink_trap_stats_update(trap_item->group_item->stats, skb->len);
>  
> -- 
> 2.17.1
> 
