Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2386D609E07
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 11:30:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230228AbiJXJaa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 05:30:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230252AbiJXJaY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 05:30:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F58142E75
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 02:30:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BACEF61147
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 09:30:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1B936C433B5;
        Mon, 24 Oct 2022 09:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666603816;
        bh=caZr8T2iURo1FgfNdJL9+VeKg54PnYQJpoviiOh3kHk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=uPBbV00xkQGCa/DnZYx849ivfNXCrSD89an7KmzV8p/eVdO6iCKNFakEPwDa45K0D
         nassyLiSIGsJKy6vOxFjpyOp357vu21NgXBYW1xgwI4f+mrU13IoxjpSDhkSpnqR0b
         NeQv/kIESci80oH//Fdl0uxSTd4pnQjO0mYpH7gRobppC/jSmiyvw10wyfE0lo4CQo
         3iUGb3gwApG8nXte/yhW7bE4UBDq0mmnKO5Qj8iUt+tEKgmYsTV6ANJFeqOZW7Qezn
         E3IEtsOtzu++uM8CzdMSVCkDMtvGuJ3JdSaaeYIouYYYcUMiqU/FoFWwf8xxtln3SR
         4BBF4HRGzjuDA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id F165EE4D005;
        Mon, 24 Oct 2022 09:30:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v1] net/mlx5e: Cleanup MACsec uninitialization routine
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166660381598.16636.7085128873050771078.git-patchwork-notify@kernel.org>
Date:   Mon, 24 Oct 2022 09:30:15 +0000
References: <186d1af058b29186f7eaefbdc91b16c84111dcf1.1666243464.git.leonro@nvidia.com>
In-Reply-To: <186d1af058b29186f7eaefbdc91b16c84111dcf1.1666243464.git.leonro@nvidia.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, leonro@nvidia.com,
        dan.carpenter@oracle.com, ehakim@nvidia.com, edumazet@google.com,
        netdev@vger.kernel.org, pabeni@redhat.com, raeds@nvidia.com,
        saeedm@nvidia.com, tariqt@nvidia.com
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 20 Oct 2022 08:28:28 +0300 you wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> The mlx5e_macsec_cleanup() routine has NULL pointer dereferencing if mlx5
> device doesn't support MACsec (priv->macsec will be NULL).
> 
> While at it delete comment line, assignment and extra blank lines, so fix
> everything in one patch.
> 
> [...]

Here is the summary with links:
  - [net,v1] net/mlx5e: Cleanup MACsec uninitialization routine
    https://git.kernel.org/netdev/net/c/f8127476930b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


