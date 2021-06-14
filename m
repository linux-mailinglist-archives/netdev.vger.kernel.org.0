Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2DA53A6EC7
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 21:21:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234322AbhFNTWJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 15:22:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:39816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234214AbhFNTWH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Jun 2021 15:22:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 42CC26124B;
        Mon, 14 Jun 2021 19:20:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623698404;
        bh=AwfEQu8WgkRay4GabiOOKXF4haBDsaAbj1mCjq1A0Q8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=SAmQsH9iJVe4FzgY6eaLvMKG9seDWby9h71hlPwYH0otulP+b8nMrmWAihe3OjkEA
         SkaWUf0p1qF2m4CzO6w/HxIGs01+8JhmCq2e70IMWBmnaGQXfU0B6+hdmeQmeEI7Oz
         PA9DrqePexnQVXwSzVR+HpdEFKGsbq+ETybLP2w8IxclvJeQplfT5iDEjbkOGno0e7
         CV1FUojyN+uYAzRYbf2nl8hRRQcWgeDODtHJoVFV3q7eFV8Gely3ewbhkDrzSVt29n
         +6oCXHGGatNWnLBvoZakzmd6Ls1gVXF/1a4HoY6uDlGHLKgFLdhQgu0GVI33CjffBs
         vnBlH2MMt9lKw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 3707460972;
        Mon, 14 Jun 2021 19:20:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: qualcomm: rmnet: don't over-count statistics
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162369840422.27454.3314678214890028177.git-patchwork-notify@kernel.org>
Date:   Mon, 14 Jun 2021 19:20:04 +0000
References: <20210611182600.2972987-1-elder@linaro.org>
In-Reply-To: <20210611182600.2972987-1-elder@linaro.org>
To:     Alex Elder <elder@linaro.org>
Cc:     subashab@codeaurora.org, stranche@codeaurora.org,
        davem@davemloft.net, kuba@kernel.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Fri, 11 Jun 2021 13:26:00 -0500 you wrote:
> The purpose of the loop using u64_stats_fetch_*_irq() is to ensure
> statistics on a given CPU are collected atomically. If one of the
> statistics values gets updated within the begin/retry window, the
> loop will run again.
> 
> Currently the statistics totals are updated inside that window.
> This means that if the loop ever retries, the statistics for the
> CPU will be counted more than once.
> 
> [...]

Here is the summary with links:
  - [net] net: qualcomm: rmnet: don't over-count statistics
    https://git.kernel.org/netdev/net/c/994c393bb688

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


