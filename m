Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58A1F2C8D21
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 19:45:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729807AbgK3SnT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 13:43:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:38236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727626AbgK3SnS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Nov 2020 13:43:18 -0500
Received: from sx1.lan (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 97BD220705;
        Mon, 30 Nov 2020 18:42:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606761758;
        bh=TSFFLJyXinr1+4oL2dcIJXHym4p28r2juv1sHPPLIwo=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=YzPHM4hXLLWgBs0KdWFe5DJogHlhjAD6C9G6AqeBUuFW+As85Kje1eKSsqA9bE0Xh
         kGiN7jtQVghOKywheOCkKtX5Kqz+fgH1bsnRImu72r+R5+1JY8xjHX1WZrHQeRCPtv
         hHbKF+EGIXZfYDn6o3e8+gB4QRdobfvzdq9vJs0g=
Message-ID: <856d27ae16ecb22cbc8e6db7d22da6887c92cf3a.camel@kernel.org>
Subject: Re: [PATCH mlx5-next 00/16] mlx5 next updates 2020-11-20
From:   Saeed Mahameed <saeed@kernel.org>
To:     Leon Romanovsky <leonro@mellanox.com>
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>
Date:   Mon, 30 Nov 2020 10:42:36 -0800
In-Reply-To: <20201120230339.651609-1-saeedm@nvidia.com>
References: <20201120230339.651609-1-saeedm@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2020-11-20 at 15:03 -0800, Saeed Mahameed wrote:
> Hi,
> 
> This series includes trivial updates to mlx5 next branch
> 1) HW definition for upcoming features
> 2) Include files and general Cleanups
> 3) Add the upcoming BlueField-3 device ID
> 4) Define flow steering priority for VDPA
> 5) Export missing steering API for ULPs,
>    will be used later in VDPA driver, to create flow steering domain
> for
>    VDPA queues.
> 6) ECPF (Embedded CPU Physical function) minor improvements for
> BlueField.
> 

Series applied to mlx5-next without the VDPA patch.

Jakub, please let me know if you still have concerns regarding that
patch, i will eventually need to apply it, regardless of the outcome of
the RDMA vs ETH discussion, it is just how we configure the HW :).

Thanks,
Saeed.


