Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A36F965B29B
	for <lists+netdev@lfdr.de>; Mon,  2 Jan 2023 14:24:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232156AbjABNYq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Jan 2023 08:24:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230062AbjABNYp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Jan 2023 08:24:45 -0500
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3FBD6447
        for <netdev@vger.kernel.org>; Mon,  2 Jan 2023 05:24:42 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id bn26so6837702wrb.0
        for <netdev@vger.kernel.org>; Mon, 02 Jan 2023 05:24:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Xh1XDNjtvmSA3i6HqOt7NFNcbFfSGIDZnxTfv3YAe0s=;
        b=Vgveb+i1WybXrYwoWkGQGoHIZ5gdHMs72h49sXa0Nic96V0p5fF2pNM/CFKEO1Xjy2
         4czXAGbH1m2kehIDUB/kdn2k3zMGZEjAhineQYlVmkC5gvHqXr90x2lF7GnUotAeNlQC
         bzaKofMuR4kx5EfowTapss3W2WFhUaqXXCZP/ylME33qup8LY29amGG8lNmYTfRI9I6Y
         7wMFNGUV/fzy6t4nV23LXN5vSORhjwDa8tlTLf/35tQpwsrNzMOmjalNMJb9kHInjzP/
         r0KmEqUD/7x78qziz7U6MgzakHBXB2xDKMFU7v2PdEbLYnxS7gDuU8l7JseCjMzvQB+Y
         PVcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Xh1XDNjtvmSA3i6HqOt7NFNcbFfSGIDZnxTfv3YAe0s=;
        b=AIutb95PBDjcwREYpGaIyiPpt0HvYdMuSnMYDD9YV6P9w10zAV4P7xZGDVqAgnh01p
         Qe3SaNKYTCzW7E68Z5q3J4ZKyRvwDgFJcXxVJepvNG0wwBh+Ilu9IbwQMuxJNsOVTapO
         LSBvxV/KO1y5EuEq0H3Qq5wOmnSucc9vYhmN7v8p68Dts5LkjmiuhjnZh2qGG70K/rmz
         u6NLGlanCA37w6O16hF4WZWOj/di1eYLTdWZCypCIRE5Ug64+KWWsuOOqNwioNViUfCA
         0tAAio4c3SfFTEFk1iTve//Vke8kySFexPoS9rZjcbTVMAOvSE5jpjf+9FQLUyNm0dHc
         NPjw==
X-Gm-Message-State: AFqh2kr+N5sHjsMH89gDQhpIN0hRwPsf73kgyD3t4YNxSD7GLbQUM4kh
        CIMxlWbYvkJRHBFr42Zl1dEXneju/iPh+cBmhusOBg==
X-Google-Smtp-Source: AMrXdXufq2+rq6WjOfoXsgvdammZ0K9NxqanmwXVHCxqYJdoNqu37mwziRBUxtfXWOB2XMg0tZV6Rw==
X-Received: by 2002:adf:f290:0:b0:242:144:90c4 with SMTP id k16-20020adff290000000b00242014490c4mr25867707wro.28.1672665881309;
        Mon, 02 Jan 2023 05:24:41 -0800 (PST)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id o2-20020adfcf02000000b00241d21d4652sm28678677wrj.21.2023.01.02.05.24.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Jan 2023 05:24:40 -0800 (PST)
Date:   Mon, 2 Jan 2023 14:24:39 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     jacob.e.keller@intel.com, leon@kernel.org, netdev@vger.kernel.org
Subject: Re: [RFC net-next 01/10] devlink: bump the instance index directly
 when iterating
Message-ID: <Y7LbF0+aRjT6AkZ+@nanopsycho>
References: <20221217011953.152487-1-kuba@kernel.org>
 <20221217011953.152487-2-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221217011953.152487-2-kuba@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sat, Dec 17, 2022 at 02:19:44AM CET, kuba@kernel.org wrote:
>We use a clever find_first() / find_after() scheme currently,
>which works nicely as xarray will write the "current" index
>into the variable we pass.
>
>We can't do the same thing during the "dump walk" because
>there we must not increment the index until we're sure
>that the instance has been fully dumped.

To be honest, this "we something" desctiption style makes things quite
hard to understand. Could you please rephrase it to actually talk
about the entities in code?


