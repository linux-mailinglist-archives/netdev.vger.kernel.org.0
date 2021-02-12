Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC59331A68F
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 22:10:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232010AbhBLVKG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 16:10:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:58928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229798AbhBLVKC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Feb 2021 16:10:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 693DA64DEC;
        Fri, 12 Feb 2021 21:09:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613164161;
        bh=gLwKAPwAdqi/hJ+fFYRRy+fQTJxn5OfnSVzRIlYP7mE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=I8i+mZDuEW9SvFUwKXYXYCSgq6zKOs7Hue+RqkwDeAUNSqI2q+tbu5KVQeI7GjJpm
         6R9KDL0hIINm2TZbCs96FbHyKabh5Ejt56LxcyYTlHS3Xig0IjEfD2RSMFRygihr0Y
         VmStungunuwLusGXbS3KLBns8noiw74ydWZaJQBMrjm006UVH6a75pcZ8hp++Qy6jz
         RkdV5GxF6PqxIgH6g9SsKmQiOuKxD8HkFDIqDx245TO8ykubS1S9iFDMtLVHXwjQ+C
         EuJUNxnjEwYg/C4S3VxmtQ7GCkzUltvUTf5GbeSv8CnNcXbEx2Li5Q+Cpn7szWabU6
         u9xUmI7SNrOYQ==
Message-ID: <5d4731e2394049ca66012f82e1645bdec51aca78.camel@kernel.org>
Subject: Re: [PATCH rdma-next 0/2] Real time/free running timestamp support
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jason Gunthorpe <jgg@nvidia.com>, Leon Romanovsky <leon@kernel.org>
Cc:     Doug Ledford <dledford@redhat.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Aharon Landau <aharonl@nvidia.com>, linux-rdma@vger.kernel.org,
        Maor Gottlieb <maorg@nvidia.com>, netdev@vger.kernel.org
Date:   Fri, 12 Feb 2021 13:09:20 -0800
In-Reply-To: <20210212181056.GB1737478@nvidia.com>
References: <20210209131107.698833-1-leon@kernel.org>
         <20210212181056.GB1737478@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.3 (3.38.3-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2021-02-12 at 14:10 -0400, Jason Gunthorpe wrote:
> On Tue, Feb 09, 2021 at 03:11:05PM +0200, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@nvidia.com>
> > 
> > Add an extra timestamp format for mlx5_ib device.
> > 
> > Thanks
> > 
> > Aharon Landau (2):
> >   net/mlx5: Add new timestamp mode bits
> >   RDMA/mlx5: Fail QP creation if the device can not support the CQE
> > TS
> > 
> >  drivers/infiniband/hw/mlx5/qp.c | 104
> > +++++++++++++++++++++++++++++---
> >  include/linux/mlx5/mlx5_ifc.h   |  54 +++++++++++++++--
> >  2 files changed, 145 insertions(+), 13 deletions(-)
> 
> Since this is a rdma series, and we are at the end of the cycle, I
> took the IFC file directly to the rdma tree instead of through the
> shared branch.
> 
> Applied to for-next, thanks
> 

mmm, i was planing to resubmit this patch with the netdev real time
support series, since the uplink representor is getting delayed, I
thought I could submit the real time stuff today. can you wait on the
ifc patch, i will re-send it today if you will, but it must go through
the shared branch

Thanks.


