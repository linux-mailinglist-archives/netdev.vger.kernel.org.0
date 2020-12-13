Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 532E12D8D02
	for <lists+netdev@lfdr.de>; Sun, 13 Dec 2020 13:09:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406604AbgLMMJc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Dec 2020 07:09:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:59070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406579AbgLMMJc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 13 Dec 2020 07:09:32 -0500
Date:   Sun, 13 Dec 2020 14:08:48 +0200
From:   Leon Romanovsky <leonro@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jason Gunthorpe <jgg@nvidia.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Sridhar Samudrala <sridhar.samudrala@intel.com>,
        david.m.ertman@intel.com, dan.j.williams@intel.com,
        kiran.patil@intel.com, gregkh@linuxfoundation.org
Subject: Re: [net-next v3 00/14] Add mlx5 subfunction support
Message-ID: <20201213120848.GB5005@unreal>
References: <20201212061225.617337-1-saeed@kernel.org>
 <20201212122518.1c09eefe@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201212122518.1c09eefe@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Dec 12, 2020 at 12:25:18PM -0800, Jakub Kicinski wrote:
> On Fri, 11 Dec 2020 22:12:11 -0800 Saeed Mahameed wrote:
> > Hi Dave, Jakub, Jason,
> >
> > This series form Parav was the theme of this mlx5 release cycle,
> > we've been waiting anxiously for the auxbus infrastructure to make it into
> > the kernel, and now as the auxbus is in and all the stars are aligned, I
> > can finally submit this V2 of the devlink and mlx5 subfunction support.
> >
> > Subfunctions came to solve the scaling issue of virtualization
> > and switchdev environments, where SRIOV failed to deliver and users ran
> > out of VFs very quickly as SRIOV demands huge amount of physical resources
> > in both of the servers and the NIC.
> >
> > Subfunction provide the same functionality as SRIOV but in a very
> > lightweight manner, please see the thorough and detailed
> > documentation from Parav below, in the commit messages and the
> > Networking documentation patches at the end of this series.
> >
> > Sending V2/V3 as a continuation to V1 that was sent Last month [0],
> > [0] https://lore.kernel.org/linux-rdma/20201112192424.2742-1-parav@nvidia.com/
>
> This adds more and more instances of the 32 bit build warning.
>
> The warning was also reported separately on netdev after the recent
> mlx5-next pull.
>
> Please address that first (or did you already do and I missed it
> somehow?)

Hi Jakub,

I posted a fix from Parav,
https://lore.kernel.org/netdev/20201213120641.216032-1-leon@kernel.org/T/#u

Thanks
