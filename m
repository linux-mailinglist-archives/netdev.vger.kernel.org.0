Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B03D5AD22A
	for <lists+netdev@lfdr.de>; Mon,  5 Sep 2022 14:12:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236854AbiIEMLS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Sep 2022 08:11:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236832AbiIEMLQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Sep 2022 08:11:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8CFF1D30A;
        Mon,  5 Sep 2022 05:11:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A0141B8113A;
        Mon,  5 Sep 2022 12:11:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 920BBC433C1;
        Mon,  5 Sep 2022 12:11:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662379873;
        bh=kkwiC/PJbBt/fd83WgK+R0SZL6IxSYt5SJKCAxCGSsI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nN/j9bDrOnbNwcU2lEjdLgsY6qYKWXKotM2ql3ysO62B8zPZEze2vINqc3I9YK08p
         TtNEqiB+yBPAPiUt8NVqv7+AkCY+hQdEF5jAs+sqoa4nvbnk4w6+7u8/xES4Om3P1R
         ihIdKR6XnD1K8PaWnf9BWOHVxbdL4bGa251Wm9Qf8SizTgyNmBef/NDrIegj847ai4
         urPR0lsLEI7PwAdZbNH7M5ZAsEbZ2ddeIJzc5UOUnpf2+ol9tJgCX8K8+FPooc4lzC
         /fQnxWNh7+gLUgEOrYUsMizbtroppXUvq834QWjrM7hIfl39DC+B4fVS42yoHMXjB1
         3FWz3ZOI5CjtQ==
Date:   Mon, 5 Sep 2022 15:11:09 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Chris Mi <cmi@nvidia.com>, Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Roi Dayan <roid@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [PATCH mlx5-next] RDMA/mlx5: Move function
 mlx5_core_query_ib_ppcnt() to mlx5_ib
Message-ID: <YxXnXZLeaQYBKCH8@unreal>
References: <fd47b9138412bd94ed30f838026cbb4cf3878150.1661763871.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fd47b9138412bd94ed30f838026cbb4cf3878150.1661763871.git.leonro@nvidia.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 29, 2022 at 12:06:04PM +0300, Leon Romanovsky wrote:
> From: Chris Mi <cmi@nvidia.com>
> 
> This patch doesn't change any functionality, but move one function
> to mlx5_ib because it is not used by mlx5_core.
> 
> The actual fix is in the next patch.
> 
> Reviewed-by: Roi Dayan <roid@nvidia.com>
> Signed-off-by: Chris Mi <cmi@nvidia.com>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> ---
>  drivers/infiniband/hw/mlx5/mad.c              | 25 +++++++++++++++++--
>  .../net/ethernet/mellanox/mlx5/core/port.c    | 23 -----------------
>  include/linux/mlx5/driver.h                   |  2 --
>  3 files changed, 23 insertions(+), 27 deletions(-)
> 

Thanks, applied.
