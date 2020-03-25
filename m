Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 510A71925C8
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 11:37:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727430AbgCYKhv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 06:37:51 -0400
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:47283 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726262AbgCYKhv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 06:37:51 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id 2BB2B58033B;
        Wed, 25 Mar 2020 06:37:49 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Wed, 25 Mar 2020 06:37:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=x9QMyL
        Qkwf7i74hjhqgDmwsJXqnwgFCRdWNTh0pd8kg=; b=FUC45Dx9kW5pXt1kLKpJhP
        wwBjaaEgYN3GPjopd4UlazIWl+3lwDDvwY1xLBTvqlh1sfvAdy345mlzyVVHBw9P
        QuLWyy94p5JR4y11Zco0m26Zd/nN39TTvECGpkbeNpTpBrPZnn9uYJBx807S0KOz
        DdHY6ZFtI6n6vRA4fMt9A0VICNpWIQAXKqDHRLIciMeSVNuMRgJfVsYmE0XnCTar
        5nm+GS4v4Fqv01gqYQZqMRNtL5i/vF66UfuuvcSmpgKhV1t1DqeBYs6wsWiQmPog
        /fOtL9dtN2hlwcF9MvyAUekAgdVjCwkZ3iKHTfFRbzIWDZglNr7jv2ZrzYXbciuQ
        ==
X-ME-Sender: <xms:ejR7Xi_VY51FTb46uExlmsB45HjC4rKzQCsJPGGx163URl4WqodPRQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudehfedgudeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpeffhffvuffkfhggtggujgesthdtre
    dttddtvdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeejledrudektddrleegrddvvdehnecuvehluhhsthgvrh
    fuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgt
    hhdrohhrgh
X-ME-Proxy: <xmx:ejR7XspElZ99vcrJRMN5c0S5bZNcUaecZb68TrQVjg2LbXnBFKYUvw>
    <xmx:ejR7Xp7PcrwPyRIBHCgpOwTxGqbcWHxL5JUouhEqIYIiHL4uUEjSDg>
    <xmx:ejR7Xl7ZGaPVMMc-iGb1s1dUAWsxloF0rrJtwjUhH3SUfOp0luE1tQ>
    <xmx:fTR7XuJH31GxEh68ZRJBvzz0SQcTA1PUHJpOxrTEP8G_anQAuTkyNg>
Received: from localhost (bzq-79-180-94-225.red.bezeqint.net [79.180.94.225])
        by mail.messagingengine.com (Postfix) with ESMTPA id EDB103066145;
        Wed, 25 Mar 2020 06:37:45 -0400 (EDT)
Date:   Wed, 25 Mar 2020 12:37:43 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, jiri@mellanox.com,
        andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        roopa@cumulusnetworks.com, nikolay@cumulusnetworks.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next 05/15] devlink: Allow setting of packet trap
 group parameters
Message-ID: <20200325103743.GC1332836@splinter>
References: <20200324193250.1322038-1-idosch@idosch.org>
 <20200324193250.1322038-6-idosch@idosch.org>
 <20200324205314.2d2ba2fd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200324205314.2d2ba2fd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 24, 2020 at 08:53:14PM -0700, Jakub Kicinski wrote:
