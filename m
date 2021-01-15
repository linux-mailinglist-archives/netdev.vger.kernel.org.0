Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13A302F8050
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 17:11:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732189AbhAOQLh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 11:11:37 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:44865 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727719AbhAOQLh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 11:11:37 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 30C725C01BE;
        Fri, 15 Jan 2021 11:10:51 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Fri, 15 Jan 2021 11:10:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=s56ZPd
        zWxpYi4+dUDvRKBO3LuWh1pCGiGd99jmMtSKk=; b=DYjO3sjJSF6MZP6y6tUCbz
        +nlBvOa92QpVbQ5naKTqd/1UzitDGSCvmayUFekbd7TMXhnkl67YQmaWCisSuKCH
        aU3nHkCWqd73bbtWZBgfRqqh3AcRfFCyMVwqUknZ/oIj+h4LwOG5LtjwpzxlnGdv
        VhlL5ZGT8d7TFD3Lwjq0BBysconUy3iH8RB1FnOfV4m89PfqBN+ZsOa+FDb6l/uA
        UDw5IGt4+CdF6dYG95A/exR6uB8Z/uCLNcCdXGqPr5TwbYl9IBNIVXY80bl3jxBF
        Bihif87wkZqsMBAiAx2vp/+N4/NOqLm36RoyXtPt6JnPSt8RNkjKbMZEE64HPXwQ
        ==
X-ME-Sender: <xms:ir4BYAkF23wAnQGkRbupj1dJLGoPQiaMdKG3XyXJsvEyQbt1fdj1_g>
    <xme:ir4BYP1WCaoowVzLlZvQ2QOg9pdSzFAdkMZlLJ-bZgBsbO78K0_dOcFPeUHU4UTcW
    bRhPdROrq08Pks>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrtddvgdeiudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcuufgt
    hhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrthhtvg
    hrnheptdffkeekfeduffevgeeujeffjefhtefgueeugfevtdeiheduueeukefhudehleet
    necukfhppeekgedrvddvledrudehfedrgeegnecuvehluhhsthgvrhfuihiivgeptdenuc
    frrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:ir4BYOqvvVgv89vXLYN2w7S-8Tx97RNN65bDoA7CRkRctAL3IhtGzQ>
    <xmx:ir4BYMmOa5FfqA3gxvSJeNqavBzvc0hw0iBPx8RfJ450noFxMal9aw>
    <xmx:ir4BYO0lpLjgxvcnReBkuhmRrCpy5zqK7yld_BHOmDjDLcWf3EweRg>
    <xmx:i74BYDzCM3ggPRk9IyoQr6odo2vYE_u9XZ3if9omZ_av3x6IXSNqkw>
Received: from localhost (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1C5D6108005F;
        Fri, 15 Jan 2021 11:10:49 -0500 (EST)
Date:   Fri, 15 Jan 2021 18:10:48 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        jacob.e.keller@intel.com, roopa@nvidia.com, mlxsw@nvidia.com
Subject: Re: [patch net-next RFC 05/10] devlink: add port to line card
 relationship set
Message-ID: <20210115161048.GE2064789@shredder.lan>
References: <20210113121222.733517-1-jiri@resnulli.us>
 <20210113121222.733517-6-jiri@resnulli.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210113121222.733517-6-jiri@resnulli.us>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 13, 2021 at 01:12:17PM +0100, Jiri Pirko wrote:
> index ec00cd94c626..cb911b6fdeda 100644
> --- a/include/net/devlink.h
> +++ b/include/net/devlink.h
> @@ -137,6 +137,7 @@ struct devlink_port {
>  	struct delayed_work type_warn_dw;
>  	struct list_head reporter_list;
>  	struct mutex reporters_lock; /* Protects reporter_list */
> +	struct devlink_linecard *linecard;
>  };
>  
>  struct devlink_linecard_ops;
> @@ -1438,6 +1439,8 @@ void devlink_port_attrs_pci_pf_set(struct devlink_port *devlink_port, u32 contro
>  				   u16 pf, bool external);
>  void devlink_port_attrs_pci_vf_set(struct devlink_port *devlink_port, u32 controller,
>  				   u16 pf, u16 vf, bool external);
> +void devlink_port_linecard_set(struct devlink_port *devlink_port,
> +			       struct devlink_linecard *linecard);
>  struct devlink_linecard *
>  devlink_linecard_create(struct devlink *devlink, unsigned int linecard_index,
>  			const struct devlink_linecard_ops *ops, void *priv);
> diff --git a/net/core/devlink.c b/net/core/devlink.c
> index 347976b88404..2faa30cc5cce 100644
> --- a/net/core/devlink.c
> +++ b/net/core/devlink.c
> @@ -855,6 +855,10 @@ static int devlink_nl_port_fill(struct sk_buff *msg, struct devlink *devlink,
>  		goto nla_put_failure;
>  	if (devlink_nl_port_function_attrs_put(msg, devlink_port, extack))
>  		goto nla_put_failure;
> +	if (devlink_port->linecard &&
> +	    nla_put_u32(msg, DEVLINK_ATTR_LINECARD_INDEX,
> +			devlink_port->linecard->index))
> +		goto nla_put_failure;
>  
>  	genlmsg_end(msg, hdr);
>  	return 0;
> @@ -8642,6 +8646,21 @@ void devlink_port_attrs_pci_vf_set(struct devlink_port *devlink_port, u32 contro
>  }
>  EXPORT_SYMBOL_GPL(devlink_port_attrs_pci_vf_set);
>  
> +/**
> + *	devlink_port_linecard_set - Link port with a linecard
> + *
> + *	@devlink_port: devlink port
> + *	@devlink_linecard: devlink linecard
> + */
> +void devlink_port_linecard_set(struct devlink_port *devlink_port,
> +			       struct devlink_linecard *linecard)
> +{
> +	if (WARN_ON(devlink_port->registered))
> +		return;
> +	devlink_port->linecard = linecard;

We already have devlink_port_attrs_set() that is called before the port
is registered, why not extend it to also set the linecard information?

> +}
> +EXPORT_SYMBOL_GPL(devlink_port_linecard_set);
> +
>  static int __devlink_port_phys_port_name_get(struct devlink_port *devlink_port,
>  					     char *name, size_t len)
>  {
> @@ -8654,7 +8673,11 @@ static int __devlink_port_phys_port_name_get(struct devlink_port *devlink_port,
>  	switch (attrs->flavour) {
>  	case DEVLINK_PORT_FLAVOUR_PHYSICAL:
>  	case DEVLINK_PORT_FLAVOUR_VIRTUAL:
> -		n = snprintf(name, len, "p%u", attrs->phys.port_number);
> +		if (devlink_port->linecard)
> +			n = snprintf(name, len, "l%u",
> +				     devlink_port->linecard->index);
> +		n += snprintf(name + n, len - n, "p%u",
> +			      attrs->phys.port_number);
>  		if (attrs->split)
>  			n += snprintf(name + n, len - n, "s%u",
>  				      attrs->phys.split_subport_number);
> -- 
> 2.26.2
> 
