Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E98E74038A8
	for <lists+netdev@lfdr.de>; Wed,  8 Sep 2021 13:21:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351239AbhIHLVT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Sep 2021 07:21:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:59938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349207AbhIHLVN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Sep 2021 07:21:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 69A5F61163;
        Wed,  8 Sep 2021 11:20:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631100005;
        bh=h5898k9wyHKn5WFZVxWlI2b2qlF+887eYsHc+DWOrNY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Bdzi1HR8NuCwS5lswFMs1lCfnDwtmUhsF+JazfGq+QubKT6ppisy85aIZvXiV5T24
         ihRuNbxZjTzgdTNdSFXUGWviwXn4F8D/ZoJT4Iv1yVZ+/rGf1asAlZHv+Yw/bCx5L+
         dwnnBbeZmBFmQwPHQHzoyoO2FPNV7rJYnOfDrqmzLJUsfXMxpPROacITlHIJKq0dPS
         RWYt2/7OnUtYCtRcg90KGVOYigBWU5c5tTNQIB8zTzFmaRKgTBZrwCYXwfmXfEIBKC
         0CWR1rMDrJY4/lJuKRlybEPsKRKGjqLy391acD2For4s1rJPDHCn6YCYf10XQWSMlJ
         6IObINUkmqiew==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 5E9C760A24;
        Wed,  8 Sep 2021 11:20:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: ipa: initialize all filter table slots
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163110000538.4441.10523758645271949269.git-patchwork-notify@kernel.org>
Date:   Wed, 08 Sep 2021 11:20:05 +0000
References: <20210907170554.399108-1-elder@linaro.org>
In-Reply-To: <20210907170554.399108-1-elder@linaro.org>
To:     Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, kuba@kernel.org, pkurapat@codeaurora.org,
        avuyyuru@codeaurora.org, bjorn.andersson@linaro.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org,
        evgreen@chromium.org, elder@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Tue,  7 Sep 2021 12:05:54 -0500 you wrote:
> There is an off-by-one problem in ipa_table_init_add(), when
> initializing filter tables.
> 
> In that function, the number of filter table entries is determined
> based on the number of set bits in the filter map.  However that
> count does *not* include the extra "slot" in the filter table that
> holds the filter map itself.  Meanwhile, ipa_table_addr() *does*
> include the filter map in the memory it returns, but because the
> count it's provided doesn't include it, it includes one too few
> table entries.
> 
> [...]

Here is the summary with links:
  - [net] net: ipa: initialize all filter table slots
    https://git.kernel.org/netdev/net/c/b5c102238cea

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


