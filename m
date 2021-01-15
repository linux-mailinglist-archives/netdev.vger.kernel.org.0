Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 029FB2F803E
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 17:07:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731063AbhAOQG6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 11:06:58 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:52143 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727288AbhAOQG6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 11:06:58 -0500
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 3DDA35C005A;
        Fri, 15 Jan 2021 11:06:12 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Fri, 15 Jan 2021 11:06:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=nK+4xh
        e0jV0LtlEBRyneRImY0SFY58ZkjVw3dQu0JGM=; b=K8Ew5u+lyiiD3sxYu+qUqy
        A23YfpmjpvFzSpPdO0i5mDztmjx1Dyn15HuJEXCAZg1NZ028Np9O76/Uzh/VEYx1
        FLQxtuFP4RFw8EZ0+reKPcuFar9CXquKiBBocrXkwYLVdFOkp/0reX5KLzmXPk+6
        EZ8XR4caqvfsJJ6+orbgUkEtis27QSYpbLie3EOdTzkIBPrFAp9xOFjqQ1zTi54V
        sIyMyjudy+7LW73WdFXVTCRXaV2K5shRGLdp9GQiuH854JRUvAj4F8tOdn3JeskS
        CZ4XnO+N/v+HBcKvXyE2XFdujjAIAYtSytUK+VtKwz7LbZWk5r1WmnKWDqVlwjBQ
        ==
X-ME-Sender: <xms:c70BYBtZwiG_tYausB7euzWctJkPu9VzyipVEqKcUp5kJehc9CUCZg>
    <xme:c70BYPrA8LKvok-B1m6nVK4BD0nTUICTJeHnS0lnqlR7zXAaqRotzHtxhB0gPy3mq
    5eK10korzoDCHo>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrtddvgdeitdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcuufgt
    hhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrthhtvg
    hrnheptdffkeekfeduffevgeeujeffjefhtefgueeugfevtdeiheduueeukefhudehleet
    necukfhppeekgedrvddvledrudehfedrgeegnecuvehluhhsthgvrhfuihiivgeptdenuc
    frrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:c70BYFrEEhE_VA8tL_cHGrIMug5YE9HhQuLjPm0ZVIGeha_gi0BkQQ>
    <xmx:c70BYObGIbPgdQ3XEFP5rvMKXkNwsFJVvl0q8nbMFZVC21RJO-z50w>
    <xmx:c70BYD800KAhIII4Mbyl1TR8v3LS8zrozb4ANz7OyBk0wRPFzF4E8g>
    <xmx:dL0BYGWgC-PmtWy3qaodAE17wsgaG8wXH9IMqq4hWd_OJCbyMJLB5A>
Received: from localhost (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id 2AE1A1080063;
        Fri, 15 Jan 2021 11:06:10 -0500 (EST)
Date:   Fri, 15 Jan 2021 18:06:08 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        jacob.e.keller@intel.com, roopa@nvidia.com, mlxsw@nvidia.com
Subject: Re: [patch net-next RFC 03/10] devlink: implement line card active
 state
Message-ID: <20210115160608.GD2064789@shredder.lan>
References: <20210113121222.733517-1-jiri@resnulli.us>
 <20210113121222.733517-4-jiri@resnulli.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210113121222.733517-4-jiri@resnulli.us>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 13, 2021 at 01:12:15PM +0100, Jiri Pirko wrote:
> +/**
> + *	devlink_linecard_deactivate - Set linecard deactive

Set linecard as inactive

> + *
> + *	@devlink_linecard: devlink linecard
> + */
> +void devlink_linecard_deactivate(struct devlink_linecard *linecard)
> +{
> +	mutex_lock(&linecard->devlink->lock);
> +	WARN_ON(linecard->state != DEVLINK_LINECARD_STATE_ACTIVE);
> +	linecard->state = DEVLINK_LINECARD_STATE_PROVISIONED;
> +	devlink_linecard_notify(linecard, DEVLINK_CMD_LINECARD_NEW);
> +	mutex_unlock(&linecard->devlink->lock);
> +}
> +EXPORT_SYMBOL_GPL(devlink_linecard_deactivate);
> +
> +/**
> + *	devlink_linecard_is_active - Check if active
> + *
> + *	@devlink_linecard: devlink linecard
> + */
> +bool devlink_linecard_is_active(struct devlink_linecard *linecard)
> +{
> +	bool active;
> +
> +	mutex_lock(&linecard->devlink->lock);
> +	active = linecard->state == DEVLINK_LINECARD_STATE_ACTIVE;
> +	mutex_unlock(&linecard->devlink->lock);
> +	return active;
> +}
> +EXPORT_SYMBOL_GPL(devlink_linecard_is_active);
> +
>  int devlink_sb_register(struct devlink *devlink, unsigned int sb_index,
>  			u32 size, u16 ingress_pools_count,
>  			u16 egress_pools_count, u16 ingress_tc_count,
> -- 
> 2.26.2
> 
