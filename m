Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0AD75030C0
	for <lists+netdev@lfdr.de>; Sat, 16 Apr 2022 01:09:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355033AbiDOVct (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 17:32:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356178AbiDOVcp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 17:32:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DCEE369EB
        for <netdev@vger.kernel.org>; Fri, 15 Apr 2022 14:30:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E991BB8308C
        for <netdev@vger.kernel.org>; Fri, 15 Apr 2022 21:30:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 613BFC385A9;
        Fri, 15 Apr 2022 21:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650058213;
        bh=150dePHsL8lUpVJ1DSH3XUm/HQDEprvd7Rl236LfiWw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Cmvl1ayS9EoVE+W0O/iBOZA5n8Sq10B5OgdMYIG6Fu3tSb6HH7qbm4hmEZ9gCihNa
         ZOQ0CpzmGl3dTy6NtLDUhwWUA7Wa3pessqzC4+wO+WmBhoLnftRUlt5V0SmtboBZCJ
         zCwFzhuH1j2Li224QKnyKRLWIHjuwntxPxG+1/jPlc7423yXLgh8lnMtJzShqgTR6Z
         szZMEBIgTGuiVT0s8fZvaBbNQXpC9OGZJs9jAc5AdqRAUdBy7UNyjm5rPLui9xn89g
         v61nTh9RE44LCGwx/WNdJllDCg0+3wtLrUmbM5BQG+K/HmTd+0ce3A+vpSQRbfHCSB
         zfr7f7lzMyKCg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 42C28EAC09B;
        Fri, 15 Apr 2022 21:30:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] octeon_ep: Remove custom driver version
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165005821326.11686.6161701970513835895.git-patchwork-notify@kernel.org>
Date:   Fri, 15 Apr 2022 21:30:13 +0000
References: <5d76f3116ee795071ec044eabb815d6c2bdc7dbd.1649922731.git.leonro@nvidia.com>
In-Reply-To: <5d76f3116ee795071ec044eabb815d6c2bdc7dbd.1649922731.git.leonro@nvidia.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, leonro@nvidia.com,
        aayarekar@marvell.com, netdev@vger.kernel.org, pabeni@redhat.com,
        sburla@marvell.com, vburru@marvell.com
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

On Thu, 14 Apr 2022 10:52:42 +0300 you wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> In review comment [1] was pointed that new code is not supposed
> to set driver version and should rely on kernel version instead.
> 
> As an outcome of that comment all the dance around setting such
> driver version to FW should be removed too, because in upstream
> kernel whole driver will have same version so read/write from/to
> FW will give same result.
> 
> [...]

Here is the summary with links:
  - [net-next] octeon_ep: Remove custom driver version
    https://git.kernel.org/netdev/net-next/c/31248b5a354b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


