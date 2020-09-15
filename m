Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C43826B7E9
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 02:32:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726795AbgIPAbz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 20:31:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726722AbgIONoa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 09:44:30 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12574C0611C0
        for <netdev@vger.kernel.org>; Tue, 15 Sep 2020 06:33:12 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id z9so3503163wmk.1
        for <netdev@vger.kernel.org>; Tue, 15 Sep 2020 06:33:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=hzZUY6CzToqBP67sQ2Eg3vFtmd/tMofW6+beTEUER7c=;
        b=ApkNpCciOAKKyfaftQveS7q+/ZQq6pyHPB7v7pNLGKIZR74KS+b1NJjOPyNRK9+Lwl
         QsopcajViP1UTRhKo5wdkv7k0rmkMAcqExdskjTq0CAv32qka0Yi3v8JFlLWT+NI02UB
         dpUmvJLlDbS8W4Uh67iuQxWP7xOzRvAQ61t6dIMwslJ4QshFQWyMzPgGnoENMS4mTdrb
         wTmL4jMZ4uz3nMLOd22ZXNmjmvYi8wszy5VrAttSHn39fdGqeJg1apZN7hZKys8C18O5
         jvOYRZWKKgtWEyeffn3L5WAtJZ/ENM99O6cuWPP3k4zlakhGJ6UUY09aDLCbSygEjqtL
         a6Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=hzZUY6CzToqBP67sQ2Eg3vFtmd/tMofW6+beTEUER7c=;
        b=LPjh0wle1973r9kuOVLYMz4x7SF3B14RalrnWlQjHhY2Ji1rtFsO0Rmh/Ubtxm3bXE
         80JmGuWVB4ug8Teqxhb/KLkUcFCsPkDtZtKCV/74jh+9VMrJboVx+jSqKsaz5SsLVmzt
         Ar/auGGtCTRXsdLycQRDCESh4bVIiaCHwBA1QfhlZc0zZr+sT+LmgA+YYhH9t/ooTDik
         adKTgJeiiGTP5J2n7lwYDG8ZRlokN1Xt+LE3OBLR3CraN5k5iYP7Tn6vluEnlaWEI2YJ
         Sky5IsssrQNmoth87iF2ynRTtpIMEtKiARJ7mz50AK3BfmGebBYC7Qxc00/CVLSK2Wxl
         3KMg==
X-Gm-Message-State: AOAM532Dsn4+shqlobFjPn2W86eZPw40laaDEWrkdW9e2UBlQZ4iXx1I
        uyS7VQXVvZbp1qnNsO2lzm8kmg==
X-Google-Smtp-Source: ABdhPJwKIkraQzTjlFbY2Afo3K6JNJUm2UD3bjsCgU+mxVYvkIiOP2RbJSQjaDkc5Li/EARQL2g/GA==
X-Received: by 2002:a1c:e0d4:: with SMTP id x203mr5113109wmg.91.1600176790703;
        Tue, 15 Sep 2020 06:33:10 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id a11sm23856074wmm.18.2020.09.15.06.33.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2020 06:33:10 -0700 (PDT)
Date:   Tue, 15 Sep 2020 15:33:09 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Moshe Shemesh <moshe@nvidia.com>
Cc:     Moshe Shemesh <moshe@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next RFC v4 03/15] devlink: Add reload action stats
Message-ID: <20200915133309.GP2236@nanopsycho.orion>
References: <1600063682-17313-1-git-send-email-moshe@mellanox.com>
 <1600063682-17313-4-git-send-email-moshe@mellanox.com>
 <20200914133939.GG2236@nanopsycho.orion>
 <a5b7cbd5-ef55-1d74-a21e-5fb962307773@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a5b7cbd5-ef55-1d74-a21e-5fb962307773@nvidia.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Sep 15, 2020 at 02:30:19PM CEST, moshe@nvidia.com wrote:
>
>On 9/14/2020 4:39 PM, Jiri Pirko wrote:
>> Mon, Sep 14, 2020 at 08:07:50AM CEST, moshe@mellanox.com wrote:

