Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B5D33D07D3
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 06:35:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232359AbhGUDyW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 23:54:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:40868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232029AbhGUDyJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Jul 2021 23:54:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 68BD460720;
        Wed, 21 Jul 2021 04:34:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626842082;
        bh=KRpsVI65gthj5QDGSh4UubthxVcYYxACPtmwB+Chn0A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=paMtprHbspYLEbLKub2xy49Jt5N2aLiSMWhhypTnnMkmFlHhfD/tp57H0SoiW8glF
         I5K55rQ8EgOLEBebiETceYs7jFQHTnlq2kZwb2dzjgK1WLkfbVbgsvEzwFoY6I/8i1
         r/7cmFYEBlp4tgR3UbU5R9sJOLZWAiqXoWP6hPLTYlDxnj9gyKOZzersa4PMeSxO3g
         wkYqWNqvNtXVE8jRFyVt3kDP5w4n2AZZGSyfovsSGWr6/Ir44d/3CekAprP4RFUXeE
         ERlIvis1ewsnCESiZ1iBx1BWeHAjw533sK6H7+7Q0YCmXbY2eVJ2e45lWWAppUFo5X
         jUfdUnCCsgMwg==
Date:   Wed, 21 Jul 2021 07:34:38 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org,
        Lior Nahmanson <liorna@nvidia.com>,
        Meir Lichtinger <meirl@nvidia.com>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [PATCH rdma-next v1 0/3] Add ConnectX DCS offload support
Message-ID: <YPej3g4x8cv7lHhN@unreal>
References: <cover.1624258894.git.leonro@nvidia.com>
 <20210720181848.GA1207526@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210720181848.GA1207526@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 20, 2021 at 03:18:48PM -0300, Jason Gunthorpe wrote:
> On Mon, Jun 21, 2021 at 10:06:13AM +0300, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@nvidia.com>
> > 
> > Changelog:
> > v1:
> >  * Rephrase commit message of second patch
> > v0: https://lore.kernel.org/linux-rdma/cover.1622723815.git.leonro@nvidia.com
> > 
> > ------------
> > 
> > This patchset from Lior adds support of DCI stream channel (DCS) support.
> > 
> > DCS is an offload to SW load balancing of DC initiator work requests.
> > 
> > A single DC QP initiator (DCI) can be connected to only one target at the time
> > and can't start new connection until the previous work request is completed.
> > 
> > This limitation causes to delays when the initiator process needs to
> > transfer data to multiple targets at the same time.
> > 
> > Thanks
> > 
> > Lior Nahmanson (3):
> >   net/mlx5: Add DCS caps & fields support
> >   RDMA/mlx5: Separate DCI QP creation logic
> >   RDMA/mlx5: Add DCS offload support
> 
> Applied to for-next, thanks

Jason,

You forgot to push this to the RDMA tree.

Thanks

> 
> Jason
