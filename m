Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E1CD26BC2C
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 08:08:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726267AbgIPGIF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 02:08:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726100AbgIPGIB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Sep 2020 02:08:01 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79032C061788
        for <netdev@vger.kernel.org>; Tue, 15 Sep 2020 23:07:57 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id a9so1623313wmm.2
        for <netdev@vger.kernel.org>; Tue, 15 Sep 2020 23:07:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=FILX8ZF1rNUuvb2e2fZU8NgwKYYWJqf30ppLCJV+z6w=;
        b=d1VzDd3mYS7pu2QYeKz1zUzCdKc5ZOp1uul/AVh6cszwZDhJ4wMm02nwguzbaxZzfY
         obrtxjKsCZjhfYtI7l1LwtVynNLX4bwSx6PQClhoL1eb+e+CFnnuveVEJH7fb6DqcOQg
         RwEdyfi+ewam84AqUVmS9MXFlmz8B38nkQ1aPScJalZDmRnbPArDO5BVhhlL6ZfYmXuI
         r18K5A2VtrLnmiIcmJNHKt25PE4HPMk+Y0O8LWT24r7j7Q8BXbYJr24BDFY4IbXOfgWe
         Vg4Kc3fZVL/ZVtIvde0K5K1MtDD612OPrFdUuapY8puXwbfvcOVUHZQj2d3o1SWis16f
         unag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=FILX8ZF1rNUuvb2e2fZU8NgwKYYWJqf30ppLCJV+z6w=;
        b=uceuysgCrTPstZ9DL4uxouLKzjAOCCOAZn9g+htq6q1z2oBbRtsWMAxnp2eKf6T7e9
         YTBNDtcKz6NfjEFzgotphSS/cHnawt/5+2JhjAcBw8it00e06V64BhhPJid+07e2oNX3
         Kbxbj4IKF+27ncXOiXnouG6sBhPkNTwu/PMz7Ro5ooZVsyL1jl/ca0yR+0isrqVyr6zp
         JdydweUDlYciYo2lTillqOX/ebCFC0ZnIfpVcOTu8O7gtR2T8rMLMDPyAcEy9Xda9uqt
         aa4O7Vgx1r/gZq9s+0hcE7kcC2KxjWuTEX3NqiVde+1iIO3l6U/+N6EwqgMJAR1ESjNN
         Y2RQ==
X-Gm-Message-State: AOAM532Do/1O4zdrnx9kIAGth+H2tFWRwq7eIaIqM/b9vFauZCPMoI4L
        4h6P61C3m6YQz1BngZl/QX5LQMH8RF8ne29z
X-Google-Smtp-Source: ABdhPJwUVB86ROAps9tp1EUn0uyafRfvbe5vpiWx+yD4iQ0rOCSyGJ5EpgDvgkhiEaHlxi82N5PyEQ==
X-Received: by 2002:a7b:c4c3:: with SMTP id g3mr2835568wmk.128.1600236475870;
        Tue, 15 Sep 2020 23:07:55 -0700 (PDT)
Received: from localhost ([85.163.43.78])
        by smtp.gmail.com with ESMTPSA id b84sm3579923wmd.0.2020.09.15.23.07.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2020 23:07:55 -0700 (PDT)
Date:   Wed, 16 Sep 2020 08:07:54 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Moshe Shemesh <moshe@nvidia.com>
Cc:     Moshe Shemesh <moshe@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next RFC v4 03/15] devlink: Add reload action stats
Message-ID: <20200916060754.GA2278@nanopsycho>
References: <1600063682-17313-1-git-send-email-moshe@mellanox.com>
 <1600063682-17313-4-git-send-email-moshe@mellanox.com>
 <20200914133939.GG2236@nanopsycho.orion>
 <a5b7cbd5-ef55-1d74-a21e-5fb962307773@nvidia.com>
 <20200915133309.GP2236@nanopsycho.orion>
 <3e5869e2-aad7-0d71-12fb-6d14c76864c9@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3e5869e2-aad7-0d71-12fb-6d14c76864c9@nvidia.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Sep 15, 2020 at 10:20:39PM CEST, moshe@nvidia.com wrote:
