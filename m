Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95E192E17DB
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 04:51:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727759AbgLWDus (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 22:50:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:35422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727261AbgLWDus (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Dec 2020 22:50:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id B9FE7223E8;
        Wed, 23 Dec 2020 03:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608695407;
        bh=68YIAocpAegvJarZSQkOD4cnGMaKrBeBemQS7jDpLMI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=V/bLbmVyULUTh1+0FCW8Uk6LpWbhfUz1jXd8N/SQmktK3SR75DWwekVLpXrTtY0Sk
         TtxQOQaoOUwCcwjmV8aG9xItJv/ykqdV8G195HZbgsY/KQ6UccA1WT9V0Wy1/+TZMG
         80K/dUxRG1RbQugUrI6Rlzj+lw2SUR1tZU0ZlGd4KdCXC4KsXUmcoN8skMg7cOY/sm
         Ik9GGdGs9ItCfq6G2cqhg0W1A/1qL2LEUvWgYoiYftQZabuldByQ7kc35/kk/bogqS
         STg4F0D2Q+FpHzo+tj821pU7dTn3m3+ZXvHKIJQOiA4wg6lpcs7FaqKX1JRnOSk2KU
         XYuAAin40VcQA==
Received: from pdx-korg-docbuild-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-1.ci.codeaurora.org (Postfix) with ESMTP id AD655604E9;
        Wed, 23 Dec 2020 03:50:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: wireless-drivers-2020-12-22
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160869540770.24460.3222068973861028264.git-patchwork-notify@kernel.org>
Date:   Wed, 23 Dec 2020 03:50:07 +0000
References: <20201222163727.D4336C433C6@smtp.codeaurora.org>
In-Reply-To: <20201222163727.D4336C433C6@smtp.codeaurora.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net.git (refs/heads/master):

On Tue, 22 Dec 2020 16:37:27 +0000 (UTC) you wrote:
> Hi,
> 
> here's a pull request to net tree, more info below. Please let me know if there
> are any problems.
> 
> Kalle
> 
> [...]

Here is the summary with links:
  - pull-request: wireless-drivers-2020-12-22
    https://git.kernel.org/netdev/net/c/e77c725a445a

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


