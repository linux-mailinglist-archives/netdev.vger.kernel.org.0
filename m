Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C58B044B41D
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 21:40:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244534AbhKIUmy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Nov 2021 15:42:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:46972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242487AbhKIUmx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Nov 2021 15:42:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 6A90F611AF;
        Tue,  9 Nov 2021 20:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636490407;
        bh=RYcIMR5vEokbAR+QXtzkXpw/phiwZkZKI+KjU00rhFE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=fm+8W0eqEhK6Qtr+gt0aZA7lxDb1W3bKyu9TlnWHQn8/uhFB0hVh2k90uOWwpylTP
         9HVtre8H4irHXaNhn/W6AOdTznJDrnTa6vHEsK6x4IxC2CS75fOia7jzX9pRXKAF+v
         Svr+qLuY9/+4cM0cKQUkq9GCRLvrT4iDUtDYurwYkVHa6LX9y8V9kyNVN95mSXEK+s
         HUrgHeDx1mhYg6jcki9f3c7qxQ6tMLObfY+LJpqU2s4Q6UU4cjv37uK1kao0yRlOkj
         TjlOnCnwoFAY78qZRrvYbqTn7nUxl77IKx4UZmVxXvyVIksreE6GUBBi529N58X2Iq
         ul97rDQ2gOwVg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 5C8DC60A89;
        Tue,  9 Nov 2021 20:40:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH ethtool v2 0/1] Fix condition for showing MDI-X status
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163649040737.15746.8792472619973521733.git-patchwork-notify@kernel.org>
Date:   Tue, 09 Nov 2021 20:40:07 +0000
References: <20211109172125.10505-1-bage@linutronix.de>
In-Reply-To: <20211109172125.10505-1-bage@linutronix.de>
To:     Bastian Germann <bage@linutronix.de>
Cc:     mkubecek@suse.cz, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to ethtool/ethtool.git (master)
by Michal Kubecek <mkubecek@suse.cz>:

On Tue,  9 Nov 2021 18:21:24 +0100 you wrote:
> From: Bastian Germann <bage@linutronix.de>
> 
> Fix a duplicate condition in the filter for showing MDI-X info.
> I am not intending to continue on this issue, so I am dropping
> the second patch (invalid for the current kernel side handling).
> 
> Changelog:
>  v2: - Collect the additional tags
>      - Drop the 2nd patch with the twisted pair port condition
> 
> [...]

Here is the summary with links:
  - [ethtool,v2,1/1] netlink: settings: Correct duplicate condition
    https://git.kernel.org/pub/scm/network/ethtool/ethtool.git/commit/?id=fd7db6457916

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


