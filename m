Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B924278164
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 09:20:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727268AbgIYHUK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 03:20:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:43128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727067AbgIYHUK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Sep 2020 03:20:10 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2F54122211;
        Fri, 25 Sep 2020 07:20:08 +0000 (UTC)
Date:   Fri, 25 Sep 2020 10:20:05 +0300
From:   Leon Romanovsky <leonro@nvidia.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Randy Dunlap <rdunlap@infradead.org>, Eli Cohen <elic@nvidia.com>,
        virtualization@lists.linux-foundation.org,
        LKML <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jason Wang <jasowang@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [PATCH v3 -next] vdpa: mlx5: change Kconfig depends to fix build
 errors
Message-ID: <20200925072005.GB2280698@unreal>
References: <73f7e48b-8d16-6b20-07d3-41dee0e3d3bd@infradead.org>
 <20200918082245.GP869610@unreal>
 <20200924052932-mutt-send-email-mst@kernel.org>
 <20200924102413.GD170403@mtl-vdi-166.wap.labs.mlnx>
 <079c831e-214d-22c1-028e-05d84e3b7f04@infradead.org>
 <20200924120217-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200924120217-mutt-send-email-mst@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 24, 2020 at 12:02:43PM -0400, Michael S. Tsirkin wrote:
> On Thu, Sep 24, 2020 at 08:47:05AM -0700, Randy Dunlap wrote:
> > On 9/24/20 3:24 AM, Eli Cohen wrote:
> > > On Thu, Sep 24, 2020 at 05:30:55AM -0400, Michael S. Tsirkin wrote:
> > >>>> --- linux-next-20200917.orig/drivers/vdpa/Kconfig
> > >>>> +++ linux-next-20200917/drivers/vdpa/Kconfig
> > >>>> @@ -31,7 +31,7 @@ config IFCVF
> > >>>>
> > >>>>  config MLX5_VDPA
> > >>>>  	bool "MLX5 VDPA support library for ConnectX devices"
> > >>>> -	depends on MLX5_CORE
> > >>>> +	depends on VHOST_IOTLB && MLX5_CORE
> > >>>>  	default n
> > >>>
> > >>> While we are here, can anyone who apply this patch delete the "default n" line?
> > >>> It is by default "n".
> > >
> > > I can do that
> > >
> > >>>
> > >>> Thanks
> > >>
> > >> Hmm other drivers select VHOST_IOTLB, why not do the same?
> >
> > v1 used select, but Saeed requested use of depends instead because
> > select can cause problems.
> >
> > > I can't see another driver doing that. Perhaps I can set dependency on
> > > VHOST which by itself depends on VHOST_IOTLB?
> > >>
> > >>
> > >>>>  	help
> > >>>>  	  Support library for Mellanox VDPA drivers. Provides code that is
> > >>>>
> > >>
> >
>
> Saeed what kind of problems? It's used with select in other places,
> isn't it?

IMHO, "depends" is much more explicit than "select".

Thanks

>
> > --
> > ~Randy
>
