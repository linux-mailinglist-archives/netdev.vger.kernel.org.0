Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C166D24A2AD
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 17:19:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728741AbgHSPTF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 11:19:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728752AbgHSPSS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 11:18:18 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3361BC061342
        for <netdev@vger.kernel.org>; Wed, 19 Aug 2020 08:18:18 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id x5so2448964wmi.2
        for <netdev@vger.kernel.org>; Wed, 19 Aug 2020 08:18:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=SxMh9e6mbIAsZJ0A31frMOmg3gZvSFe2o4lw2DcDccI=;
        b=tjXqKCiWyEz1/E8V0+0SvbrgpGkhEZV+J4WcpM+FKGV2NoIR05VBQtd1AgB1xdvXaN
         QZHOMP6mpfg0121lwLJ5IGNPqHzD5LYY9cFOkTXRSLm01YQRAJQQOfkkuwhhiGg/b3Va
         TtX4ko0YbgN92D71/FgkeazzxCSklfKv5dBcTA9Ht5X1V2APTkXDdMo+EZgSySGfgt9X
         tjJG7dK0lAgV2UM+KxF0+mzftee7kaFYzWzrzeLy17UfYn7eB8XQzZSr+JSFOCajK5mF
         My7EL6gyX5sBZT258FUk4iH6kZIkR8Vb1TO+y5nYroZwU9xMNnBU6VtAZEwrztj6IbBy
         Rptw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=SxMh9e6mbIAsZJ0A31frMOmg3gZvSFe2o4lw2DcDccI=;
        b=fZvuSbiS21Yke1FkdmoJvzQqGlXe4z8ngr3xpw5kFuO9QP5NU1XMq5sqhPO03i2jJ/
         3NQUrkfPhw61C2fptOELgOgNEld+SSO3/wnpPnKoRielXu+1ietRrfMDsUMAr3P/K3Hn
         Mc43j3fJF1oGUKy50VyldZQMDBINwl1sItNT0Yd4Ai3LEfkpmYYkzRFRCFn9NXDK7JyJ
         GC9hadFhGTdtnK8jOCWDEnepZJtRt3ZfkC2jnLFWrjV4HBgm0rp3k87NaCiLSU0btqFr
         uqJTvj/kia/y2jgWwCW7N+KG3vrNCwQQOxdRfsLtT/EyTbMdFr1HCJoYWjvEBYMNpNZR
         1NWQ==
X-Gm-Message-State: AOAM533pQdBFTfzFOD8F7bKrqn3c7XhOra9iRPxNKSGeUDLOOS4EmGgz
        +M3bxHt+zjErKVVahY6mjtTRlA==
X-Google-Smtp-Source: ABdhPJxRmTZCdsJ36j9dI46sigvM3dovKBVuhYWw2XssKMM6VAIq/F/SfEu9/L1Ww91/o5I9Q7CMLA==
X-Received: by 2002:a7b:c15a:: with SMTP id z26mr87263wmi.35.1597850296887;
        Wed, 19 Aug 2020 08:18:16 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id l11sm5674200wme.11.2020.08.19.08.18.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Aug 2020 08:18:16 -0700 (PDT)
Date:   Wed, 19 Aug 2020 17:18:15 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Moshe Shemesh <moshe@nvidia.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Moshe Shemesh <moshe@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next RFC v2 01/13] devlink: Add reload action option
 to devlink reload command
Message-ID: <20200819151815.GA2575@nanopsycho.orion>
References: <1597657072-3130-1-git-send-email-moshe@mellanox.com>
 <1597657072-3130-2-git-send-email-moshe@mellanox.com>
 <20200817163612.GA2627@nanopsycho>
 <3ed1115e-8b44-b398-55f2-cee94ef426fd@nvidia.com>
 <20200818171010.11e4b615@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <cd0e3d7e-4746-d26d-dd0c-eb36c9c8a10f@nvidia.com>
 <20200819124616.GA2314@nanopsycho.orion>
 <fc0d7c2f-afb5-c2e7-e44b-2ab5d21d8465@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fc0d7c2f-afb5-c2e7-e44b-2ab5d21d8465@nvidia.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Aug 19, 2020 at 04:23:25PM CEST, moshe@nvidia.com wrote:
>
>On 8/19/2020 3:46 PM, Jiri Pirko wrote:
>> Wed, Aug 19, 2020 at 02:18:22PM CEST, moshe@nvidia.com wrote:
>> > On 8/19/2020 3:10 AM, Jakub Kicinski wrote:
>> > > On Tue, 18 Aug 2020 12:10:36 +0300 Moshe Shemesh wrote:
>> > > > On 8/17/2020 7:36 PM, Jiri Pirko wrote:
>> > > > > Mon, Aug 17, 2020 at 11:37:40AM CEST, moshe@mellanox.com wrote:
>> > > > > > Add devlink reload action to allow the user to request a specific reload
>> > > > > > action. The action parameter is optional, if not specified then devlink
>> > > > > > driver re-init action is used (backward compatible).
>> > > > > > Note that when required to do firmware activation some drivers may need
>> > > > > > to reload the driver. On the other hand some drivers may need to reset
>> > > > > Sounds reasonable. I think it would be good to indicate that though. Not
>> > > > > sure how...
>> > > > Maybe counters on the actions done ? Actually such counters can be
>> > > > useful on debug, knowing what reloads we had since driver was up.
>> > > Wouldn't we need to know all types of reset of drivers may do?
>> > 
>> > Right, we can't tell all reset types driver may have, but we can tell which
>> > reload actions were done.
>> > 
>> > > I think documenting this clearly should be sufficient.
>> > > 
>> > > A reset counter for the _requested_ reset type (fully maintained by
>> > > core), however - that may be useful. The question "why did this NIC
>> > > reset itself / why did the link just flap" comes up repeatedly.
>> > 
>> > I will add counters on which reload were done. reload_down()/up() can return
>> > which actions were actually done and devlink will show counters.
>> Why a counter? Just return what was done over netlink reply.
>
>
>Such counters can be useful for debugging, telling which reload actions were
>done on this dev from the point it was up.

Not sure why this is any different from other commands...

>
