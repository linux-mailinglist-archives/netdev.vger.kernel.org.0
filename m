Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B48A18A129
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 18:07:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727166AbgCRRH0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 13:07:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:40880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726855AbgCRRHZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Mar 2020 13:07:25 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AD22120753;
        Wed, 18 Mar 2020 17:07:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584551245;
        bh=y5A7BGbCC27R1O3f8EBbgrW6SajWQHehra/gxa7dPvw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KNePhfFC2M08KULuxc1NqeYxJP0rABdxSG6ciuh8tupKnDJ4SOfGtc7nFEFbzFnRl
         g1gBI21sUbSXv9g/12aO+d9JvdqFypYKXGWqTE21gxBv8VGgeUW+APyam7XeyNNIAL
         mL0n7/XAkL/Eft5vbOrOSGVt5+Sbo5udlPBQhb+0=
Date:   Wed, 18 Mar 2020 19:07:21 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@mellanox.com>
Cc:     Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org,
        Michael Guralnik <michaelgur@mellanox.com>,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>,
        Yishai Hadas <yishaih@mellanox.com>
Subject: Re: [PATCH rdma-next 0/4] Introduce dynamic UAR allocation mode
Message-ID: <20200318170721.GD126814@unreal>
References: <20200318124329.52111-1-leon@kernel.org>
 <20200318125459.GI13183@mellanox.com>
 <20200318131450.GY3351@unreal>
 <20200318132100.GK13183@mellanox.com>
 <20200318135631.GA126497@unreal>
 <20200318140001.GL13183@mellanox.com>
 <20200318140932.GB126814@unreal>
 <20200318141208.GM13183@mellanox.com>
 <20200318142455.GC126814@unreal>
 <20200318143903.GN13183@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200318143903.GN13183@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 18, 2020 at 11:39:03AM -0300, Jason Gunthorpe wrote:
> On Wed, Mar 18, 2020 at 04:24:55PM +0200, Leon Romanovsky wrote:
> > > > I'm ok with this approach because it helps us to find those dead
> > > > paths, but have last question, shouldn't this be achieved with
> > > > proper documentation of every flag instead of adding CONFIG_..?
> > >
> > > How do you mean?
> > >
> > > The other half of this idea is to disable obsolete un tested code to
> > > avoid potential bugs. Which requires CONFIG_?
> >
> > The second part is achievable by distros when they will decide to
> > support starting from version X. The same decision is not so easy
> > to do in the upstream.
>
> Upstream will probably carry the code for a long, long time, that
> doesn't mean the distros don't get value by using a shorter time
> window

Sure

>
> > Let's take as an example this feature. It will be set as default from
> > rdma-core v29 and the legacy code will be guarded by
> > "if (CONFIG_INFINIBAND_MIN_RDMA_CORE_VERSION >= 29)". When will change
> > CONFIG_INFINIBAND_MIN_RDMA_CORE_VERSION to be above 29? So we will
> > delete such legacy code.
>
> First the distros will decide in their own kconfigs where they want to
> set the value.
>
> Then the upstream kernel will decide some default value
>
> Then maybe we could talk about lowest values when enough of the user
> community uses a higher value

I think that you over-optimistic here, but let's hear other voices here.

Thanks

>
> Jason
