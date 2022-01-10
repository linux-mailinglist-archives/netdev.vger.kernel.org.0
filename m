Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 982B448A108
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 21:42:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241781AbiAJUmQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 15:42:16 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:41578 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241494AbiAJUmQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jan 2022 15:42:16 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2408FB81642
        for <netdev@vger.kernel.org>; Mon, 10 Jan 2022 20:42:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94BB4C36AE3;
        Mon, 10 Jan 2022 20:42:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641847333;
        bh=Gy83b4LyJ3IwjvnS87TQGrhJvuSqqT0PxyVo1WIJYYo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ZWJYEn+iYIzl/lciDj1DEkIgk+StNZ4iWxqB/dARiMAp5/H4/OxY79lOU/HEcLSt+
         hIgyGccPQ4iHhyifSDF3o2LauVV091TO2P55OTy5u5+ohsP4uarMQKmUEuO+fiNoAh
         cGY3qsd8m5VH4vxmeKNgUYMJh5dhIz70UM0r8+iQXBpeHKqrBSp5CUUuOjjGkp3Zkh
         S/A0oO6f8svexj8/aPXIh8m1cHPEs1CpnyFWu4pHa4mskpY462d63fzmQ+3A/uD25I
         Q0qqtOnNPxe33gsqnUgtzlmHuzOX4RNlPZPtDWvVRkbvSfkbiOyS4aQ9tZNuqM5Fi+
         57eZVGEDt2fNQ==
Date:   Mon, 10 Jan 2022 12:42:12 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, saeedm@nvidia.com,
        leonro@nvidia.com, kernel test robot <lkp@intel.com>,
        Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH net-next] net/mlx5e: Fix build error in
 fec_set_block_stats()
Message-ID: <20220110124212.2190d75c@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220110203354.i7aovyaev77waha2@sx1>
References: <YdqsUj3UNmESqvOw@unreal>
        <20220109213321.2292830-1-kuba@kernel.org>
        <20220110203354.i7aovyaev77waha2@sx1>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 10 Jan 2022 12:33:54 -0800 Saeed Mahameed wrote:
> On Sun, Jan 09, 2022 at 01:33:21PM -0800, Jakub Kicinski wrote:
> >Build bot reports:
> >
> >drivers/net/ethernet/mellanox/mlx5/core/en_stats.c: In function 'fec_set_block_stats':
> >drivers/net/ethernet/mellanox/mlx5/core/en_stats.c:1235:48: error: 'outl' undeclared (first use in this function); did you mean 'out'?
> >    1235 |         if (mlx5_core_access_reg(mdev, in, sz, outl, sz, MLX5_REG_PPCNT, 0, 0))
> >         |                                                ^~~~
> >         |                                                out
> >
> >Reported-by: kernel test robot <lkp@intel.com>
> >Suggested-by: Leon Romanovsky <leon@kernel.org>
> >Signed-off-by: Jakub Kicinski <kuba@kernel.org>  
> 
> Thanks For handling ! I have no clue how this happened.
> I will check and improve my process, I Know I've manually changed a patch
> before submission, but i am sure i did it through my normal process.
> 
> Interestingly the series passed netdev/build_allmodconfig_warn.      
> https://patchwork.kernel.org/project/netdevbpf/patch/20220107002956.74849-9-saeed@kernel.org/

And it built just fine for me as well with allmodconfig.

LMK if you figure out why, that's really strange.
