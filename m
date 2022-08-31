Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E37485A769D
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 08:30:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230282AbiHaGae (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 02:30:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230245AbiHaGaZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 02:30:25 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2185A61105
        for <netdev@vger.kernel.org>; Tue, 30 Aug 2022 23:30:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id EC0A8CE1F29
        for <netdev@vger.kernel.org>; Wed, 31 Aug 2022 06:30:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1F2F9C43144;
        Wed, 31 Aug 2022 06:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661927418;
        bh=w2nRO8S5lAAB08UKFtKgpzZwyJuw2fJUEOsXBRC8aeQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=tmX527bj7O6dAdN+2o8YbYhOTNadNjx8EB7dz+Y8MqMc+R/i6NyTvyy4niibC7VGm
         zsMpsRBu0+I0BOlpqCcD633V/64ko0zBagNqOXwVldY4t/5VqRPIw25xCXbvIqkVng
         BsAzM60D9Nhwp/1evnVqWnNOYYcJya2r2kKShVuOIOeq797E6NjVNJePwnaUyS9W1A
         qri9m/hJKba6U45f5O0WjQRg8Zzn0VIb8jX7CPXF0+7E+FZm00wC24AZ85UpCVsCCv
         X+Dul70ZI7NFP3ZkzdZoC1OgncMM527k450eBMPSy6POl+NzIQ0/88bsR/EcZrrkmv
         TutyPCVpRzmyQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0708FE924DB;
        Wed, 31 Aug 2022 06:30:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 1/1] net/mlx5e: Fix returning uninitialized err
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166192741801.4297.11235357997305730538.git-patchwork-notify@kernel.org>
Date:   Wed, 31 Aug 2022 06:30:18 +0000
References: <20220830122024.2900197-1-roid@nvidia.com>
In-Reply-To: <20220830122024.2900197-1-roid@nvidia.com>
To:     Roi Dayan <roid@nvidia.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, saeedm@nvidia.com,
        maord@nvidia.com, alexandr.lobakin@intel.com,
        dan.carpenter@oracle.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 30 Aug 2022 15:20:24 +0300 you wrote:
> In the cited commit the function mlx5e_rep_add_meta_tunnel_rule()
> was added and in success flow, err was returned uninitialized.
> Fix it.
> 
> Fixes: 430e2d5e2a98 ("net/mlx5: E-Switch, Move send to vport meta rule creation")
> Reported-by: Alexander Lobakin <alexandr.lobakin@intel.com>
> Signed-off-by: Roi Dayan <roid@nvidia.com>
> Reviewed-by: Maor Dickman <maord@nvidia.com>
> 
> [...]

Here is the summary with links:
  - [net-next,1/1] net/mlx5e: Fix returning uninitialized err
    https://git.kernel.org/netdev/net-next/c/92f97c00f0ca

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


