Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA0D01E44EA
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 15:58:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389100AbgE0N6U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 09:58:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:52492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389091AbgE0N6S (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 May 2020 09:58:18 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 34134208C3;
        Wed, 27 May 2020 13:58:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590587897;
        bh=fFPA0K02yuhpsOujQX4dpnN+Uaj87fjy3IaWpkVclYw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZCayY+a4E0iLfsGRm0vArSZEoU+XvOnm7YS7OCAoYgjRR7IYRDhDof/6nVZu2ucuZ
         W2/N6lbgLzUugnD1g/aAfzGR52QhRz33CEVr5vIQo/D/hEjunkpka6tZVwSyCAaQzq
         HNiMlz9Pmsp/NBQKcYjqv6yvHQoh/DbQukAJvAQs=
Date:   Wed, 27 May 2020 16:58:13 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Max Gurtovoy <maxg@mellanox.com>
Cc:     jgg@mellanox.com, dledford@redhat.com, galpress@amazon.com,
        dennis.dalessandro@intel.com, netdev@vger.kernel.org,
        sagi@grimberg.me, linux-rdma@vger.kernel.org, bvanassche@acm.org,
        santosh.shilimkar@oracle.com, tom@talpey.com,
        aron.silverton@oracle.com, israelr@mellanox.com, oren@mellanox.com,
        shlomin@mellanox.com, vladimirk@mellanox.com
Subject: Re: [PATCH 1/9] RDMA/mlx5: Remove FMR leftovers
Message-ID: <20200527135813.GF349682@unreal>
References: <20200527094634.24240-1-maxg@mellanox.com>
 <20200527094634.24240-2-maxg@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200527094634.24240-2-maxg@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 27, 2020 at 12:46:26PM +0300, Max Gurtovoy wrote:
> From: Gal Pressman <galpress@amazon.com>
>
> Remove a few leftovers from FMR functionality which are no longer used.
>
> Signed-off-by: Gal Pressman <galpress@amazon.com>
> Signed-off-by: Max Gurtovoy <maxg@mellanox.com>
> ---
>  drivers/infiniband/hw/mlx5/mlx5_ib.h | 8 --------
>  1 file changed, 8 deletions(-)


Thanks,
Acked-by: Leon Romanovsky <leonro@mellanox.com>
