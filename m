Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D40DF3CC86F
	for <lists+netdev@lfdr.de>; Sun, 18 Jul 2021 12:38:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232358AbhGRKlI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Jul 2021 06:41:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:58394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230461AbhGRKlH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 18 Jul 2021 06:41:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7A106610D1;
        Sun, 18 Jul 2021 10:38:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626604689;
        bh=H/blmi1bcoaBh+CBZ8vsfGLxUAhzjxY/70q/vEpigzk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=E0i403PskP7q7iy1j1Um8HM64r8W3WeJgW7zAUWeO49frfywx0eNRyWw63v1ct3yr
         KttkixCQNpjDjEdWgFvyLdGRNUOW10UiJaJA/CL/POIyxJPLTWUZKDssYBs2iN3Xm+
         7X+LKVgetMyVn1mpmOJJgyeNHinp+VQlqpWnnnn9qoa1R4wH1wUJ3Fksu1r63sTkif
         6lhFnuNqKmcahpdyIM58VzZGH3lvkLXCQ06jvE9DQ+HYnbEK8znzN2j89SR4jxDjIU
         4ensedpSQeWehuN8KDL+D+OvIzQySyUsbPgmTYQ4T3kKb4tME8wa67Z35TSrS/NGEr
         5DvItXSlbVNuQ==
Date:   Sun, 18 Jul 2021 13:38:05 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org,
        Lior Nahmanson <liorna@nvidia.com>,
        Meir Lichtinger <meirl@nvidia.com>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [PATCH rdma-next v1 0/3] Add ConnectX DCS offload support
Message-ID: <YPQEjUIbviO74e6X@unreal>
References: <cover.1624258894.git.leonro@nvidia.com>
 <20210716154208.GA758521@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210716154208.GA758521@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 16, 2021 at 12:42:08PM -0300, Jason Gunthorpe wrote:
> On Mon, Jun 21, 2021 at 10:06:13AM +0300, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@nvidia.com>
> > 
> > Changelog:
> > v1:
> >  * Rephrase commit message of second patch
> > v0: https://lore.kernel.org/linux-rdma/cover.1622723815.git.leonro@nvidia.com
> > 
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
> Okay, can you update the shared branch?

Pushed, 96cd2dd65bb0 ("net/mlx5: Add DCS caps & fields support")

Thanks

> 
> Thanks,
> Jason
