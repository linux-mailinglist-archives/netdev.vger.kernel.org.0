Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B3E221342C
	for <lists+netdev@lfdr.de>; Fri,  3 Jul 2020 08:28:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726365AbgGCG2O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jul 2020 02:28:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:41830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726347AbgGCG2N (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 Jul 2020 02:28:13 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 32D3320772;
        Fri,  3 Jul 2020 06:28:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593757692;
        bh=57k3H5N/CoCyneU8xje2Gdy9cNE/mU+s8od4ztCbvj4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sCnqUW+Z7wqN9ZERHApQrmABBYmapyCsLNkaH4yNkk/HhmRUFcds5rOiba/amZf3H
         STwxooyjFcVgKDTLGLsyjdRmT+hGO1cSA2AkOH+PjQV4j2wteUMhsDAMZWQShN2jmI
         bWt++1YZ54KgS2XKUj++k2qg63cwki79fmsDx3JY=
Date:   Fri, 3 Jul 2020 09:28:09 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Doug Ledford <dledford@redhat.com>,
        Feras Daoud <ferasda@mellanox.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-rdma@vger.kernel.org,
        Michael Guralnik <michaelgur@mellanox.com>,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>
Subject: Re: [PATCH rdma-next 0/2] Create IPoIB QP with specific QP number
Message-ID: <20200703062809.GG4837@unreal>
References: <20200623110105.1225750-1-leon@kernel.org>
 <20200702175541.GA721759@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200702175541.GA721759@nvidia.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 02, 2020 at 02:55:41PM -0300, Jason Gunthorpe wrote:
> On Tue, Jun 23, 2020 at 02:01:03PM +0300, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@mellanox.com>
> >
> > >From Michael,
> >
> > This series handles IPoIB child interface creation with setting
> > interface's HW address.
> >
> > In current implementation, lladdr requested by user is ignored and
> > overwritten. Child interface gets the same GID as the parent interface
> > and a QP number which is assigned by the underlying drivers.
> >
> > In this series we fix this behavior so that user's requested address is
> > assigned to the newly created interface.
> >
> > As specific QP number request is not supported for all vendors, QP
> > number requested by user will still be overwritten when this is not
> > supported.
> >
> > Behavior of creation of child interfaces through the sysfs mechanism or
> > without specifying a requested address, stays the same.
> >
> > Thanks
> >
> > Michael Guralnik (2):
> >   net/mlx5: Enable QP number request when creating IPoIB underlay QP
> >   RDMA/ipoib: Handle user-supplied address when creating child
>
> Applied to for-next, thanks

Thanks Jason,

Won't it better that first patch be applied to mlx5-next in order to
avoid possible merge conflicts?

Thanks

>
> Jason
