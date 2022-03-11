Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DD244D660A
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 17:24:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345668AbiCKQZ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 11:25:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243994AbiCKQZ2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 11:25:28 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EBD1106137
        for <netdev@vger.kernel.org>; Fri, 11 Mar 2022 08:24:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id D70A3CE295C
        for <netdev@vger.kernel.org>; Fri, 11 Mar 2022 16:24:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F6EAC340E9;
        Fri, 11 Mar 2022 16:24:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647015861;
        bh=lfY+Z5ibDvi60FNkyvHNFI02dXfEEa3+le4R6LqyRbA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JCqIWCfmHs8ksUOUxvZOgFYVr5fgRVlu1wroXXfM1/KACx1wP/BCV9Ua/dKHi3QE3
         blH4OHjZW3V8Erb2k0NCQqXIRvh3wRrF2Icyv7PwHG0zQS4JqsSyR1muyCy714GHcN
         rVIecfaDyr6Gpd3arheJXHv5acbJfBqMNnYtiCu8XK8wOLb1fNgpZV16ulmnl+9vAr
         xwdc+CQuSKJFxgPKMrS3VKK7c5/NsEcrFFSxeYTy3pLrm28y/4EsnP8c+23b9h61Fs
         7ElByCUWhXoMgR5ubJIe6oZRjcDZzFSHdgE541MYyuze5VaZFIwNswGGIHsrod7Lul
         7nROyTbxpfVAA==
Date:   Fri, 11 Mar 2022 18:24:16 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
Cc:     Leon Romanovsky <leon@ikernel.org>,
        Tony Nguyen <anthony.l.nguyen@intel.com>, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        sudheer.mogilappagari@intel.com, amritha.nambiar@intel.com,
        jiri@nvidia.com
Subject: Re: [PATCH net-next 0/2][pull request] 10GbE Intel Wired LAN Driver
 Updates 2022-03-10
Message-ID: <Yit3sLq6b+ZNZ07j@unreal>
References: <20220310231235.2721368-1-anthony.l.nguyen@intel.com>
 <YirRQWT7dtTV4fwG@unreal>
 <0e672d96-5b68-4445-482f-1fc4c55e8f45@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0e672d96-5b68-4445-482f-1fc4c55e8f45@intel.com>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 11, 2022 at 09:19:23AM -0600, Samudrala, Sridhar wrote:
> On 3/10/2022 10:34 PM, Leon Romanovsky wrote:
> > On Thu, Mar 10, 2022 at 03:12:33PM -0800, Tony Nguyen wrote:
> > > Sudheer Mogilappagari says:
> > > 
> > > Add support to enable inline flow director which allows uniform
> > > distribution of flows among queues of a TC. This is configured
> > > on a per TC basis using devlink interface.
> > > 
> > > Devlink params are registered/unregistered during TC creation
> > > at runtime. To allow that commit 7a690ad499e7 ("devlink: Clean
> > > not-executed param notifications") needs to be reverted.
> > > 
> > > The following are changes since commit 3126b731ceb168b3a780427873c417f2abdd5527:
> > >    net: dsa: tag_rtl8_4: fix typo in modalias name
> > > and are available in the git repository at:
> > >    git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue 10GbE
> > > 
> > > Kiran Patil (1):
> > >    ice: Add inline flow director support for channels
> > > 
> > > Sridhar Samudrala (1):
> > >    devlink: Allow parameter registration/unregistration during runtime
> > Sorry, NO to whole series.
> > 
> > I don't see any explanation why it is good idea and must-to-be
> > implemented one to configure global TC parameter during runtime.
> 
> This parameter is applicable only after splitting the netdevice queues into
> queue groups(TCs) via tc mqprio command.
> The queue groups can be created/destroyed during runtime.
> So the patch is trying to register/unregister this parameter when TCs are
> created and destroyed.
> 
> > 
> > You created TC with special tool, you should use that tool to configure
> > TC and not devlink. Devlink parameters can be seen as better replacement
> > of module parameters, which are global by nature. It means that this
> > tc_inline_fd can be configured without relation if TC was created or
> > not.
> 
> Extending tc qdisc mqprio to add this parameter is an option we could explore.
> Not sure if it allows changing parameters without reloading the qdisc.

It was one of the options. I don't mind if it is going to be in devlink
or TC, as long as devlink_params_register() is not changed to be dynamic.

> 
> > 
> > I didn't look too deeply in revert patch, but from glance view it
> > is not correct too as it doesn't have any protection from users
> > who will try to configure params during devlink_params_unregister().
> 
> Is there any limitation that devlink params can be registered only during
> probe time?

Yes, we don't want races between userspace that tries to access devlink
parameters and kernel code that adds/deletes them.

> Would it be OK if we register this parameter during probe time, but allow
> changing it only after TCs are created?

Of course, this is exactly how it is supposed to be.
For an example, see commit e890acd5ff18 ("net/mlx5: Add devlink flow_steering_mode parameter")

In your case, you will have some sort of "if (!tc_configured) ..." line
that will prevent to set this parameter.

Thanks

> 
> -Sridhar
> 
