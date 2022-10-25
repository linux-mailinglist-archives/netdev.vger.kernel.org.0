Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB38560C299
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 06:27:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229894AbiJYE1c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 00:27:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229717AbiJYE1b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 00:27:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C67F1786E1
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 21:27:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4583461733
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 04:27:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C959C433D6;
        Tue, 25 Oct 2022 04:27:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666672049;
        bh=yzq7I1gp0jj4R01B5O60zdZSeCYOs3HplNfsF9ajjvc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=RB0hdk2PzTZxnQgID44XU/MNu6LEMEOivRSohrvwrBFN2g3o3s9J3o3755bYR+1th
         4yrOc67rMO+M5dMCLjViHpkM5zRR/JhCfvtQwkHA4k8dRGDhAbpIKq/dtd+n8Pgeai
         MxO8wR0xMbBQDV40DvUG6Zbpo5+l18MPjHukU5PNSFzurI66wz+wPNyCEXmufviI3e
         QI/LJZ6b+h2pLgWGu8a0ua0Jx7zuvXZUAkLdgsLulkTMJe/Zx2vqkA3nOfgBWoeJBc
         8IiXvKRWWPqZhwmcnsY0YUMbc/+E39tQTmsDH46uwOI+K4eK0r1HE9KpqUW90IaMYF
         KUSG/bM9wawcA==
Date:   Mon, 24 Oct 2022 21:27:28 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Shay Drory <shayd@nvidia.com>, Parav Pandit <parav@nvidia.com>
Subject: Re: [V3 net 09/16] net/mlx5: SF: Fix probing active SFs during
 driver probe phase
Message-ID: <20221024212728.7cdd879b@kernel.org>
In-Reply-To: <20221024115357.37278-10-saeed@kernel.org>
References: <20221024115357.37278-1-saeed@kernel.org>
        <20221024115357.37278-10-saeed@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 24 Oct 2022 12:53:50 +0100 Saeed Mahameed wrote:
> From: Shay Drory <shayd@nvidia.com>
> 
> When SF devices and SF port representors are located on different
> functions, unloading and reloading of SF parent driver doesn't recreate
> the existing SF present in the device.
> Fix it by querying SFs and probe active SFs during driver probe phase.
> 
> Fixes: 90d010b8634b ("net/mlx5: SF, Add auxiliary device support")
> Signed-off-by: Shay Drory <shayd@nvidia.com>
> Reviewed-by: Parav Pandit <parav@nvidia.com>
> Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>

Does not build cleanly, I thought v1 built :S

drivers/net/ethernet/mellanox/mlx5/core/sf/dev/dev.c:287:6: warning: no previous prototype for function 'mlx5_sf_dev_destroy_active_work' [-Wmissing-prototypes]
void mlx5_sf_dev_destroy_active_work(struct mlx5_sf_dev_table *table)
     ^
