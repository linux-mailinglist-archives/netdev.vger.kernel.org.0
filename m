Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63D1E2E0416
	for <lists+netdev@lfdr.de>; Tue, 22 Dec 2020 02:51:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725938AbgLVBvg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Dec 2020 20:51:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:56732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726032AbgLVBvf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Dec 2020 20:51:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id D41C722A83;
        Tue, 22 Dec 2020 01:50:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608601854;
        bh=lsnE4BE4U5bUwGsqrqYaDruRhu9YBHUbN19RrCHxI9I=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ROQWlvoyRYQXbhDmYJ/N8k+rStNf+pziibVawxZ+/IwX0DF5sua2D4dRXPguUqEJ2
         41tFPHCYpENCN1y8adGFpLn/iwDRyqXIhXbGUXcnQbEXyBdlfRlZrT/cWV+vDx8grv
         purW9pBP+yyTnfPNmli2LYtQsWiSBpUWBTtQitHYNbERmPoSsayDr3LK8YP2rhc/br
         IKC6mi/5jH3Xx5z8ofO5cpdVDVWM/E0U6/9rglI2TNE8wh1l1k/GGJnV3mDBt0/dqM
         6+V3S0/bV3yYza7c9tnaP7vuy63T9ka7JGfFrriYCj1BxWI29BRqaPN3QldXM5cj//
         SslxSq/ezWhTA==
Received: from pdx-korg-docbuild-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-1.ci.codeaurora.org (Postfix) with ESMTP id CB063603F8;
        Tue, 22 Dec 2020 01:50:54 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] ppp: Fix PPPIOCUNBRIDGECHAN request number
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160860185482.6881.9727379640203695231.git-patchwork-notify@kernel.org>
Date:   Tue, 22 Dec 2020 01:50:54 +0000
References: <e3a4c355e3820331d8e1fffef8522739aae58b57.1608380117.git.gnault@redhat.com>
In-Reply-To: <e3a4c355e3820331d8e1fffef8522739aae58b57.1608380117.git.gnault@redhat.com>
To:     Guillaume Nault <gnault@redhat.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        tparkin@katalix.com, jchapman@katalix.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Sat, 19 Dec 2020 13:19:24 +0100 you wrote:
> PPPIOCGL2TPSTATS already uses 54. This shouldn't be a problem in
> practice, but let's keep the logical decreasing assignment scheme.
> 
> Fixes: 4cf476ced45d ("ppp: add PPPIOCBRIDGECHAN and PPPIOCUNBRIDGECHAN ioctls")
> Signed-off-by: Guillaume Nault <gnault@redhat.com>
> ---
> 
> [...]

Here is the summary with links:
  - [net] ppp: Fix PPPIOCUNBRIDGECHAN request number
    https://git.kernel.org/netdev/net/c/bcce55f556e8

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


