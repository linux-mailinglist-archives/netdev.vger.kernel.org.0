Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43E5E4395B1
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 14:10:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232657AbhJYMMh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 08:12:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:51910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231358AbhJYMMh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Oct 2021 08:12:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id F1B2C60FDA;
        Mon, 25 Oct 2021 12:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635163815;
        bh=taz/gIzUMNVMPrNO01EH8LPmg96WyWNtyZOZ2t1skeg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=d/wRpPzanil7MLuRQVNlrT2omyS2GYBO5f2a0pZwuu7quJL2Ob2YiTTn9uWrahlwn
         /55j8wp2SZt+jLdMc99KKIhhDm6PFWB5kG4C4lZD2bOQvCJGsLzIiWfLY2vpz2OxFq
         dDnmoFBc5L2znkiB+omqyEqguV4Elqwxj72wlI19r/OLkBfzPSDbQdnLbdhn1glj6e
         HWDetI/7YwjxrC0FTnrpkYadSuqSzGjcN4csnGXCCCRZqkSwWJxWQqGBXnYbOOKq2n
         oLGjHgoA2DbLUe+AGDRoPQBGqB+EkfgxESe9qUjtUGdSyMqAwOVQ2Vm+5OOvK1oo3V
         M5wP3QnJTWKTg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id E7C4060A90;
        Mon, 25 Oct 2021 12:10:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 0/8] don't write directly to netdev->dev_addr
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163516381494.1029.2799078026241697416.git-patchwork-notify@kernel.org>
Date:   Mon, 25 Oct 2021 12:10:14 +0000
References: <20211022232103.2715312-1-kuba@kernel.org>
In-Reply-To: <20211022232103.2715312-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 22 Oct 2021 16:20:55 -0700 you wrote:
> Constify references to netdev->dev_addr and
> use appropriate helpers.
> 
> v2: s/got/go/
> 
> Jakub Kicinski (8):
>   net: core: constify mac addrs in selftests
>   net: rtnetlink: use __dev_addr_set()
>   net: phy: constify netdev->dev_addr references
>   net: bonding: constify and use dev_addr_set()
>   net: hsr: get ready for const netdev->dev_addr
>   net: caif: get ready for const netdev->dev_addr
>   net: drivers: get ready for const netdev->dev_addr
>   net: atm: use address setting helpers
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/8] net: core: constify mac addrs in selftests
    https://git.kernel.org/netdev/net-next/c/5fd348a050f7
  - [net-next,v2,2/8] net: rtnetlink: use __dev_addr_set()
    https://git.kernel.org/netdev/net-next/c/efd38f75bb04
  - [net-next,v2,3/8] net: phy: constify netdev->dev_addr references
    https://git.kernel.org/netdev/net-next/c/86466cbed173
  - [net-next,v2,4/8] net: bonding: constify and use dev_addr_set()
    https://git.kernel.org/netdev/net-next/c/6f238100d098
  - [net-next,v2,5/8] net: hsr: get ready for const netdev->dev_addr
    https://git.kernel.org/netdev/net-next/c/39c19fb9b4f9
  - [net-next,v2,6/8] net: caif: get ready for const netdev->dev_addr
    https://git.kernel.org/netdev/net-next/c/5520fb42a0a1
  - [net-next,v2,7/8] net: drivers: get ready for const netdev->dev_addr
    https://git.kernel.org/netdev/net-next/c/8bc7823ed3bd
  - [net-next,v2,8/8] net: atm: use address setting helpers
    https://git.kernel.org/netdev/net-next/c/d6b3daf24e75

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


