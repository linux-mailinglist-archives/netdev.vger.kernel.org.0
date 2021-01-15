Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1F6C2F8141
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 17:53:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727741AbhAOQwl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 11:52:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726065AbhAOQwl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 11:52:41 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63F3BC061757
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 08:52:00 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id by1so7846366ejc.0
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 08:52:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=3d8iFTANk0UmVyQUlG47vm6KwCW2hPqTFB0liF97LE0=;
        b=FOsfVEx4WWqvuIUEnDVflHg2uYfvIyAQIqw9unKnn5BhbMeC/zic+vU1SUcYw7sk0P
         mXPdYN9Okdjz9A3BukrGce4dVWvfutMK1nu/c/oEM0aOfdcp7/d2JqlIdHHOTzIBO/67
         128whzFOhmMngT5qGsx81PImvbqyBhCKC0SO0bcKEVOWFkjcxD08y7X+X9tRm2essGtK
         Z876Pajemoc9030nrilWOeGbco9FOVDe5d3fk4rBHbU1oISjbMkHT1Y7c3KH0C1urcls
         jK44R99dsrBXZKp0smP0KtYoo2ZSjeUcoYDOagQFr+xgoBEJAcID0F1Q+nopusaaxeK4
         XDRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=3d8iFTANk0UmVyQUlG47vm6KwCW2hPqTFB0liF97LE0=;
        b=s5dmjDOV7OVFwJOBG7a4sc8BKRahyf3cuxegbbdpVQUX2+aaOtF7Uk47uq4cLkJ7oN
         La6hiqynmL83tJVFgHzwHsRBqsielZ08ovxqk0/63QPRDhjYfDjtfwl5H+VadFYF1b1i
         ifWF/WCgGxZaqhKp9wLpv4ExK+6RvD6NMf7uF0Uycs/Wjto0i7D1uD4LV3YQbs5VtteM
         sj8itTBF/Z8mgtOFYcR9KiZFNEqb0g6lk1Hqn8WDbkyGNd9xGlJ0eeKTpr4ACqU6pxkc
         hot9FbSUh+88R1KeN3kbIcWYNLK0pTanYZvie0bvNUhQAo72YJ+RQf37GNnlT2FVekwq
         Ic5g==
X-Gm-Message-State: AOAM532pMukDsNUNknamLzgGSvnDwoyqqIg3zjfCM0CsM08ZHp6IFbvS
        FrfGSOZIyuYgF3Dty6rRxSHsLg==
X-Google-Smtp-Source: ABdhPJxlgxEp9WXlfCjJB8DmWvzjpxhuxNxGrEY/0zJb7Q9CnVFoM0F0bjtX0ypr7Ix6Q5IkpEO6WA==
X-Received: by 2002:a17:906:4d8f:: with SMTP id s15mr5510920eju.389.1610729518980;
        Fri, 15 Jan 2021 08:51:58 -0800 (PST)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id bo20sm4317430edb.1.2021.01.15.08.51.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jan 2021 08:51:58 -0800 (PST)
Date:   Fri, 15 Jan 2021 17:51:57 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        jacob.e.keller@intel.com, roopa@nvidia.com, mlxsw@nvidia.com
Subject: Re: [patch net-next RFC 02/10] devlink: implement line card
 provisioning
Message-ID: <20210115165157.GO3565223@nanopsycho.orion>
References: <20210113121222.733517-1-jiri@resnulli.us>
 <20210113121222.733517-3-jiri@resnulli.us>
 <20210115160319.GC2064789@shredder.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210115160319.GC2064789@shredder.lan>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Jan 15, 2021 at 05:03:19PM CET, idosch@idosch.org wrote:
