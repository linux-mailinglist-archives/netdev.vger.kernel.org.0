Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C0B63AD2BF
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 21:21:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235776AbhFRTWh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 15:22:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:33958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235435AbhFRTWQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Jun 2021 15:22:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id AB2C0613F9;
        Fri, 18 Jun 2021 19:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624044006;
        bh=HZ4786m59RuoK2hhVqx9AEvfGS19lUp25OPPq29lkUU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=m2OgkkTsdmofpAAu+W1ppBUgg89bpi+1Rut7sSdt4QOX6ZIbFyLif7ypQ6aA9wbDU
         +gaLLp7pX/cIr1d3ak3nb/YXyOoBCqpjRZvUolGJxw4RsExGqy2Z749K4WvUnarJ9G
         CBNVDmLMxX7RS/B6IcVMKj2YSCD44wPK/yl9n0vtH1CFeznK0ul49HoIZ+ZTCqYti3
         9dmnEQhninmnPpwIjfL8s+AKlz08LFngtHSp+2R62c5ugzIWHd17Zi/ebJcfoqBe4z
         c0fJK90vs8Vpa4E8ZyAYo63WkC7rga5LTcxlZSOSDTQMkAWuhSiCe9B2T35tqHuufu
         dGroWBUz9RBdA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 9BDEA60CE2;
        Fri, 18 Jun 2021 19:20:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: stmmac: remove redundant continue statement
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162404400663.12339.191732752255079680.git-patchwork-notify@kernel.org>
Date:   Fri, 18 Jun 2021 19:20:06 +0000
References: <20210618094425.100395-1-colin.king@canonical.com>
In-Reply-To: <20210618094425.100395-1-colin.king@canonical.com>
To:     Colin King <colin.king@canonical.com>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org,
        mcoquelin.stm32@gmail.com, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Fri, 18 Jun 2021 10:44:25 +0100 you wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> The continue statement in the for-loop has no effect, remove it.
> 
> Addresses-Coverity: ("Continue has no effect")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> 
> [...]

Here is the summary with links:
  - net: stmmac: remove redundant continue statement
    https://git.kernel.org/netdev/net-next/c/c44924c532fb

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


