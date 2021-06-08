Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CE263A03F5
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 21:25:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238250AbhFHTX5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 15:23:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:42312 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236010AbhFHTV5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Jun 2021 15:21:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id CA75D610A1;
        Tue,  8 Jun 2021 19:20:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623180003;
        bh=ro5NKQTYjlHQUSk2hsY8ng0jsC7W2HUXYh1ZNdRxNkk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=IS7VXkKcW8UZZgjTSPM0XixYwwmD037TUWBRmC2t3Ki/4OqKSp7loPNGt3c/NCofO
         5YAog4Vpvit7eX9jDla7MsyP/jYAVvxbVGgQ6IwfC97zOCJzbxkKGYWy46gnWGNVuW
         VRGUcvQeDspo73LVF7QNAZslOxRhNzB4/Hlvw1hGUbMrjCo3O8uybgY0A6lFtTiOQs
         9Vo0nM7TyMFyG1pP/OTWwrp3Nuhl2HxLjRPTgUGjy1Fm0xuEQwnG6w7cWrb1GW+Ld/
         ZBs29VOwk83XPGZ9KySg+xvF1jlva5zY+JBxVcSFDVrTsrAV+kgWBE74gOWsh3dAVf
         8/+z1kiUFn+Ug==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id BDFFD60A22;
        Tue,  8 Jun 2021 19:20:03 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 1/1] batman-adv: Avoid WARN_ON timing related checks
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162318000377.7737.11699354745969828257.git-patchwork-notify@kernel.org>
Date:   Tue, 08 Jun 2021 19:20:03 +0000
References: <20210608152947.30833-2-sw@simonwunderlich.de>
In-Reply-To: <20210608152947.30833-2-sw@simonwunderlich.de>
To:     Simon Wunderlich <sw@simonwunderlich.de>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        b.a.t.m.a.n@lists.open-mesh.org, sven@narfation.org,
        penguin-kernel@i-love.sakura.ne.jp,
        syzbot+c0b807de416427ff3dd1@syzkaller.appspotmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Tue,  8 Jun 2021 17:29:47 +0200 you wrote:
> From: Sven Eckelmann <sven@narfation.org>
> 
> The soft/batadv interface for a queued OGM can be changed during the time
> the OGM was queued for transmission and when the OGM is actually
> transmitted by the worker.
> 
> But WARN_ON must be used to denote kernel bugs and not to print simple
> warnings. A warning can simply be printed using pr_warn.
> 
> [...]

Here is the summary with links:
  - [1/1] batman-adv: Avoid WARN_ON timing related checks
    https://git.kernel.org/netdev/net/c/9f460ae31c44

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


