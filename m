Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72D06458FFD
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 15:10:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232357AbhKVONU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 09:13:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:51096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229984AbhKVONT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Nov 2021 09:13:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 16A45601FF;
        Mon, 22 Nov 2021 14:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637590209;
        bh=4wusU6ChU7CXnLF4loOdOlin1IKaCNh4dlmNUm3JAgw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=S8FPadgLOsjJ5GFAfMsTikfeqhW4uu9ooJ5pqIIwqKbxD5CQNGnA6U59ChRL11+6I
         SVmO2xFLIHUI/lfdpVc3TNk1425/zUpvHq0ViBgYrcjO0lGyYShwwILtT7UXGsBIam
         QRUtCYjzlyOYPpQFqZz0rqSAMHZEMjIvqvY5lhc7l9ENbN9N7axJgs21ZYVVKYWngD
         K8RJYCYriYdKtFsgrHbrMbAHVwoiOLH5LU/H0jYHuwfEYnwQfUTyFtwB9qon8wvcxd
         1pW8/n6s49xZd7fQewEw9VzzHcOXZPupp8ZmgMRmWoK2ABfwjBlpHZ4hgPYZHDK2Wd
         daxRc7k914XmQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 02D6D609D9;
        Mon, 22 Nov 2021 14:10:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] pcmcia: hide the MAC address helpers if !NET
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163759020900.20383.12641272664043156997.git-patchwork-notify@kernel.org>
Date:   Mon, 22 Nov 2021 14:10:09 +0000
References: <20211120171510.201163-1-kuba@kernel.org>
In-Reply-To: <20211120171510.201163-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, lkp@intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Sat, 20 Nov 2021 09:15:10 -0800 you wrote:
> pcmcia_get_mac_from_cis is only called from networking and
> recent changes made it call dev_addr_mod() which is itself
> only defined if NET.
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Fixes: adeef3e32146 ("net: constify netdev->dev_addr")
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> 
> [...]

Here is the summary with links:
  - [net-next] pcmcia: hide the MAC address helpers if !NET
    https://git.kernel.org/netdev/net-next/c/bd4b827cec1d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


