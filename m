Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 640D424171F
	for <lists+netdev@lfdr.de>; Tue, 11 Aug 2020 09:25:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728064AbgHKHZg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Aug 2020 03:25:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:33734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727852AbgHKHZf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 Aug 2020 03:25:35 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B42E520656;
        Tue, 11 Aug 2020 07:25:34 +0000 (UTC)
Date:   Tue, 11 Aug 2020 10:25:30 +0300
From:   Leon Romanovsky <leonro@nvidia.com>
To:     Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@gmail.com>
Cc:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        linux-netdev <netdev@vger.kernel.org>,
        RDMA mailing list <linux-rdma@vger.kernel.org>
Subject: Re: [PATCH iproute2-rc] rdma: Fix owner name for the kernel resources
Message-ID: <20200811072530.GA634816@unreal>
References: <20200811063304.581395-1-leon@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200811063304.581395-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 11, 2020 at 09:33:04AM +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
>
> Owner of kernel resources is printed in different format than user
> resources to easy with the reader by simply looking on the name.
> The kernel owner will have "[ ]" around the name.
>
> Before this change:
> [leonro@vm ~]$ rdma res show qp
> link rocep0s9/1 lqpn 1 type GSI state RTS sq-psn 58 comm ib_core
>
> After this change:
> [leonro@vm ~]$ rdma res show qp
> link rocep0s9/1 lqpn 1 type GSI state RTS sq-psn 58 comm [ib_core]
>
> Fixes: b0a688a542cd ("rdma: Rewrite custom JSON and prints logic to use common API")
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> ---
>  rdma/res.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Please drop this patch, I'll send another version with extra fix.

Thanks
