Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DBB441B2FD
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 17:32:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241639AbhI1PeP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 11:34:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:54878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241509AbhI1PeM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Sep 2021 11:34:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A4F02610FC;
        Tue, 28 Sep 2021 15:32:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632843153;
        bh=7B8Tzqd8GFJxYTnmwPnsNGyyRt0vFWnob+bE2vuVpXw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EUJOfwTwhE1q5I1Xnz7xCx/ICxEKVn2xhZa4vPYrD8SHO6H5GNsoOVYbORv5xkkwh
         DIcMGTIeOe8T0wfPWsx69AnAFmL79d2XEDP5HixFO4jmQUPENSE9AXgAMCJ6m7yjiT
         wzmJUJDMp4WblubSatYN30n9SN8uCYOidbdxmmTpWDCHgLqmfXTvJ2j4sF+K2s6hp2
         NB5XteLcBwgoUdgerv97U2n8EmrwD8pJ7ALptKEz5zyA85hrq22dE6s9KgyyK29Vun
         3vSnH5IkFrxQYEdXr/cRcbtFpM1Eybp79Gi6WPVQbqcbdX3jYjOyf4b3k9B1m4vktq
         NWceXf0F0SjLw==
Date:   Tue, 28 Sep 2021 18:32:29 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Doug Ledford <dledford@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-rdma@vger.kernel.org,
        Meir Lichtinger <meirl@nvidia.com>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>
Subject: Re: [PATCH rdma-next v1 0/2] Extend UAR to have DevX UID
Message-ID: <YVM1jRqtKBG0rbwE@unreal>
References: <cover.1632299184.git.leonro@nvidia.com>
 <20210928150904.GA1675481@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210928150904.GA1675481@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 28, 2021 at 12:09:04PM -0300, Jason Gunthorpe wrote:
> On Wed, Sep 22, 2021 at 11:28:49AM +0300, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@nvidia.com>
> > 
> > Changelog:
> > v1:
> >  * Renamed functions and unexport mlx5_core uar calls.
> > v0: https://lore.kernel.org/all/cover.1631660943.git.leonro@nvidia.com
> > ----------------------------------------------------------------------
> >
> > Hi,
> > 
> > This is short series from Meir that adds DevX UID to the UAR.
> > 
> > Thanks
> > 
> > Meir Lichtinger (2):
> >   net/mlx5: Add uid field to UAR allocation structures
> >   IB/mlx5: Enable UAR to have DevX UID
> > 
> >  drivers/infiniband/hw/mlx5/cmd.c              | 26 +++++++++
> >  drivers/infiniband/hw/mlx5/cmd.h              |  2 +
> >  drivers/infiniband/hw/mlx5/main.c             | 55 +++++++++++--------
> >  drivers/net/ethernet/mellanox/mlx5/core/uar.c | 14 ++---
> >  include/linux/mlx5/driver.h                   |  2 -
> >  include/linux/mlx5/mlx5_ifc.h                 |  4 +-
> >  6 files changed, 68 insertions(+), 35 deletions(-)
> 
> This seems fine, can you update the shared branch please

Done, thanks
d2c8a1554c10 IB/mlx5: Enable UAR to have DevX UID
8de1e9b01b03 net/mlx5: Add uid field to UAR allocation structures

> 
> Jason
