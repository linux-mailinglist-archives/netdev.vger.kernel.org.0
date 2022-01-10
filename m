Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5494B48A0FB
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 21:34:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240007AbiAJUd7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 15:33:59 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:38672 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239773AbiAJUd7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jan 2022 15:33:59 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3E3A3B817D7
        for <netdev@vger.kernel.org>; Mon, 10 Jan 2022 20:33:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FA74C36AE9;
        Mon, 10 Jan 2022 20:33:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641846836;
        bh=Bou0mQW6qHU+EYixtW/T722sfdI5CjzwqS13w7n/5B8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=p3na2gd/voed2TfxRyY7FWwV0qkmRx5CJb/dQUetcsg5QMrAy4jnR538iYEp7IOU5
         smPD7CnYPgmSf/LPW3LwLQ+Q/Ad8VMrq3dAhYM/KvGqTNO5YaXo70WseXzllUKv/dH
         JNQCno/OCrfWM+kLu8v/3BqXTiPyfeEcIrd9hSIlrw0vFnse2e+kfAyQu01SfisXKb
         gAbtT9dnHFp3DYx+GsvMimoKpAM/wveA7y7jl4BVIZxZmPdR9Tp01HA1KSF0pc6UPs
         +fRXB4aY9DqIjNfWrcuxh4vQO85s4vBGer+2U8gSZOoiHRhAYqnPX26aqJfnb55YqW
         S8nBJmeOKrE+g==
Date:   Mon, 10 Jan 2022 12:33:54 -0800
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, saeedm@nvidia.com,
        leonro@nvidia.com, kernel test robot <lkp@intel.com>,
        Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH net-next] net/mlx5e: Fix build error in
 fec_set_block_stats()
Message-ID: <20220110203354.i7aovyaev77waha2@sx1>
References: <YdqsUj3UNmESqvOw@unreal>
 <20220109213321.2292830-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20220109213321.2292830-1-kuba@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 09, 2022 at 01:33:21PM -0800, Jakub Kicinski wrote:
>Build bot reports:
>
>drivers/net/ethernet/mellanox/mlx5/core/en_stats.c: In function 'fec_set_block_stats':
>drivers/net/ethernet/mellanox/mlx5/core/en_stats.c:1235:48: error: 'outl' undeclared (first use in this function); did you mean 'out'?
>    1235 |         if (mlx5_core_access_reg(mdev, in, sz, outl, sz, MLX5_REG_PPCNT, 0, 0))
>         |                                                ^~~~
>         |                                                out
>
>Reported-by: kernel test robot <lkp@intel.com>
>Suggested-by: Leon Romanovsky <leon@kernel.org>
>Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Thanks For handling ! I have no clue how this happened.
I will check and improve my process, I Know I've manually changed a patch
before submission, but i am sure i did it through my normal process.

Interestingly the series passed netdev/build_allmodconfig_warn.      
https://patchwork.kernel.org/project/netdevbpf/patch/20220107002956.74849-9-saeed@kernel.org/


