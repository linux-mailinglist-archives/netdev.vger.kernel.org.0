Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8477D193CEC
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 11:22:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727773AbgCZKWs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 06:22:48 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:44600 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726292AbgCZKWs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 06:22:48 -0400
Received: by mail-wr1-f66.google.com with SMTP id m17so6983246wrw.11
        for <netdev@vger.kernel.org>; Thu, 26 Mar 2020 03:22:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=8uJQeUSe4cm50sj8y7jllInBOUpocv8VDHTw6VGNX7I=;
        b=wXGCX8yYd4onYfKXb6+C+2P7gZV1Era2LAtDeMerJSrQjdBWAF0qUn3DPe0/HIWnqR
         mKNLECfdqkVwoZs3mpuHXxKfAFfO9YWp4xGbz7S+93bEHCuhQ9mlr2wAPUXa9MwNHRXe
         hqf+hxQbV24entHhMPWe7EX2EQBfRIxKv5UQhl13ZIljv552SnTAInImKXNmdfBHkdaV
         8TRmuRrlQwma9gIzIy8HmrIkMdGWTLO2HjTZXXxUYcmY2wniYGOhPlZ9LexQbd4H4R01
         4YKacbqJz/Q0g41OgykHgt1wyZvsX3Jqk9dw1gUh5HWRM5JXOxMiMSpq5Kx0GU2g+KsH
         xs2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=8uJQeUSe4cm50sj8y7jllInBOUpocv8VDHTw6VGNX7I=;
        b=G4qredGwo61Uz0IaFIUinMLPjbwQkq7YRjwKGF5BDWLRc2nlTqnAk1BB+xkMMJ21qO
         oguWEkw6BaC0NRU0qtPsgMto7TaNk4PgkFTv+AVwsuAq647MoBxpDspvIV1XkzXQ2rip
         z59m2IDvMAW0kK8IO277MhcxXQ7pAqWgnYUTCtrNGcGmX+nbfFvXos3NFDUtV6YMp3KL
         cqKpjCFufjASN/v7u9tzR0lj6fgZIi5UPtiS8UEOic89fm6NIA+W1/RaRLGZuZhRX10Y
         uNhZZfalTK2jcTZ+TcAbcI3mbsNFE9pVBv6zi7T7GhdIfmGCfqW6Zs/yk2dmZi15oGCh
         dGQA==
X-Gm-Message-State: ANhLgQ3DuSShcuELhzQEKrg+G7EmREeY3ygC6TeaDNbAhkGJyyI8Mj4v
        sF2DJvWNHr6wUlETYFKg9iE2Rw==
X-Google-Smtp-Source: ADFU+vvAHxowut+0h7uyz4l5eb3OEEpiS5urdFI+ewa6t6Gjho9EvUd3NrAWdGF4yJ2AuYB2Ywj/yw==
X-Received: by 2002:adf:e345:: with SMTP id n5mr9020450wrj.220.1585218165916;
        Thu, 26 Mar 2020 03:22:45 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id u17sm2569043wri.45.2020.03.26.03.22.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Mar 2020 03:22:44 -0700 (PDT)
Date:   Thu, 26 Mar 2020 11:22:44 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Eran Ben Elisha <eranbe@mellanox.com>, netdev@vger.kernel.org,
        Jiri Pirko <jiri@mellanox.com>,
        Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: Re: [PATCH net-next 2/2] devlink: Add auto dump flag to health
 reporter
Message-ID: <20200326102244.GT11304@nanopsycho.orion>
References: <1585142784-10517-1-git-send-email-eranbe@mellanox.com>
 <1585142784-10517-3-git-send-email-eranbe@mellanox.com>
 <20200325114529.3f4179c1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200325190821.GE11304@nanopsycho.orion>
 <f947cfe1-1ec3-7bb5-90dc-3bea61b71cf3@mellanox.com>
 <20200325170135.28587e4a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200325170135.28587e4a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Mar 26, 2020 at 01:01:35AM CET, kuba@kernel.org wrote:
>On Wed, 25 Mar 2020 21:38:35 +0200 Eran Ben Elisha wrote:
>> On 3/25/2020 9:08 PM, Jiri Pirko wrote:
>> > Wed, Mar 25, 2020 at 07:45:29PM CET, kuba@kernel.org wrote:  
>> >> On Wed, 25 Mar 2020 15:26:24 +0200 Eran Ben Elisha wrote:  
>> >>> On low memory system, run time dumps can consume too much memory. Add
>> >>> administrator ability to disable auto dumps per reporter as part of the
>> >>> error flow handle routine.
>> >>>
>> >>> This attribute is not relevant while executing
>> >>> DEVLINK_CMD_HEALTH_REPORTER_DUMP_GET.
>> >>>
>> >>> By default, auto dump is activated for any reporter that has a dump method,
>> >>> as part of the reporter registration to devlink.
>> >>>
>> >>> Signed-off-by: Eran Ben Elisha <eranbe@mellanox.com>
>> >>> Reviewed-by: Jiri Pirko <jiri@mellanox.com>
>> >>> ---
>> >>>   include/uapi/linux/devlink.h |  2 ++
>> >>>   net/core/devlink.c           | 26 ++++++++++++++++++++++----
>> >>>   2 files changed, 24 insertions(+), 4 deletions(-)
>> >>>
>> >>> diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
>> >>> index dfdffc42e87d..e7891d1d2ebd 100644
>> >>> --- a/include/uapi/linux/devlink.h
>> >>> +++ b/include/uapi/linux/devlink.h
>> >>> @@ -429,6 +429,8 @@ enum devlink_attr {
>> >>>   	DEVLINK_ATTR_NETNS_FD,			/* u32 */
>> >>>   	DEVLINK_ATTR_NETNS_PID,			/* u32 */
>> >>>   	DEVLINK_ATTR_NETNS_ID,			/* u32 */
>> >>> +
>> >>> +	DEVLINK_ATTR_HEALTH_REPORTER_AUTO_DUMP,	/* u8 */
>> >>>   	/* add new attributes above here, update the policy in devlink.c */
>> >>>   
>> >>>   	__DEVLINK_ATTR_MAX,
>> >>> diff --git a/net/core/devlink.c b/net/core/devlink.c
>> >>> index ad69379747ef..e14bf3052289 100644
>> >>> --- a/net/core/devlink.c
>> >>> +++ b/net/core/devlink.c
>> >>> @@ -4837,6 +4837,7 @@ struct devlink_health_reporter {
>> >>>   	struct mutex dump_lock; /* lock parallel read/write from dump buffers */
>> >>>   	u64 graceful_period;
>> >>>   	bool auto_recover;
>> >>> +	bool auto_dump;
>> >>>   	u8 health_state;
>> >>>   	u64 dump_ts;
>> >>>   	u64 dump_real_ts;
>> >>> @@ -4903,6 +4904,7 @@ devlink_health_reporter_create(struct devlink *devlink,
>> >>>   	reporter->devlink = devlink;
>> >>>   	reporter->graceful_period = graceful_period;
>> >>>   	reporter->auto_recover = !!ops->recover;
>> >>> +	reporter->auto_dump = !!ops->dump;
>> >>>   	mutex_init(&reporter->dump_lock);
>> >>>   	refcount_set(&reporter->refcount, 1);
>> >>>   	list_add_tail(&reporter->list, &devlink->reporter_list);
>> >>> @@ -4983,6 +4985,10 @@ devlink_nl_health_reporter_fill(struct sk_buff *msg,
>> >>>   	    nla_put_u64_64bit(msg, DEVLINK_ATTR_HEALTH_REPORTER_DUMP_TS_NS,
>> >>>   			      reporter->dump_real_ts, DEVLINK_ATTR_PAD))
>> >>>   		goto reporter_nest_cancel;
>> >>> +	if (reporter->ops->dump &&
>> >>> +	    nla_put_u8(msg, DEVLINK_ATTR_HEALTH_REPORTER_AUTO_DUMP,
>> >>> +		       reporter->auto_dump))
>> >>> +		goto reporter_nest_cancel;  
>> >>
>> >> Since you're making it a u8 - does it make sense to indicate to user  
>> > 
>> > Please don't be mistaken. u8 carries a bool here.
>
>Are you okay with limiting the value in the policy?

Well, not-0 means true. Do you think it is wise to limit to 0/1?

[...]
