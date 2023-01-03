Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41B4E65BB4B
	for <lists+netdev@lfdr.de>; Tue,  3 Jan 2023 08:35:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233007AbjACHfW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Jan 2023 02:35:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231239AbjACHfV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Jan 2023 02:35:21 -0500
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20E85E0A
        for <netdev@vger.kernel.org>; Mon,  2 Jan 2023 23:35:19 -0800 (PST)
Received: by mail-wm1-x330.google.com with SMTP id m3so13142222wmq.0
        for <netdev@vger.kernel.org>; Mon, 02 Jan 2023 23:35:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Kwgl31jogbYQ2xPlSazjh7eu1/XHvL/ZeV7Rv28XYwI=;
        b=HawaxpTorC+IACIqVZ8kfTYeU/amJzS4UPWi8I9bLxuPPBX3h0UvIFTiUnpw1fhdp0
         8LOaEe8I0zW9xwtuPpyUg38KJMZp/K/p3p0cHJtmYkfeYPVx2XVczzgcd80dBYY41tYn
         IZy790ZClQXoINPVm7JF/CRVAE7azYSObJ+cKRYOH0QxpnqjxclN7lJVtXcfub4gWyUk
         q4+ES34k6EuQdaEYDO9ahYVA9yoBHdUMJ1+8DQ36bnxVEIucGiCZ+4jkFci3dVB9Bn4f
         t5ZoOJMyo8x/6jSd49zyiK47b49pbhvM87ggRVzYMcNX9N/Kpa+ATN/g+g37YwNZjAco
         5fuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Kwgl31jogbYQ2xPlSazjh7eu1/XHvL/ZeV7Rv28XYwI=;
        b=elFUcUuUVgEeaQlX51LITgsOOoPR4hmtBq5IZ4tXBQe6p9UpHE7jjDN7XL8gFooqEq
         o+8Qk2fzrm2FvMRqk+9/8ePyB7YS8AXZgNN4bMEBvAssHFk90W5a18bZjUWO4Qv2k8FH
         rH6D5difZ2knfZzinKyIJ5ENbI6nsbGLuewAspuZaJM/qaPjOWTTTXuauaC67LCZq7tp
         MXt7JJ4RuZqUDJPVkDjnaOaY72w2A9Ur3b8xh0ppKuu8cRuVyOvxtsNA9tKrHJUK9G9d
         Jbqzep0xUm7QQ85g1gjFLIurQbNTaCEmTd8TqsPh6Jly198VvZjQz3FQlJMDt7PD6sVw
         gDIQ==
X-Gm-Message-State: AFqh2kpDyywHBLgycXHnRq72d9AOaQ22ZqPQQ/ukz/01+B0yd5fllOwd
        ySgnGPvZocDpVK3arlJTvCF6HQ==
X-Google-Smtp-Source: AMrXdXtb7jmX1Shmt/QpmXwVbtT0pr33dHot4tLzJJmGdcCAbHF5thlIsMSxf0OyL/EJBvts3hFzQQ==
X-Received: by 2002:a05:600c:2e44:b0:3d3:4406:8a3c with SMTP id q4-20020a05600c2e4400b003d344068a3cmr30176857wmf.32.1672731317616;
        Mon, 02 Jan 2023 23:35:17 -0800 (PST)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id k5-20020a05600c080500b003d208eb17ecsm38968468wmp.26.2023.01.02.23.35.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Jan 2023 23:35:17 -0800 (PST)
Date:   Tue, 3 Jan 2023 08:35:16 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     jacob.e.keller@intel.com, leon@kernel.org, netdev@vger.kernel.org
Subject: Re: [RFC net-next 01/10] devlink: bump the instance index directly
 when iterating
Message-ID: <Y7PatJruZVTEz7Pb@nanopsycho>
References: <20221217011953.152487-1-kuba@kernel.org>
 <20221217011953.152487-2-kuba@kernel.org>
 <Y7LbF0+aRjT6AkZ+@nanopsycho>
 <20230102144813.1363cb38@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230102144813.1363cb38@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Jan 02, 2023 at 11:48:13PM CET, kuba@kernel.org wrote:
>On Mon, 2 Jan 2023 14:24:39 +0100 Jiri Pirko wrote:
>> Sat, Dec 17, 2022 at 02:19:44AM CET, kuba@kernel.org wrote:
>> >We use a clever find_first() / find_after() scheme currently,
>> >which works nicely as xarray will write the "current" index
>> >into the variable we pass.
>> >
>> >We can't do the same thing during the "dump walk" because
>> >there we must not increment the index until we're sure
>> >that the instance has been fully dumped.  
>> 
>> To be honest, this "we something" desctiption style makes things quite
>> hard to understand. Could you please rephrase it to actually talk
>> about the entities in code?
>
>Could you be more specific? I'm probably misunderstanding but it sounds
>to me like you're asking me to describe what I'm doing rather than
>the background and motivation.

"We" is us, you me and other people. It is weird to talk about the code
and what there as "we do", "we use" etc. It's quite confusing as the
reader it not able to distinguish if you are talking about code or
people (developers in this case). I'm just askin if it is possible
to make the descriptions easier to understand.


>
>> >diff --git a/net/devlink/devl_internal.h b/net/devlink/devl_internal.h
>> >index 1d7ab11f2f7e..ef0369449592 100644
>> >--- a/net/devlink/devl_internal.h
>> >+++ b/net/devlink/devl_internal.h
>> >@@ -82,18 +82,9 @@ extern struct genl_family devlink_nl_family;
>> >  * in loop body in order to release the reference.
>> >  */
>> > #define devlinks_xa_for_each_registered_get(net, index, devlink)	\
>> >-	for (index = 0,							\
>> >-	     devlink = devlinks_xa_find_get_first(net, &index);	\
>> >-	     devlink; devlink = devlinks_xa_find_get_next(net, &index))
>> >-
>> >-struct devlink *
>> >-devlinks_xa_find_get(struct net *net, unsigned long *indexp,
>> >-		     void * (*xa_find_fn)(struct xarray *, unsigned long *,
>> >-					  unsigned long, xa_mark_t));
>> >-struct devlink *
>> >-devlinks_xa_find_get_first(struct net *net, unsigned long *indexp);
>> >-struct devlink *
>> >-devlinks_xa_find_get_next(struct net *net, unsigned long *indexp);
>> >+	for (index = 0; (devlink = devlinks_xa_find_get(net, &index)); index++)  
>> 
>> You don't need ()' in the 2nd for arg.
>
>Pretty sure I was getting a compiler warning for assignment in 
>a condition....

I see.
