Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 390112F7FF8
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 16:48:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730792AbhAOPsd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 10:48:33 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:37489 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729489AbhAOPsc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 10:48:32 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 6B0275C0190;
        Fri, 15 Jan 2021 10:47:46 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Fri, 15 Jan 2021 10:47:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=u6IDgs
        1moV0f0yU1LtC7oN2tcjKK9L8jrmBFKBEyD74=; b=pqrAYdQedCexP0AmYBZkgC
        R0ap0BDnO3a6yyeV5PCtiIGLP9UKIsWGdAzDHyRnI6MRUSAmoAt1ub0/kBempuvx
        Pwq0Jq4DOkr0APDGjh9RtOvXpE3PPtbXfp6scc+vwzGt+MZHZvGsMZ3pG6dLZ30K
        LZ6a8ffxU0QYUe3cjCYmrH73/HcqT3pPg2xjvMDbXNZ6+jzyG+5U4Usjp4xTI5nM
        JpdahnDPaJKLSY3uEa/+U/FYcRnTje+/E6DGQOHtEN+d0tZep5OgxCSajQnPb1oX
        ijjXfXf5TrplSMBPjm4x+5A4q590Yty5sHwImT0fhCe6L34Ij6pbBsBWMXkffIiw
        ==
X-ME-Sender: <xms:IbkBYHX9K6-TZVIlwqAzWyTf9iO6-jIKkIIOGbTsoeJk7rjtij71-g>
    <xme:IbkBYPkkRIFuuLy5SJoq22wRrlPHUvFmYV8hu4qGsqLSG0jbrNNUooaSRwy0t3hsr
    mt0XqJyRwhTAnE>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrtddvgdehiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcuufgt
    hhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrthhtvg
    hrnheptdffkeekfeduffevgeeujeffjefhtefgueeugfevtdeiheduueeukefhudehleet
    necukfhppeekgedrvddvledrudehfedrgeegnecuvehluhhsthgvrhfuihiivgeptdenuc
    frrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:IbkBYDbMJz733D7DKWbDgFE5vRNUDbBA8k4-5miMUFk9IHQVm8_L6g>
    <xmx:IbkBYCXjFZP5DhtbiiswlYA8bHZfOuO6nZY3WU__vEgVr7JPkwfqXQ>
    <xmx:IbkBYBm5xAJRRrs6t0mixfn6WbLQHmGacA7IdMl-lZpj2ooupodMDQ>
    <xmx:IrkBYHjv8aCjVTYSiPbJ3R6yUBHG4KphYX-xaDsyJ9OYwCDBKQjGPw>
Received: from localhost (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id 6CB0C240062;
        Fri, 15 Jan 2021 10:47:45 -0500 (EST)
Date:   Fri, 15 Jan 2021 17:47:42 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        jacob.e.keller@intel.com, roopa@nvidia.com, mlxsw@nvidia.com
Subject: Re: [patch net-next RFC 01/10] devlink: add support to create line
 card and expose to user
Message-ID: <20210115154742.GB2064789@shredder.lan>
References: <20210113121222.733517-1-jiri@resnulli.us>
 <20210113121222.733517-2-jiri@resnulli.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210113121222.733517-2-jiri@resnulli.us>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 13, 2021 at 01:12:13PM +0100, Jiri Pirko wrote:
> diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
> index cf89c318f2ac..e5ed0522591f 100644
> --- a/include/uapi/linux/devlink.h
> +++ b/include/uapi/linux/devlink.h
> @@ -126,6 +126,11 @@ enum devlink_command {
>  
>  	DEVLINK_CMD_HEALTH_REPORTER_TEST,
>  
> +	DEVLINK_CMD_LINECARD_GET,		/* can dump */
> +	DEVLINK_CMD_LINECARD_SET,

Never used (but should)

> +	DEVLINK_CMD_LINECARD_NEW,
> +	DEVLINK_CMD_LINECARD_DEL,
> +
>  	/* add new commands above here */
>  	__DEVLINK_CMD_MAX,
>  	DEVLINK_CMD_MAX = __DEVLINK_CMD_MAX - 1
> @@ -529,6 +534,8 @@ enum devlink_attr {
>  	DEVLINK_ATTR_RELOAD_ACTION_INFO,        /* nested */
>  	DEVLINK_ATTR_RELOAD_ACTION_STATS,       /* nested */
>  
> +	DEVLINK_ATTR_LINECARD_INDEX,		/* u32 */
> +
>  	/* add new attributes above here, update the policy in devlink.c */
>  
>  	__DEVLINK_ATTR_MAX,

[...]

>  
> +/**
> + *	devlink_linecard_register - Register devlink linecard

Does not match function name

> + *
> + *	@devlink: devlink
> + *	@devlink_linecard: devlink linecard
> + *	@linecard_index: driver-specific numerical identifier of the linecard
> + *
> + *	Create devlink linecard instance with provided linecard index.
> + *	Caller can use any indexing, even hw-related one.
> + */
> +struct devlink_linecard *devlink_linecard_create(struct devlink *devlink,
> +						 unsigned int linecard_index)
> +{
> +	struct devlink_linecard *linecard;
> +
> +	mutex_lock(&devlink->lock);
> +	if (devlink_linecard_index_exists(devlink, linecard_index)) {
> +		mutex_unlock(&devlink->lock);
> +		return ERR_PTR(-EEXIST);
> +	}
> +
> +	linecard = kzalloc(sizeof(*linecard), GFP_KERNEL);
> +	if (!linecard)
> +		return ERR_PTR(-ENOMEM);
> +
> +	linecard->devlink = devlink;
> +	linecard->index = linecard_index;
> +	list_add_tail(&linecard->list, &devlink->linecard_list);
> +	mutex_unlock(&devlink->lock);
> +	devlink_linecard_notify(linecard, DEVLINK_CMD_LINECARD_NEW);
> +	return linecard;
> +}
> +EXPORT_SYMBOL_GPL(devlink_linecard_create);
> +
> +/**
> + *	devlink_linecard_destroy - Destroy devlink linecard
> + *
> + *	@devlink_linecard: devlink linecard
> + */
> +void devlink_linecard_destroy(struct devlink_linecard *linecard)
> +{
> +	struct devlink *devlink = linecard->devlink;
> +
> +	devlink_linecard_notify(linecard, DEVLINK_CMD_LINECARD_DEL);
> +	mutex_lock(&devlink->lock);
> +	list_del(&linecard->list);
> +	mutex_unlock(&devlink->lock);
> +}
> +EXPORT_SYMBOL_GPL(devlink_linecard_create);
> +
>  int devlink_sb_register(struct devlink *devlink, unsigned int sb_index,
>  			u32 size, u16 ingress_pools_count,
>  			u16 egress_pools_count, u16 ingress_tc_count,
> -- 
> 2.26.2
> 
