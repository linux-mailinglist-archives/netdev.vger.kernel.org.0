Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26B242F80D8
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 17:32:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732828AbhAOQcJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 11:32:09 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:52867 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731582AbhAOQcI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 11:32:08 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 087775C01ED;
        Fri, 15 Jan 2021 11:31:02 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Fri, 15 Jan 2021 11:31:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=1wRzw5
        YvcT5fwKUDuPC5q1ZTUwW0kWMxx//69g7vwdg=; b=b83f8uj36WfQ5atnzfrcbv
        7OFzLs8mZDIOwq4fpCqYIZWvtp9tzy43611K0fAiZmKzfWeGnejcHWQFXvftMAp8
        jEZvLMLyaUVlET3Om7lyA4p6smpExAVkgjwBqlwBwei6ZGBeK+0t7qMxdhhS4uHp
        4eEvBMhq53MXtvgpvBHOgW3ULzgD4pFGqtzvr2MUpXSMpWEf0GDumJshV3dPnfs3
        ltum3V9qM3Mz34V50HCbslwB34OUZp1Ol8oZiFatLl3ueZT+Tbn5w57Ad5vFPDeq
        bZkZcNE5c1YILZvs9dLdWdFmROagG9Ez4XF1nK265SnMq08pn8BUtmoGu9QtGZvg
        ==
X-ME-Sender: <xms:RcMBYJ1suBS64tbn7iBRXEoM7v2pa1qYV8uwZ62pPQ-fSJ4MlfjWAQ>
    <xme:RcMBYAFpzRLRnCXciEr_lES4gvCWclEFoQ8uOaC1Z8UvbaEVnlyUKGI6G4kka4sFx
    UmM2ois9JuM2Eg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrtddvgdeihecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcuufgt
    hhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrthhtvg
    hrnheptdffkeekfeduffevgeeujeffjefhtefgueeugfevtdeiheduueeukefhudehleet
    necukfhppeekgedrvddvledrudehfedrgeegnecuvehluhhsthgvrhfuihiivgeptdenuc
    frrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:RcMBYJ7zGDCSDJWBcKmdhImoCa8DHtwqxlSIQctshS4veGpmPRkaBQ>
    <xmx:RcMBYG0aC8RFR9ec_eajHhYIpv8H8HEwim3vBJxhCSGBY1qjTpGRkQ>
    <xmx:RcMBYMHyN5HV05RRz2RPv3jNJc9w4129YUV-cwI-h03hS12TLbpQ8w>
    <xmx:RsMBYAB1PqWzEyQsXhV0mVZvFIsTyM0VEMULw2x0BBJlbVwS0bn29Q>
