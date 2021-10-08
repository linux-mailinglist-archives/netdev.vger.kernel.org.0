Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AE60426D66
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 17:20:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242889AbhJHPWE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Oct 2021 11:22:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:38966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242662AbhJHPWC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Oct 2021 11:22:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 1C9A460FD8;
        Fri,  8 Oct 2021 15:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633706407;
        bh=XaoepD9pnpqvmvlNYkOauTaOInKIGi3EeI10E4+GpuA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=LYVqtEzlITS9He8HreSE7lMmRr3pSD86Inmf9xioAt6/nrWgURw5UrLBxyH1cMqeD
         Eklo73u6xQSSw1HlCYYOl5Piyfwa4K+/AZx+CYnw8KmxYVK6Y+7mV4mPvQ3gqi2OpE
         oQZl7vfX1vOmLDM60W+ePxJmdurLPsVVWWQd67cpW3v9ueNgQp8XeeO0Q+neJhlfhr
         Sva7GoHxZQ0sVraprAdNPd7X77UesX+c4pEFpB2ZowHi+2mEF+nbhmLGwirj4rag/e
         lYHBeSKakEm+jtO/MrChPh9KseJz/J1C2aIL8NSvQFQXebUPVsOGoF2Xr1195cEVhl
         3ZTvuzp/C5hhQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 0F4F460A44;
        Fri,  8 Oct 2021 15:20:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] ath11k: fix m68k and xtensa build failure in
 ath11k_peer_assoc_h_smps()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163370640705.31693.17970287687909944942.git-patchwork-notify@kernel.org>
Date:   Fri, 08 Oct 2021 15:20:07 +0000
References: <20211008143932.23884-1-kvalo@codeaurora.org>
In-Reply-To: <20211008143932.23884-1-kvalo@codeaurora.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     netdev@vger.kernel.org, ath11k@lists.infradead.org,
        linux-wireless@vger.kernel.org, sfr@canb.auug.org.au,
        geert@linux-m68k.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri,  8 Oct 2021 17:39:32 +0300 you wrote:
> Stephen reported that ath11k was failing to build on m68k and xtensa:
> 
> In file included from <command-line>:0:0:
> In function 'ath11k_peer_assoc_h_smps',
>     inlined from 'ath11k_peer_assoc_prepare' at drivers/net/wireless/ath/ath11k/mac.c:2362:2:
> include/linux/compiler_types.h:317:38: error: call to '__compiletime_assert_650' declared with attribute error: FIELD_GET: type of reg too small for mask
>   _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
>                                       ^
> include/linux/compiler_types.h:298:4: note: in definition of macro '__compiletime_assert'
>     prefix ## suffix();    \
>     ^
> include/linux/compiler_types.h:317:2: note: in expansion of macro '_compiletime_assert'
>   _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
>   ^
> include/linux/build_bug.h:39:37: note: in expansion of macro 'compiletime_assert'
>  #define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), msg)
>                                      ^
> include/linux/bitfield.h:52:3: note: in expansion of macro 'BUILD_BUG_ON_MSG'
>    BUILD_BUG_ON_MSG((_mask) > (typeof(_reg))~0ull,  \
>    ^
> include/linux/bitfield.h:108:3: note: in expansion of macro '__BF_FIELD_CHECK'
>    __BF_FIELD_CHECK(_mask, _reg, 0U, "FIELD_GET: "); \
>    ^
> drivers/net/wireless/ath/ath11k/mac.c:2079:10: note: in expansion of macro 'FIELD_GET'
>    smps = FIELD_GET(IEEE80211_HE_6GHZ_CAP_SM_PS,
> 
> [...]

Here is the summary with links:
  - [net-next] ath11k: fix m68k and xtensa build failure in ath11k_peer_assoc_h_smps()
    https://git.kernel.org/netdev/net-next/c/16bdce2ada5a

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


