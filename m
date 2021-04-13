Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E87735E701
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 21:21:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344557AbhDMTVU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 15:21:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:35044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229458AbhDMTVT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Apr 2021 15:21:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0379361353;
        Tue, 13 Apr 2021 19:20:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618341659;
        bh=eg2mDj0jk8WBLWTkxKBLWu9KYKSV1LwvDLmegiz0Zkg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=obBeaiwo7GAtiQcVjEmNXBSTj61Fs14hDO4hDST4Rwr6JP+cTKlSwT8/6X/19831X
         +A15HbuS3MnjtP8+pDN+iYdvrXD2RZA0OMeYM6PsdZxVqW5cu9vm3FOiJ1syl0Qee1
         R/ILEiVZoZVqxZoQh/l4L/ClbzPuUVDDQk02Qp3Ryo3PugPfuSLawFwMS/7A4uuq1x
         wE+K1BRBCFGLVguEhbviTCk4YDSYQJw10F20JAcNaGecEDLFOy8MNLlPXGdWlOSjVP
         KzucGABLVPaJ+fcPrGLejRDpfcy8QCn9QzBL53V6RtFPVyQpnUseF+WJdFnNGBCrdX
         1ZYavdmZRAdrw==
Date:   Tue, 13 Apr 2021 22:20:56 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Doug Ledford <dledford@redhat.com>, linux-api@vger.kernel.org,
        linux-rdma@vger.kernel.org, Maor Gottlieb <maorg@nvidia.com>,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Yishai Hadas <yishaih@mellanox.com>
Subject: Re: [PATCH rdma-next v1 0/7] Add MEMIC operations support
Message-ID: <YHXvGOrvQLOA9CBT@unreal>
References: <20210411122924.60230-1-leon@kernel.org>
 <20210413185527.GA1340003@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210413185527.GA1340003@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 13, 2021 at 03:55:27PM -0300, Jason Gunthorpe wrote:
> On Sun, Apr 11, 2021 at 03:29:17PM +0300, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@nvidia.com>
> > 
> > Changelog:
> > v1: 
> >  * Changed logic of patch #6 per-Jason's request. 
> > v0: https://lore.kernel.org/linux-rdma/20210318111548.674749-1-leon@kernel.org
> > 
> > ---------------------------------------------------------------------------
> > 
> > Hi,
> > 
> > This series from Maor extends MEMIC to support atomic operations from
> > the host in addition to already supported regular read/write.
> > 
> > Thanks
> > 
> > Maor Gottlieb (7):
> >   net/mlx5: Add MEMIC operations related bits
> >   RDMA/uverbs: Make UVERBS_OBJECT_METHODS to consider line number
> >   RDMA/mlx5: Move all DM logic to separate file
> >   RDMA/mlx5: Re-organize the DM code
> >   RDMA/mlx5: Add support to MODIFY_MEMIC command
> >   RDMA/mlx5: Add support in MEMIC operations
> >   RDMA/mlx5: Expose UAPI to query DM
> 
> This looks OK now, can you update the shared branch?

63f9c44bca5e net/mlx5: Add MEMIC operations related bits

mlx5-next was updated, thanks

> 
> Thanks,
> Jason
