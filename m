Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22A66624023
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 11:39:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230265AbiKJKjx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 05:39:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230264AbiKJKjk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 05:39:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEB896A69F
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 02:39:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CE6D061229
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 10:39:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD7C0C433D6;
        Thu, 10 Nov 2022 10:39:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668076743;
        bh=UdrAFpqAUGJu5JwZaMfMz+ZSHELxuegs3lgWKN72OdM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Rwk3mWyA1JYleaiahh6tbYkxwUfv/k3sctqJL2gjzyrAeSb0Ek5SBHVhEJzrx0cmG
         gZNybPsT7+yxDXhQGEuVwLfq9LW+oHa452RqR7AlJHY+UJKl8Jj5sJ82CKMiaCYFM4
         F9mqDb9wge8J+saLrlQbKfAy1l2p7/ac3iTWi8N4s+acZ59kkw3NJukcRe3R6moyvH
         PgXSE6dn6wDnb+E1dYwAQAUxXzjPt8dXzdPvzT+DdESfufFH+lSAcW6tXaEcN3znGT
         JyTCCEmCDoc56kvVxC7fPptYcI05sNOpq9+9PoEfBlAi1UP/4YC4QpTKUWRi2XbpMY
         ZiSTHUw7zoxZQ==
Date:   Thu, 10 Nov 2022 12:38:58 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Zhengchao Shao <shaozhengchao@huawei.com>
Cc:     netdev@vger.kernel.org, dchickles@marvell.com, sburla@marvell.com,
        fmanlunas@marvell.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, richardcochran@gmail.com,
        rvatsavayi@caviumnetworks.com, gregkh@linuxfoundation.org,
        tseewald@gmail.com, weiyongjun1@huawei.com, yuehaibing@huawei.com
Subject: Re: [PATCH net v2] net: liquidio: release resources when liquidio
 driver open failed
Message-ID: <Y2zUwncZudQKI3t1@unreal>
References: <20221110103037.133791-1-shaozhengchao@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221110103037.133791-1-shaozhengchao@huawei.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 10, 2022 at 06:30:37PM +0800, Zhengchao Shao wrote:
> When liquidio driver open failed, it doesn't release resources. Compile
> tested only.
> 
> Fixes: 5b07aee11227 ("liquidio: MSIX support for CN23XX")
> Fixes: dbc97bfd3918 ("net: liquidio: Add missing null pointer checks")
> Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
> ---
> v2: simplify "if" judgment statements
> ---
>  .../net/ethernet/cavium/liquidio/lio_main.c   | 34 ++++++++++++++-----
>  1 file changed, 26 insertions(+), 8 deletions(-)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
