Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0516D13760A
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 19:31:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728633AbgAJSat (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 13:30:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:49044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726346AbgAJSas (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Jan 2020 13:30:48 -0500
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D017E2082E;
        Fri, 10 Jan 2020 18:30:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578681048;
        bh=fWYpDygwtZyYnO5ifpqIXsux7tX8m/qF/p7JS6nIZXM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Qnv9t4J2opmWf12DZJjT1oO+uQEftCdMN/t6S5GK8K4AVh9z0JsF4AtsbW4HTStGx
         19Uf+uyHvoT/2KRZsLC3YpzLSRBywoFDwpAy2CZq7bO4t88LRC+kPG5E+Bn7ExWwPl
         Ka3dplJpSjI2SGpcJpsZ+24M0zUABncfzLPynxxY=
Date:   Fri, 10 Jan 2020 20:30:41 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Saeed Mahameed <saeedm@mellanox.com>,
        Doug Ledford <dledford@redhat.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Shahaf Shuler <shahafs@mellanox.com>,
        Yishai Hadas <yishaih@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH rdma-next 0/5] VIRTIO_NET Emulation Offload
Message-ID: <20200110183041.GA6871@unreal>
References: <20191212110928.334995-1-leon@kernel.org>
 <20200107193744.GB18256@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200107193744.GB18256@ziepe.ca>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 07, 2020 at 03:37:44PM -0400, Jason Gunthorpe wrote:
> On Thu, Dec 12, 2019 at 01:09:23PM +0200, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@mellanox.com>
> >
> > Hi,
> >
> > In this series, we introduce VIRTIO_NET_Q HW offload capability, so SW will
> > be able to create special general object with relevant virtqueue properties.
> >
> > This series is based on -rc patches:
> > https://lore.kernel.org/linux-rdma/20191212100237.330654-1-leon@kernel.org
> >
> > Thanks
> >
> > Yishai Hadas (5):
> >   net/mlx5: Add Virtio Emulation related device capabilities
> >   net/mlx5: Expose vDPA emulation device capabilities
>
> This series looks OK enough to me. Saeed can you update the share
> branch with the two patches?

Merged, thanks,

ca1992c62cad net/mlx5: Expose vDPA emulation device capabilities
90fbca595243 net/mlx5: Add Virtio Emulation related device capabilities
