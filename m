Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C4AB2D009A
	for <lists+netdev@lfdr.de>; Sun,  6 Dec 2020 06:04:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725747AbgLFFEh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Dec 2020 00:04:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:40254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725355AbgLFFEg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 6 Dec 2020 00:04:36 -0500
Date:   Sun, 6 Dec 2020 07:03:51 +0200
From:   Leon Romanovsky <leonro@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, Jason Gunthorpe <jgg@ziepe.ca>,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Dave Ertman <david.m.ertman@intel.com>,
        Dan Williams <dan.j.williams@intel.com>
Subject: Re: [pull request][for-next] mlx5-next auxbus support
Message-ID: <20201206050351.GA210929@unreal>
References: <20201204182952.72263-1-saeedm@nvidia.com>
 <20201205153545.3d30536b@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
 <20201205161921.28d5cb7e@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201205161921.28d5cb7e@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Dec 05, 2020 at 04:19:21PM -0800, Jakub Kicinski wrote:
> On Sat, 5 Dec 2020 15:35:45 -0800 Jakub Kicinski wrote:
> > On Fri, 4 Dec 2020 10:29:52 -0800 Saeed Mahameed wrote:
> > > This pull request is targeting net-next and rdma-next branches.
> > >
> > > This series provides mlx5 support for auxiliary bus devices.
> > >
> > > It starts with a merge commit of tag 'auxbus-5.11-rc1' from
> > > gregkh/driver-core into mlx5-next, then the mlx5 patches that will convert
> > > mlx5 ulp devices (netdev, rdma, vdpa) to use the proper auxbus
> > > infrastructure instead of the internal mlx5 device and interface management
> > > implementation, which Leon is deleting at the end of this patchset.
> > >
> > > Link: https://lore.kernel.org/alsa-devel/20201026111849.1035786-1-leon@kernel.org/
> > >
> > > Thanks to everyone for the joint effort !
> >
> > Pulled, thanks! (I'll push out after build finishes so may be an hour)
>
> Or not, looks like you didn't adjust to Greg's changes:

Sorry Jakub, It was my mistake.

I'm fixing, folding the changes and pushing new branch now.
Most likely that Saeed will send new pull request on Monday.

Thanks
