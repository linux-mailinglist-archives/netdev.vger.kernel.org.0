Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 309FA3A0950
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 03:34:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235958AbhFIBfs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 21:35:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:35780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235919AbhFIBfq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Jun 2021 21:35:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 272CC61208;
        Wed,  9 Jun 2021 01:33:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623202432;
        bh=v156cAft9LyaIoQEz4RJ53s9TOtRVo94rIr9C4Gt/S0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=ZDdVMHcebRQRJXL2EjGMYHZ+KFW0qzjqGMOna1/+HD1mMaDNlCXxKv2eCtwyHz0Fy
         armkRNmqRMF965QVfNDxLj1VgopMvcgYL5Kcnk3mQVpYmRlj6c/DBCrymK3JbqNNTZ
         dxwtJKnr1UTdQWt9uOVEYQkvr959w2QjF72iJ70GPDgceqjt5KqH2Khs0Z74/tPnYi
         we+idD+gy8uEmrMekaSH5z7lYL6mRu6L6oeN+zE5Nqq+cP3xsoLgP+thIgXM79M3/F
         3+sFQijB7hC08mSsDRXARm92O7/KzawF4fTcilL9JzO4j0bXWOGZRVMApCj9iiijno
         rHxnVyyNUdErQ==
Message-ID: <1190c96c38df650d7fdf3aa6d12674359ad16e51.camel@kernel.org>
Subject: Re: [PATCH v2] net/mlx5e: Fix an error code in
 mlx5e_arfs_create_tables()
From:   Saeed Mahameed <saeed@kernel.org>
To:     Yang Li <yang.lee@linux.alibaba.com>
Cc:     leon@kernel.org, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Tue, 08 Jun 2021 18:33:51 -0700
In-Reply-To: <1622801307-34745-1-git-send-email-yang.lee@linux.alibaba.com>
References: <1622801307-34745-1-git-send-email-yang.lee@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.1 (3.40.1-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2021-06-04 at 18:08 +0800, Yang Li wrote:
> When the code execute 'if (!priv->fs.arfs->wq)', the value of err is
> 0.
> So, we use -ENOMEM to indicate that the function
> create_singlethread_workqueue() return NULL.
> 
> Clean up smatch warning:
> drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c:373
> mlx5e_arfs_create_tables() warn: missing error code 'err'.
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Fixes: f6755b80d693 ("net/mlx5e: Dynamic alloc arfs table for netdev
> when needed")
> Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
> ---
> 
> Changes in v2:
> --According to Saeed's suggestion, we modify the format of Fixes tag,
> --and initialize err to -ENOMEM.
> https://lore.kernel.org/patchwork/patch/1440018/
> 

applied to net-mlx5.

thanks !

