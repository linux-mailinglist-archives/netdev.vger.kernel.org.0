Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F4F39FB23
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 09:06:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726322AbfH1HGZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 03:06:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:41730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726210AbfH1HGZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Aug 2019 03:06:25 -0400
Received: from localhost (unknown [77.137.115.125])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1E22922CF5;
        Wed, 28 Aug 2019 07:06:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566975984;
        bh=pxuO5tHRnu4YHjvFXoyyh17RBdMMQaQJo7orI5lxm8o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hx5PDjeD1jJDOji3lEz1S4i/2+I4ZnZMbL8JbCEMFXqjOEGORK724+5w3mCxaCQnf
         XRc20gHTRqMAnpF3noqhKoj28wCmBo4OyQm4S5PvO2EfdN0xP/g0JPIdT1ueEOAWnD
         EKUJXGoo3v8CteCfF1PHnKJZC+C2q8j/8yDoPtlY=
Date:   Wed, 28 Aug 2019 10:06:20 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Doug Ledford <dledford@redhat.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Michael Guralnik <michaelgur@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH rdma-next v3 0/3] ODP support for mlx5 DC QPs
Message-ID: <20190828070620.GD4725@mtr-leonro.mtl.com>
References: <20190819120815.21225-1-leon@kernel.org>
 <20190827155140.GA15153@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190827155140.GA15153@ziepe.ca>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 27, 2019 at 12:51:40PM -0300, Jason Gunthorpe wrote:
> On Mon, Aug 19, 2019 at 03:08:12PM +0300, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@mellanox.com>
> >
> > Changelog
> >  v3:
> >  * Rewrote patches to expose through DEVX without need to change mlx5-abi.h at all.
> >  v2: https://lore.kernel.org/linux-rdma/20190806074807.9111-1-leon@kernel.org
> >  * Fixed reserved_* field wrong name (Saeed M.)
> >  * Split first patch to two patches, one for mlx5-next and one for  rdma-next. (Saeed M.)
> >  v1: https://lore.kernel.org/linux-rdma/20190804100048.32671-1-leon@kernel.org
> >  * Fixed alignment to u64 in mlx5-abi.h (Gal P.)
> >  v0: https://lore.kernel.org/linux-rdma/20190801122139.25224-1-leon@kernel.org
> >
> > >From Michael,
> >
> > The series adds support for on-demand paging for DC transport.
> >
> > As DC is mlx-only transport, the capabilities are exposed
> > to the user using DEVX objects and later on through mlx5dv_query_device.
> >
> > Thanks
> >
> > Michael Guralnik (3):
> >   net/mlx5: Set ODP capabilities for DC transport to max
> >   IB/mlx5: Remove check of FW capabilities in ODP page fault handling
> >   IB/mlx5: Add page fault handler for DC initiator WQE
>
> This seems fine, can you put the commit on the shared branch?

Thanks, applied to mlx5-next
00679b631edd net/mlx5: Set ODP capabilities for DC transport to max

>
> Thanks,
> Jason
