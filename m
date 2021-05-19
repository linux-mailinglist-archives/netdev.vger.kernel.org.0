Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B22193896B8
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 21:30:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232058AbhESTbm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 15:31:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:56150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232046AbhESTbg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 May 2021 15:31:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id BAAC66135F;
        Wed, 19 May 2021 19:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621452616;
        bh=JfAU2s45ELoqRxZp7xQz2g0sSLbLmY/ipoKMOmtwuaE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=KvBfOyKa9BaUakVwdNcLsNphaz/IN4iRUH/xUwWSuMh0J2zWUNkU4EnS9JAmH828p
         jjJtO5eAwuVy5Qod+1wAimWRjTOzTVjDbq+sZsv7ZSBnlojdzs/NBKC87LY0olm1nB
         fWmHHjFxVQg8zXJcKB+Dr0zOX6iNMiSinssbkRJh3lUKgtlA8PWkXYj6GpWdeDfCZg
         l2cb2wxEMT0RrslTR3qze6lqsbXQL+j/BmZJQkxBkRsE5Qe9BwRPUTAE8BwcUmgdC/
         NImpxVMivSjId0xPRnCu+qSXkYdpE0yTEnKsJ2XZVTQgmgSOEmb4cM8pw/FPURJnMh
         bnIUkAY0kN1YA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id B013560CD2;
        Wed, 19 May 2021 19:30:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/5] net: intel: some cleanups
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162145261671.25646.17755422977690306558.git-patchwork-notify@kernel.org>
Date:   Wed, 19 May 2021 19:30:16 +0000
References: <1621404885-20075-1-git-send-email-huangguangbin2@huawei.com>
In-Reply-To: <1621404885-20075-1-git-send-email-huangguangbin2@huawei.com>
To:     Guangbin Huang <huangguangbin2@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, jesse.brandeburg@intel.com,
        anthony.l.nguyen@intel.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        lipeng321@huawei.com, tanhuazhong@huawei.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Wed, 19 May 2021 14:14:40 +0800 you wrote:
> This patchset adds some cleanups for intel e1000/e1000e ethernet driver.
> 
> Hao Chen (5):
>   net: e1000: remove repeated word "slot" for e1000_main.c
>   net: e1000: remove repeated words for e1000_hw.c
>   net: e1000e: remove repeated word "the" for ich8lan.c
>   net: e1000e: remove repeated word "slot" for netdev.c
>   net: e1000e: fix misspell word "retreived"
> 
> [...]

Here is the summary with links:
  - [net-next,1/5] net: e1000: remove repeated word "slot" for e1000_main.c
    https://git.kernel.org/netdev/net-next/c/4b63b27fc59a
  - [net-next,2/5] net: e1000: remove repeated words for e1000_hw.c
    https://git.kernel.org/netdev/net-next/c/e77471f1de0d
  - [net-next,3/5] net: e1000e: remove repeated word "the" for ich8lan.c
    https://git.kernel.org/netdev/net-next/c/59398afda176
  - [net-next,4/5] net: e1000e: remove repeated word "slot" for netdev.c
    https://git.kernel.org/netdev/net-next/c/800b74a57363
  - [net-next,5/5] net: e1000e: fix misspell word "retreived"
    https://git.kernel.org/netdev/net-next/c/0d27895bcbb4

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


