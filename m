Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06D0C390C93
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 01:00:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232310AbhEYXBy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 May 2021 19:01:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:33016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232065AbhEYXBl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 May 2021 19:01:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 360DF61413;
        Tue, 25 May 2021 23:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621983611;
        bh=WIQn5JUuhEPqEZQMf0sfhTzbqn0OgQGaYSkMi9cVdn0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=hRRvuG+FQxPXRh+8WfjZPJRnvUWrts35wcxaVaZI4C+kFJjHsYeN5Sir5EHoCj7vq
         h80jfpVymyRNFNNPfupQ9Sk9N6T+G2Sv8MHJsqJzAtlwcH+Mp2FHeGbT0MpckEjqn8
         u4fYHBJegncEb13RUo/qJdoYlIXNHp8D2RqHEqyicWu/d1/nbCdJ89baFvq0eKbEeA
         3MZacqUn7AdTSSgZ1sGUDoZyCf6AyOV+f2pW8NNw0msagAwuQXd4NsP/yvGX3F5mul
         z6oKY1JziFLpgpB+x0XuDdKAXhGHknPdE6eBz/fNsDkw9ohzUKT3cvihmcJLBKDUi2
         ONSkfGFrYcHpA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 28B9260BE2;
        Tue, 25 May 2021 23:00:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/4] MPTCP fixes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162198361116.32227.16179567965464130072.git-patchwork-notify@kernel.org>
Date:   Tue, 25 May 2021 23:00:11 +0000
References: <20210525212313.148142-1-mathew.j.martineau@linux.intel.com>
In-Reply-To: <20210525212313.148142-1-mathew.j.martineau@linux.intel.com>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        matthieu.baerts@tessares.net, mptcp@lists.01.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Tue, 25 May 2021 14:23:09 -0700 you wrote:
> Here are a few fixes for the -net tree.
> 
> Patch 1 fixes an attempt to access a tcp-specific field that does not
> exist in mptcp sockets.
> 
> Patches 2 and 3 remove warning/error log output that could be flooded.
> 
> [...]

Here is the summary with links:
  - [net,1/4] mptcp: avoid OOB access in setsockopt()
    https://git.kernel.org/netdev/net/c/20b5759f21cf
  - [net,2/4] mptcp: drop unconditional pr_warn on bad opt
    https://git.kernel.org/netdev/net/c/3812ce895047
  - [net,3/4] mptcp: avoid error message on infinite mapping
    https://git.kernel.org/netdev/net/c/3ed0a585bfad
  - [net,4/4] mptcp: validate 'id' when stopping the ADD_ADDR retransmit timer
    https://git.kernel.org/netdev/net/c/d58300c3185b

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


