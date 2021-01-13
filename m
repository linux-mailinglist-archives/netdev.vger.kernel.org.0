Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AA772F4327
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 05:31:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726082AbhAMEav (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 23:30:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:55008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725877AbhAMEau (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Jan 2021 23:30:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 037C02313C;
        Wed, 13 Jan 2021 04:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610512210;
        bh=CJ5xwc00drdm+Zm4GfJ6WUeVY/iAwWnv+3LT52ETQ94=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=UmpllbbjQ8IjeoyUvCWBk3JpYOnW+36JkM7n99wHz1cx84i45CE8WimO9qzfS9t1j
         DAqSRZtNnAjKC6CttUQaBRKyeTKQy8lMQrkQ8HJOCpGVMu14ijHL1n6jFnnfKUY4HX
         ACOSLyRiLQD3HxquwgCLqNyZC12bntxiXVy/58FX3uYDhQs/IxS4dx3Do7TToT2cMO
         YtWxDrTl9qFNtX6TBqtacXd39xQryISBQmNx1cR0UkDNIBjQZYEQK10ipzg2WCKqAb
         hz7Emv803wfry/XxZIxIExf9fMJufgcIA4wjRTXkENhOPJFf7cPCK9Lp7tubkfQxWR
         FSrBrMFesvNgw==
Received: from pdx-korg-docbuild-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-1.ci.codeaurora.org (Postfix) with ESMTP id EA5E4604E9;
        Wed, 13 Jan 2021 04:30:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: ipa: add config dependency on QCOM_SMEM
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161051220995.5581.14922384616430514042.git-patchwork-notify@kernel.org>
Date:   Wed, 13 Jan 2021 04:30:09 +0000
References: <20210112192134.493-1-elder@linaro.org>
In-Reply-To: <20210112192134.493-1-elder@linaro.org>
To:     Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, kuba@kernel.org, evgreen@chromium.org,
        bjorn.andersson@linaro.org, cpratapa@codeaurora.org,
        subashab@codeaurora.org, rdunlap@infradead.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue, 12 Jan 2021 13:21:34 -0600 you wrote:
> The IPA driver depends on some SMEM functionality (qcom_smem_init(),
> qcom_smem_alloc(), and qcom_smem_virt_to_phys()), but this is not
> reflected in the configuration dependencies.  Add a dependency on
> QCOM_SMEM to avoid attempts to build the IPA driver without SMEM.
> This avoids a link error for certain configurations.
> 
> Reported-by: Randy Dunlap <rdunlap@infradead.org>
> Fixes: 38a4066f593c5 ("net: ipa: support COMPILE_TEST")
> Signed-off-by: Alex Elder <elder@linaro.org>
> 
> [...]

Here is the summary with links:
  - [net-next] net: ipa: add config dependency on QCOM_SMEM
    https://git.kernel.org/netdev/net-next/c/46e05e1df628

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