[..]


>> > +/**
>> > + *	devlink_reload_implicit_actions_performed - Update devlink on reload actions
>> > + *	  performed which are not a direct result of devlink reload call.
>> > + *
>> > + *	This should be called by a driver after performing reload actions in case it was not
>> > + *	a result of devlink reload call. For example fw_activate was performed as a result
>> > + *	of devlink reload triggered fw_activate on another host.
>> > + *	The motivation for this function is to keep data on reload actions performed on this
>> > + *	function whether it was done due to direct devlink reload call or not.
>> > + *
>> > + *	@devlink: devlink
>> > + *	@limit_level: reload action limit level
>> > + *	@actions_performed: bitmask of actions performed
>> > + */
>> > +void devlink_reload_implicit_actions_performed(struct devlink *devlink,
>> > +					       enum devlink_reload_action_limit_level limit_level,
>> > +					       unsigned long actions_performed)
>> What I'm a bit scarred of that the driver would call this from withing
>> reload_down()/up() ops. Perheps this could be WARN_ON'ed here (or in
>> devlink_reload())?
>> 
>
>Not sure how I know if it was called from devlink_reload_down()/up() ? Maybe
>mutex ? So the warn will be actually mutex deadlock ?

No. Don't abuse mutex for this.
Just make sure that the counters do not move when you call
reload_down/up().


>
>> > +{
>> > +	if (!devlink_reload_supported(devlink))
>> Hmm. I think that the driver does not have to support the reload and can
>> still be reloaded by another instance and update the stats here. Why
>> not?
>> 
>
>But I show counters only for supported reload actions and levels, otherwise
>we will have these counters on devlink dev show output for other drivers that
>don't have support for devlink reload and didn't implement any of these
>including this function and these drivers may do some actions like
>fw_activate in another way and don't update the stats and so that will make
>these stats misleading. They will show history "stats" but they don't update
>them as they didn't apply anything related to devlink reload.

The case I tried to point at is the driver instance, that does not
implement reload ops itself, but still it can be reloaded by someone else -
the other driver instance outside.

The counters should work no matter if the driver implements reload ops
or not. Why wouldn't they? The user still likes to know that the devices
was reloaded.



>
>> > +		return;
>> > +	devlink_reload_action_stats_update(devlink, limit_level, actions_performed);
>> > +}
>> > +EXPORT_SYMBOL_GPL(devlink_reload_implicit_actions_performed);
>> > +
>> > static int devlink_reload(struct devlink *devlink, struct net *dest_net,
>> > 			  enum devlink_reload_action action,
>> > 			  enum devlink_reload_action_limit_level limit_level,
>> > -			  struct netlink_ext_ack *extack, unsigned long *actions_performed)
>> > +			  struct netlink_ext_ack *extack, unsigned long *actions_performed_out)
>> > {
>> > +	unsigned long actions_performed;
>> > 	int err;
>> > 
>> > 	if (!devlink->reload_enabled)
>> > @@ -2998,9 +3045,14 @@ static int devlink_reload(struct devlink *devlink, struct net *dest_net,
>> > 	if (dest_net && !net_eq(dest_net, devlink_net(devlink)))
>> > 		devlink_reload_netns_change(devlink, dest_net);
>> > 
>> > -	err = devlink->ops->reload_up(devlink, action, limit_level, extack, actions_performed);
>> > +	err = devlink->ops->reload_up(devlink, action, limit_level, extack, &actions_performed);
>> > 	devlink_reload_failed_set(devlink, !!err);
>> > -	return err;
>> > +	if (err)
>> > +		return err;
>> > +	devlink_reload_action_stats_update(devlink, limit_level, actions_performed);
>> > +	if (actions_performed_out)
>> Just make the caller to provide valid pointer, as I suggested in the
>> other patch review.
>
>
>Ack.
>
>> 
>> > +		*actions_performed_out = actions_performed;
>> > +	return 0;
>> > }
>> > 
>> > static int
>> > -- 
>> > 2.17.1
>> > 
