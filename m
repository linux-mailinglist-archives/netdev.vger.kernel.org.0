Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E15D37B239
	for <lists+netdev@lfdr.de>; Wed, 12 May 2021 01:10:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230176AbhEKXLT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 May 2021 19:11:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:47060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229784AbhEKXLS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 May 2021 19:11:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id A6938616E8;
        Tue, 11 May 2021 23:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620774611;
        bh=RxO8rqbNKhnGA6/yv+HVtDqR1RDHt2nrwlR/Qd4jH6M=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=tt2K8iNBGhez3mOXVacd+sXu3R5+lWi9SPynq4eb+uQNR7z/zllzTVuLvMOy/yGpt
         rbVNjeRcHpE6rr6FGiMOBDUuOhcWb5HiIBuWLWrKmKNOAigvDlLWnpcXs+kgopuAlX
         ba1NY3Q1DUPFzIfWseja8xkT9u0n4xW85vQbOBSF04XSedKMx+Fb/du4IRBV50nfPM
         fGJpHM9ZG+aIfOfoJK3qMmTNzcrhF3zEU3ito3xuL8eodM0/tRQr6xvsWD+AUKr2tt
         enwtJLT9HChJOlCTeWdQvl/8MtKZots5xQknlh9Rtyiz1eiUJhglBaLdR55z7e3W2U
         4pwqY8nnWy9sA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 9E8F060A71;
        Tue, 11 May 2021 23:10:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: mac80211 2021-05-11
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162077461164.9014.5914886764334257230.git-patchwork-notify@kernel.org>
Date:   Tue, 11 May 2021 23:10:11 +0000
References: <20210511184454.164893-1-johannes@sipsolutions.net>
In-Reply-To: <20210511184454.164893-1-johannes@sipsolutions.net>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net.git (refs/heads/master):

On Tue, 11 May 2021 20:44:53 +0200 you wrote:
> Hi,
> 
> So exciting times, for the first pull request for fixes I
> have a bunch of security things that have been under embargo
> for a while - see more details in the tag below, and at the
> patch posting message I linked to.
> 
> [...]

Here is the summary with links:
  - pull-request: mac80211 2021-05-11
    https://git.kernel.org/netdev/net/c/9fe37a80c929

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


