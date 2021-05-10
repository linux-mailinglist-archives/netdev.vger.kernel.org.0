Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 120F73799F0
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 00:20:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232917AbhEJWVm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 May 2021 18:21:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:58290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231807AbhEJWVS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 May 2021 18:21:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 1C04F61574;
        Mon, 10 May 2021 22:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620685212;
        bh=IGpo852VP0UBJMhzDDLnJgI8WU2p1gQKmQuCOOvO5Bc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ah8uiay4b5d5Gvt6fV8aCCP1s1o2xIWWJ7DfuH/xW12TUkBf5qzUX8gs+jsL6+xJK
         wTGwCGIN0n9OdGFHluU7b0aFgrMInXhnZKnpjpRQa11tMzrs1z6BIP2hwOHAEpiu27
         m/VstknEWvsSdeLLxi/TfFVfTMIJDilKtOpKw2eYotlDacn5QUMwmOHJO/LnF+r2sf
         VcK4mXSbsR71zhxeI3PVFKzYgqUUid2ZFK28Yl/mo/C4r5uG7Dp27ZZnKTWA+xQ2lp
         C1Y+nsO6EAfaxMi9FR+I9PgKMZCDbwXSdbEJHt0U7CPSUaSvJ6cz5WhlqjVxFlGt11
         sdwY8gCzOVvTw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 104FC60A48;
        Mon, 10 May 2021 22:20:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v1 1/1] atm: Replace custom isprint() with generic analogue
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162068521206.17141.12558344137042579043.git-patchwork-notify@kernel.org>
Date:   Mon, 10 May 2021 22:20:12 +0000
References: <20210510144909.58123-1-andriy.shevchenko@linux.intel.com>
In-Reply-To: <20210510144909.58123-1-andriy.shevchenko@linux.intel.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, 3chas3@gmail.com, lkp@intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon, 10 May 2021 17:49:09 +0300 you wrote:
> Custom isprint() definition may collide with one form ctype.h.
> In order to avoid this, replace it with a functional analogue
> which is isascii() && isprint() in this case.
> 
> First appearance of the code is in the commit 636b38438001
> ("Import 2.3.43").
> 
> [...]

Here is the summary with links:
  - [v1,1/1] atm: Replace custom isprint() with generic analogue
    https://git.kernel.org/netdev/net-next/c/532062b09956

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


