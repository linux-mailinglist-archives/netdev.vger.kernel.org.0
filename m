Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47AE441F540
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 21:00:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355051AbhJATBx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 15:01:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:52588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229464AbhJATBw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 Oct 2021 15:01:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 6E4B161A57;
        Fri,  1 Oct 2021 19:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633114807;
        bh=U42s5iau1W5Pvjq48XQ/CO41HHevX0PJPs6CUOzlwiU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=LMpHciWD+f6to/RtaSWb1HQr3JH+ExsZBU2k5ZHTIWtDRplDdt0wN6Dw8cjWwjjFe
         sg0q2hinPgmyMxQlmuiQHXX6tC6HKCmZjogPdbfqhFW70sh3fIfusvFabJyTAVLTLE
         ZYcUsntBsb4XRgeemeaOFd007XTICtjxn2TGeuA3YdCpsY74q56jWxFbugAWNrMpOt
         gebjdEZZ+8DvghRTRmVY8pP5W5B37zes+w6/wyJZCLiKnSh3Fx+HX3cJgQ4zjA4l+e
         7S6gVm51yyZYl0EN282DKcoeoYaVLdp0oqcqIgseZTAagot/XOUqhQm6/vqbrJdKCb
         9/f50qCYQ9Vsw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 6061960A4E;
        Fri,  1 Oct 2021 19:00:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: add kerneldoc comment for sk_peer_lock
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163311480739.17593.4114916723959154488.git-patchwork-notify@kernel.org>
Date:   Fri, 01 Oct 2021 19:00:07 +0000
References: <20211001164622.58520-1-eric.dumazet@gmail.com>
In-Reply-To: <20211001164622.58520-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com, sfr@canb.auug.org.au
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Fri,  1 Oct 2021 09:46:22 -0700 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> Fixes following warning:
> 
> include/net/sock.h:533: warning: Function parameter or member 'sk_peer_lock' not described in 'sock'
> 
> Fixes: 35306eb23814 ("af_unix: fix races in sk_peer_pid and sk_peer_cred accesses")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> 
> [...]

Here is the summary with links:
  - [net] net: add kerneldoc comment for sk_peer_lock
    https://git.kernel.org/netdev/net/c/5fb14d20f824

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


