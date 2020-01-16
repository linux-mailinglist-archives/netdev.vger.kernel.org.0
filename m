Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F5FD13D4D8
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 08:11:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726950AbgAPHLP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 02:11:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:60830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726763AbgAPHLP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 02:11:15 -0500
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 08F5B20748;
        Thu, 16 Jan 2020 07:11:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579158674;
        bh=A8EA80uTPuqlXiUtdcZtHk3ZHXZxOHtF3/k5khPkt8w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NmZ5nCXlBfkmtl1h9LDyoQ1bKTrHn4kitotdm+hncijGtZCG2w539CKzgUkbghvvq
         23efY4wdDmiw+DeA7ZPDFyj4RvvpTCwdqKVPqjtEv/GZu1plR2/ga/uoULsnw7iVzM
         t/EFteRBhs1Y13rrsh9nW3rWf7WdOt5GL3syuZBo=
Date:   Thu, 16 Jan 2020 09:11:10 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     santosh.shilimkar@oracle.com
Cc:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        "David S . Miller" <davem@davemloft.net>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Hans Westgaard Ry <hans.westgaard.ry@oracle.com>,
        Moni Shoua <monis@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH mlx5-next 09/10] net/rds: Handle ODP mr
 registration/unregistration
Message-ID: <20200116071110.GE76932@unreal>
References: <20200115124340.79108-1-leon@kernel.org>
 <20200115124340.79108-10-leon@kernel.org>
 <3c479d8a-f98a-a4c9-bd85-6332e919bf35@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3c479d8a-f98a-a4c9-bd85-6332e919bf35@oracle.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 15, 2020 at 01:51:23PM -0800, santosh.shilimkar@oracle.com wrote:
> On 1/15/20 4:43 AM, Leon Romanovsky wrote:
> > From: Hans Westgaard Ry <hans.westgaard.ry@oracle.com>
> >
> > On-Demand-Paging MRs are registered using ib_reg_user_mr and
> > unregistered with ib_dereg_mr.
> >
> > Signed-off-by: Hans Westgaard Ry <hans.westgaard.ry@oracle.com>
> > Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
> > ---
>
> Have already reviewed this patchset on internal list. Couple of
> minor nits below o.w patch looks good to me.
>
> Acked-by: Santosh Shilimkar <santosh.shilimkar@oracle.com>

Thanks Santosh, Once, I'll figure the apply path for this series,
I will add extra lines while applying the patches.
