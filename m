Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F2484C02B3
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 21:01:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235399AbiBVUBE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 15:01:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235427AbiBVUAj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 15:00:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21892EA74E
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 12:00:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B6F6DB81C61
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 20:00:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7042EC340EF;
        Tue, 22 Feb 2022 20:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645560010;
        bh=ksoj1ReG9pLqLQnmUXa8yi65Ym2nhgZ88NKTsy9eM3g=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=jZCq5BuBnO7qnJtOCUDmX2VaUSnjL87MYJD/g0uvN54144JX599PRxcvYwC11Ydtl
         ffIV5cqEeuvkgccCSU25qC9upadyKfz2Dr2dPxzerkWIx2++SexoSNmJWabqOhdB8/
         Exp1amVQRyO1IwFJ8ybPZuMtxsM1keGfE3dM/aRx4kevxMrUPCb5phsQzrYqkdzkxb
         hN+HbWoLEZw3Ai7re90Snvd8I9rmxRPNF778FLVj86YaQ/TkuC+Dhlqt9FptgpFg1K
         dw/B8ajShaObXz7SfFjAzGNLWcKBd3WmkgkEk9ciU02KHgnc6Q/FJK+VZgGkvs2ifk
         LhRjZ4ql2kzfA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 57378E6D539;
        Tue, 22 Feb 2022 20:00:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next] gro_cells: avoid using synchronize_rcu() in
 gro_cells_destroy()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164556001034.16898.17296775826071482460.git-patchwork-notify@kernel.org>
Date:   Tue, 22 Feb 2022 20:00:10 +0000
References: <20220220041155.607637-1-eric.dumazet@gmail.com>
In-Reply-To: <20220220041155.607637-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com
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

On Sat, 19 Feb 2022 20:11:55 -0800 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> Another thing making netns dismantles potentially very slow is located
> in gro_cells_destroy(),
> whenever cleanup_net() has to remove a device using gro_cells framework.
> 
> RTNL is not held at this stage, so synchronize_net()
> is calling synchronize_rcu():
> 
> [...]

Here is the summary with links:
  - [v2,net-next] gro_cells: avoid using synchronize_rcu() in gro_cells_destroy()
    https://git.kernel.org/netdev/net-next/c/ee8f97efa7a5

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


