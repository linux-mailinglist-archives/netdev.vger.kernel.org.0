Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1FA741930E4
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 20:08:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727703AbgCYTI0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 15:08:26 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:38726 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727444AbgCYTI0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 15:08:26 -0400
Received: by mail-wr1-f65.google.com with SMTP id s1so4659512wrv.5
        for <netdev@vger.kernel.org>; Wed, 25 Mar 2020 12:08:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=5NU31ryC8JYjzKC8jkg/FshTU/Ikpr4DJ0B+Hq8FD5I=;
        b=d16DunXoeeQN9nGoLyiYZQ1PNm7c7if2+LQXEkBqyW+fnLw/2n8RTNbynPndNvcgOK
         EJHH9qur6btujPEXi9PyTmXSaDYpNcjoQgAqB/nuV5sGmyRTapqUC/hY3e5dyoINOBnc
         xTFohUV2vMf3m1K1xa3P3+g0nTvxLiJ5xr//BiWh2Twz1KKocwHvXY/OJFvY3JbsVjI1
         0SQJgssZIraCfMcxqjo+27dqy1wg7TOsnnIuA+YD7QAMVMdOgL48ZjvBlAlfs9beHuah
         H7n1qAQ336Yo7xR58En5ZzbUo5+246ja/7AW2bSVxH9Y2fkNyeN3oVmA9eUUlMq6g6Yi
         cXRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=5NU31ryC8JYjzKC8jkg/FshTU/Ikpr4DJ0B+Hq8FD5I=;
        b=ADpY2uGq4Wu0zRRBa9uhfuwDiSLmn9gvbVB8er/ceXwYtv9zK9s8QBC67tCXwD3Sgg
         SGpFo45hT/WJhIjikT3EXn8cXDLZ6czPgn688PWlPBAdPukUNFq+/+9pQ2/jVzxlI7/s
         O2DavUk7bdpfo+72BLCNVkhRpqBCj4GNPE8CkwKJg2nKpRrO7yUceSYcFFvMU5c73hTT
         LSpevdhLxHVd5xFlqLLvAZIEYig1YIqOxNJegewp9XGwjr98pW4yGnqr/uL/lNe34kku
         AOywvaVZD8ft+eBklZzBLcNmKOP3S2Fm0vKOWitJKgzxY4OKDd7nijr06WrqXuSguxHj
         ytrA==
X-Gm-Message-State: ANhLgQ2EHKgXTPGr9/t5DJLa7I6hWX0CeZ9w9O8jnErErDRSaS4zUYIW
        vGUsKkPQ129b9pdFBnJn0t/AYxOa1Gc=
X-Google-Smtp-Source: ADFU+vuAe31lJtHbOof3mpKJ5jNa7ubhlxVzfXxUYpta1h9wsaz9ejiyNDkNFy7i/yAz/7qYGhDdWw==
X-Received: by 2002:a5d:4705:: with SMTP id y5mr5168117wrq.288.1585163302961;
        Wed, 25 Mar 2020 12:08:22 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id e1sm36056350wrx.90.2020.03.25.12.08.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Mar 2020 12:08:22 -0700 (PDT)
Date:   Wed, 25 Mar 2020 20:08:21 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Eran Ben Elisha <eranbe@mellanox.com>, netdev@vger.kernel.org,
        Jiri Pirko <jiri@mellanox.com>,
        Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: Re: [PATCH net-next 2/2] devlink: Add auto dump flag to health
 reporter
Message-ID: <20200325190821.GE11304@nanopsycho.orion>
References: <1585142784-10517-1-git-send-email-eranbe@mellanox.com>
 <1585142784-10517-3-git-send-email-eranbe@mellanox.com>
 <20200325114529.3f4179c1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200325114529.3f4179c1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Mar 25, 2020 at 07:45:29PM CET, kuba@kernel.org wrote:
>On Wed, 25 Mar 2020 15:26:24 +0200 Eran Ben Elisha wrote:
>> On low memory system, run time dumps can consume too much memory. Add
>> administrator ability to disable auto dumps per reporter as part of the
>> error flow handle routine.
>> 
>> This attribute is not relevant while executing
>> DEVLINK_CMD_HEALTH_REPORTER_DUMP_GET.
>> 
>> By default, auto dump is activated for any reporter that has a dump method,
>> as part of the reporter registration to devlink.
>> 
>> Signed-off-by: Eran Ben Elisha <eranbe@mellanox.com>
>> Reviewed-by: Jiri Pirko <jiri@mellanox.com>
>> ---
>>  include/uapi/linux/devlink.h |  2 ++
>>  net/core/devlink.c           | 26 ++++++++++++++++++++++----
>>  2 files changed, 24 insertions(+), 4 deletions(-)
>> 
>> diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
>> index dfdffc42e87d..e7891d1d2ebd 100644
>> --- a/include/uapi/linux/devlink.h
>> +++ b/include/uapi/linux/devlink.h
>> @@ -429,6 +429,8 @@ enum devlink_attr {
>>  	DEVLINK_ATTR_NETNS_FD,			/* u32 */
>>  	DEVLINK_ATTR_NETNS_PID,			/* u32 */
>>  	DEVLINK_ATTR_NETNS_ID,			/* u32 */
>> +
>> +	DEVLINK_ATTR_HEALTH_REPORTER_AUTO_DUMP,	/* u8 */
>>  	/* add new attributes above here, update the policy in devlink.c */
>>  
>>  	__DEVLINK_ATTR_MAX,
>> diff --git a/net/core/devlink.c b/net/core/devlink.c
>> index ad69379747ef..e14bf3052289 100644
>> --- a/net/core/devlink.c
>> +++ b/net/core/devlink.c
>> @@ -4837,6 +4837,7 @@ struct devlink_health_reporter {
>>  	struct mutex dump_lock; /* lock parallel read/write from dump buffers */
>>  	u64 graceful_period;
>>  	bool auto_recover;
>> +	bool auto_dump;
>>  	u8 health_state;
>>  	u64 dump_ts;
>>  	u64 dump_real_ts;
>> @@ -4903,6 +4904,7 @@ devlink_health_reporter_create(struct devlink *devlink,
>>  	reporter->devlink = devlink;
>>  	reporter->graceful_period = graceful_period;
>>  	reporter->auto_recover = !!ops->recover;
>> +	reporter->auto_dump = !!ops->dump;
>>  	mutex_init(&reporter->dump_lock);
>>  	refcount_set(&reporter->refcount, 1);
>>  	list_add_tail(&reporter->list, &devlink->reporter_list);
>> @@ -4983,6 +4985,10 @@ devlink_nl_health_reporter_fill(struct sk_buff *msg,
>>  	    nla_put_u64_64bit(msg, DEVLINK_ATTR_HEALTH_REPORTER_DUMP_TS_NS,
>>  			      reporter->dump_real_ts, DEVLINK_ATTR_PAD))
>>  		goto reporter_nest_cancel;
>> +	if (reporter->ops->dump &&
>> +	    nla_put_u8(msg, DEVLINK_ATTR_HEALTH_REPORTER_AUTO_DUMP,
>> +		       reporter->auto_dump))
>> +		goto reporter_nest_cancel;
>
>Since you're making it a u8 - does it make sense to indicate to user

Please don't be mistaken. u8 carries a bool here.


>space whether the dump is disabled or not supported?

If you want to expose "not supported", I suggest to do it in another
attr. Because this attr is here to do the config from userspace. Would
be off if the same enum would carry "not supported".

But anyway, since you opened this can, the supported/capabilities
should be probably passed by a separate bitfield for all features.


>
>Right now no attribute means either old kernel or dump not possible..
>
>>  	nla_nest_end(msg, reporter_attr);
>>  	genlmsg_end(msg, hdr);
>> @@ -5129,10 +5135,12 @@ int devlink_health_report(struct devlink_health_reporter *reporter,
>>  
>>  	reporter->health_state = DEVLINK_HEALTH_REPORTER_STATE_ERROR;
>>  
>> -	mutex_lock(&reporter->dump_lock);
>> -	/* store current dump of current error, for later analysis */
>> -	devlink_health_do_dump(reporter, priv_ctx, NULL);
>> -	mutex_unlock(&reporter->dump_lock);
>> +	if (reporter->auto_dump) {
>> +		mutex_lock(&reporter->dump_lock);
>> +		/* store current dump of current error, for later analysis */
>> +		devlink_health_do_dump(reporter, priv_ctx, NULL);
>> +		mutex_unlock(&reporter->dump_lock);
>> +	}
>>  
>>  	if (reporter->auto_recover)
>>  		return devlink_health_reporter_recover(reporter,
>> @@ -5306,6 +5314,11 @@ devlink_nl_cmd_health_reporter_set_doit(struct sk_buff *skb,
>>  		err = -EOPNOTSUPP;
>>  		goto out;
>>  	}
>> +	if (!reporter->ops->dump &&
>> +	    info->attrs[DEVLINK_ATTR_HEALTH_REPORTER_AUTO_DUMP]) {
>
>... and then this behavior may have to change, I think?
>
>> +		err = -EOPNOTSUPP;
>> +		goto out;
>> +	}
>>  
>>  	if (info->attrs[DEVLINK_ATTR_HEALTH_REPORTER_GRACEFUL_PERIOD])
>>  		reporter->graceful_period =
>> @@ -5315,6 +5328,10 @@ devlink_nl_cmd_health_reporter_set_doit(struct sk_buff *skb,
>>  		reporter->auto_recover =
>>  			nla_get_u8(info->attrs[DEVLINK_ATTR_HEALTH_REPORTER_AUTO_RECOVER]);
>>  
>> +	if (info->attrs[DEVLINK_ATTR_HEALTH_REPORTER_AUTO_DUMP])
>> +		reporter->auto_dump =
>> +		nla_get_u8(info->attrs[DEVLINK_ATTR_HEALTH_REPORTER_AUTO_DUMP]);
>> +
>>  	devlink_health_reporter_put(reporter);
>>  	return 0;
>>  out:
>> @@ -6053,6 +6070,7 @@ static const struct nla_policy devlink_nl_policy[DEVLINK_ATTR_MAX + 1] = {
>>  	[DEVLINK_ATTR_HEALTH_REPORTER_NAME] = { .type = NLA_NUL_STRING },
>>  	[DEVLINK_ATTR_HEALTH_REPORTER_GRACEFUL_PERIOD] = { .type = NLA_U64 },
>>  	[DEVLINK_ATTR_HEALTH_REPORTER_AUTO_RECOVER] = { .type = NLA_U8 },
>> +	[DEVLINK_ATTR_HEALTH_REPORTER_AUTO_DUMP] = { .type = NLA_U8 },
>
>I'd suggest we keep the attrs in order of definition, because we should
>set .strict_start_type, and then it matters which are before and which
>are after.
>
>Also please set max value of 1.
>
>>  	[DEVLINK_ATTR_FLASH_UPDATE_FILE_NAME] = { .type = NLA_NUL_STRING },
>>  	[DEVLINK_ATTR_FLASH_UPDATE_COMPONENT] = { .type = NLA_NUL_STRING },
>>  	[DEVLINK_ATTR_TRAP_NAME] = { .type = NLA_NUL_STRING },
>
