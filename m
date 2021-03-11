Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FB06338169
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 00:26:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231149AbhCKXZd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 18:25:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:55258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230388AbhCKXY4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Mar 2021 18:24:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D4EB864F8D;
        Thu, 11 Mar 2021 23:24:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615505096;
        bh=gwBIEm5eCEuFPWt/lCBtyPTARvKErQXYjIBh09bK8nw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=YeLVThZSuUV3lgKuJgngaUxk0h45cJzN7SEhidEFZlqAcV7kxzrDrA3DGZzo/YA0b
         5VSXrajqBqv8lmVAuRbCQl9KjQj1VrPjSISlhVtBy0McQKG4s1Z9ogqf2AgAvyvoP2
         WVmzsgYILuT3QOqEXa02Sms12XWkHzUO/NjFVP37RADgV9i4G9y3XiW2dgUugH3+de
         4SRT5/vDrXgLLiESYt1gIUK8Wdx6XbTpvGn/gPNuGPaCwgpfSzQppFdjo2wmECSWSO
         Rk3N9oPeqxvBL7+hd4rvOFQXZrGVJ8gxcJvYigCuS4lOmh3JDnutnR2rac4R5NPN6F
         wba8reH1fXWEw==
Message-ID: <46d60ad85a94e8bc693abbfbcbaf55ab6f7ca91e.camel@kernel.org>
Subject: Re: [PATCH] net/mlx5: remove unneeded semicolon
From:   Saeed Mahameed <saeed@kernel.org>
To:     Parav Pandit <parav@nvidia.com>,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc:     "leon@kernel.org" <leon@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date:   Thu, 11 Mar 2021 15:24:55 -0800
In-Reply-To: <DM6PR12MB433097A211B6A99DAF690958DC989@DM6PR12MB4330.namprd12.prod.outlook.com>
References: <1613987819-43161-1-git-send-email-jiapeng.chong@linux.alibaba.com>
         <BY5PR12MB4322C25D61EC6E4549370917DC819@BY5PR12MB4322.namprd12.prod.outlook.com>
         <DM6PR12MB433097A211B6A99DAF690958DC989@DM6PR12MB4330.namprd12.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2021-03-03 at 08:52 +0000, Parav Pandit wrote:
> Hi Saeed,
> 
> > From: Parav Pandit <parav@nvidia.com>
> > Sent: Monday, February 22, 2021 3:32 PM
> > 
> > 
> > > From: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
> > > Sent: Monday, February 22, 2021 3:27 PM
> > > 
> > > Fix the following coccicheck warnings:
> > > 
> > > ./drivers/net/ethernet/mellanox/mlx5/core/sf/devlink.c:495:2-3:
> > > Unneeded semicolon.
> > > 
> > > Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> > > Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
> > > ---
> > >  drivers/net/ethernet/mellanox/mlx5/core/sf/devlink.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sf/devlink.c
> > > b/drivers/net/ethernet/mellanox/mlx5/core/sf/devlink.c
> > > index c2ba41b..60a6328 100644
> > > --- a/drivers/net/ethernet/mellanox/mlx5/core/sf/devlink.c
> > > +++ b/drivers/net/ethernet/mellanox/mlx5/core/sf/devlink.c
> > > @@ -492,7 +492,7 @@ static int mlx5_sf_esw_event(struct
> > > notifier_block
> > > *nb, unsigned long event, voi
> > >                 break;
> > >         default:
> > >                 break;
> > > -       };
> > > +       }
> > > 
> > >         return 0;
> > >  }
> > > --
> > > 1.8.3.1
> > 
> > Reviewed-by: Parav Pandit <parav@nvidia.com>
> 
> Will you take this patch [1] to your queue?
> 
> [1]
> https://lore.kernel.org/linux-rdma/1613987819-43161-1-git-send-email-jiapeng.chong@linux.alibaba.com/

Applied to net-next-mlx5.
Thanks,
Saeed.

