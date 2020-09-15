Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 792BC26B7EC
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 02:32:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726247AbgIPAcP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 20:32:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726717AbgIONoG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 09:44:06 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3646AC0611C2
        for <netdev@vger.kernel.org>; Tue, 15 Sep 2020 06:34:09 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id y15so3512497wmi.0
        for <netdev@vger.kernel.org>; Tue, 15 Sep 2020 06:34:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=2ko20fCI5B7yynbCHaELcyL95KT/Cjn6cdhfTKOxg+w=;
        b=WFtnZskhHfIidflh3b2fV37hTNbG3leHUk5iaDtD++SpGGekMH9LjZYtYQCDkLg4iD
         ogg/r+QA0jG1avvTAamJ+i+nuFtmkohyPgErkAf4h6d9awX3shb+3gdPWQ/HJyNxd7tK
         X1HYsQCF2N+xVbmpSw2df6EJ7ObfGIEe2mdAHhZ5nVeizccV3hrf2oC/B5PfiKC5IZmF
         qFzd68q9CIXF/PBx3+U633JgIZzsxaBlu8eGyV43dYKxMKWrEtSKzPASoEFfsKOhHf95
         9wyduOprp86tP4UvQh1ekFK/BojHIPjvqn2kF5GNoPPIF9DRjkG9S0UETl1Nf4JIt0NM
         CMKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2ko20fCI5B7yynbCHaELcyL95KT/Cjn6cdhfTKOxg+w=;
        b=nNa7+JApAxKzBK8GHLpDpfDADoK6Z3BBFw9mcSveXRQp6iuhZqZ/NOHMHgi0PFldJq
         O/3DcYApqvxhK3lJw9wPKU9pQ/WVMh3dk23X9iONjm0NJ142SdgkaWZUEmxnhIhgLXzG
         cb+MLTDSduwCUskPrHvWCfw/uoFSliL6WmjrB+za0NWCQk29/5ahDZnO6RtQPbKKUYN7
         KjUkVAmu+G2LCFJHLEPCxbkje64P2s+/7xgTd5INOD3kUijNUon413KnEIRhs1Z2bI57
         7evoafjKYSHkyPdTxoBtp6+dKp42Md77avGZkKY35PwjxC4HPJ016VrnVSnDFo4g57dn
         uEXw==
X-Gm-Message-State: AOAM530a1vmv+3GgxCAkUSjLqo1snDP16zxJJm+EPtb8Rfe4j6buwE9p
        dOhdtOnl7D32dxUSzUWACkXc0IvljB0O4v5l
X-Google-Smtp-Source: ABdhPJx0/zHAvXNWb5HpZZ3ZVdFw3GPx8gsCgorj9lNjYlMftepwyLWkfVfHYNjSI+EIOrFZdY5Dag==
X-Received: by 2002:a1c:20ce:: with SMTP id g197mr2188405wmg.72.1600176847887;
        Tue, 15 Sep 2020 06:34:07 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id u66sm25275316wmg.44.2020.09.15.06.34.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2020 06:34:07 -0700 (PDT)
Date:   Tue, 15 Sep 2020 15:34:06 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Moshe Shemesh <moshe@nvidia.com>
Cc:     Ido Schimmel <idosch@idosch.org>,
        Moshe Shemesh <moshe@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next RFC v4 04/15] devlink: Add reload actions stats
 to dev get
Message-ID: <20200915133406.GQ2236@nanopsycho.orion>
References: <1600063682-17313-1-git-send-email-moshe@mellanox.com>
 <1600063682-17313-5-git-send-email-moshe@mellanox.com>
 <20200914134500.GH2236@nanopsycho.orion>
 <20200915064519.GA5390@shredder>
 <20200915074402.GM2236@nanopsycho.orion>
 <0d6cb0da-761b-b122-f5b1-b82320cfd5c4@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0d6cb0da-761b-b122-f5b1-b82320cfd5c4@nvidia.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Sep 15, 2020 at 02:31:38PM CEST, moshe@nvidia.com wrote:
>
>On 9/15/2020 10:44 AM, Jiri Pirko wrote:
>> Tue, Sep 15, 2020 at 08:45:19AM CEST, idosch@idosch.org wrote:
>> > On Mon, Sep 14, 2020 at 03:45:00PM +0200, Jiri Pirko wrote:
>> > > Mon, Sep 14, 2020 at 08:07:51AM CEST, moshe@mellanox.com wrote:
>> > > > Expose devlink reload actions stats to the user through devlink dev
>> > > > get command.
>> > > > 
>> > > > Examples:
>> > > > $ devlink dev show
>> > > > pci/0000:82:00.0:
>> > > >   reload_action_stats:
>> > > >     driver_reinit 2
>> > > >     fw_activate 1
>> > > >     driver_reinit_no_reset 0
>> > > >     fw_activate_no_reset 0
>> > > > pci/0000:82:00.1:
>> > > >   reload_action_stats:
>> > > >     driver_reinit 1
>> > > >     fw_activate 1
>> > > >     driver_reinit_no_reset 0
>> > > >     fw_activate_no_reset 0
>> > > I would rather have something like:
>> > >     stats:
>> > >       reload_action:
>> > >         driver_reinit 1
>> > >         fw_activate 1
>> > >         driver_reinit_no_reset 0
>> > >         fw_activate_no_reset 0
>> > > 
>> > > Then we can easily extend and add other stats in the tree.
>
>
>Sure, I will add it.

Could you please checkout the metrics patchset and figure out how to
merge that with your usecase?


>
>> > > 
>> > > Also, I wonder if these stats could be somehow merged with Ido's metrics
>> > > work:
>> > > https://github.com/idosch/linux/commits/submit/devlink_metric_rfc_v1
>> > > 
>> > > Ido, would it make sense?
>> > I guess. My original idea for devlink-metric was to expose
>> > design-specific metrics to user space where the entity registering the
>> > metrics is the device driver. In this case the entity would be devlink
>> > itself and it would be auto-registered for each device.
>> Yeah, the usecase is different, but it is still stats, right.
>> 
>> 
>> > > 
>> > > > $ devlink dev show -jp
>> > > > {
>> > > >     "dev": {
>> > > >         "pci/0000:82:00.0": {
>> > > >             "reload_action_stats": [ {
>> > > >                     "driver_reinit": 2
>> > > >                 },{
>> > > >                     "fw_activate": 1
>> > > >                 },{
>> > > >                     "driver_reinit_no_reset": 0
>> > > >                 },{
>> > > >                     "fw_activate_no_reset": 0
>> > > >                 } ]
>> > > >         },
>> > > >         "pci/0000:82:00.1": {
>> > > >             "reload_action_stats": [ {
>> > > >                     "driver_reinit": 1
>> > > >                 },{
>> > > >                     "fw_activate": 1
>> > > >                 },{
>> > > >                     "driver_reinit_no_reset": 0
>> > > >                 },{
>> > > >                     "fw_activate_no_reset": 0
>> > > >                 } ]
>> > > >         }
>> > > >     }
>> > > > }
>> > > > 
>> > > [..]
