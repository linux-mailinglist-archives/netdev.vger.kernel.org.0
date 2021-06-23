Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28D053B2225
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 23:00:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229906AbhFWVCX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 17:02:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:53050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229660AbhFWVCV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Jun 2021 17:02:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 0CB42610C7;
        Wed, 23 Jun 2021 21:00:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624482004;
        bh=JIHIvf3Nwn7CKGia3o0oJguNpcXSf/gMVH6x8x6rIgc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=gUPDEMRAs5F2GxLpQMO4/23a3TkStxrxIZcj9dp+tZTCykYUkhTLeUdc69GNOFxvR
         L1i4a+yArxZLhceqEcGDct5IBYw82pskuZdzdPFTZu58kt2TBZ249WNg0zgfji5o0d
         UrLGM3mgbIJy57RmXXdlZVhCUPWQ6eT/AkpKLDn6Y9Lb/CGo6XmVGA4q9kROMGQWLI
         8bK7rXLx9f4ySdog9jfa2SxlslG+TTogPS5y5akeo0/E/4ZKYkerNxSfI/T0fs83vX
         52GP/O0tPfvzVcyRpEegUiMy279wRY2dgXy9OmDIb990uOA54CXiLFa8gttufKxo5K
         6tQJFnvqzrvNQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id EF407609AC;
        Wed, 23 Jun 2021 21:00:03 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] ipv6: exthdrs: do not blindly use init_net
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162448200397.24119.7989295577580138832.git-patchwork-notify@kernel.org>
Date:   Wed, 23 Jun 2021 21:00:03 +0000
References: <20210623152700.1896304-1-eric.dumazet@gmail.com>
In-Reply-To: <20210623152700.1896304-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com, tom@quantonium.net, lixiaoyan@google.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed, 23 Jun 2021 08:27:00 -0700 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> I see no reason why max_dst_opts_cnt and max_hbh_opts_cnt
> are fetched from the initial net namespace.
> 
> The other sysctls (max_dst_opts_len & max_hbh_opts_len)
> are in fact already using the current ns.
> 
> [...]

Here is the summary with links:
  - [net] ipv6: exthdrs: do not blindly use init_net
    https://git.kernel.org/netdev/net/c/bcc3f2a829b9

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


