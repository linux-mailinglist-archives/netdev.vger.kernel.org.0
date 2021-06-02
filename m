Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0D47397D80
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 02:10:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235315AbhFBAL4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 20:11:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:55986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235228AbhFBALu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Jun 2021 20:11:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 11968613CA;
        Wed,  2 Jun 2021 00:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622592608;
        bh=OxysOBcHmeIZbgczDdKcVXDBxCPDoUBJcUo+rF79/Fw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=PmTEmaYO3zXVugXSIGd8WcPgUugxWH2xPnuJjMpxriOGvNXLFQoMu7ftERQM6na48
         cYrNcp5D2z4tfspsoEg/q9vX+5TnuAOng+6xJEqQC5P5FHdNDl3uFQ6ffb4bYWAlvy
         m1B6cyIADIi0AfEv9S0RE9dm5o2sRtbyXUwyvVqNXJGb4G8qp6QbH44TNtRdx9mVQ+
         hgR1IGTPWAbxEB/gIURgS21hOWYoUOyJTSUAHYVb+BmDxAmWCbA1rXlG18uvqVHhrk
         Noevke0q6gFkzb34Ds3dDtX0Flw7Q8XdMmI6Uicca1zqzT74UP8KyhiCkICmISMGAF
         rZIzB+km3wGvw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 07B0760BFB;
        Wed,  2 Jun 2021 00:10:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/7] net: hdlc: clean up some code style issues
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162259260802.22595.5738598548558595264.git-patchwork-notify@kernel.org>
Date:   Wed, 02 Jun 2021 00:10:08 +0000
References: <1622553802-19903-1-git-send-email-huangguangbin2@huawei.com>
In-Reply-To: <1622553802-19903-1-git-send-email-huangguangbin2@huawei.com>
To:     Guangbin Huang <huangguangbin2@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, xie.he.0141@gmail.com,
        ms@dev.tdt.de, willemb@google.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lipeng321@huawei.com,
        tanhuazhong@huawei.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Tue, 1 Jun 2021 21:23:15 +0800 you wrote:
> From: Peng Li <lipeng321@huawei.com>
> 
> This patchset clean up some code style issues.
> 
> Peng Li (7):
>   net: hdlc: remove redundant blank lines
>   net: hdlc: add blank line after declarations
>   net: hdlc: fix an code style issue about "foo* bar"
>   net: hdlc: fix an code style issue about EXPORT_SYMBOL(foo)
>   net: hdlc: replace comparison to NULL with "!param"
>   net: hdlc: move out assignment in if condition
>   net: hdlc: add braces {} to all arms of the statement
> 
> [...]

Here is the summary with links:
  - [net-next,1/7] net: hdlc: remove redundant blank lines
    https://git.kernel.org/netdev/net-next/c/30cd458be244
  - [net-next,2/7] net: hdlc: add blank line after declarations
    https://git.kernel.org/netdev/net-next/c/04cc04f07bb2
  - [net-next,3/7] net: hdlc: fix an code style issue about "foo* bar"
    https://git.kernel.org/netdev/net-next/c/68fd73925bce
  - [net-next,4/7] net: hdlc: fix an code style issue about EXPORT_SYMBOL(foo)
    https://git.kernel.org/netdev/net-next/c/01506939cc84
  - [net-next,5/7] net: hdlc: replace comparison to NULL with "!param"
    https://git.kernel.org/netdev/net-next/c/387847f295c8
  - [net-next,6/7] net: hdlc: move out assignment in if condition
    https://git.kernel.org/netdev/net-next/c/e50eb6c3578c
  - [net-next,7/7] net: hdlc: add braces {} to all arms of the statement
    https://git.kernel.org/netdev/net-next/c/1bb521825265

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