>
>On 9/15/2020 4:33 PM, Jiri Pirko wrote:
>> Tue, Sep 15, 2020 at 02:30:19PM CEST, moshe@nvidia.com wrote:
>> > On 9/14/2020 4:39 PM, Jiri Pirko wrote:
>> > > Mon, Sep 14, 2020 at 08:07:50AM CEST, moshe@mellanox.com wrote:
>> [..]
>> 
>> 
>> > > > +/**
>> > > > + *	devlink_reload_implicit_actions_performed - Update devlink on reload actions
>> > > > + *	  performed which are not a direct result of devlink reload call.
>> > > > + *
>> > > > + *	This should be called by a driver after performing reload actions in case it was not
>> > > > + *	a result of devlink reload call. For example fw_activate was performed as a result
>> > > > + *	of devlink reload triggered fw_activate on another host.
>> > > > + *	The motivation for this function is to keep data on reload actions performed on this
>> > > > + *	function whether it was done due to direct devlink reload call or not.
>> > > > + *
>> > > > + *	@devlink: devlink
>> > > > + *	@limit_level: reload action limit level
>> > > > + *	@actions_performed: bitmask of actions performed
>> > > > + */
>> > > > +void devlink_reload_implicit_actions_performed(struct devlink *devlink,
>> > > > +					       enum devlink_reload_action_limit_level limit_level,
>> > > > +					       unsigned long actions_performed)
>> > > What I'm a bit scarred of that the driver would call this from withing
>> > > reload_down()/up() ops. Perheps this could be WARN_ON'ed here (or in
>> > > devlink_reload())?
>> > > 
>> > Not sure how I know if it was called from devlink_reload_down()/up() ? Maybe
>> > mutex ? So the warn will be actually mutex deadlock ?
>> No. Don't abuse mutex for this.
>> Just make sure that the counters do not move when you call
>> reload_down/up().
>> 
>
>Can make that, but actually I better take devlink->lock anyway in this
>function to avoid races, WDYT ?

Either you need to protect some data or not. So if you do, do it.


>
>> > > > +{
>> > > > +	if (!devlink_reload_supported(devlink))
>> > > Hmm. I think that the driver does not have to support the reload and can
>> > > still be reloaded by another instance and update the stats here. Why
>> > > not?
>> > > 
>> > But I show counters only for supported reload actions and levels, otherwise
>> > we will have these counters on devlink dev show output for other drivers that
>> > don't have support for devlink reload and didn't implement any of these
>> > including this function and these drivers may do some actions like
>> > fw_activate in another way and don't update the stats and so that will make
>> > these stats misleading. They will show history "stats" but they don't update
>> > them as they didn't apply anything related to devlink reload.
>> The case I tried to point at is the driver instance, that does not
>> implement reload ops itself, but still it can be reloaded by someone else -
>> the other driver instance outside.
>> 
>> The counters should work no matter if the driver implements reload ops
>> or not. Why wouldn't they? The user still likes to know that the devices
>> was reloaded.
>> 
>
>OK, so you say that every driver should show all counters no matter what
>actions it supports and if it supports devlink reload at all, right ?

Well, as I wrote in the other email, I think that there should be 2 sets
of stats for this.


>
>> 
>> > > > +		return;
>> > > > +	devlink_reload_action_stats_update(devlink, limit_level, actions_performed);
>> > > > +}
>> > > > +EXPORT_SYMBOL_GPL(devlink_reload_implicit_actions_performed);
>> > > > +
>> > > > static int devlink_reload(struct devlink *devlink, struct net *dest_net,
>> > > > 			  enum devlink_reload_action action,
>> > > > 			  enum devlink_reload_action_limit_level limit_level,
>> > > > -			  struct netlink_ext_ack *extack, unsigned long *actions_performed)
>> > > > +			  struct netlink_ext_ack *extack, unsigned long *actions_performed_out)
>> > > > {
>> > > > +	unsigned long actions_performed;
>> > > > 	int err;
>> > > > 
>> > > > 	if (!devlink->reload_enabled)
>> > > > @@ -2998,9 +3045,14 @@ static int devlink_reload(struct devlink *devlink, struct net *dest_net,
>> > > > 	if (dest_net && !net_eq(dest_net, devlink_net(devlink)))
>> > > > 		devlink_reload_netns_change(devlink, dest_net);
>> > > > 
>> > > > -	err = devlink->ops->reload_up(devlink, action, limit_level, extack, actions_performed);
>> > > > +	err = devlink->ops->reload_up(devlink, action, limit_level, extack, &actions_performed);
>> > > > 	devlink_reload_failed_set(devlink, !!err);
>> > > > -	return err;
>> > > > +	if (err)
>> > > > +		return err;
>> > > > +	devlink_reload_action_stats_update(devlink, limit_level, actions_performed);
>> > > > +	if (actions_performed_out)
>> > > Just make the caller to provide valid pointer, as I suggested in the
>> > > other patch review.
>> > 
>> > Ack.
>> > 
>> > > > +		*actions_performed_out = actions_performed;
>> > > > +	return 0;
>> > > > }
>> > > > 
>> > > > static int
>> > > > -- 
>> > > > 2.17.1
>> > > > 
