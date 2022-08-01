Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EA79587132
	for <lists+netdev@lfdr.de>; Mon,  1 Aug 2022 21:13:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234998AbiHATNH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Aug 2022 15:13:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234140AbiHATMw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Aug 2022 15:12:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACB25E30
        for <netdev@vger.kernel.org>; Mon,  1 Aug 2022 12:10:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 13F04612C6
        for <netdev@vger.kernel.org>; Mon,  1 Aug 2022 19:10:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 62425C433D6;
        Mon,  1 Aug 2022 19:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659381014;
        bh=FNJ03ysqlMqOuRxi3wefIQ7ASikYWKtTHFRRJRZieWs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=VDT24y0RXwPGSmlMStNsJhHtvH8Dp52hRdJpf5GqAu+/71RaD0LuKUScCPHruld/W
         /xVuZZfg0ddv+X4t0dCSIcUM8kZExBMzsRv+jY2jDLBYulrBbKmDHPASpOIxIUjv5X
         hXfqzftS+yfPPVFDgRB6aJhHBUM5k8K8yk1pCA8UYC36sjP1u84O6nBJTTOGQ2mqFY
         6v1zsdsr8jVuURDO2/g3KcHE+0JckS+Pd45q85WB4pjQ1hcJdtZgH9yiqqRuRbXTuU
         7qTG0ve6T3VrolUEslKwllBPl1wrXJ9cExBrGULvyMgLJje0GHoPCg3+cICy1kgROh
         xkIKAABaPu4Hw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 48559C43140;
        Mon,  1 Aug 2022 19:10:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/2] net: rose: fix module unload issues
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165938101429.19579.17722984811701505216.git-patchwork-notify@kernel.org>
Date:   Mon, 01 Aug 2022 19:10:14 +0000
References: <20220729091233.1030680-1-edumazet@google.com>
In-Reply-To: <20220729091233.1030680-1-edumazet@google.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, eric.dumazet@gmail.com, f6bvp@free.fr
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 29 Jul 2022 09:12:31 +0000 you wrote:
> Bernard Pidoux reported that unloading rose module could lead
> to infamous "unregistered_netdevice:" issues.
> 
> First patch is the fix, stable candidate.
> Second patch is adding netdev ref tracker to af_rose.
> 
> I chose net-next to not inflict merge conflicts, because
> Jakub changed dev_put_track() to netdev_put_track() in net-next.
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] net: rose: fix netdev reference changes
    https://git.kernel.org/netdev/net-next/c/931027820e4d
  - [net-next,2/2] net: rose: add netdev ref tracker to 'struct rose_sock'
    https://git.kernel.org/netdev/net-next/c/2df91e397d85

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


