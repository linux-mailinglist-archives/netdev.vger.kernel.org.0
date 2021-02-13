Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 895DA31A930
	for <lists+netdev@lfdr.de>; Sat, 13 Feb 2021 02:02:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232366AbhBMBA4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 20:00:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:58788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231952AbhBMBAt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Feb 2021 20:00:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 695D464E0A;
        Sat, 13 Feb 2021 01:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613178009;
        bh=am+bzmi8nif6VN98EecF6S77xKZRf7Mz6WAtm5mou84=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=hOn9adx/LyhSGHmPqEy2MRpCgSchcVuH7Kv03lu9oqUfZjnQAszZurEApxwmnDoEo
         ZrxOHvF8Fmnk9LSCm+c9W0J9RN77Iv9njOziSpha0u7Eb63YbcPs6JbmOjYEnSI0As
         RwNqOVwHYGADWvk7mL5GZSQdym+8lrnbTEYdn8lD7TPYTVxZI96BZ6pPUl3fyLIWR2
         +sxEhoJMYVQvIQw3qx4S/lDeMl8fTVCOsJyjGQtl3jZwfdMysvFo4XNxhv1O4yXV86
         u8rpw3YZp0w7gqV5Tq76hJauZFaA63Dky/WaQgmrUhXbsWRX9kUgqRN2vxOzfbR+j+
         8aU8zqR3Hfppw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 57D6260971;
        Sat, 13 Feb 2021 01:00:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3 net-next 0/5] net: ipa: some more cleanup
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161317800935.11471.14534739208351267742.git-patchwork-notify@kernel.org>
Date:   Sat, 13 Feb 2021 01:00:09 +0000
References: <20210212143402.2691-1-elder@linaro.org>
In-Reply-To: <20210212143402.2691-1-elder@linaro.org>
To:     Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, kuba@kernel.org, elder@kernel.org,
        evgreen@chromium.org, bjorn.andersson@linaro.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Fri, 12 Feb 2021 08:33:57 -0600 you wrote:
> Version 3 of this series uses dev_err_probe() in the second patch,
> as suggested by Heiner Kallweit.
> 
> Version 2 was sent to ensure the series was based on current
> net-next/master, and added copyright updates to files touched.
> 
> The original introduction is below.
> 
> [...]

Here is the summary with links:
  - [v3,net-next,1/5] net: ipa: use a separate pointer for adjusted GSI memory
    https://git.kernel.org/netdev/net-next/c/571b1e7e58ad
  - [v3,net-next,2/5] net: ipa: use dev_err_probe() in ipa_clock.c
    https://git.kernel.org/netdev/net-next/c/4c7ccfcd09fd
  - [v3,net-next,3/5] net: ipa: fix register write command validation
    https://git.kernel.org/netdev/net-next/c/2d65ed76924b
  - [v3,net-next,4/5] net: ipa: introduce ipa_table_hash_support()
    https://git.kernel.org/netdev/net-next/c/a266ad6b5deb
  - [v3,net-next,5/5] net: ipa: introduce gsi_channel_initialized()
    https://git.kernel.org/netdev/net-next/c/6170b6dab2d4

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


