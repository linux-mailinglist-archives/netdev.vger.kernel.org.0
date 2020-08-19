Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13CA3249E82
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 14:47:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728324AbgHSMrD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 08:47:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728002AbgHSMqX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 08:46:23 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77855C061383
        for <netdev@vger.kernel.org>; Wed, 19 Aug 2020 05:46:22 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id f1so21419181wro.2
        for <netdev@vger.kernel.org>; Wed, 19 Aug 2020 05:46:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=2BzCE5QyyYKQU931AlGPMu5HZVvIvHxha+lrY7tCRes=;
        b=MWp6hmrRJhUbzUdF0FdnrfONYMpFUd7Iyj63uekk/ZvngRnKZkjWtl//71SJLcWmdu
         XFUVVPM5DhNUB+kFlpvn2H79VSVE/mu0dkJlU/2cRRbMEbOuTZl+G2ySd2dDqSD8Jl0C
         7KB6HizxZ4KpnotaU49Km7jTyTF7+JT+9KOjGe5xT9SRDe7B7vVArfjeybaJ2Qhlvv4E
         vL24tKCcoRsntKQRVwuTg/OilunaMOvnibVxD81nI8FmZmccTaqxCtUH9A3dwDVLs5oR
         sn9ycaDgMUjsxb7S260D69JFYBS2CDc7wQnKQLs3IfqyVfDDoqGPpd2KA2O13byN4smx
         RwrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2BzCE5QyyYKQU931AlGPMu5HZVvIvHxha+lrY7tCRes=;
        b=EAoV/lvsv1GzY7BsvsVKoozNAKmc5YSoq7a3j9URquKYbRoh/fDPu6sAjlJumZO+w5
         XAZWVLBVPUs0fhb489EV1bTByjHfcSyxZj5eLsnIlU8n031W3Vf3QmOhWjD66x68nT/g
         7BXN36qrnOQ2gDGrQxTvbSir7fc+R1xSsls+JPGZet/x/5Nyy90vzrEj9TTbKkXWCFuy
         RtDwtOPfykffoDjBgrVBlQUKZKhLBmWhURgp4MggIRvl9e8BVu1sqX+VXZae8y3BKTfE
         VOjj3Hvd2SE2AnBOzVzFRSXTrcYlcJgmBwKTLK8ioWuYYBSrsEab5RC41FtGes7Zh7OV
         M7tQ==
X-Gm-Message-State: AOAM533jHh40s5Zn6vA8eWCrsglpdeGs5qiPoAZGzCsvgPoAWTzOqejC
        kATa+oiigkaXyM7s/diSSk05Ew==
X-Google-Smtp-Source: ABdhPJymzCY2LUtVitxv8O8Xw0EyPf38KeeNj79RfMFFgL6iJSYyu+7mD2ngPcz9zyP9N4dirVJKaQ==
X-Received: by 2002:adf:e550:: with SMTP id z16mr24865865wrm.329.1597841180601;
        Wed, 19 Aug 2020 05:46:20 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id j24sm44099589wrb.49.2020.08.19.05.46.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Aug 2020 05:46:19 -0700 (PDT)
Date:   Wed, 19 Aug 2020 14:46:16 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Moshe Shemesh <moshe@nvidia.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Moshe Shemesh <moshe@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next RFC v2 01/13] devlink: Add reload action option
 to devlink reload command
Message-ID: <20200819124616.GA2314@nanopsycho.orion>
References: <1597657072-3130-1-git-send-email-moshe@mellanox.com>
 <1597657072-3130-2-git-send-email-moshe@mellanox.com>
 <20200817163612.GA2627@nanopsycho>
 <3ed1115e-8b44-b398-55f2-cee94ef426fd@nvidia.com>
 <20200818171010.11e4b615@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <cd0e3d7e-4746-d26d-dd0c-eb36c9c8a10f@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cd0e3d7e-4746-d26d-dd0c-eb36c9c8a10f@nvidia.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Aug 19, 2020 at 02:18:22PM CEST, moshe@nvidia.com wrote:
>
>On 8/19/2020 3:10 AM, Jakub Kicinski wrote:
>> 
>> On Tue, 18 Aug 2020 12:10:36 +0300 Moshe Shemesh wrote:
>> > On 8/17/2020 7:36 PM, Jiri Pirko wrote:
>> > > Mon, Aug 17, 2020 at 11:37:40AM CEST, moshe@mellanox.com wrote:
>> > > > Add devlink reload action to allow the user to request a specific reload
>> > > > action. The action parameter is optional, if not specified then devlink
>> > > > driver re-init action is used (backward compatible).
>> > > > Note that when required to do firmware activation some drivers may need
>> > > > to reload the driver. On the other hand some drivers may need to reset
>> > > Sounds reasonable. I think it would be good to indicate that though. Not
>> > > sure how...
>> > Maybe counters on the actions done ? Actually such counters can be
>> > useful on debug, knowing what reloads we had since driver was up.
>> Wouldn't we need to know all types of reset of drivers may do?
>
>
>Right, we can't tell all reset types driver may have, but we can tell which
>reload actions were done.
>
>> I think documenting this clearly should be sufficient.
>> 
>> A reset counter for the _requested_ reset type (fully maintained by
>> core), however - that may be useful. The question "why did this NIC
>> reset itself / why did the link just flap" comes up repeatedly.
>
>
>I will add counters on which reload were done. reload_down()/up() can return
>which actions were actually done and devlink will show counters.

Why a counter? Just return what was done over netlink reply.

>
