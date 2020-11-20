Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA6E02BA0DF
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 04:11:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727336AbgKTDKa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 22:10:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:35354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727318AbgKTDK3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Nov 2020 22:10:29 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605841829;
        bh=TEti/QK0d1u/sEEkasO1ZIHKhE5XzILDoAlxYWLtUag=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=aNYXqO5+ECMmF4zbuUZMU5otQyDKGzQJQ0UhoLHfhCBeEF5QXwrvo+Yb5jlNChvxg
         DsbHuvoci2V5gsl4MVKqzHT2hdEfh/YpQCwK7eifjcncc0IPQpvrNRCs3Nuj4ZDIhs
         RrYZoK0nNYLqPIR5Enc+L7XOeO1NkOzZlN+6PR9c=
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [GIT PULL] Networking
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160584182916.12719.12482696439938475107.git-patchwork-notify@kernel.org>
Date:   Fri, 20 Nov 2020 03:10:29 +0000
References: <20201119211531.3441860-1-kuba@kernel.org>
In-Reply-To: <20201119211531.3441860-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     torvalds@linux-foundation.org, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net.git (refs/heads/master):

On Thu, 19 Nov 2020 13:15:31 -0800 you wrote:
> The following changes since commit db7c953555388571a96ed8783ff6c5745ba18ab9:
> 
>   Merge tag 'net-5.10-rc4' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2020-11-12 14:02:04 -0800)
> 
> are available in the Git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.10-rc5
> 
> [...]

Here is the summary with links:
  - [GIT,PULL] Networking
    https://git.kernel.org/netdev/net/c/4d02da974ea8

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


