Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8802C441BA0
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 14:20:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232354AbhKANWm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 09:22:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:50284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231794AbhKANWl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Nov 2021 09:22:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 0E81160EE9;
        Mon,  1 Nov 2021 13:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635772808;
        bh=eatbTcYn5xTsYExVI22lwTXjaouUiaBN5Sy8V2HifDM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Yhe7vJNPw6YudCISLKhYNEYjt8Ilg7X2Ctm+Nj9V6TOljj0IHmyMqDrjNY8Vd202U
         rD0igfxZLICwmoFPl5wFPwhr3BLqVCkLWDlPf2npXJPPG+gEbxQpLPR52gU1GqEuGm
         6A1463Ij3vCwam1/TfSCAjmSjeWMCIqk9yCyWymWag67FQ6DK2sNDI6BpUXxa1uWBf
         ZTukk5aM8Lefypw6kZonbL6d2MmZsiWmhyTfpkN+/3oLGOGfcFmgHF36XwpvihU3qT
         4nVSjdE3DtdOuHYB8q4GCUEpvxVbTUSRfD1rCS0FHkqI4glzZzq0E0qDRSoymcVKRm
         Ds3/moVcNpZIw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 03C2260AA4;
        Mon,  1 Nov 2021 13:20:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/2] udp6: allow SO_MARK ctrl msg to affect routing
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163577280801.31246.523680560913994797.git-patchwork-notify@kernel.org>
Date:   Mon, 01 Nov 2021 13:20:08 +0000
References: <20211029155135.468098-1-kuba@kernel.org>
In-Reply-To: <20211029155135.468098-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, willemb@google.com, netdev@vger.kernel.org,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 29 Oct 2021 08:51:33 -0700 you wrote:
> Hi!
> 
> Looks like SO_MARK from cmsg does not affect routing policy.
> This seems accidental.
> 
> I opted for net because of the discrepancy between IPv4
> and IPv6, but it never worked and doesn't cause crashes..
> 
> [...]

Here is the summary with links:
  - [net,1/2] udp6: allow SO_MARK ctrl msg to affect routing
    https://git.kernel.org/netdev/net/c/42dcfd850e51
  - [net,2/2] selftests: udp: test for passing SO_MARK as cmsg
    https://git.kernel.org/netdev/net/c/b0ced8f290fb

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


