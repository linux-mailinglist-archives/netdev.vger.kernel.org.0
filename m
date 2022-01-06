Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1B58485F60
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 04:51:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231617AbiAFDvl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 22:51:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbiAFDvl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 22:51:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9587C061245;
        Wed,  5 Jan 2022 19:51:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D5DA4619C9;
        Thu,  6 Jan 2022 03:51:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC2CCC36AE5;
        Thu,  6 Jan 2022 03:51:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641441099;
        bh=9wjdD8DktMiHwFCByDt1jEtaoOIoudB5LfFrXfuJPWk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uxIxRxev6pngubEOx8bvjMx6ULmreRX8zUBPL0ZJEcBH9tUcLNVFx5CiVXoUr91uz
         9e6s0NqxrSGiVVGaSVtfI5AL1cdWq7BPVyt0zaF3V4v6IIe61/IV5wpgkzboiFED+s
         nj6qjA6m6rzCLOByRS4NLpqbL1kMf4ZM/AkDjIp0hWoXXz4rZJRtjM89W/8ajyZ9zS
         R7LMutwt9xIyYsLSxN0lmdc/yg2VbyOpjAfDwqNSLynlK2JhGzTgbpM80fgIMJMIPJ
         4Pd8RVwmml20TpcTvLni+RU2YvBGu7mBx+i7NGcooQhz3NW8wTuLL7iaTI/hLckmMf
         aW0oBoVfDmdvQ==
Date:   Wed, 5 Jan 2022 19:51:37 -0800
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc:     saeedm@nvidia.com, leon@kernel.org, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        Abaci Robot <abaci@linux.alibaba.com>
Subject: Re: [PATCH] net/mlx5e: Fix missing error code in
 mlx5e_rx_reporter_err_icosq_cqe_recover()
Message-ID: <20220106035137.wwfpxejblgbpw66w@sx1>
References: <20220105151751.40723-1-jiapeng.chong@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20220105151751.40723-1-jiapeng.chong@linux.alibaba.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 05, 2022 at 11:17:51PM +0800, Jiapeng Chong wrote:
>The error code is missing in this code scenario, add the error code
>'-EINVAL' to the return value 'err'.
>
>Eliminate the follow smatch warning:
>
>drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c:91
>mlx5e_rx_reporter_err_icosq_cqe_recover() warn: missing error code
>'err'.
>

error code is not missing, err is equal to 0 at this point and the 
code aborts with err = 0 as intended. False alarm. nack.


