Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DD9557E96D
	for <lists+netdev@lfdr.de>; Sat, 23 Jul 2022 00:00:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236713AbiGVWAS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 18:00:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236668AbiGVWAR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 18:00:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A38512776;
        Fri, 22 Jul 2022 15:00:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C56F0B82B32;
        Fri, 22 Jul 2022 22:00:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 72E67C341C7;
        Fri, 22 Jul 2022 22:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658527213;
        bh=uLyay4WTUhXAXpTOAWsQVx/SsOhJ6GE7TpgTuKMStIY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=n1d74XpsFs839wnrjUh32I31IqKsFy775ACv1nkZZ0pnzXczmf9nN/dIl2JvF9X7H
         PfbUAYSDkQMbXNJcYsJ8T5WXlbqvUuPc+9uml+S9UqJvdF3On+0IFz9sI3pTSmZsJp
         ND1Ev+/2J+Bap/G++e7J/KysjQ9FYZlqkzFIeRLZJZpYipN0/TO2d0+XPwVYCvpOz9
         Vap2lsbZMtJuiU7tf1CjDG2SBJIuq9V+ikBnrisdhtjO15wl7b5tBaU2VHWr6vBhub
         cWYjJyGnBRs/AQHOSuLFt7pui0bzLhNEUo2Ob+nHZtvCppCCEvUE/7c488h1ki+eQl
         PIW9uLaeppdEQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 5A747E451B3;
        Fri, 22 Jul 2022 22:00:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: fix uninitialised msghdr->sg_from_iter
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165852721336.8145.1830308584894724128.git-patchwork-notify@kernel.org>
Date:   Fri, 22 Jul 2022 22:00:13 +0000
References: <ce8b68b41351488f79fd998b032b3c56e9b1cc6c.1658401817.git.asml.silence@gmail.com>
In-Reply-To: <ce8b68b41351488f79fd998b032b3c56e9b1cc6c.1658401817.git.asml.silence@gmail.com>
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, dsahern@kernel.org
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 21 Jul 2022 15:25:46 +0100 you wrote:
> Because of how struct msghdr is usually initialised some fields and
> sg_from_iter in particular might be left out not initialised, so we
> can't safely use it in __zerocopy_sg_from_iter().
> 
> For now use the callback only when there is ->msg_ubuf set relying on
> the fact that they're used together and we properly zero ->msg_ubuf.
> 
> [...]

Here is the summary with links:
  - [net-next] net: fix uninitialised msghdr->sg_from_iter
    https://git.kernel.org/netdev/net-next/c/2829a267fca2

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


