Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 430893B48F9
	for <lists+netdev@lfdr.de>; Fri, 25 Jun 2021 20:50:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229816AbhFYSwZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Jun 2021 14:52:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:41524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229671AbhFYSwY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Jun 2021 14:52:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id B1FFC61960;
        Fri, 25 Jun 2021 18:50:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624647003;
        bh=MDbdx1tGkxVWDukB2VXHB7pTkAgl4pZkTkkZwkJL7pc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=oz4mcXJjAREnhGJ2mr6G5MfPGuDP5ZHoo93zfn3Q26tJtfIypca+kYgq6rleHRqCy
         V9GgJfxlRbNnCl1/YLEr9ky4+KKXj5tj3ODvB2Vws02F1AcztYThxASk6eBjVoPl+h
         EIacdccXJmZWWFAd0rKyzkZ1rM676jivYNzBkHWqmfSzbGu2jxLPJMOdkIbqSEmsXu
         yJ6N7E5LWoEkVab1MMBospktkupkZVKv7r7xoHwrvFGUKF1U16uEKAXUf3sXhUjwF5
         TJi/WpMUCGw8ZhvYsLWIlKQRJ0lydkNeRcLIXBPT3WQiyszWweVb/DKnm5aizlXk/4
         dEwR6o+e/8nkw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id A4A9C60A37;
        Fri, 25 Jun 2021 18:50:03 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] Revert "be2net: disable bh with spin_lock in
 be_process_mcc"
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162464700366.1054.1799505322526105978.git-patchwork-notify@kernel.org>
Date:   Fri, 25 Jun 2021 18:50:03 +0000
References: <20210625082745.1761296-1-poros@redhat.com>
In-Reply-To: <20210625082745.1761296-1-poros@redhat.com>
To:     Petr Oros <poros@redhat.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        ajit.khaparde@broadcom.com, sriharsha.basavapatna@broadcom.com,
        somnath.kotur@broadcom.com, davem@davemloft.net, kuba@kernel.org,
        kda@linux-powerpc.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Fri, 25 Jun 2021 10:27:45 +0200 you wrote:
> Patch was based on wrong presumption that be_poll can be called only
> from bh context. It reintroducing old regression (also reverted) and
> causing deadlock when we use netconsole with benet in bonding.
> 
> Old revert: commit 072a9c486004 ("netpoll: revert 6bdb7fe3104 and fix
> be_poll() instead")
> 
> [...]

Here is the summary with links:
  - [net] Revert "be2net: disable bh with spin_lock in be_process_mcc"
    https://git.kernel.org/netdev/net/c/d6765985a42a

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


