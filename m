Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F60145483F
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 15:10:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238246AbhKQONK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 09:13:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:36566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234227AbhKQONK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Nov 2021 09:13:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id B109561BB3;
        Wed, 17 Nov 2021 14:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637158211;
        bh=PVeUVFTouHcWpAqbSeKlSHpKMsUgX+0RRhpp7yoyuQw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=GMx+U7USwS0FJR3I8BmMuEdHx1s0HLHeyuTJN+0/k/NexycJN+CihEo2QmTDAwmfC
         S0WTPkARxz0oaW7HnXqAcOcreYlEylyqm7nO0nB+h7FpHp9t2cptsv1S8qWbxwwXqK
         O0F65QWgyjDUp8baust3Y0d7kXZFJ8eDoPKeFbtdU/WgGnXnLkv1swWuJcmZabVlCo
         ws3gcwFfjf/rB49UUOXIXldXR50CghMejmpvg6DKanZ322kVV01n0J0dLgYz6TdIcd
         oQsSaCHzLYziuo4ch9mFVhVgccWe4oQxC7cOJ6OFQfn/jI1uvVSt5QBGRoTcszck4x
         VlftY3YLI8vHA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id A287360A0C;
        Wed, 17 Nov 2021 14:10:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] Documentation: networking: net_failover: Fix
 documentation
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163715821166.24451.4688350054015031132.git-patchwork-notify@kernel.org>
Date:   Wed, 17 Nov 2021 14:10:11 +0000
References: <20211116072148.2044042-1-vasudev@copyninja.info>
In-Reply-To: <20211116072148.2044042-1-vasudev@copyninja.info>
To:     Vasudev Kamath <vasudev@copyninja.info>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        sridhar.samudrala@intel.com, krikku@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue, 16 Nov 2021 12:51:48 +0530 you wrote:
> Update net_failover documentation with missing and incomplete
> details to get a proper working setup.
> 
> Signed-off-by: Vasudev Kamath <vasudev@copyninja.info>
> Reviewed-by: Krishna Kumar <krikku@gmail.com>
> ---
>  Documentation/networking/net_failover.rst | 111 +++++++++++++++++-----
>  1 file changed, 88 insertions(+), 23 deletions(-)

Here is the summary with links:
  - [net-next] Documentation: networking: net_failover: Fix documentation
    https://git.kernel.org/netdev/net-next/c/738baea4970b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


