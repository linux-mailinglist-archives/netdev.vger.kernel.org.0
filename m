Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00EFF453EB6
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 04:00:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232796AbhKQDDJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 22:03:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:39002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231214AbhKQDDI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Nov 2021 22:03:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id D62D661BF9;
        Wed, 17 Nov 2021 03:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637118010;
        bh=NbvoHfHUMlZP9Cfd0+4Rnb8ASJ6mq3JxJi8yrVmrGi8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=tPYDbtNN9qT5GEIuDbKQiyCqCmzaRb2zvJ7SBaIVwR8gU7azmcK/qlLUOqGT5mqR3
         CldYw2zptC1y0yzAMU/fz0NQ0fyFwb+XmHjsX6d12bZEFdoPMga54CVpADMZiaGF3J
         5puc7mzsmcUw0mn1gDdHQwuwlg9MOHEpyzCiF4LqvEJI6OBQz3g9gp1B8IagrkTQok
         5v32jtTF6k9NuZq8Km3Lb6dkP1G1RAhjoL9Puabxnnq26ydpTHCYD0qY3gisH2u3To
         b0YASZVmpzRHu17c4ZtQVCuqoqmzBTDq/vpGaHwezwVkCTuf/Ds4Y4Xbv6fjMLJ8ry
         40sJCjRwsABjw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id C871260A4E;
        Wed, 17 Nov 2021 03:00:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: bpf 2021-11-16
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163711801081.22897.9430715087196163726.git-patchwork-notify@kernel.org>
Date:   Wed, 17 Nov 2021 03:00:10 +0000
References: <20211116141134.6490-1-daniel@iogearbox.net>
In-Reply-To: <20211116141134.6490-1-daniel@iogearbox.net>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        andrii@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 16 Nov 2021 15:11:34 +0100 you wrote:
> Hi David, hi Jakub,
> 
> The following pull-request contains BPF updates for your *net* tree.
> 
> We've added 12 non-merge commits during the last 5 day(s) which contain
> a total of 23 files changed, 573 insertions(+), 73 deletions(-).
> 
> [...]

Here is the summary with links:
  - pull-request: bpf 2021-11-16
    https://git.kernel.org/netdev/net/c/f083ec316032

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


