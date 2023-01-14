Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FE4966A951
	for <lists+netdev@lfdr.de>; Sat, 14 Jan 2023 06:01:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229471AbjANFAW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Jan 2023 00:00:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbjANFAS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Jan 2023 00:00:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4334A35AA;
        Fri, 13 Jan 2023 21:00:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D3DCB60AE8;
        Sat, 14 Jan 2023 05:00:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 37A1DC43398;
        Sat, 14 Jan 2023 05:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673672417;
        bh=CIXvaaw3EogcoKoOEINq0liejivgaLYQl6eFZWwZcSE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=JUuFd98WTy68many7KxkyzijHlBG351pD3jqcnAaxNrXQNadSDC8GsBcQoSdgmJIX
         pCMnabqNnHYGnGqtbzkxbF23rXAEe6o7tid8Frv/bBGznxR6DThbgCUg0tO7bGgNZu
         U6MflI7a70vcLOYsqDO3lcMYVtTkK0LTwQoYaPy5qKJstMGIJo8CGw28mI2csw0NZ4
         XfswQ3m8nvWeCBC3SG7vw4Gd+rWMMYXNFUDoSKRdxE2QU9VnkyfwS5MpdGsH8qaQ7r
         qqzISFof1qMyZhjsbSC95m/mZTYA8nvP/Skl00aYhgTstqwCgJ6WVfE06KKSB2tqhA
         ZR58RIddBYzlA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 20A3BC395CA;
        Sat, 14 Jan 2023 05:00:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] caif: don't assume iov_iter type
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167367241712.28163.12154259620888863155.git-patchwork-notify@kernel.org>
Date:   Sat, 14 Jan 2023 05:00:17 +0000
References: <20230111184245.3784393-1-kbusch@meta.com>
In-Reply-To: <20230111184245.3784393-1-kbusch@meta.com>
To:     Keith Busch <kbusch@meta.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, axboe@kernel.dk,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        kbusch@kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Wed, 11 Jan 2023 10:42:45 -0800 you wrote:
> From: Keith Busch <kbusch@kernel.org>
> 
> The details of the iov_iter types are appropriately abstracted, so
> there's no need to check for specific type fields. Just let the
> abstractions handle it.
> 
> This is preparing for io_uring/net's io_send to utilize the more
> efficient ITER_UBUF.
> 
> [...]

Here is the summary with links:
  - caif: don't assume iov_iter type
    https://git.kernel.org/netdev/net-next/c/c19175141079

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


