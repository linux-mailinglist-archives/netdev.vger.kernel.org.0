Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E2976C45DB
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 10:12:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229836AbjCVJML (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 05:12:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229826AbjCVJMK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 05:12:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4304E5F510;
        Wed, 22 Mar 2023 02:11:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DC67561FCA;
        Wed, 22 Mar 2023 09:11:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1996C4339B;
        Wed, 22 Mar 2023 09:11:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679476300;
        bh=EvlfZcTxqy9qPXxo4PhPRiUzIho1Q85SM6eI5HhTj0I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DA0Lgp/br+pVlUpSmFdrx3vwY3NUCPXGEbrq0Aqv5Nh5Ofa5XAm/h84Aa9tvbkfJM
         iQMnvSgCxjQa7BPvJV+na7WGt1JneGH7D0jlFRetvC6E9Nr/oV0UMzFSWQhttHbNbE
         2XiZIez2SvL4KsknKQUNWu28hGpQG+Z6XuzPq6uyDM2Fs4jfruHE4IEbgS8TEVYflp
         aicYLj6dPVfAlYC1allLHuWS820IjZKhidCpk4foBs2Vqi3zIGNufdmgrfy6V9E+Mz
         EcF+otwaUosR6q/ycOQ8F17LW0yj2B1WJ7BZN3CT0Gx1kkX6fXx3Ma0sfsO5OCdOBS
         An7gDqxngQFvw==
Date:   Wed, 22 Mar 2023 11:11:35 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        Michael Guralnik <michaelgur@nvidia.com>,
        netdev@vger.kernel.org, Patrisious Haddad <phaddad@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [PATCH rdma-next 0/2] Add Q-counters for representors
Message-ID: <20230322091135.GY36557@unreal>
References: <cover.1678974109.git.leon@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1678974109.git.leon@kernel.org>
X-Spam-Status: No, score=-2.7 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SORTED_RECIPS,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 16, 2023 at 03:45:19PM +0200, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> The following series from Patrisious exports iVF representors counters
> to be visible by the host.
> 
> Thanks
> 
> Patrisious Haddad (2):
>   net/mlx5: Introduce other vport query for Q-counters
>   RDMA/mlx5: Expand switchdev Q-counters to expose representor
>     statistics

This patch needs to be resent, so I'm dropping the series from patchworks.

Thanks

> 
>  drivers/infiniband/hw/mlx5/counters.c | 161 ++++++++++++++++++++++----
>  include/linux/mlx5/mlx5_ifc.h         |  13 ++-
>  2 files changed, 146 insertions(+), 28 deletions(-)
> 
> -- 
> 2.39.2
> 