> On Tue, 24 Mar 2020 21:32:40 +0200 Ido Schimmel wrote:
> > From: Ido Schimmel <idosch@mellanox.com>
> > 
> > The previous patch allowed device drivers to publish their default
> > binding between packet trap policers and packet trap groups. However,
> > some users might not be content with this binding and would like to
> > change it.
> > 
> > In case user space passed a packet trap policer identifier when setting
> > a packet trap group, invoke the appropriate device driver callback and
> > pass the new policer identifier.
> > 
> > Signed-off-by: Ido Schimmel <idosch@mellanox.com>
> > Reviewed-by: Jiri Pirko <jiri@mellanox.com>
> > ---
> >  include/net/devlink.h |  9 +++++++++
> >  net/core/devlink.c    | 43 +++++++++++++++++++++++++++++++++++++++++++
> >  2 files changed, 52 insertions(+)
> > 
> > diff --git a/include/net/devlink.h b/include/net/devlink.h
> > index 84c28e0f2d90..dea3c3fd9634 100644
> > --- a/include/net/devlink.h
> > +++ b/include/net/devlink.h
> > @@ -847,6 +847,15 @@ struct devlink_ops {
> >  	 */
> >  	int (*trap_group_init)(struct devlink *devlink,
> >  			       const struct devlink_trap_group *group);
> > +	/**
> > +	 * @trap_group_set: Trap group parameters set function.
> > +	 *
> > +	 * Note: @policer can be NULL when a policer is being unbound from
> > +	 * @group.
> > +	 */
> > +	int (*trap_group_set)(struct devlink *devlink,
> > +			      const struct devlink_trap_group *group,
> > +			      const struct devlink_trap_policer *policer);
> >  	/**
> >  	 * @trap_policer_init: Trap policer initialization function.
> >  	 *
> > diff --git a/net/core/devlink.c b/net/core/devlink.c
> > index 4ec7c7578709..e3042e131c1f 100644
> > --- a/net/core/devlink.c
> > +++ b/net/core/devlink.c
> > @@ -6039,6 +6039,45 @@ devlink_trap_group_action_set(struct devlink *devlink,
> >  	return 0;
> >  }
> >  
> > +static int devlink_trap_group_set(struct devlink *devlink,
> > +				  struct devlink_trap_group_item *group_item,
> > +				  struct genl_info *info)
> > +{
> > +	struct devlink_trap_policer_item *policer_item;
> > +	struct netlink_ext_ack *extack = info->extack;
> > +	const struct devlink_trap_policer *policer;
> > +	struct nlattr **attrs = info->attrs;
> > +	int err;
> > +
> 
> Why not:
> 
> 	if (!attrs[DEVLINK_ATTR_TRAP_POLICER_ID])
> 		return 0?

Trying to come up with a good reason why I didn't do it, but don't have
any :p

> 
> > +	if (!devlink->ops->trap_group_set) {
> > +		if (attrs[DEVLINK_ATTR_TRAP_POLICER_ID])
> > +			return -EOPNOTSUPP;
> > +		return 0;
> > +	}
> > +
> > +	policer_item = group_item->policer_item;
> > +	if (attrs[DEVLINK_ATTR_TRAP_POLICER_ID]) {
> > +		u32 policer_id;
> > +
> > +		policer_id = nla_get_u32(attrs[DEVLINK_ATTR_TRAP_POLICER_ID]);
> > +		policer_item = devlink_trap_policer_item_lookup(devlink,
> > +								policer_id);
> > +		if (policer_id && !policer_item) {
> > +			NL_SET_ERR_MSG_MOD(extack, "Device did not register this trap policer");
> 
> nit: is KBUILD_MODNAME still set if devlink can only be built-in now?

It seems fine:

NL_SET_ERR_MSG_MOD:

# devlink trap policer set pci/0000:01:00.0 policer 1337
Error: devlink: Device did not register this trap policer.
devlink answers: No such file or directory

NL_SET_ERR_MSG:

# devlink trap policer set pci/0000:01:00.0 policer 1337
Error: Device did not register this trap policer.
devlink answers: No such file or directory

> 
> > +			return -ENOENT;
> > +		}
> > +	}
> > +	policer = policer_item ? policer_item->policer : NULL;
> > +
> > +	err = devlink->ops->trap_group_set(devlink, group_item->group, policer);
> > +	if (err)
> > +		return err;
> > +
> > +	group_item->policer_item = policer_item;
> > +
> > +	return 0;
> > +}
> > +
> >  static int devlink_nl_cmd_trap_group_set_doit(struct sk_buff *skb,
> >  					      struct genl_info *info)
> >  {
> > @@ -6060,6 +6099,10 @@ static int devlink_nl_cmd_trap_group_set_doit(struct sk_buff *skb,
> >  	if (err)
> >  		return err;
> >  
> > +	err = devlink_trap_group_set(devlink, group_item, info);
> > +	if (err)
> > +		return err;
> 
> Should this unwind the action changes? Are the changes supposed to be
> atomic? :S 

I used do_setlink() as reference and it seems that it does not unwind
the changes. I can add extack message in case we did set action and
devlink_trap_group_set() failed.

> Also could it potentially be a problem if trap is being enabled and
> policer applied - if we enable first the CPU may get overloaded and it
> may be hard to apply the policer? Making sure the ordering is right
> requires some careful checking, so IDK if its worth it..

I'm not sure it's really an issue, but I can flip the order just to be
on the safe side.

> 
> >  	return 0;
> >  }
> >  
> 
