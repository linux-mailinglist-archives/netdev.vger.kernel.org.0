Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 356933380B7
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 23:38:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231327AbhCKWiV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 17:38:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:33608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230034AbhCKWiK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Mar 2021 17:38:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0A9FE64F88;
        Thu, 11 Mar 2021 22:38:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615502290;
        bh=8t4Urmt9wScpSHPj86H4F0L9dCTqjL2LZLXXlENTJgU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=ksMJOld3N2uLHInZ2IDLn7uJ6KsilnpnwPIRen535ipyqmUGgcAseV71Ff8nrdXCq
         qvdYqWSEn091rj++VTZNavSOz15Ta3WgJ5PxQ4A291EdqL4FjtPQa1JcEIhgVAMmSF
         lONFxArpalscfbp5mGK4+PH99Ns35q2oL3UwyDM66RIXGS/8JYrIJEUSz7crb7uOaG
         VC/vZjqXBoxXKWYOVDg5wOWNTfbsmlXof27ce2WCppbMdlWKml1lNMhUyntHiSpSUF
         EVpycwvYBFRiY49xfsgRzg43kCrSIAEGIKYR5qj026eOPU+cC3GNA80ysmNWvPIv/n
         cSyb8oeBc1eNQ==
Message-ID: <fcc10702a825d003d1353fdef671648ff066ca14.camel@kernel.org>
Subject: Re: [PATCH mlx5-next 6/9] RDMA/mlx5: Use represntor E-Switch when
 getting netdev and metadata
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, Mark Bloch <mbloch@nvidia.com>
Date:   Thu, 11 Mar 2021 14:38:09 -0800
In-Reply-To: <20210311173335.GA2710053@nvidia.com>
References: <20210311070915.321814-1-saeed@kernel.org>
         <20210311070915.321814-7-saeed@kernel.org>
         <20210311173335.GA2710053@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2021-03-11 at 13:33 -0400, Jason Gunthorpe wrote:
> On Wed, Mar 10, 2021 at 11:09:12PM -0800, Saeed Mahameed wrote:
> > From: Mark Bloch <mbloch@nvidia.com>
> > 
> > Now that a pointer to the managing E-Switch is stored in the
> > representor
> > use it.
> > 
> > Signed-off-by: Mark Bloch <mbloch@nvidia.com>
> > Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
> > Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
> > ---
> >  drivers/infiniband/hw/mlx5/fs.c     | 2 +-
> >  drivers/infiniband/hw/mlx5/ib_rep.c | 2 +-
> >  drivers/infiniband/hw/mlx5/main.c   | 3 +--
> >  3 files changed, 3 insertions(+), 4 deletions(-)
> 
> Spelling error in the subject
> 

Will fix this up before I apply the series,

Thanks !


