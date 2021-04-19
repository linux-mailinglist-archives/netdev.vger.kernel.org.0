Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59B70364EBF
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 01:40:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232314AbhDSXkk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 19:40:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:36466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229842AbhDSXkj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Apr 2021 19:40:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 573A76127C;
        Mon, 19 Apr 2021 23:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618875609;
        bh=YFMR1CrT8IXUUNrAy5Ul9VF19JsQIWMFohLmhpn71Vw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=UZ9KuqYuqvyHx9cB+RYAylObuqwZi/MkS2I252PfzcxneHp9w7cdhZRiccWE5PmH8
         qvehcMllWEtp8h5OO3RKk8OqXQ17pB6dTb0KgMsZ5FsGfIVuwogkwxSeALeNPUe348
         XFLoJrzyFATL9Vx/obc/eitAy7OG+Z/YfatUOSapKw7+IVNtbA5dxFemyFtxGtCCdS
         k9sxYW3O3Hoz1Lf3ztTSc5iPBcNwrYjGX9YvnAlMEudqRKHqeKBlCsU8aY2Gp32Rou
         ZqeCmILaSfJguFILAikMolvOBdZ+KJSkoH4y0V/Usk/ArRo6qGQB2ElYwhgBsRlymB
         hvxx9fEe4UKQg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 48F4360970;
        Mon, 19 Apr 2021 23:40:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] MAINTAINERS: update
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161887560929.13803.2397044457894925895.git-patchwork-notify@kernel.org>
Date:   Mon, 19 Apr 2021 23:40:09 +0000
References: <20210419212525.12894-1-ljp@linux.ibm.com>
In-Reply-To: <20210419212525.12894-1-ljp@linux.ibm.com>
To:     Lijun Pan <ljp@linux.ibm.com>
Cc:     netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Mon, 19 Apr 2021 16:25:25 -0500 you wrote:
> I am making this change again since I received the following instruction.
> 
> "As an IBM employee, you are not allowed to use your gmail account to work
> in any way on VNIC. You are not allowed to use your personal email account
> as a "hobby". You are an IBM employee 100% of the time.
> Please remove yourself completely from the maintainers file.
> I grant you a 1 time exception on contributions to VNIC to make this
> change."
> 
> [...]

Here is the summary with links:
  - [net] MAINTAINERS: update
    https://git.kernel.org/netdev/net/c/4acd47644ef1

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


