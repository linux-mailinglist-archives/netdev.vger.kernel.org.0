Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 352D82CE1A5
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 23:31:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387570AbgLCWaw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 17:30:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:54938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725885AbgLCWaw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Dec 2020 17:30:52 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607034611;
        bh=xgkQfJ8gQ9Skcnghiv+SrJhxLx0T+KKog7UBJw/CiUI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=HJN3t9uvTnjDfb5YNxoly21/Md8gYiJ9PUluS0FvOX++fYafkRmLUwiKnciU3+qqt
         25T1g5wcBFFGgdJI9dHvaYDhML930P/+C+6QOcjXJz7/YM1AQMuKmg8R44CmcwKu9F
         8SRQ7klYnpt2x/iFtlQ6QUG+P8Rf7+Isv0oPUv+HeCt0ZPVb/vKSD1F5xg+4k9UKfP
         Z3RsDr/rIyYII7AJRp2Xo+/4vEs9UoHkO5I07Dbewcy3DB74TinywmYYMWqNqDdXNz
         KDdSJwlMsDc+K3sMQzvFLDPZLEneDvbnIOqsilLw3CnTfWOKYx9AA5ZmAMMMccXKRM
         v7iNTYeRWuWxA==
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [GIT PULL] Networking for 5.10-rc7
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160703461137.774.1632248569911721691.git-patchwork-notify@kernel.org>
Date:   Thu, 03 Dec 2020 22:30:11 +0000
References: <20201203204459.3963776-1-kuba@kernel.org>
In-Reply-To: <20201203204459.3963776-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     torvalds@linux-foundation.org, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net.git (refs/heads/master):

On Thu,  3 Dec 2020 12:44:59 -0800 you wrote:
> The following changes since commit c84e1efae022071a4fcf9f1899bf71777c49943a:
> 
>   Merge tag 'asm-generic-fixes-5.10-2' of git://git.kernel.org/pub/scm/linux/kernel/git/arnd/asm-generic (2020-11-27 15:00:35 -0800)
> 
> are available in the Git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.10-rc7
> 
> [...]

Here is the summary with links:
  - [GIT,PULL] Networking for 5.10-rc7
    https://git.kernel.org/netdev/net/c/bbe2ba04c5a9

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