Received: from localhost (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id DD8681080067;
        Fri, 15 Jan 2021 11:31:00 -0500 (EST)
Date:   Fri, 15 Jan 2021 18:30:58 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        jacob.e.keller@intel.com, roopa@nvidia.com, mlxsw@nvidia.com
Subject: Re: [patch net-next RFC 08/10] netdevsim: create devlink line card
 object and implement provisioning
Message-ID: <20210115163058.GF2064789@shredder.lan>
References: <20210113121222.733517-1-jiri@resnulli.us>
 <20210113121222.733517-9-jiri@resnulli.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210113121222.733517-9-jiri@resnulli.us>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 13, 2021 at 01:12:20PM +0100, Jiri Pirko wrote:
> @@ -977,6 +1012,9 @@ static int __nsim_dev_port_add(struct nsim_dev *nsim_dev,
>  	memcpy(attrs.switch_id.id, nsim_dev->switch_id.id, nsim_dev->switch_id.id_len);
>  	attrs.switch_id.id_len = nsim_dev->switch_id.id_len;
>  	devlink_port_attrs_set(devlink_port, &attrs);
> +	if (nsim_dev_linecard)
> +		devlink_port_linecard_set(devlink_port,
> +					  nsim_dev_linecard->devlink_linecard);

Should be fold into devlink_port_attrs_set()

>  	err = devlink_port_register(priv_to_devlink(nsim_dev), devlink_port,
>  				    nsim_dev_port->port_index);
>  	if (err)
> @@ -1053,10 +1091,88 @@ static int nsim_dev_port_add_all(struct nsim_dev *nsim_dev,
>  	return err;
>  }
>  
> +static void nsim_dev_linecard_provision_work(struct work_struct *work)
> +{
> +	struct nsim_dev_linecard *nsim_dev_linecard;
> +	struct nsim_bus_dev *nsim_bus_dev;
> +	int err;
> +	int i;
> +
> +	nsim_dev_linecard = container_of(work, struct nsim_dev_linecard,
> +					 provision_work);
> +
> +	nsim_bus_dev = nsim_dev_linecard->nsim_dev->nsim_bus_dev;
> +	for (i = 0; i < nsim_dev_linecard_port_count(nsim_dev_linecard); i++) {
> +		err = nsim_dev_port_add(nsim_bus_dev, nsim_dev_linecard, i);
> +		if (err)
> +			goto err_port_del_all;
> +	}
> +	nsim_dev_linecard->provisioned = true;
> +	devlink_linecard_provision_set(nsim_dev_linecard->devlink_linecard,
> +				       nsim_dev_linecard->type_index);
> +	return;
> +
> +err_port_del_all:
> +	for (i--; i >= 0; i--)
> +		nsim_dev_port_del(nsim_bus_dev, nsim_dev_linecard, i);
> +	devlink_linecard_provision_clear(nsim_dev_linecard->devlink_linecard);
> +}
> +
> +static int nsim_dev_linecard_provision(struct devlink_linecard *linecard,
> +				       void *priv, u32 type_index,
> +				       struct netlink_ext_ack *extack)
> +{
> +	struct nsim_dev_linecard *nsim_dev_linecard = priv;
> +
> +	nsim_dev_linecard->type_index = type_index;
> +	INIT_WORK(&nsim_dev_linecard->provision_work,
> +		  nsim_dev_linecard_provision_work);
> +	schedule_work(&nsim_dev_linecard->provision_work);
> +
> +	return 0;
> +}
> +
> +static void nsim_dev_linecard_unprovision_work(struct work_struct *work)
> +{
> +	struct nsim_dev_linecard *nsim_dev_linecard;
> +	struct nsim_bus_dev *nsim_bus_dev;
> +	int i;
> +
> +	nsim_dev_linecard = container_of(work, struct nsim_dev_linecard,
> +					 provision_work);
> +
> +	nsim_bus_dev = nsim_dev_linecard->nsim_dev->nsim_bus_dev;
> +	nsim_dev_linecard->provisioned = false;
> +	devlink_linecard_provision_clear(nsim_dev_linecard->devlink_linecard);
> +	for (i = 0; i < nsim_dev_linecard_port_count(nsim_dev_linecard); i++)
> +		nsim_dev_port_del(nsim_bus_dev, nsim_dev_linecard, i);
> +}
> +
> +static int nsim_dev_linecard_unprovision(struct devlink_linecard *linecard,
> +					 void *priv,
> +					 struct netlink_ext_ack *extack)
> +{
> +	struct nsim_dev_linecard *nsim_dev_linecard = priv;
> +
> +	INIT_WORK(&nsim_dev_linecard->provision_work,
> +		  nsim_dev_linecard_unprovision_work);
> +	schedule_work(&nsim_dev_linecard->provision_work);
> +
> +	return 0;
> +}
> +
> +static const struct devlink_linecard_ops nsim_dev_linecard_ops = {
> +	.supported_types = nsim_dev_linecard_supported_types,
> +	.supported_types_count = ARRAY_SIZE(nsim_dev_linecard_supported_types),
> +	.provision = nsim_dev_linecard_provision,
> +	.unprovision = nsim_dev_linecard_unprovision,
> +};
> +
>  static int __nsim_dev_linecard_add(struct nsim_dev *nsim_dev,
>  				   unsigned int linecard_index)
>  {
>  	struct nsim_dev_linecard *nsim_dev_linecard;
> +	struct devlink_linecard *devlink_linecard;
>  	int err;
>  
>  	nsim_dev_linecard = kzalloc(sizeof(*nsim_dev_linecard), GFP_KERNEL);
> @@ -1066,14 +1182,27 @@ static int __nsim_dev_linecard_add(struct nsim_dev *nsim_dev,
>  	nsim_dev_linecard->linecard_index = linecard_index;
>  	INIT_LIST_HEAD(&nsim_dev_linecard->port_list);
>  
> +	devlink_linecard = devlink_linecard_create(priv_to_devlink(nsim_dev),
> +						   linecard_index,
> +						   &nsim_dev_linecard_ops,
> +						   nsim_dev_linecard);
> +	if (IS_ERR(devlink_linecard)) {
> +		err = PTR_ERR(devlink_linecard);
> +		goto err_linecard_free;
> +	}
> +
> +	nsim_dev_linecard->devlink_linecard = devlink_linecard;
> +
>  	err = nsim_dev_linecard_debugfs_init(nsim_dev, nsim_dev_linecard);
>  	if (err)
> -		goto err_linecard_free;
> +		goto err_dl_linecard_destroy;
>  
>  	list_add(&nsim_dev_linecard->list, &nsim_dev->linecard_list);
>  
>  	return 0;
>  
> +err_dl_linecard_destroy:
> +	devlink_linecard_destroy(devlink_linecard);
>  err_linecard_free:
>  	kfree(nsim_dev_linecard);
>  	return err;
> @@ -1081,8 +1210,12 @@ static int __nsim_dev_linecard_add(struct nsim_dev *nsim_dev,
>  
>  static void __nsim_dev_linecard_del(struct nsim_dev_linecard *nsim_dev_linecard)
>  {
> +	struct devlink_linecard *devlink_linecard =
> +					nsim_dev_linecard->devlink_linecard;
> +
>  	list_del(&nsim_dev_linecard->list);
>  	nsim_dev_linecard_debugfs_exit(nsim_dev_linecard);

What about the delayed work? I believe it can run while you are
destroying the linecard, so cancel_delayed_work_sync() is needed

> +	devlink_linecard_destroy(devlink_linecard);
>  	kfree(nsim_dev_linecard);
>  }
>  
> diff --git a/drivers/net/netdevsim/netdevsim.h b/drivers/net/netdevsim/netdevsim.h
> index 88b61b9390bf..ab217b361416 100644
> --- a/drivers/net/netdevsim/netdevsim.h
> +++ b/drivers/net/netdevsim/netdevsim.h
> @@ -196,10 +196,14 @@ struct nsim_dev;
>  
>  struct nsim_dev_linecard {
>  	struct list_head list;
> +	struct devlink_linecard *devlink_linecard;
>  	struct nsim_dev *nsim_dev;
>  	struct list_head port_list;
>  	unsigned int linecard_index;
>  	struct dentry *ddir;
> +	bool provisioned;
> +	u32 type_index;
> +	struct work_struct provision_work;
>  };
>  
>  struct nsim_dev {
> -- 
> 2.26.2
> 
