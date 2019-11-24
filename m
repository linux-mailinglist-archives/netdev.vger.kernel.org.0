Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFB4A1083DD
	for <lists+netdev@lfdr.de>; Sun, 24 Nov 2019 15:55:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727004AbfKXOz3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Nov 2019 09:55:29 -0500
Received: from mga06.intel.com ([134.134.136.31]:52697 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726798AbfKXOz3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 24 Nov 2019 09:55:29 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 24 Nov 2019 06:55:28 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,238,1571727600"; 
   d="scan'208";a="210856170"
Received: from dpdk-virtio-tbie-2.sh.intel.com (HELO ___) ([10.67.104.74])
  by orsmga006.jf.intel.com with ESMTP; 24 Nov 2019 06:55:26 -0800
Date:   Sun, 24 Nov 2019 22:56:00 +0800
From:   Tiwei Bie <tiwei.bie@intel.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Jason Gunthorpe <jgg@ziepe.ca>, Jason Wang <jasowang@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Parav Pandit <parav@mellanox.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        davem@davemloft.net, gregkh@linuxfoundation.org,
        Dave Ertman <david.m.ertman@intel.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, nhorman@redhat.com,
        sassmann@redhat.com, Kiran Patil <kiran.patil@intel.com>
Subject: Re: [net-next v2 1/1] virtual-bus: Implementation of Virtual Bus
Message-ID: <20191124145559.GA374632@___>
References: <20191120181108.GJ22515@ziepe.ca>
 <20191120150732.2fffa141@x1.home>
 <20191121030357.GB16914@ziepe.ca>
 <5dcef4ab-feb5-d116-b2a9-50608784a054@redhat.com>
 <20191121141732.GB7448@ziepe.ca>
 <721e49c2-a2e1-853f-298b-9601c32fcf9e@redhat.com>
 <20191122180214.GD7448@ziepe.ca>
 <20191123043951.GA364267@___>
 <20191123230948.GF7448@ziepe.ca>
 <20191124055343-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20191124055343-mutt-send-email-mst@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 24, 2019 at 06:00:23AM -0500, Michael S. Tsirkin wrote:
> On Sat, Nov 23, 2019 at 07:09:48PM -0400, Jason Gunthorpe wrote:
> > > > > > Further, I do not think it is wise to design the userspace ABI around
> > > > > > a simplistict implementation that can't do BAR assignment,
> > > > > 
> > > > > Again, the vhost-mdev follow the VFIO ABI, no new ABI is invented, and
> > > > > mmap() was kept their for mapping device regions.
> > > > 
> > > > The patches have a new file in include/uapi.
> > > 
> > > I guess you didn't look at the code. Just to clarify, there is no
> > > new file introduced in include/uapi. Only small vhost extensions to
> > > the existing vhost uapi are involved in vhost-mdev.
> > 
> > You know, I review alot of patches every week, and sometimes I make
> > mistakes, but not this time. From the ICF cover letter:
> > 
> > https://lkml.org/lkml/2019/11/7/62
> > 
> >  drivers/vfio/mdev/mdev_core.c    |  21 ++
> >  drivers/vhost/Kconfig            |  12 +
> >  drivers/vhost/Makefile           |   3 +
> >  drivers/vhost/mdev.c             | 556 +++++++++++++++++++++++++++++++
> >  include/linux/mdev.h             |   5 +
> >  include/uapi/linux/vhost.h       |  21 ++
> >  include/uapi/linux/vhost_types.h |   8 +
> >       ^^^^^^^^^^^^^^
> > 
> > Perhaps you thought I ment ICF was adding uapi? My remarks cover all
> > three of the series involved here.
> 
> Tiwei seems to be right - include/uapi/linux/vhost.h and
> include/uapi/linux/vhost_types.h are both existing files.  vhost uapi
> extensions included here are very modest. They
> just add virtio spec things that vhost was missing.

Yeah, that's what I meant. Thanks!

> 
> Are you looking at a very old linux tree maybe?
> vhost_types.h appeared around 4.20.
> 
> -- 
> MST
> 