>
>Since we have a precedent and a requirement for manually futzing
>with the increment of the index, let's switch
>devlinks_xa_for_each_registered_get() to do the same thing.
>It removes some indirections.
>
>Signed-off-by: Jakub Kicinski <kuba@kernel.org>
>---
> net/devlink/core.c          | 31 +++++++++----------------------
> net/devlink/devl_internal.h | 17 ++++-------------
> 2 files changed, 13 insertions(+), 35 deletions(-)
>
>diff --git a/net/devlink/core.c b/net/devlink/core.c
>index 371d6821315d..88c88b8053e2 100644
>--- a/net/devlink/core.c
>+++ b/net/devlink/core.c
>@@ -91,16 +91,13 @@ void devlink_put(struct devlink *devlink)
> 		call_rcu(&devlink->rcu, __devlink_put_rcu);
> }
> 
>-struct devlink *
>-devlinks_xa_find_get(struct net *net, unsigned long *indexp,
>-		     void * (*xa_find_fn)(struct xarray *, unsigned long *,
>-					  unsigned long, xa_mark_t))
>+struct devlink *devlinks_xa_find_get(struct net *net, unsigned long *indexp)
> {
>-	struct devlink *devlink;
>+	struct devlink *devlink = NULL;
> 
> 	rcu_read_lock();
> retry:
>-	devlink = xa_find_fn(&devlinks, indexp, ULONG_MAX, DEVLINK_REGISTERED);
>+	devlink = xa_find(&devlinks, indexp, ULONG_MAX, DEVLINK_REGISTERED);
> 	if (!devlink)
> 		goto unlock;
> 
>@@ -109,31 +106,21 @@ devlinks_xa_find_get(struct net *net, unsigned long *indexp,
> 	 * This prevents live-lock of devlink_unregister() wait for completion.
> 	 */
> 	if (xa_get_mark(&devlinks, *indexp, DEVLINK_UNREGISTERING))
>-		goto retry;
>+		goto next;
> 
>-	/* For a possible retry, the xa_find_after() should be always used */
>-	xa_find_fn = xa_find_after;

Hmm. Any idea why xa_find_after()? implementation is different to
xa_find()?


> 	if (!devlink_try_get(devlink))
>-		goto retry;
>+		goto next;
> 	if (!net_eq(devlink_net(devlink), net)) {
> 		devlink_put(devlink);
>-		goto retry;
>+		goto next;
> 	}
> unlock:
> 	rcu_read_unlock();
> 	return devlink;
>-}
>-
>-struct devlink *
>-devlinks_xa_find_get_first(struct net *net, unsigned long *indexp)
>-{
>-	return devlinks_xa_find_get(net, indexp, xa_find);
>-}
> 
>-struct devlink *
>-devlinks_xa_find_get_next(struct net *net, unsigned long *indexp)
>-{
>-	return devlinks_xa_find_get(net, indexp, xa_find_after);
>+next:
>+	(*indexp)++;
>+	goto retry;
> }
> 
> /**
>diff --git a/net/devlink/devl_internal.h b/net/devlink/devl_internal.h
>index 1d7ab11f2f7e..ef0369449592 100644
>--- a/net/devlink/devl_internal.h
>+++ b/net/devlink/devl_internal.h
>@@ -82,18 +82,9 @@ extern struct genl_family devlink_nl_family;
>  * in loop body in order to release the reference.
>  */
> #define devlinks_xa_for_each_registered_get(net, index, devlink)	\
>-	for (index = 0,							\
>-	     devlink = devlinks_xa_find_get_first(net, &index);	\
>-	     devlink; devlink = devlinks_xa_find_get_next(net, &index))
>-
>-struct devlink *
>-devlinks_xa_find_get(struct net *net, unsigned long *indexp,
>-		     void * (*xa_find_fn)(struct xarray *, unsigned long *,
>-					  unsigned long, xa_mark_t));
>-struct devlink *
>-devlinks_xa_find_get_first(struct net *net, unsigned long *indexp);
>-struct devlink *
>-devlinks_xa_find_get_next(struct net *net, unsigned long *indexp);
>+	for (index = 0; (devlink = devlinks_xa_find_get(net, &index)); index++)

You don't need ()' in the 2nd for arg.


>+
>+struct devlink *devlinks_xa_find_get(struct net *net, unsigned long *indexp);
> 
> /* Netlink */
> #define DEVLINK_NL_FLAG_NEED_PORT		BIT(0)
>@@ -133,7 +124,7 @@ struct devlink_gen_cmd {
>  */
> #define devlink_dump_for_each_instance_get(msg, dump, devlink)		\
> 	for (; (devlink = devlinks_xa_find_get(sock_net(msg->sk),	\
>-					       &dump->instance, xa_find)); \
>+					       &dump->instance));	\
> 	     dump->instance++, dump->idx = 0)
> 
> extern const struct genl_small_ops devlink_nl_ops[56];
>-- 
>2.38.1
>
