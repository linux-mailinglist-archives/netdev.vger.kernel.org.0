Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B149C325513
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 19:04:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230459AbhBYSCd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Feb 2021 13:02:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:51688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233860AbhBYSAq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Feb 2021 13:00:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id F106764F65;
        Thu, 25 Feb 2021 18:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614276007;
        bh=l1R2ok4pwm3zwn42TzPmaJYzSERJ5w/HcmSpKHLPG/w=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ilqzjkea/CYz1ShVJ3rvh+hKcRkEURq0PpQCx8AVXUrYSqsahP4G8j9FsXhWKULt3
         Y6Z83fKjA4hQxsrh0MOyClTd+M45PrRRdNIaaCtS/2Dgi1kdvntRj5rKLb/2SszNwa
         kCchr8dQgtWo6dbvgeJqXPZ6+ICMhoQND4GJl1zdYttixsDWzJ3w/+6DWN//d+b1Vt
         c+7HNAh3GtGvio9wBgVDqyn+PbzOe3JHEgMZlKu/yjVZxh2VaVpciLVvbE0E+UppK3
         ax6x3y3I0D0U96O7qKaGX5kXq2FcvxvWIzYa8YGy6rnRHC6rNYuxlQE8GUzm7ezLs9
         Q7qTMeGun59pg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id E0BAF609F5;
        Thu, 25 Feb 2021 18:00:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] r8169: fix jumbo packet handling on RTL8168e
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161427600691.9193.11726487967728956648.git-patchwork-notify@kernel.org>
Date:   Thu, 25 Feb 2021 18:00:06 +0000
References: <b15ddef7-0d50-4320-18f4-6a3f86fbfd3e@gmail.com>
In-Reply-To: <b15ddef7-0d50-4320-18f4-6a3f86fbfd3e@gmail.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     kuba@kernel.org, davem@davemloft.net, nic_swsd@realtek.com,
        netdev@vger.kernel.org, joskera@redhat.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Thu, 25 Feb 2021 16:05:19 +0100 you wrote:
> Josef reported [0] that using jumbo packets fails on RTL8168e.
> Aligning the values for register MaxTxPacketSize with the
> vendor driver fixes the problem.
> 
> [0] https://bugzilla.kernel.org/show_bug.cgi?id=211827
> 
> Fixes: d58d46b5d851 ("r8169: jumbo fixes.")
> Reported-by: Josef Oškera <joskera@redhat.com>
> Tested-by: Josef Oškera <joskera@redhat.com>
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> 
> [...]

Here is the summary with links:
  - [net] r8169: fix jumbo packet handling on RTL8168e
    https://git.kernel.org/netdev/net/c/6cf739131a15

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


