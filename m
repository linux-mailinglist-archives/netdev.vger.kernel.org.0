Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 542AB4E49DB
	for <lists+netdev@lfdr.de>; Wed, 23 Mar 2022 01:00:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240818AbiCWABm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Mar 2022 20:01:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbiCWABl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Mar 2022 20:01:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47F4B1FA65
        for <netdev@vger.kernel.org>; Tue, 22 Mar 2022 17:00:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4988F612F5
        for <netdev@vger.kernel.org>; Wed, 23 Mar 2022 00:00:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A4CC7C340F3;
        Wed, 23 Mar 2022 00:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647993610;
        bh=KFAyptUhIjaBjeKh30Y9Qh6pbJwIYgAWk2DyG3DG90E=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ZCVxExWx1/p+C/ETx2atkJYKPL0Fg8g/pxNd3yXIf85wpWfcDUUyUb57BnTeEY1Mn
         LAUqzLFn+705omPZDg2qbfb7oX5Vp4nMLifPa457MDgwNTcS21VS0ahmhEW7fqRPmi
         KkrAYj1pZLCHmtD9uLqSh9TPBvFII3rOkG0sMaCHRGT0dvoaHxAHDB5l7ZICmMEe8S
         ue8dKvhgJLFLisPRyCkq/10grZaGNGXDiBobf2lEuh/o5rOpg/U37yEfNlBPFepn8C
         6s3NmOpQklhvWUO8n0XfzzGLiJ4jH0HtDcp7rYGc2hthSKHUcd9reDdf5+ztmKTtVM
         uXPFnfkLNOP6Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8A619E6D402;
        Wed, 23 Mar 2022 00:00:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net/mlx5e: Fix build warning,
 detected write beyond size of field
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164799361056.27605.10896409337643025462.git-patchwork-notify@kernel.org>
Date:   Wed, 23 Mar 2022 00:00:10 +0000
References: <20220322172224.31849-1-saeed@kernel.org>
In-Reply-To: <20220322172224.31849-1-saeed@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        keescook@chromium.org, maximmi@nvidia.com, saeedm@nvidia.com,
        sfr@canb.auug.org.au
X-Spam-Status: No, score=-7.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Tue, 22 Mar 2022 10:22:24 -0700 you wrote:
> From: Saeed Mahameed <saeedm@nvidia.com>
> 
> When merged with Linus tree, the cited patch below will cause the
> following build warning:
> 
> In function 'fortify_memset_chk',
>     inlined from 'mlx5e_xmit_xdp_frame' at drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c:438:3:
> include/linux/fortify-string.h:242:25: error: call to '__write_overflow_field' declared with attribute warning: detected write beyond size of field (1st parameter); maybe use struct_group()? [-Werror=attribute-warning]
>   242 |                         __write_overflow_field(p_size_field, size);
>       |                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> [...]

Here is the summary with links:
  - [net-next] net/mlx5e: Fix build warning, detected write beyond size of field
    https://git.kernel.org/netdev/net-next/c/2af7e566a861

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


