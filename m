Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDE06397D89
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 02:10:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235437AbhFBAMK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 20:12:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:56096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235296AbhFBALu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Jun 2021 20:11:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 7E16E613E7;
        Wed,  2 Jun 2021 00:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622592608;
        bh=SyFNUV2l6tmGkPboaz4rroWwDLleamp7lPyj+ufFBp4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=hMi/62+26cGvHnljDHuZD5x0W4LJfeyuMxfOPCm7vbLWuvoTpWNkkDrdrAlsEcf4T
         v2djqhzX+MlAdxtPChLrl6bParQj93WukxjNkXV5EXeQxs8T4rJPfAV8P7No2/Jp4R
         NgDLaCuHS/EtDfUsw4jMdOgiO7hznUBY7Y00W8yfgNtLX8HA1epG55RRudW9JtVP72
         mXbtzwRxDjZFef7+QRZKP2S+eQ/GQD4pgZbokwRqY25gKS1JpKg3rxOKOB1ES9MJrQ
         Ts6MpjCNYY2pqlR8M0cMGRaabRGYzQ36XumiEcK9YKvPuF0T3v6NJCbkG3N8qfprg2
         h390ifS4Qwiow==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 7703760A6F;
        Wed,  2 Jun 2021 00:10:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 1/1] net: stmmac: enable platform specific safety
 features
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162259260848.22595.3435009042583708673.git-patchwork-notify@kernel.org>
Date:   Wed, 02 Jun 2021 00:10:08 +0000
References: <20210601135235.1058841-1-vee.khee.wong@linux.intel.com>
In-Reply-To: <20210601135235.1058841-1-vee.khee.wong@linux.intel.com>
To:     Wong Vee Khee <vee.khee.wong@linux.intel.com>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org,
        mcoquelin.stm32@gmail.com, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue,  1 Jun 2021 21:52:35 +0800 you wrote:
> On Intel platforms, not all safety features are enabled on the hardware.
> The current implementation enable all safety features by default. This
> will cause mass error and warning printouts after the module is loaded.
> 
> Introduce platform specific safety features flag to enable or disable
> each safety features.
> 
> [...]

Here is the summary with links:
  - [net-next,1/1] net: stmmac: enable platform specific safety features
    https://git.kernel.org/netdev/net-next/c/5ac712dcdfef

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


