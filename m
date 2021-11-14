Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BF8644F7DD
	for <lists+netdev@lfdr.de>; Sun, 14 Nov 2021 13:30:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235894AbhKNMdC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Nov 2021 07:33:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:46888 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235756AbhKNMdB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 14 Nov 2021 07:33:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 8A40A61164;
        Sun, 14 Nov 2021 12:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636893007;
        bh=cx51PSUwREeky8Z/ulRMdAX/ywe1FUYhUu22mpwW6G8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=A3AS2d0qVE7XMFIbN0MVXlHCBNAqFuu0nJqROwLdzffBSbMTycjTlockDev8PZJyy
         5bOxElLpl+nrzuQ0NipXN5EX89UNG5plBa4+3gInAFpsl9SFCUCdaZchi5E9AWNh/E
         I8m9UWp7QQGbad/iZ0Fi6U2wltc+fH/zAoqonWO9WleVWyHayBxzrjd7bnHHhL0IVK
         OAVAWhJpXcgPTmCW2MeHzCDSNhaDoUSKfE78XBP9PlwE/2wsWYGXueFsaDyWUeIiVR
         ntkB2N0gvpDZwcfYUW6+rke1pJoDTS9AioTuN8KceoQw7PIko2wTlrYvMGr/kqMrJ8
         Zw4WtjEMpUaYw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 7E3456097A;
        Sun, 14 Nov 2021 12:30:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net,lsm,selinux: revert the security_sctp_assoc_established()
 hook
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163689300751.19604.8326940151173653633.git-patchwork-notify@kernel.org>
Date:   Sun, 14 Nov 2021 12:30:07 +0000
References: <163675909043.176428.14878151490285663317.stgit@olly>
In-Reply-To: <163675909043.176428.14878151490285663317.stgit@olly>
To:     Paul Moore <paul@paul-moore.com>
Cc:     selinux@vger.kernel.org, linux-security-module@vger.kernel.org,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 12 Nov 2021 18:18:10 -0500 you wrote:
> This patch reverts two prior patches, e7310c94024c
> ("security: implement sctp_assoc_established hook in selinux") and
> 7c2ef0240e6a ("security: add sctp_assoc_established hook"), which
> create the security_sctp_assoc_established() LSM hook and provide a
> SELinux implementation.  Unfortunately these two patches were merged
> without proper review (the Reviewed-by and Tested-by tags from
> Richard Haines were for previous revisions of these patches that
> were significantly different) and there are outstanding objections
> from the SELinux maintainers regarding these patches.
> 
> [...]

Here is the summary with links:
  - net,lsm,selinux: revert the security_sctp_assoc_established() hook
    https://git.kernel.org/netdev/net/c/1aa3b2207e88

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


