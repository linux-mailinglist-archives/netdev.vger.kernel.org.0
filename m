Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8060A6B58A5
	for <lists+netdev@lfdr.de>; Sat, 11 Mar 2023 06:30:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229806AbjCKFab (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Mar 2023 00:30:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229940AbjCKFaW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Mar 2023 00:30:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA2BB120845
        for <netdev@vger.kernel.org>; Fri, 10 Mar 2023 21:30:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 88E01B824C7
        for <netdev@vger.kernel.org>; Sat, 11 Mar 2023 05:30:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 469E6C433D2;
        Sat, 11 Mar 2023 05:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678512618;
        bh=xmL6UsB+MLBFWP1U2szDjt8YBFaEs5DtIODgWbJQbCI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=r7/oK2LQgLXJelYIpmTi7G4Az5TyLLDm9WuFjbDW7laq5fDqCt/C77DFqyoIvT7SW
         Ek3v4varGgPbJkUQHEI6063M6X+SplsVDr/KF9niKaiWZzzcZl6RMHoG1n+/HzN2fI
         16w1kN4zxTtPvl0yEuGnLsCWcZFN41XCpJgLkYK+kGV+x8l8Gn+3SHvgOPXBTi8epH
         x91I5xcgPCNi1Gob9l9/37igdMbBnWu6OpgCfdpJ8No0jGVbYbre7CZF6eSEWtQhng
         yuJ59e/m9RKRX2X6o9JIq6IKOLLT29XYx/hBn1tCAj2C4Td6VEox6Qd9XGwwiUjupN
         eYLrkK8zr2poQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2D838E270C7;
        Sat, 11 Mar 2023 05:30:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] ipvlan: Make skb->skb_iif track skb->dev for l3s
 mode
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167851261818.13546.6086007363056861795.git-patchwork-notify@kernel.org>
Date:   Sat, 11 Mar 2023 05:30:18 +0000
References: <29865b1f-6db7-c07a-de89-949d3721ea30@163.com>
In-Reply-To: <29865b1f-6db7-c07a-de89-949d3721ea30@163.com>
To:     Jianguo Wu <wujianguo106@163.com>
Cc:     netdev@vger.kernel.org, edumazet@google.com, davem@davemloft.net,
        daniel@iogearbox.net, fw@strlen.de
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 9 Mar 2023 10:03:36 +0800 you wrote:
> From: Jianguo Wu <wujianguo@chinatelecom.cn>
> 
> For l3s mode, skb->dev is set to ipvlan interface in ipvlan_nf_input():
>   skb->dev = addr->master->dev
> but, skb->skb_iif remain unchanged, this will cause socket lookup failed
> if a target socket is bound to a interface, like the following example:
> 
> [...]

Here is the summary with links:
  - [net-next] ipvlan: Make skb->skb_iif track skb->dev for l3s mode
    https://git.kernel.org/netdev/net/c/59a0b022aa24

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


