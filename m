Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F097B39ABD5
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 22:30:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230090AbhFCUb6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 16:31:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:42702 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229801AbhFCUbt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Jun 2021 16:31:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id A0143613E3;
        Thu,  3 Jun 2021 20:30:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622752204;
        bh=7UVILHlYdovfcc+PGt1dpo0CJ2ONA+U4rhwsS/F/a0c=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=RiH8/GBVRSH2qYeYrRCzBBqbHgZMe5kjKnL0J9XxJX6ycc1F3qWOCAD2tRiw7CBQo
         LtpWScYPkIfajRmFPRVp9tLY7ZUULEdu32gZjAki0spyCB4DgfRdNh2FtTd1syEwCZ
         vznUUnbVIbsmCyzlNYWb3E+FgUhjorms7LvQPmELafsjK1kSIdlTxgSeU+t+2PT0VH
         i2Tg7h2ebpQweEmwVK8QLsX2ZG7TsbK0449M1ZIOKjEM0jOU9ruIVlztUf+jrbvA//
         LxxN3TDigSvRYXG5Quf+keGeSYshBUn3XeeH+tNRt7WmgCLpbqLbhSb7RQFzsi1/L4
         cJSw3a4FXPe2Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 92B8660ACA;
        Thu,  3 Jun 2021 20:30:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/6] net: hdlc_cisci: clean up some code style issues
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162275220459.19203.14503519672467316957.git-patchwork-notify@kernel.org>
Date:   Thu, 03 Jun 2021 20:30:04 +0000
References: <1622631676-34037-1-git-send-email-huangguangbin2@huawei.com>
In-Reply-To: <1622631676-34037-1-git-send-email-huangguangbin2@huawei.com>
To:     huangguangbin (A) <huangguangbin2@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, xie.he.0141@gmail.com,
        ms@dev.tdt.de, willemb@google.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lipeng321@huawei.com,
        tanhuazhong@huawei.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Wed, 2 Jun 2021 19:01:10 +0800 you wrote:
> From: Peng Li <lipeng321@huawei.com>
> 
> This patchset clean up some code style issues.
> 
> Peng Li (6):
>   net: hdlc_cisco: remove redundant blank lines
>   net: hdlc_cisco: fix the code style issue about "foo* bar"
>   net: hdlc_cisco: add some required spaces
>   net: hdlc_cisco: remove unnecessary out of memory message
>   net: hdlc_cisco: add blank line after declaration
>   net: hdlc_cisco: remove redundant space
> 
> [...]

Here is the summary with links:
  - [net-next,1/6] net: hdlc_cisco: remove redundant blank lines
    https://git.kernel.org/netdev/net-next/c/5abaf211c4a5
  - [net-next,2/6] net: hdlc_cisco: fix the code style issue about "foo* bar"
    https://git.kernel.org/netdev/net-next/c/001aa274300d
  - [net-next,3/6] net: hdlc_cisco: add some required spaces
    https://git.kernel.org/netdev/net-next/c/c1300f37ea99
  - [net-next,4/6] net: hdlc_cisco: remove unnecessary out of memory message
    https://git.kernel.org/netdev/net-next/c/05ff5525aa82
  - [net-next,5/6] net: hdlc_cisco: add blank line after declaration
    https://git.kernel.org/netdev/net-next/c/4e38d514788c
  - [net-next,6/6] net: hdlc_cisco: remove redundant space
    https://git.kernel.org/netdev/net-next/c/4a20f8ecbf61

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


