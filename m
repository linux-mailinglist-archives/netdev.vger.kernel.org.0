Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 558973156D5
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 20:34:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233439AbhBITcL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 14:32:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:50112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233635AbhBITQI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Feb 2021 14:16:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8C2CC64ED3;
        Tue,  9 Feb 2021 19:14:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612898068;
        bh=jIeL83Vc6VKc9kTFWSUiCB4hPYo8GmO9zhfQVCfKJPA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mpmVXCL6mJzgnhe83R99JyXKnYiJHjnR25Siu2hKOTlhuFmVLEUpnACMqmAVWFLgE
         7eLxiWiiugRce7MuoERBj1fgrksnpspNvT8HVWHtIR6kL6+PlyuSWqDa7Os71d+ZX5
         K8pdrwPMzkIehHu06Q+yjEF9s9QxthHmB2wfjVH7l+wevMTU072i9V75kAUzHi0e4o
         yFOxk3QPTf7CTQ5FJ/S+/d5mbW4CRIUeCdawpLD2fL8dzFg+dInEoKYaXCG/h4wxP8
         ycYqNKSRMBAUJE7QpOZfdooRFrchpKqXxjSFyVmI5iTW1Pl4Wza66ktO3I0YR/3bW8
         m9zpBwZwWhFUQ==
Date:   Tue, 9 Feb 2021 21:14:24 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Aharon Landau <aharonl@nvidia.com>, linux-rdma@vger.kernel.org,
        Maor Gottlieb <maorg@nvidia.com>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [PATCH mlx5-next 1/2] net/mlx5: Add new timestamp mode bits
Message-ID: <20210209191424.GE139298@unreal>
References: <20210209131107.698833-1-leon@kernel.org>
 <20210209131107.698833-2-leon@kernel.org>
 <20210209102825.6ede1bd4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210209102825.6ede1bd4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 09, 2021 at 10:28:25AM -0800, Jakub Kicinski wrote:
> On Tue,  9 Feb 2021 15:11:06 +0200 Leon Romanovsky wrote:
> > From: Aharon Landau <aharonl@nvidia.com>
> >
> > These fields declare which timestamp mode is supported by the device
> > per RQ/SQ/QP.
> >
> > In addiition add the ts_format field to the select the mode for
> > RQ/SQ/QP.
> >
> > Signed-off-by: Aharon Landau <aharonl@nvidia.com>
> > Signed-off-by: Maor Gottlieb <maorg@nvidia.com>
> > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
>
> We only got patch 1 which explains very little.

I will change my scripts to ensure that all people will be always CCed
on whole series.

https://lore.kernel.org/linux-rdma/20210209131107.698833-3-leon@kernel.org

>
> You also need to CC Richard.

We are not talking about PTP, but about specific to RDMA timestamp mechanism
which is added to the CQE (completion queue entry) per-user request when
he/she creates CQ (completion queue). User has an option to choose the format
of it for every QP/RQ/SQ.

https://github.com/linux-rdma/rdma-core/blob/master/libibverbs/man/ibv_create_cq_ex.3#L44

Thanks
