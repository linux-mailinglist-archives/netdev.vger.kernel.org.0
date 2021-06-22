Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A14BB3AFD26
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 08:42:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229890AbhFVGo0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 02:44:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:39154 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229490AbhFVGo0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Jun 2021 02:44:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4141E611CE;
        Tue, 22 Jun 2021 06:42:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624344130;
        bh=SPHRwKPwX5XqFVogsKZHFX2w/txyPzLAkf8PWFlX9EU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Xux4vycETZ6uLKrP90yUOJk9mDP+27Jic5pL1dc7w+O+nMmey5qUIMHLpX5xbs2L2
         3qVFz3QtpCFW2+0w/nZGhbHlI2uqAXAHKHQNFP+mXi2sAbCm6ci7jEhsL3mHm2DG8D
         PI3gnUYZyUcwcPMFkxysX+DNyc35Roh6jBZ/jB6mit58TavC008qUsBSX83w0UA97s
         VN8ENQPWJg2ac1WjEnOMGSs0M/UQ+asUZVb0k77myAI0Ef1HsKt0LoitVcurzuqYud
         xh1qdgMp+ryk0svnljP5MLZXWXfVQOgJEp5t8Tg5SNBexB9u/7bwTkE4/ghas+wYFY
         HRr8892tCAu6w==
Date:   Tue, 22 Jun 2021 09:42:07 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Doug Ledford <dledford@redhat.com>,
        Aharon Landau <aharonl@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-rdma@vger.kernel.org,
        Maor Gottlieb <maorg@nvidia.com>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [PATCH rdma-next 0/2] Provide already supported real-time
 timestamp
Message-ID: <YNGGP3KMwYJ5lFz5@unreal>
References: <cover.1623829775.git.leonro@nvidia.com>
 <20210621233734.GA2363796@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210621233734.GA2363796@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 21, 2021 at 08:37:34PM -0300, Jason Gunthorpe wrote:
> On Wed, Jun 16, 2021 at 10:57:37AM +0300, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@nvidia.com>
> > 
> > In case device supports only real-time timestamp, the kernel will
> > fail to create QP despite rdma-core requested such timestamp type.
> > 
> > It is because device returns free-running timestamp, and the conversion
> > from free-running to real-time is performed in the user space.
> > 
> > This series fixes it, by returning real-time timestamp.
> > 
> > Thanks
> > 
> > Aharon Landau (2):
> >   RDMA/mlx5: Refactor get_ts_format functions to simplify code
> >   RDMA/mlx5: Support real-time timestamp directly from the device
> 
> This looks fine, can you update the shared branch please

9a1ac95a59d0 RDMA/mlx5: Refactor get_ts_format functions to simplify code

Applied, thanks

> 
> Jason
