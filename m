Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44A17380088
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 00:50:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233786AbhEMWv1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 May 2021 18:51:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:47480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231186AbhEMWvW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 May 2021 18:51:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 2D23D61435;
        Thu, 13 May 2021 22:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620946212;
        bh=N0lbkzjz/kzxhQuNf4I79qyZzybhtWCPEzh3uTmLy4c=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=XgQm82SxJ8dlfQb3TW91Bjdxl4XwIJxFX77hZHkDtnxbfAPIvsaltREsAvZPwLFUv
         Fhwwn2fJFx9JKC3mSAFqLXvKshRzPiiD6D1dj1D+V9GiR1Yy4DmJp6wRD4X/T9SCXk
         rZjqsx3LDoLyR1N4axX88xIPgkalPGLKfn46dc/LLb26hYOBrIwPj30UTlliZ6kTm9
         DwM1Pgx7JZu0YVt7OgC5LxxFOAXjXPkLYB08FpEwe84isVCYVbmFPlmbQQgqfDr/Z3
         zwf3ojkpqnYPNBOa31GRJa9KuG0s+rWB5VxbkzkfIfbj3M1YupPctMul3/OKYV5Pjo
         3q4LNKgFn5Jow==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 2207460A2C;
        Thu, 13 May 2021 22:50:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/4] net: hinic: some cleanups
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162094621213.964.5055654018730375012.git-patchwork-notify@kernel.org>
Date:   Thu, 13 May 2021 22:50:12 +0000
References: <1620887213-49364-1-git-send-email-huangguangbin2@huawei.com>
In-Reply-To: <1620887213-49364-1-git-send-email-huangguangbin2@huawei.com>
To:     Guangbin Huang <huangguangbin2@huawei.com>
Cc:     luobin9@huawei.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Thu, 13 May 2021 14:26:49 +0800 you wrote:
> This patchset adds some cleanups for the hinic ethernet driver.
> 
> Guangbin Huang (4):
>   net: hinic: remove unnecessary blank line
>   net: hinic: add blank line after function declaration
>   net: hinic: remove unnecessary parentheses
>   net: hinic: fix misspelled "acessing"
> 
> [...]

Here is the summary with links:
  - [net-next,1/4] net: hinic: remove unnecessary blank line
    https://git.kernel.org/netdev/net-next/c/9afcb5959730
  - [net-next,2/4] net: hinic: add blank line after function declaration
    https://git.kernel.org/netdev/net-next/c/3402ab54a8e3
  - [net-next,3/4] net: hinic: remove unnecessary parentheses
    https://git.kernel.org/netdev/net-next/c/c8ad5df6151e
  - [net-next,4/4] net: hinic: fix misspelled "acessing"
    https://git.kernel.org/netdev/net-next/c/5db8c86e8904

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


