Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0420D2F8146
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 17:55:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727840AbhAOQyF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 11:54:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725910AbhAOQyE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 11:54:04 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20715C061757
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 08:53:24 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id h16so10250438edt.7
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 08:53:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1EJ6y98vuv5SlVnuIquKps9u3qw/nSNS2GPf/mtMuLI=;
        b=GBfbevi2/LPEz8CWb666P6JdnQqKDZbmgXAk5IgQ4H2dkqJVUK08CXinuTM3iujiyp
         CiOAHId8GNcTn1FUm2qYN0lcTnxxouQYkJ+l8R3aIQcSWqg1oREqWre/x2rpmoTrU/CB
         8n7qsK1WcR5le547bfMM/X/PBPOuyEhZhRru5c8ak/3aWXJ5Jc1DM+EY3ArDg7Pejg23
         9I7j0Po8tbyrv3zltV0ucXoD5/QjB0QGG1Q1N4NXU3KHSlaq1u3wF40S463yHQNGLKJE
         Uevgv61mbbO0Fyu6pfMEdMIX6S+bGs+GbW7YZhUW0IbUKH9D+IFbERFs+iITH9yoC3yJ
         fJQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1EJ6y98vuv5SlVnuIquKps9u3qw/nSNS2GPf/mtMuLI=;
        b=jR2JR02cDVC/rsX36AQyA88H+2W5Ydfu6U9lNiNad+tu6L6ub25m5/wSF5ZVLbLMf/
         oeS1Sg6V2+HeKvKuArHRY8CKVtW2poAw/Da307/OosGuXv4KWx5vUu1zMmUqYf0IuYdu
         8iaCxFJey1l+FOG/WJKnWqy2/CaGJxefd5TMWZF8zkRFpmMrL+/L9YxVZ5lfXzOpjtKs
         0vjjYDpPWltRFWv5gQ4bFtgB152je7/VS5KeZXnZh7teZVj32swZV/+BEEbYedhZO7+K
         h6Q5s9Ub753OWq0TP/jmCmci3cHzw3IePKitFIlbah3AYeEb3RNpjwVrs+hFODTCCaNo
         jodA==
X-Gm-Message-State: AOAM530nS9g6DZfW0L5G3MxDJyx5Ti95TRL6shQdKpH0uHyf3pKTkQ72
        3tLEZYtaxcayRDdVsw7YPGdlpA==
X-Google-Smtp-Source: ABdhPJz3Gm9sy5ehzqPBm18E6qs4kz1I9RjiChO+uQmMsvaPmbZfJmic/T5cPusd3kQLDgXljLD5Fw==
X-Received: by 2002:a05:6402:27d1:: with SMTP id c17mr10207638ede.109.1610729602901;
        Fri, 15 Jan 2021 08:53:22 -0800 (PST)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id mb15sm3828795ejb.9.2021.01.15.08.53.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jan 2021 08:53:22 -0800 (PST)
Date:   Fri, 15 Jan 2021 17:53:21 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        jacob.e.keller@intel.com, roopa@nvidia.com, mlxsw@nvidia.com
Subject: Re: [patch net-next RFC 05/10] devlink: add port to line card
 relationship set
Message-ID: <20210115165321.GQ3565223@nanopsycho.orion>
References: <20210113121222.733517-1-jiri@resnulli.us>
 <20210113121222.733517-6-jiri@resnulli.us>
 <20210115161048.GE2064789@shredder.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210115161048.GE2064789@shredder.lan>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Jan 15, 2021 at 05:10:48PM CET, idosch@idosch.org wrote:
>On Wed, Jan 13, 2021 at 01:12:17PM +0100, Jiri Pirko wrote:
>> index ec00cd94c626..cb911b6fdeda 100644
>> --- a/include/net/devlink.h
>> +++ b/include/net/devlink.h
>> @@ -137,6 +137,7 @@ struct devlink_port {
>>  	struct delayed_work type_warn_dw;
>>  	struct list_head reporter_list;
>>  	struct mutex reporters_lock; /* Protects reporter_list */
>> +	struct devlink_linecard *linecard;
>>  };
>>  
>>  struct devlink_linecard_ops;
>> @@ -1438,6 +1439,8 @@ void devlink_port_attrs_pci_pf_set(struct devlink_port *devlink_port, u32 contro
>>  				   u16 pf, bool external);
>>  void devlink_port_attrs_pci_vf_set(struct devlink_port *devlink_port, u32 controller,
>>  				   u16 pf, u16 vf, bool external);
>> +void devlink_port_linecard_set(struct devlink_port *devlink_port,
>> +			       struct devlink_linecard *linecard);
>>  struct devlink_linecard *
>>  devlink_linecard_create(struct devlink *devlink, unsigned int linecard_index,
>>  			const struct devlink_linecard_ops *ops, void *priv);
>> diff --git a/net/core/devlink.c b/net/core/devlink.c
>> index 347976b88404..2faa30cc5cce 100644
>> --- a/net/core/devlink.c
>> +++ b/net/core/devlink.c
>> @@ -855,6 +855,10 @@ static int devlink_nl_port_fill(struct sk_buff *msg, struct devlink *devlink,
>>  		goto nla_put_failure;
>>  	if (devlink_nl_port_function_attrs_put(msg, devlink_port, extack))
>>  		goto nla_put_failure;
>> +	if (devlink_port->linecard &&
>> +	    nla_put_u32(msg, DEVLINK_ATTR_LINECARD_INDEX,
>> +			devlink_port->linecard->index))
>> +		goto nla_put_failure;
>>  
>>  	genlmsg_end(msg, hdr);
>>  	return 0;
>> @@ -8642,6 +8646,21 @@ void devlink_port_attrs_pci_vf_set(struct devlink_port *devlink_port, u32 contro
>>  }
>>  EXPORT_SYMBOL_GPL(devlink_port_attrs_pci_vf_set);
>>  
>> +/**
>> + *	devlink_port_linecard_set - Link port with a linecard
>> + *
>> + *	@devlink_port: devlink port
>> + *	@devlink_linecard: devlink linecard
>> + */
>> +void devlink_port_linecard_set(struct devlink_port *devlink_port,
>> +			       struct devlink_linecard *linecard)
>> +{
>> +	if (WARN_ON(devlink_port->registered))
>> +		return;
>> +	devlink_port->linecard = linecard;
>
>We already have devlink_port_attrs_set() that is called before the port
>is registered, why not extend it to also set the linecard information?

I was thinking about that. Looked odd to put the linecard pointer to the
attr struct. I like it better this way. But if you insist.


>
>> +}
>> +EXPORT_SYMBOL_GPL(devlink_port_linecard_set);
>> +
>>  static int __devlink_port_phys_port_name_get(struct devlink_port *devlink_port,
>>  					     char *name, size_t len)
>>  {
>> @@ -8654,7 +8673,11 @@ static int __devlink_port_phys_port_name_get(struct devlink_port *devlink_port,
>>  	switch (attrs->flavour) {
>>  	case DEVLINK_PORT_FLAVOUR_PHYSICAL:
>>  	case DEVLINK_PORT_FLAVOUR_VIRTUAL:
>> -		n = snprintf(name, len, "p%u", attrs->phys.port_number);
>> +		if (devlink_port->linecard)
>> +			n = snprintf(name, len, "l%u",
>> +				     devlink_port->linecard->index);
>> +		n += snprintf(name + n, len - n, "p%u",
>> +			      attrs->phys.port_number);
>>  		if (attrs->split)
>>  			n += snprintf(name + n, len - n, "s%u",
>>  				      attrs->phys.split_subport_number);
>> -- 
>> 2.26.2
>> 
