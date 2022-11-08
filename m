Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D97A620F80
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 12:50:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233641AbiKHLuU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 06:50:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233472AbiKHLuR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 06:50:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51DEA11811
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 03:50:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E1B8E61518
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 11:50:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4CFA7C433D7;
        Tue,  8 Nov 2022 11:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667908215;
        bh=NK/YYNIJdEDXsT8gEjp0URhjdXkM2lhCZCUWpqxLoHo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=MTjZgDc4/cfgx5PJfAv8htQ/8FIxlwXwk4kUCNv5BYdhLXMAwacEBju/Hl8svkpau
         UhRMdTr44h/peVjQGG9FtDfA0G7NtIb+CmweSgdNhjioA5OoJs+T2nAzXFxrIV6Gk4
         qRCoQSmwD8PIzkNgdDrQsnkYWckkU/Kjtj8vWaGrYCgXz4fyn+WaINwkBQeQCax9am
         Mx4rmA4tXJd9/aypj6Stq8TWnixAecoc70z+i/GnjB3GxU2jo5A1gH63J77gV8bSNt
         NxPvGqYUENgZAnWCqObQHoJkaufGGzpz5S8WYaOLuZZ297UZDMCE00SJG7vKCTX1Za
         4BEiw6Pe/Gs5g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 30704E270D0;
        Tue,  8 Nov 2022 11:50:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/3] bnxt_en: Updates
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166790821519.5959.10098542093861526805.git-patchwork-notify@kernel.org>
Date:   Tue, 08 Nov 2022 11:50:15 +0000
References: <1667780192-3700-1-git-send-email-michael.chan@broadcom.com>
In-Reply-To: <1667780192-3700-1-git-send-email-michael.chan@broadcom.com>
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com, gospo@broadcom.com,
        pavan.chebbi@broadcom.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Sun,  6 Nov 2022 19:16:29 -0500 you wrote:
> This small patchset adds an improvement to the configuration of ethtool
> RSS tuple hash and a PTP improvement when running in a multi-host
> environment.
> 
> Edwin Peer (2):
>   bnxt_en: refactor VNIC RSS update functions
>   bnxt_en: update RSS config using difference algorithm
> 
> [...]

Here is the summary with links:
  - [net-next,1/3] bnxt_en: refactor VNIC RSS update functions
    https://git.kernel.org/netdev/net-next/c/41d2dd42bfa1
  - [net-next,2/3] bnxt_en: update RSS config using difference algorithm
    https://git.kernel.org/netdev/net-next/c/98a4322b70e8
  - [net-next,3/3] bnxt_en: Add a non-real time mode to access NIC clock
    https://git.kernel.org/netdev/net-next/c/85036aee1938

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


