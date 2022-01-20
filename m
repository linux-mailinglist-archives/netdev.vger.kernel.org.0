Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FE7B494D8A
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 13:00:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232475AbiATMAL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 07:00:11 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:39092 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232464AbiATMAL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jan 2022 07:00:11 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DD76A61696;
        Thu, 20 Jan 2022 12:00:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4E7D7C340E5;
        Thu, 20 Jan 2022 12:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642680010;
        bh=B0LNF65epiT75ISbYwnKBeSakjUZozKKuUL/HAv2CUg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=iVv87KJZJOcHfIk0r8gXIs43F4GfMHvzMBjw8CRLtbMQ2oTumfkSaIYYukAZAzNBw
         atyiSP47B1DWGX5FRSeJA70BAQk6p73LawaWeIJDnNbORlRu/bpJ3MBYNuOakmibZL
         Q66hw9cWJFIc3nZyrFGSDJLyJNHgXmms4R5Nk/OD/MPsGAozmAXrKFZnZGBdmXxrOC
         oAc2wgBQ0grQKPBBSmaxIYWrYnap5nvqwJCCU9bz4QB8FZSeNDw/BIEkiddmoJ+zh7
         5dxKtoBADa+iH7q3/Gn0WBZKrFu5jMdg8FaX2eqxrNpBRD+y7P9zWSbOAr53sNo0dl
         RlqHIRwqVhsbQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 38527F6079B;
        Thu, 20 Jan 2022 12:00:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 0/2] net: stmmac: dwmac-visconti: Fix bit definitions and
 clock configuration for RMII mode
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164268001022.32466.14296016089234300224.git-patchwork-notify@kernel.org>
Date:   Thu, 20 Jan 2022 12:00:10 +0000
References: <20220119044648.18094-1-yuji2.ishikawa@toshiba.co.jp>
In-Reply-To: <20220119044648.18094-1-yuji2.ishikawa@toshiba.co.jp>
To:     Yuji Ishikawa <yuji2.ishikawa@toshiba.co.jp>
Cc:     davem@davemloft.net, kuba@kernel.org, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, joabreu@synopsys.com,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, nobuhiro1.iwamatsu@toshiba.co.jp
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 19 Jan 2022 13:46:46 +0900 you wrote:
> Hi,
> 
> This series is a fix for RMII/MII operation mode of the dwmac-visconti driver.
> It is composed of two parts:
> 
> * 1/2: fix constant definitions for cleared bits in ETHER_CLK_SEL register
> * 2/2: fix configuration of ETHER_CLK_SEL register for running in RMII operation mode.
> 
> [...]

Here is the summary with links:
  - [v2,1/2] net: stmmac: dwmac-visconti: Fix bit definitions for ETHER_CLK_SEL
    https://git.kernel.org/netdev/net/c/1ba1a4a90fa4
  - [v2,2/2] net: stmmac: dwmac-visconti: Fix clock configuration for RMII mode
    https://git.kernel.org/netdev/net/c/0959bc4bd420

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


