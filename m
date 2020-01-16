Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C75AA13D688
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 10:14:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726897AbgAPJOf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 04:14:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:43050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726406AbgAPJOf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 04:14:35 -0500
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 069112064C;
        Thu, 16 Jan 2020 09:14:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579166074;
        bh=/ZP5DMFXtvJgpTiq9dMw2rh/k9mrDcKdr98oM2mMCb4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=u9oe0bzh8DUh8A3H6Yw+Abbespstue2lzXd2XIwj2e0CZdnCokA37LJgL0XU2rnIZ
         voXO89Puh/kZlE+glv4YdRBcXLb1k4xOsIEW8F0XAd9gtfp8s8mb9AAe8ie1qC9FXk
         uCVDww+ZdhAAzwYN/yPlXWIAO50WWGbCQljryvT0=
Date:   Thu, 16 Jan 2020 11:14:30 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Doug Ledford <dledford@redhat.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Avihai Horon <avihaih@mellanox.com>,
        Maor Gottlieb <maorg@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH rdma-next 0/2] RoCE accelerator counters
Message-ID: <20200116091430.GA6853@unreal>
References: <20200115145459.83280-1-leon@kernel.org>
 <20200115203929.GA26829@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200115203929.GA26829@ziepe.ca>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 15, 2020 at 04:39:29PM -0400, Jason Gunthorpe wrote:
> On Wed, Jan 15, 2020 at 04:54:57PM +0200, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@mellanox.com>
> >
> > Hi,
> >
> > Very small change, separated to two patches due to our shared methodology.
> >
> > Thanks
> >
> > Avihai Horon (1):
> >   IB/mlx5: Expose RoCE accelerator counters
> >
> > Leon Romanovsky (1):
> >   net/mlx5: Add RoCE accelerator counters
>
> Looks fine to me, can you update the shared branch?

Thanks, applied
8cbf17c14f9b net/mlx5: Add RoCE accelerator counters

>
> Thanks,
> Jason
