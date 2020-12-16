Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 572382DBBA2
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 07:52:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726125AbgLPGvg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 01:51:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:44070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726119AbgLPGvf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Dec 2020 01:51:35 -0500
Date:   Wed, 16 Dec 2020 08:50:50 +0200
From:   Leon Romanovsky <leonro@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Saeed Mahameed <saeed@kernel.org>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Netdev <netdev@vger.kernel.org>, linux-rdma@vger.kernel.org,
        David Ahern <dsahern@kernel.org>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Sridhar Samudrala <sridhar.samudrala@intel.com>,
        "Ertman, David M" <david.m.ertman@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Kiran Patil <kiran.patil@intel.com>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [net-next v4 00/15] Add mlx5 subfunction support
Message-ID: <20201216065050.GR5005@unreal>
References: <20201214214352.198172-1-saeed@kernel.org>
 <CAKgT0UejoduCB6nYFV2atJ4fa4=v9-dsxNh4kNJNTtoHFd1DuQ@mail.gmail.com>
 <608505778d76b1b01cb3e8d19ecda5b8578f0f79.camel@kernel.org>
 <CAKgT0UfEsd0hS=iJTcVc20gohG0WQwjsGYOw1y0_=DRVbhb1Ng@mail.gmail.com>
 <ecad34f5c813591713bb59d9c5854148c3d7f291.camel@kernel.org>
 <20201215132805.22ddcd44@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201215132805.22ddcd44@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 15, 2020 at 01:28:05PM -0800, Jakub Kicinski wrote:
> On Tue, 15 Dec 2020 12:35:20 -0800 Saeed Mahameed wrote:
> > > I think the big thing we really should do if we are going to go this
> > > route is to look at standardizing what the flavours are that get
> > > created by the parent netdevice. Otherwise we are just creating the
> > > same mess we had with SRIOV all over again and muddying the waters of
> > > mediated devices.
> >
> > yes in the near future we will be working on auxbus interfaces for
> > auto-probing and user flavor selection, this is a must have feature for
> > us.
>
> Can you elaborate? I thought config would be via devlink.

Yes, everything continues to be done through devlink.

One of the immediate features is an ability to disable/enable creation
of specific SF types.

For example, if user doesn't want RDMA, the SF RDMA won't be created.

Thanks
