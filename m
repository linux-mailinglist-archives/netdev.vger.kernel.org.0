Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 746A02B5656
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 02:40:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726424AbgKQBkF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 20:40:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:60780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725730AbgKQBkF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Nov 2020 20:40:05 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605577205;
        bh=aWa1sRw7CoxvhNmPL9K51E1+wWHyG8lRZmRe8hEAmnk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=zG+/Wrf4/tiiESFEtfmnWYdJeYJuVuQJVSY70ICNthQwZsVpvFrcoReOOX6AZSUdT
         hOEsTyEw4krlB17pL5qP+q8B+kTgv1KzhMOvttIgkTI1AnmxLzXIHxooFwtZBMG9A/
         CMXh/LmsoHVDGU7mu0pc7wClhGVM9APeka2edq1U=
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: ipa: lock when freeing transaction
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160557720487.5616.9020550394630303825.git-patchwork-notify@kernel.org>
Date:   Tue, 17 Nov 2020 01:40:04 +0000
References: <20201114182017.28270-1-elder@linaro.org>
In-Reply-To: <20201114182017.28270-1-elder@linaro.org>
To:     Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, kuba@kernel.org, evgreen@chromium.org,
        subashab@codeaurora.org, cpratapa@codeaurora.org,
        bjorn.andersson@linaro.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, swboyd@chromium.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Sat, 14 Nov 2020 12:20:17 -0600 you wrote:
> Transactions sit on one of several lists, depending on their state
> (allocated, pending, complete, or polled).  A spinlock protects
> against concurrent access when transactions are moved between these
> lists.
> 
> Transactions are also reference counted.  A newly-allocated
> transaction has an initial count of 1; a transaction is released in
> gsi_trans_free() only if its decremented reference count reaches 0.
> Releasing a transaction includes removing it from the polled (or if
> unused, allocated) list, so the spinlock is acquired when we release
> a transaction.
> 
> [...]

Here is the summary with links:
  - [net] net: ipa: lock when freeing transaction
    https://git.kernel.org/netdev/net/c/064c9c32b17c

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


