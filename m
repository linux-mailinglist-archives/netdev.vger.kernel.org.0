Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB1D728FDDC
	for <lists+netdev@lfdr.de>; Fri, 16 Oct 2020 07:57:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390495AbgJPF5M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Oct 2020 01:57:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:51134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390225AbgJPF5M (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Oct 2020 01:57:12 -0400
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602827831;
        bh=A9hby/QY7YmCCIPbSKHpzunHYsZ3zsFe03hiQjW/X7E=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=peEcS6FjzkYhvye8v1kRMJorUi2ICbkdVO5B64JRQZJbaFPTadDHgjuQLMRbid161
         1/gSROSgy3PDqBoKB2aYNZdCFCiflRD5JVxtkiIWRT2pRZB9lDVd1tbsMLrcuvvT9+
         LiynH3YOfsreMvHqraT1pjnEoHhmUwiySEUwkE60=
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [GIT PULL] Networking
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160282783169.22602.17744543398482887901.git-patchwork-notify@kernel.org>
Date:   Fri, 16 Oct 2020 05:57:11 +0000
References: <20201015141302.4e82985e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201015141302.4e82985e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net.git (refs/heads/master):

On Thu, 15 Oct 2020 14:13:02 -0700 you wrote:
> Hi!
> 
> The following changes since commit 3fdd47c3b40ac48e6e6e5904cf24d12e6e073a96:
> 
>   Merge tag 'for_linus' of git://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost (2020-10-08 14:25:46 -0700)
> 
> are available in the Git repository at:
> 
> [...]

Here is the summary with links:
  - [GIT,PULL] Networking
    https://git.kernel.org/netdev/net/c/9ff9b0d392ea

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


