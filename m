Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A471A39C2A3
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 23:40:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231450AbhFDVmC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 17:42:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:40464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229987AbhFDVlw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Jun 2021 17:41:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 1D5FE61408;
        Fri,  4 Jun 2021 21:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622842806;
        bh=fgHG7v+Kgih3XhZMXVzrOzR56W61hin3PMhbLfOJkgE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=sCU7HQ8+/dKu95I0y/QuJWMHs2Eb06MOmUR3YhTvGOovHRjrHy3gu3VE6oDgaitqm
         zd8FbXYRjWv+hsVdrNzpKfNZ2zBoTqF/fuwTxePEOev54XAeSel38TKGTkT4gah/zX
         IU/NQeU7DMt4x1XHQ45sBRML5hrh9jnTyBsEZNjLCBwmtBFlI6IkmSug9eu3Fr0U1/
         8UQRcM/C25EtiiXjbLzz1nDMJx94sSzbvByN+moHfyFSlJl6PyfZFY0/s/uLCU9yJJ
         WPygf107H+2azpcREi8dcI2Lu4ngTdFXY8XDDvNOtvtsSMF5S6ZmXah8JeWB1YYbMN
         nzSbcPYhg18ng==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 0F08F60CD2;
        Fri,  4 Jun 2021 21:40:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/6] net: hdlc_x25: clean up some code style issues
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162284280605.31903.2813051469495224858.git-patchwork-notify@kernel.org>
Date:   Fri, 04 Jun 2021 21:40:06 +0000
References: <1622791932-49876-1-git-send-email-huangguangbin2@huawei.com>
In-Reply-To: <1622791932-49876-1-git-send-email-huangguangbin2@huawei.com>
To:     Guangbin Huang <huangguangbin2@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, xie.he.0141@gmail.com,
        ms@dev.tdt.de, willemb@google.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lipeng321@huawei.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Fri, 4 Jun 2021 15:32:06 +0800 you wrote:
> From: Peng Li <lipeng321@huawei.com>
> 
> This patchset clean up some code style issues.
> 
> Peng Li (6):
>   net: hdlc_x25: remove redundant blank lines
>   net: hdlc_x25: remove unnecessary out of memory message
>   net: hdlc_x25: move out assignment in if condition
>   net: hdlc_x25: add some required spaces
>   net: hdlc_x25: fix the code issue about "if..else.."
>   net: hdlc_x25: fix the alignment issue
> 
> [...]

Here is the summary with links:
  - [net-next,1/6] net: hdlc_x25: remove redundant blank lines
    https://git.kernel.org/netdev/net-next/c/1c906e369815
  - [net-next,2/6] net: hdlc_x25: remove unnecessary out of memory message
    https://git.kernel.org/netdev/net-next/c/579ebffe7973
  - [net-next,3/6] net: hdlc_x25: move out assignment in if condition
    https://git.kernel.org/netdev/net-next/c/ec1f37741244
  - [net-next,4/6] net: hdlc_x25: add some required spaces
    https://git.kernel.org/netdev/net-next/c/5de446075c8e
  - [net-next,5/6] net: hdlc_x25: fix the code issue about "if..else.."
    https://git.kernel.org/netdev/net-next/c/792b070fca8f
  - [net-next,6/6] net: hdlc_x25: fix the alignment issue
    https://git.kernel.org/netdev/net-next/c/316fe3cc7de3

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


