Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3162632C9D4
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 02:20:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243448AbhCDBMO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Mar 2021 20:12:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:49478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239825AbhCDAut (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Mar 2021 19:50:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 0877164F70;
        Thu,  4 Mar 2021 00:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614819007;
        bh=VZGcO2toRp0M0Nzy52Q5kcFhVFR/QjmGPI5Nlc/3wEc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=KL7zL6J7+1V9fHKIl6gx+TuJQLpXwmNnS2jLWOG/6IoE9V9SNEn7UiKFkTwfrGYE4
         w2fQWwZNfBjZj7DSD8i6V0kGwMd66NeFgw7ZaqhhzkMz9LGdLoaxNpVOQ7Yc9MgTtW
         pNyCj9c8PVvIa5ev5FxbjWnMGhgg4G5YhjCop1o3/8HkVMltQGOwzurxGNj51m0ITi
         dj9Twwaoz6Op8Lr0MO0zzLY9Jh47ndH6xXO4mPdOQrSzru9KJZeYUizwzmwPe6oRqm
         1ZQNBkn36zachMJrJt8Fm1OorGdkbVALd4AE5yyhTM34g2JIdRW2MCksJCUa1qno2r
         i6yFjBhitpTlw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id F1349609E7;
        Thu,  4 Mar 2021 00:50:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: wireless-drivers-2021-03-03
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161481900698.22203.12756456853178390495.git-patchwork-notify@kernel.org>
Date:   Thu, 04 Mar 2021 00:50:06 +0000
References: <20210303172632.8B86DC433ED@smtp.codeaurora.org>
In-Reply-To: <20210303172632.8B86DC433ED@smtp.codeaurora.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net.git (refs/heads/master):

On Wed,  3 Mar 2021 17:26:32 +0000 (UTC) you wrote:
> Hi,
> 
> here's a pull request to net tree, more info below. Please let me know if there
> are any problems.
> 
> Kalle
> 
> [...]

Here is the summary with links:
  - pull-request: wireless-drivers-2021-03-03
    https://git.kernel.org/netdev/net/c/ef9a6df09c76

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


