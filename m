Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18DB43DEB41
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 12:52:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235600AbhHCKvO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 06:51:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:42332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235481AbhHCKuf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Aug 2021 06:50:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 906C360F94;
        Tue,  3 Aug 2021 10:50:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627987805;
        bh=1QOQv5V34KtBH2qOa5zdjAHcBIUjPsffHWf1wD7XsIs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=m6K3nlrH9bFVlJMb1AnxLunweDSFEwdYsxaH1HFoPNjUHkNvZBim7qMHkMCJWC+pl
         RlgoHI2p5Ighis2ow/XkGmakWAevC09Y60vcuyKhQcSDhvbfVlbQUkeE0mHra7vacR
         95OsFQdLkaQvLywikqAKRIPLLh/4uvBr9wcLyKbABgWjCJnVLX6ymZjLAFYLRR2WB/
         FZQTvGqKy0Qd4OLxEyQYArBlUkONosIytk0fMPHORfhK60vD8IRNabd6KN+CUUGk1g
         mN+bWAIOXvKoEWER4VIV1RdZhXjxGIwIq5HFwI5+KUgBdcLspOH+9Cm4ILDOl3XkE4
         6TTnZ5WY4kKZw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 8551060A49;
        Tue,  3 Aug 2021 10:50:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] sctp: move the active_key update after sh_keys is added
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162798780554.3453.3732441559932672042.git-patchwork-notify@kernel.org>
Date:   Tue, 03 Aug 2021 10:50:05 +0000
References: <514d9b43054a4dc752b7d575700ad87ae0db5f0c.1627799131.git.lucien.xin@gmail.com>
In-Reply-To: <514d9b43054a4dc752b7d575700ad87ae0db5f0c.1627799131.git.lucien.xin@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Sun,  1 Aug 2021 02:25:31 -0400 you wrote:
> In commit 58acd1009226 ("sctp: update active_key for asoc when old key is
> being replaced"), sctp_auth_asoc_init_active_key() is called to update
> the active_key right after the old key is deleted and before the new key
> is added, and it caused that the active_key could be found with the key_id.
> 
> In Ying Xu's testing, the BUG_ON in sctp_auth_asoc_init_active_key() was
> triggered:
> 
> [...]

Here is the summary with links:
  - [net] sctp: move the active_key update after sh_keys is added
    https://git.kernel.org/netdev/net/c/ae954bbc451d

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


