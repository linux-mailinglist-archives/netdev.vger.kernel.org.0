Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97CC027F2BF
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 21:53:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729813AbgI3Txg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 15:53:36 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:39477 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725355AbgI3Txg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 15:53:36 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 63C635C00F9;
        Wed, 30 Sep 2020 15:53:35 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Wed, 30 Sep 2020 15:53:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=Ajj7eT
        SJIQo5ftB/4qyl+BRZEs9w1r44JV1WRP1tyNg=; b=bHxezUkwJNXVU3tYOi3FUj
        q/zUzLIiwZvzHp8UlrHfkJSdubhio3o5VmFoXLoTmMtmh9NqrEPLKWgTbu5sylZm
        zSRXwk1xmdhtGXFUbm0Kd37Bb3vEEZxsIIvGU90CN2sFWLoxr/K3iyRLEhmR7Qmj
        rVWAF8Q9nx1EuqKf5Lj5cbOTjSMDfb8YLJ2phhGp5g5IhwemZYGOp9hmHWlwNCtq
        MJ0/E8Qh8FfFf3gPEhevhDFRSvopIoc36wwOBfNu3Ewh4LQ83es21gdI1PYJu/re
        nO7wjMbsAVypCaFepIfLa9U+k8bKnq+BOuH89alrYSDSo1mTPyoGslw/ZtEvMCXw
        ==
X-ME-Sender: <xms:PuJ0X3wFF6hIBggVr2CT4JKlvtp_6O_bK-lwXYZVhohv3mW7QbLTDw>
    <xme:PuJ0X_TZAB9y9UPkbQIsL1QIfCZAOOeTlyTaza2aanWf-tZDXTPxQ2LlA3Yi-y6u4
    RhTM0HSpeSNQ6U>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrfedvgddufeelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpeekhffhheetvdfhtddvgfekleetudetgeelheelvdetveefiefgveffhffhvefg
    hfenucffohhmrghinhepthhrrghprdhshhenucfkphepkeegrddvvdelrdefjedrudegke
    enucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiugho
    shgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:PuJ0XxVdfnPR2IkS3zEvSlZaDtjBxrC04EOqRYSpGlWx-rd2qrKY6A>
    <xmx:PuJ0Xxjsrf5k684jXWIepPfe-a6VFUD5wXOadV6CpSHHsddn_u81Vw>
    <xmx:PuJ0X5DajmSQ5E1eqiQalONDgx--2FcQTjhJjIrWoX1UsmRH9tm52Q>
    <xmx:P-J0X8OpxHMzTS9nmApAkImPeXlWkSghkuMz0yo-ZOIjn4kr2PlCuw>
Received: from localhost (igld-84-229-37-148.inter.net.il [84.229.37.148])
        by mail.messagingengine.com (Postfix) with ESMTPA id 2B2B03064610;
        Wed, 30 Sep 2020 15:53:33 -0400 (EDT)
Date:   Wed, 30 Sep 2020 22:53:31 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        jiri@nvidia.com, idosch@nvidia.com
Subject: Re: [PATCH net-next v2 2/4] devlink: add .trap_group_action_set()
 callback
Message-ID: <20200930195331.GB1850258@shredder>
References: <20200930191645.9520-1-ioana.ciornei@nxp.com>
 <20200930191645.9520-3-ioana.ciornei@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200930191645.9520-3-ioana.ciornei@nxp.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 30, 2020 at 10:16:43PM +0300, Ioana Ciornei wrote:
> Add a new devlink callback, .trap_group_action_set(), which can be used
> by device drivers which do not support controlling the action (drop,
> trap) on each trap but rather on the entire group trap.
> If this new callback is populated, it will take precedence over the
> .trap_action_set() callback when the user requests a change of all the
> traps in a group.
> 
> Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>

Did you test this change with

tools/testing/selftests/drivers/net/netdevsim/devlink_trap.sh

?

Just to make sure you didn't add a regression

> ---
> Changes in v2:
>  - none
> 
>  include/net/devlink.h | 10 ++++++++++
>  net/core/devlink.c    | 18 ++++++++++++++++++
>  2 files changed, 28 insertions(+)
> 
> diff --git a/include/net/devlink.h b/include/net/devlink.h
> index 20db4a070fc8..307937efa83a 100644
> --- a/include/net/devlink.h
> +++ b/include/net/devlink.h
> @@ -1226,6 +1226,16 @@ struct devlink_ops {
>  			      const struct devlink_trap_group *group,
>  			      const struct devlink_trap_policer *policer,
>  			      struct netlink_ext_ack *extack);
> +	/**
> +	 * @trap_group_action_set: Group action set function.

To be consistent with other operations:

Trap group action set function.

> +	 *
> +	 * If this callback is populated, it will take precedence over looping
> +	 * over all traps in a group and calling .trap_action_set().
> +	 */
> +	int (*trap_group_action_set)(struct devlink *devlink,
> +				     const struct devlink_trap_group *group,
> +				     enum devlink_trap_action action,
> +				     struct netlink_ext_ack *extack);
>  	/**
>  	 * @trap_policer_init: Trap policer initialization function.
>  	 *
> diff --git a/net/core/devlink.c b/net/core/devlink.c
> index 10fea5854bc2..18136ad413e6 100644
> --- a/net/core/devlink.c
> +++ b/net/core/devlink.c
> @@ -6720,6 +6720,24 @@ __devlink_trap_group_action_set(struct devlink *devlink,
>  	struct devlink_trap_item *trap_item;
>  	int err;
>  
> +	if (devlink->ops->trap_group_action_set) {
> +		err = devlink->ops->trap_group_action_set(devlink, group_item->group,
> +							  trap_action, extack);
> +		if (err)
> +			return err;
> +
> +		list_for_each_entry(trap_item, &devlink->trap_list, list) {
> +			if (strcmp(trap_item->group_item->group->name, group_name))
> +				continue;
> +			if (trap_item->action != trap_action &&
> +			    trap_item->trap->type != DEVLINK_TRAP_TYPE_DROP)
> +				continue;
> +			trap_item->action = trap_action;
> +		}
> +
> +		return 0;
> +	}
> +
>  	list_for_each_entry(trap_item, &devlink->trap_list, list) {
>  		if (strcmp(trap_item->group_item->group->name, group_name))
>  			continue;
> -- 
> 2.28.0
> 
