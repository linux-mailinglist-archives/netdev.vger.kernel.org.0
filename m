Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0B6B3084AE
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 05:51:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231972AbhA2EvN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 23:51:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:52832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231947AbhA2Euz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Jan 2021 23:50:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 6B28964DFA;
        Fri, 29 Jan 2021 04:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611895813;
        bh=3Kv2/ZXqyVZe5YmLdXfB1UCDX0E1dUlO5HjGKKGorGo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=SZl5c643gUr2hd6eodCx1XTFhM+ALqpHgRJ8z3ZPBBXYUhj4kdfFtubqts4cQJ2ye
         3UHiTtM+cy9YUkO0e6BZEs2fnnJc6Yq0WBPPM/ak4sjUbO8ZEmSCzPMRj41bfbNfcp
         Q5s1Zox7y6xIWsPTI3sAqAfgL1JsFPr8aMEBfATX6PolcEzoBAbCtwy+WkFz/pGngF
         LLudt6cd0Sb9xEsIFines4jm3kZtIDf0YV3AFt6B8Uud8eErDOorEqmkUfIt8VHDja
         mpxwmof2LVhxGkBqy7j5Ju5g7Lk3NklO8pOz6bLjVKzYqphImMc4S5tHfg7yKjMvZT
         +DLePvm7j25fQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 5F27165326;
        Fri, 29 Jan 2021 04:50:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 0/6] net: ipa: hardware pipeline cleanup fixes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161189581338.32508.15067215532800740787.git-patchwork-notify@kernel.org>
Date:   Fri, 29 Jan 2021 04:50:13 +0000
References: <20210126185703.29087-1-elder@linaro.org>
In-Reply-To: <20210126185703.29087-1-elder@linaro.org>
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

On Tue, 26 Jan 2021 12:56:57 -0600 you wrote:
> Version 2 of this series fixes a "restricted __le16 degrades to
> integer" warning from sparse in the third patch.  The normal host
> architecture is little-endian, so the problem did not produce
> incorrect behavior, but the code was wrong not to perform the
> endianness conversion.  The updated patch uses le16_get_bits() to
> properly extract the value of the field we're interested in.
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/6] net: ipa: rename "tag status" symbols
    https://git.kernel.org/netdev/net-next/c/aa56e3e5cdb4
  - [net-next,v2,2/6] net: ipa: minor update to handling of packet with status
    https://git.kernel.org/netdev/net-next/c/162fbc6f4519
  - [net-next,v2,3/6] net: ipa: drop packet if status has valid tag
    https://git.kernel.org/netdev/net-next/c/f6aba7b5199a
  - [net-next,v2,4/6] net: ipa: signal when tag transfer completes
    https://git.kernel.org/netdev/net-next/c/51c48ce264f8
  - [net-next,v2,5/6] net: ipa: don't pass tag value to ipa_cmd_ip_tag_status_add()
    https://git.kernel.org/netdev/net-next/c/792b75b14786
  - [net-next,v2,6/6] net: ipa: don't pass size to ipa_cmd_transfer_add()
    https://git.kernel.org/netdev/net-next/c/070740d389aa

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


