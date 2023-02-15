Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48B746979E0
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 11:30:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234045AbjBOKaY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 05:30:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233711AbjBOKaX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 05:30:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7A16367EB
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 02:30:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6E504B820F8
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 10:30:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 22960C4339C;
        Wed, 15 Feb 2023 10:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676457018;
        bh=amZoLesJlP8387Qb/BdVnSxxpe4Nrt3mutRcMKkDdFQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=IeVFbu/ZGKXD5x1FMpb20Nh8cAUo2FKglbZjKgmGqyFuWSbzgTK//5l2whObSt6o7
         NaDUoxDzavfDiyPncwURyjQJs151zadCHXS4N64wyeEKcSvqq4K/T3iLrdzNpvuj9U
         lc2O4lfwdbhMpRxxM4TTiLhxhPFsg3lDXmDTFmZ0L0JXzXsWeXPNnbtwD09tcYvX1P
         y15pBg/MTBJnupqnNXfYnPrUYRnwA8tEFqDPL57k2S5Mmje/fG8kbYsRvXvSVqGsfo
         BZOYtXy+TOiDUlv3AuEW4ctp0tGOlJR4Ba3mcK/vK80KzW+oMJy6z/GqaS1Lya5H2d
         zh9dRDlus3r7A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0BDA0C4166F;
        Wed, 15 Feb 2023 10:30:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: mpls: fix stale pointer if allocation fails during
 device rename
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167645701804.29620.16187922516857113249.git-patchwork-notify@kernel.org>
Date:   Wed, 15 Feb 2023 10:30:18 +0000
References: <20230214065355.358890-1-kuba@kernel.org>
In-Reply-To: <20230214065355.358890-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, bluetlh@gmail.com, kuniyu@amazon.co.jp,
        gongruiqi1@huawei.com, rshearma@brocade.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Mon, 13 Feb 2023 22:53:55 -0800 you wrote:
> lianhui reports that when MPLS fails to register the sysctl table
> under new location (during device rename) the old pointers won't
> get overwritten and may be freed again (double free).
> 
> Handle this gracefully. The best option would be unregistering
> the MPLS from the device completely on failure, but unfortunately
> mpls_ifdown() can fail. So failing fully is also unreliable.
> 
> [...]

Here is the summary with links:
  - [net] net: mpls: fix stale pointer if allocation fails during device rename
    https://git.kernel.org/netdev/net/c/fda6c89fe3d9

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