>On Wed, Jan 13, 2021 at 01:12:14PM +0100, Jiri Pirko wrote:
>> From: Jiri Pirko <jiri@nvidia.com>
>> 
>> In order to be able to configure all needed stuff on a port/netdevice
>> of a line card without the line card being present, introduce line card
>> provisioning. Basically provisioning will create a placeholder for
>> instances (ports/netdevices) for a line card type.
>> 
>> Allow the user to query the supported line card types over line card
>> get command. Then implement two netlink commands to allow user to
>> provision/unprovision the line card with selected line card type.
>> 
>> On the driver API side, add provision/unprovision ops and supported
>> types array to be advertised. Upon provision op call, the driver should
>> take care of creating the instances for the particular line card type.
>> Introduce provision_set/clear() functions to be called by the driver
>> once the provisioning/unprovisioning is done on its side.
>> 
>> Signed-off-by: Jiri Pirko <jiri@nvidia.com>
>> ---
>>  include/net/devlink.h        |  31 +++++++-
>>  include/uapi/linux/devlink.h |  17 +++++
>>  net/core/devlink.c           | 141 ++++++++++++++++++++++++++++++++++-
>>  3 files changed, 185 insertions(+), 4 deletions(-)
>> 
>> diff --git a/include/net/devlink.h b/include/net/devlink.h
>> index 67c2547d5ef9..854abd53e9ea 100644
>> --- a/include/net/devlink.h
>> +++ b/include/net/devlink.h
>> @@ -139,10 +139,33 @@ struct devlink_port {
>>  	struct mutex reporters_lock; /* Protects reporter_list */
>>  };
>>  
>> +struct devlink_linecard_ops;
>> +
>>  struct devlink_linecard {
>>  	struct list_head list;
>>  	struct devlink *devlink;
>>  	unsigned int index;
>> +	const struct devlink_linecard_ops *ops;
>> +	void *priv;
>> +	enum devlink_linecard_state state;
>> +	const char *provisioned_type;
>> +};
>> +
>> +/**
>> + * struct devlink_linecard_ops - Linecard operations
>> + * @supported_types: array of supported types of linecards
>> + * @supported_types_count: number of elements in the array above
>> + * @provision: callback to provision the linecard slot with certain
>> + *	       type of linecard
>> + * @unprovision: callback to unprovision the linecard slot
>> + */
>> +struct devlink_linecard_ops {
>> +	const char **supported_types;
>> +	unsigned int supported_types_count;
>> +	int (*provision)(struct devlink_linecard *linecard, void *priv,
>> +			 u32 type_index, struct netlink_ext_ack *extack);
>> +	int (*unprovision)(struct devlink_linecard *linecard, void *priv,
>> +			   struct netlink_ext_ack *extack);
>>  };
>>  
>>  struct devlink_sb_pool_info {
>> @@ -1414,9 +1437,13 @@ void devlink_port_attrs_pci_pf_set(struct devlink_port *devlink_port, u32 contro
>>  				   u16 pf, bool external);
>>  void devlink_port_attrs_pci_vf_set(struct devlink_port *devlink_port, u32 controller,
>>  				   u16 pf, u16 vf, bool external);
>> -struct devlink_linecard *devlink_linecard_create(struct devlink *devlink,
>> -						 unsigned int linecard_index);
>> +struct devlink_linecard *
>> +devlink_linecard_create(struct devlink *devlink, unsigned int linecard_index,
>> +			const struct devlink_linecard_ops *ops, void *priv);
>>  void devlink_linecard_destroy(struct devlink_linecard *linecard);
>> +void devlink_linecard_provision_set(struct devlink_linecard *linecard,
>> +				    u32 type_index);
>> +void devlink_linecard_provision_clear(struct devlink_linecard *linecard);
>>  int devlink_sb_register(struct devlink *devlink, unsigned int sb_index,
>>  			u32 size, u16 ingress_pools_count,
>>  			u16 egress_pools_count, u16 ingress_tc_count,
>> diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
>> index e5ed0522591f..4111ddcc000b 100644
>> --- a/include/uapi/linux/devlink.h
>> +++ b/include/uapi/linux/devlink.h
>> @@ -131,6 +131,9 @@ enum devlink_command {
>>  	DEVLINK_CMD_LINECARD_NEW,
>>  	DEVLINK_CMD_LINECARD_DEL,
>>  
>> +	DEVLINK_CMD_LINECARD_PROVISION,
>> +	DEVLINK_CMD_LINECARD_UNPROVISION,
>
>I do not really see the point in these two commands. Better extend
>DEVLINK_CMD_LINECARD_SET to carry these attributes.

Yeah, I was thinking about that. Not sure it is correct though. This is
single purpose command. It really does not change "an attribute" as the
"_SET" commands are usually doing. Consider extension of "_SET" by other
attributes. Then it looks wrong.


>
>> +
>>  	/* add new commands above here */
>>  	__DEVLINK_CMD_MAX,
>>  	DEVLINK_CMD_MAX = __DEVLINK_CMD_MAX - 1
>> @@ -329,6 +332,17 @@ enum devlink_reload_limit {
>>  
>>  #define DEVLINK_RELOAD_LIMITS_VALID_MASK (_BITUL(__DEVLINK_RELOAD_LIMIT_MAX) - 1)
>>  
>> +enum devlink_linecard_state {
>> +	DEVLINK_LINECARD_STATE_UNSPEC,
>> +	DEVLINK_LINECARD_STATE_UNPROVISIONED,
>> +	DEVLINK_LINECARD_STATE_UNPROVISIONING,
>> +	DEVLINK_LINECARD_STATE_PROVISIONING,
>
>Can you explain why these two states are necessary? Any reason the
>provision operation can't be synchronous? This is somewhat explained in
>patch #8, but it should really be explained here. Changelog says:
>
>"To avoid deadlock and to mimic actual HW flow, use workqueue
>to add/del ports during provisioning as the port add/del calls
>devlink_port_register/unregister() which take devlink mutex."
>
>The deadlock is not really a reason to have these states.

It is, need to avoid recursice locking

>'DEVLINK_CMD_PORT_SPLIT' also calls devlink_port_register() /
>devlink_port_unregister() and the deadlock is solved by:
>
>'internal_flags = DEVLINK_NL_FLAG_NO_LOCK'

Yeah, however, there, the port_index is passed down to the driver, not
the actual object pointer. That's why it can be done like that.

>
>A hardware flow the requires it is something else...

Hardware flow in case of Spectrum is async too.


>
>> +	DEVLINK_LINECARD_STATE_PROVISIONED,
>> +
>> +	__DEVLINK_LINECARD_STATE_MAX,
>> +	DEVLINK_LINECARD_STATE_MAX = __DEVLINK_LINECARD_STATE_MAX - 1
>> +};
>> +
>>  enum devlink_attr {
>>  	/* don't change the order or add anything between, this is ABI! */
>>  	DEVLINK_ATTR_UNSPEC,
>> @@ -535,6 +549,9 @@ enum devlink_attr {
>>  	DEVLINK_ATTR_RELOAD_ACTION_STATS,       /* nested */
>>  
>>  	DEVLINK_ATTR_LINECARD_INDEX,		/* u32 */
>> +	DEVLINK_ATTR_LINECARD_STATE,		/* u8 */
>> +	DEVLINK_ATTR_LINECARD_TYPE,		/* string */
>> +	DEVLINK_ATTR_LINECARD_SUPPORTED_TYPES,	/* nested */
>>  
>>  	/* add new attributes above here, update the policy in devlink.c */
>>  
>> diff --git a/net/core/devlink.c b/net/core/devlink.c
>> index 564e921133cf..434eecc310c3 100644
>> --- a/net/core/devlink.c
>> +++ b/net/core/devlink.c
>> @@ -1192,7 +1192,9 @@ static int devlink_nl_linecard_fill(struct sk_buff *msg,
>>  				    u32 seq, int flags,
>>  				    struct netlink_ext_ack *extack)
>>  {
>> +	struct nlattr *attr;
>>  	void *hdr;
>> +	int i;
>>  
>>  	hdr = genlmsg_put(msg, portid, seq, &devlink_nl_family, flags, cmd);
>>  	if (!hdr)
>> @@ -1202,6 +1204,22 @@ static int devlink_nl_linecard_fill(struct sk_buff *msg,
>>  		goto nla_put_failure;
>>  	if (nla_put_u32(msg, DEVLINK_ATTR_LINECARD_INDEX, linecard->index))
>>  		goto nla_put_failure;
>> +	if (nla_put_u8(msg, DEVLINK_ATTR_LINECARD_STATE, linecard->state))
>> +		goto nla_put_failure;
>> +	if (linecard->state >= DEVLINK_LINECARD_STATE_PROVISIONED &&
>
>This assumes that every state added after provisioned should report the
>type. Better to check for the specific states

Yes, that is correct assumption.


>
>> +	    nla_put_string(msg, DEVLINK_ATTR_LINECARD_TYPE,
>> +			   linecard->provisioned_type))
>> +		goto nla_put_failure;
>> +
>> +	attr = nla_nest_start(msg, DEVLINK_ATTR_LINECARD_SUPPORTED_TYPES);
>> +	if (!attr)
>> +		return -EMSGSIZE;
>> +	for (i = 0; i < linecard->ops->supported_types_count; i++) {
>> +		if (nla_put_string(msg, DEVLINK_ATTR_LINECARD_TYPE,
>> +				   linecard->ops->supported_types[i]))
>> +			goto nla_put_failure;
>> +	}
>> +	nla_nest_end(msg, attr);
>>  
>>  	genlmsg_end(msg, hdr);
>>  	return 0;
>> @@ -1300,6 +1318,68 @@ static int devlink_nl_cmd_linecard_get_dumpit(struct sk_buff *msg,
>>  	return msg->len;
>>  }
>>  
>> +static int devlink_nl_cmd_linecard_provision_doit(struct sk_buff *skb,
>> +						  struct genl_info *info)
>> +{
>> +	struct devlink_linecard *linecard = info->user_ptr[1];
>> +	const char *type;
>> +	int i;
>> +
>> +	if (linecard->state == DEVLINK_LINECARD_STATE_PROVISIONING) {
>> +		NL_SET_ERR_MSG_MOD(info->extack, "Linecard is currently being provisioned");
>> +		return -EBUSY;
>> +	}
>> +	if (linecard->state == DEVLINK_LINECARD_STATE_UNPROVISIONING) {
>> +		NL_SET_ERR_MSG_MOD(info->extack, "Linecard is currently being unprovisioned");
>> +		return -EBUSY;
>> +	}
>> +	if (linecard->state != DEVLINK_LINECARD_STATE_UNPROVISIONED) {
>> +		NL_SET_ERR_MSG_MOD(info->extack, "Linecard already provisioned");
>> +		return -EBUSY;
>> +	}
>> +
>> +	if (!info->attrs[DEVLINK_ATTR_LINECARD_TYPE]) {
>> +		NL_SET_ERR_MSG_MOD(info->extack, "Provision type not provided");
>> +		return -EINVAL;
>> +	}
>> +
>> +	type = nla_data(info->attrs[DEVLINK_ATTR_LINECARD_TYPE]);
>> +	for (i = 0; i < linecard->ops->supported_types_count; i++) {
>> +		if (!strcmp(linecard->ops->supported_types[i], type)) {
>> +			linecard->state = DEVLINK_LINECARD_STATE_PROVISIONING;
>> +			devlink_linecard_notify(linecard, DEVLINK_CMD_LINECARD_NEW);
>> +			return linecard->ops->provision(linecard,
>> +							linecard->priv, i,
>> +							info->extack);
>
>So if this fails user space will see 'provisioning' although nothing is
>being provisioned... Better to set the state and notify if this call did
>not fail

The driver is responsible to either call provision_set/provision_clear
helper. Note the async nature of this op.


>
>> +		}
>> +	}
>> +	NL_SET_ERR_MSG_MOD(info->extack, "Unsupported provision type provided");
>> +	return -EINVAL;
>> +}
>> +
>> +static int devlink_nl_cmd_linecard_unprovision_doit(struct sk_buff *skb,
>> +						    struct genl_info *info)
>> +{
>> +	struct devlink_linecard *linecard = info->user_ptr[1];
>> +
>> +	if (linecard->state == DEVLINK_LINECARD_STATE_PROVISIONING) {
>> +		NL_SET_ERR_MSG_MOD(info->extack, "Linecard is currently being provisioned");
>> +		return -EBUSY;
>> +	}
>> +	if (linecard->state == DEVLINK_LINECARD_STATE_UNPROVISIONING) {
>> +		NL_SET_ERR_MSG_MOD(info->extack, "Linecard is currently being unprovisioned");
>> +		return -EBUSY;
>> +	}
>> +	if (linecard->state == DEVLINK_LINECARD_STATE_UNPROVISIONED) {
>> +		NL_SET_ERR_MSG_MOD(info->extack, "Linecard is not provisioned");
>> +		return -EOPNOTSUPP;
>> +	}
>> +	linecard->state = DEVLINK_LINECARD_STATE_UNPROVISIONING;
>> +	devlink_linecard_notify(linecard, DEVLINK_CMD_LINECARD_NEW);
>> +	return linecard->ops->unprovision(linecard, linecard->priv,
>> +					  info->extack);
>> +}
>> +
>>  static int devlink_nl_sb_fill(struct sk_buff *msg, struct devlink *devlink,
>>  			      struct devlink_sb *devlink_sb,
>>  			      enum devlink_command cmd, u32 portid,
>> @@ -7759,6 +7839,7 @@ static const struct nla_policy devlink_nl_policy[DEVLINK_ATTR_MAX + 1] = {
>>  							DEVLINK_RELOAD_ACTION_MAX),
>>  	[DEVLINK_ATTR_RELOAD_LIMITS] = NLA_POLICY_BITFIELD32(DEVLINK_RELOAD_LIMITS_VALID_MASK),
>>  	[DEVLINK_ATTR_LINECARD_INDEX] = { .type = NLA_U32 },
>> +	[DEVLINK_ATTR_LINECARD_TYPE] = { .type = NLA_NUL_STRING },
>>  };
>>  
>>  static const struct genl_small_ops devlink_nl_ops[] = {
>> @@ -7806,6 +7887,20 @@ static const struct genl_small_ops devlink_nl_ops[] = {
>>  		.internal_flags = DEVLINK_NL_FLAG_NEED_LINECARD,
>>  		/* can be retrieved by unprivileged users */
>>  	},
>> +	{
>> +		.cmd = DEVLINK_CMD_LINECARD_PROVISION,
>> +		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
>> +		.doit = devlink_nl_cmd_linecard_provision_doit,
>> +		.flags = GENL_ADMIN_PERM,
>> +		.internal_flags = DEVLINK_NL_FLAG_NEED_LINECARD,
>> +	},
>> +	{
>> +		.cmd = DEVLINK_CMD_LINECARD_UNPROVISION,
>> +		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
>> +		.doit = devlink_nl_cmd_linecard_unprovision_doit,
>> +		.flags = GENL_ADMIN_PERM,
>> +		.internal_flags = DEVLINK_NL_FLAG_NEED_LINECARD,
>> +	},
>>  	{
>>  		.cmd = DEVLINK_CMD_SB_GET,
>>  		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
>> @@ -8613,11 +8708,17 @@ static int __devlink_port_phys_port_name_get(struct devlink_port *devlink_port,
>>   *	Create devlink linecard instance with provided linecard index.
>>   *	Caller can use any indexing, even hw-related one.
>>   */
>> -struct devlink_linecard *devlink_linecard_create(struct devlink *devlink,
>> -						 unsigned int linecard_index)
>> +struct devlink_linecard *
>> +devlink_linecard_create(struct devlink *devlink, unsigned int linecard_index,
>> +			const struct devlink_linecard_ops *ops, void *priv)
>>  {
>>  	struct devlink_linecard *linecard;
>>  
>> +	if (WARN_ON(!ops || !ops->supported_types ||
>> +		    !ops->supported_types_count ||
>> +		    !ops->provision || !ops->unprovision))
>> +		return ERR_PTR(-EINVAL);
>> +
>>  	mutex_lock(&devlink->lock);
>>  	if (devlink_linecard_index_exists(devlink, linecard_index)) {
>>  		mutex_unlock(&devlink->lock);
>> @@ -8630,6 +8731,9 @@ struct devlink_linecard *devlink_linecard_create(struct devlink *devlink,
>>  
>>  	linecard->devlink = devlink;
>>  	linecard->index = linecard_index;
>> +	linecard->ops = ops;
>> +	linecard->priv = priv;
>> +	linecard->state = DEVLINK_LINECARD_STATE_UNPROVISIONED;
>>  	list_add_tail(&linecard->list, &devlink->linecard_list);
>>  	mutex_unlock(&devlink->lock);
>>  	devlink_linecard_notify(linecard, DEVLINK_CMD_LINECARD_NEW);
>> @@ -8653,6 +8757,39 @@ void devlink_linecard_destroy(struct devlink_linecard *linecard)
>>  }
>>  EXPORT_SYMBOL_GPL(devlink_linecard_create);
>>  
>> +/**
>> + *	devlink_linecard_provision_set - Set provisioning on linecard
>
>'Set linecard as provisioned' maybe?

Sure, why not.


>
>> + *
>> + *	@devlink_linecard: devlink linecard
>> + *	@type_index: index of the linecard type (in array of types in ops)
>> + */
>> +void devlink_linecard_provision_set(struct devlink_linecard *linecard,
>> +				    u32 type_index)
>> +{
>> +	WARN_ON(type_index >= linecard->ops->supported_types_count);
>
>Wouldn't this explode below when you use the index to access the array?
>Maybe better to just warn and return

Okay.


>
>> +	mutex_lock(&linecard->devlink->lock);
>> +	linecard->state = DEVLINK_LINECARD_STATE_PROVISIONED;
>> +	linecard->provisioned_type = linecard->ops->supported_types[type_index];
>> +	mutex_unlock(&linecard->devlink->lock);
>> +	devlink_linecard_notify(linecard, DEVLINK_CMD_LINECARD_NEW);
>> +}
>> +EXPORT_SYMBOL_GPL(devlink_linecard_provision_set);
>> +
>> +/**
>> + *	devlink_linecard_provision_clear - Clear provisioning on linecard
>
>'Set linecard as unprovisioned' maybe?

Sure, why not.


>
>> + *
>> + *	@devlink_linecard: devlink linecard
>> + */
>> +void devlink_linecard_provision_clear(struct devlink_linecard *linecard)
>> +{
>> +	mutex_lock(&linecard->devlink->lock);
>> +	linecard->state = DEVLINK_LINECARD_STATE_UNPROVISIONED;
>> +	linecard->provisioned_type = NULL;
>> +	mutex_unlock(&linecard->devlink->lock);
>> +	devlink_linecard_notify(linecard, DEVLINK_CMD_LINECARD_NEW);
>> +}
>> +EXPORT_SYMBOL_GPL(devlink_linecard_provision_clear);
>> +
>>  int devlink_sb_register(struct devlink *devlink, unsigned int sb_index,
>>  			u32 size, u16 ingress_pools_count,
>>  			u16 egress_pools_count, u16 ingress_tc_count,
>> -- 
>> 2.26.2
>> 
