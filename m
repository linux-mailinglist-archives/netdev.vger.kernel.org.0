Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB77E4761A1
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 20:23:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238837AbhLOTXW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 14:23:22 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:44762 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234497AbhLOTXW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Dec 2021 14:23:22 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ED4E861A5E;
        Wed, 15 Dec 2021 19:23:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 210AFC36AE3;
        Wed, 15 Dec 2021 19:23:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639596201;
        bh=VHkvd2c2/Toz6BdzBuDxCoXCX/NXTx+fcygy0BcBFkk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=APONJEcO4gpFrWtKD6M+/u9tYoDOpjZTWz2boix3fd64pkpBvbK5pQwMFHs2WGT/W
         xajxBiTDRGIycYHTfSFsWBc163xf6pu6SVeTUHIeGrbyLBwp5cbKyM3vsB6VzcTFAI
         SUMFVgAw3LdF6g1/tICqwUxfaHFXGwp/H7ME5ikrdvwz3/phts+DrZqp4dbdyMSJdG
         j4Vfxj9M7HUKwcibW0yY8/13PX/qBgpP0amx340c0rK7U29kU5ipt/xf/VwzUBggfa
         ejf6S8u2fnFVmsCTEPxXTJTDrOzwVGdjqpcf9VqcR63XM3dYyx6Z73zQ7jjBrp6OT5
         0iSYbXcaPr8YA==
Date:   Wed, 15 Dec 2021 11:23:19 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [pull-request] mlx5-next branch 2021-12-15
Message-ID: <20211215112319.44d7daea@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211215184945.185708-1-saeed@kernel.org>
References: <20211215184945.185708-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 15 Dec 2021 10:49:45 -0800 Saeed Mahameed wrote:
> This pulls mlx5-next branch into net-next and rdma branches.
> All patches already reviewed on both rdma and netdev mailing lists.
> 
> Please pull and let me know if there's any problem.
> 
> 1) Add multiple FDB steering priorities [1]
> 2) Introduce HW bits needed to configure MAC list size of VF/SF.
>    Required for ("net/mlx5: Memory optimizations") upcoming series [2].

Why are you not posting the patches?
