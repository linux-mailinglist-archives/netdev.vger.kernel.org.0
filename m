Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD7D9CF23E
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 07:47:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729813AbfJHFrQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 01:47:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:50004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729440AbfJHFrQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Oct 2019 01:47:16 -0400
Received: from localhost (unknown [77.137.89.37])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E227F206BB;
        Tue,  8 Oct 2019 05:47:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570513635;
        bh=UgEIBI9zXUfWqg45q7CP+3IkAq5jRlWev+EO20nspro=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LI4EGRG9MtQwdQlIv+ssiTiwjnli1lzsZ3VvHXuzMkDx5LnNy5GTGjmblprRPuyu8
         maQwUl83RKw2tWL0ltPN4e2RMKxx31st/d4aayHJvGekEyZFnUQdzv/3ndljK6kC8o
         d4fkvFRBbw+Iczs52HhiTDFNRpEa6bW2zTpqjZh4=
Date:   Tue, 8 Oct 2019 08:47:11 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Qing Huang <qing.huang@oracle.com>
Cc:     linux-rdma@vger.kernel.org, linux-netdev <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: Re: [PATCH] net/mlx5: Fixed a typo in a comment in esw_del_uc_addr()
Message-ID: <20191008054711.GC5855@unreal>
References: <20190921004928.24349-1-qing.huang@oracle.com>
 <20889bb7-0b36-831f-faa1-6bfe0e70dd94@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20889bb7-0b36-831f-faa1-6bfe0e70dd94@oracle.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 07, 2019 at 05:38:55PM -0700, Qing Huang wrote:
> I know this is not critical. Maybe someone can merge this or fix it with
> other commits? Thanks.

It is not "linux-rdma", but netdev. Your chances will be much higher if
you use get_maintainer.pl and put relevant mailing lists together with
maintainers in TO/CC parts of an email.

Saeed will return from vacation and will take it to his net-next part.

Thanks

>
> On 9/20/19 5:49 PM, Qing Huang wrote:
> > Changed "managerss" to "managers".
> >
> > Fixes: a1b3839ac4a4 ("net/mlx5: E-Switch, Properly refer to the esw manager vport")
> > Signed-off-by: Qing Huang <qing.huang@oracle.com>
> > ---
> >   drivers/net/ethernet/mellanox/mlx5/core/eswitch.c | 2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
> > index 81e03e4..48642b8 100644
> > --- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
> > +++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
> > @@ -530,7 +530,7 @@ static int esw_del_uc_addr(struct mlx5_eswitch *esw, struct vport_addr *vaddr)
> >   	u16 vport = vaddr->vport;
> >   	int err = 0;
> > -	/* Skip mlx5_mpfs_del_mac for eswitch managerss,
> > +	/* Skip mlx5_mpfs_del_mac for eswitch managers,
> >   	 * it is already done by its netdev in mlx5e_execute_l2_action
> >   	 */
> >   	if (!vaddr->mpfs || esw->manager_vport == vport)
