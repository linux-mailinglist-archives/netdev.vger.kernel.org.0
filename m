Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EC2633C8F0
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 23:01:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231721AbhCOWAf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 18:00:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:33348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231409AbhCOWAI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Mar 2021 18:00:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id F2ABE64F4D;
        Mon, 15 Mar 2021 22:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615845608;
        bh=lMEoOj1q+icuD0/tVgRGCgk1WwF2JDi0ziuaGcOzBIs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=mjQBoPzAfSQuaC6hx+0AmwVALKwlvId5W3m74Ll5V4b98HLuMNmb3RpLvpb6Ckxok
         wzj8sORfY8HOv9sa6744MBolvxz5ZQLOvzkFmdixwEStyMzvfyTyq6htrfBJdnviw0
         azGxXJArr4IC7cVXeCrXBbdJ5W6OxdZCIl4ReeFOewlCd0xgt6BDeK4LJ0AxVfrKyL
         UoGT0K6zF6W/j/T29kaHJAFw08imTtLfIH5xSXn8ZO85sXqm1Bz1RElgCxl7eS4Skw
         6rR3pJQWQGXNoP9A/wSsqIDYzQXrKap2ozaiEbIm/P8L5alDudn0bux53mwUkEssku
         qj2LKaRo8Mfrw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id E6FD760A19;
        Mon, 15 Mar 2021 22:00:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: ipa: make ipa_table_hash_support() inline
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161584560794.15277.15837378804770997090.git-patchwork-notify@kernel.org>
Date:   Mon, 15 Mar 2021 22:00:07 +0000
References: <20210315150118.1770939-1-elder@linaro.org>
In-Reply-To: <20210315150118.1770939-1-elder@linaro.org>
To:     Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, kuba@kernel.org, alexander.duyck@gmail.com,
        bjorn.andersson@linaro.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, elder@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon, 15 Mar 2021 10:01:18 -0500 you wrote:
> In review, Alexander Duyck suggested that ipa_table_hash_support()
> was trivial enough that it could be implemented as a static inline
> function in the header file.  But the patch had already been
> accepted.  Implement his suggestion.
> 
> Signed-off-by: Alex Elder <elder@linaro.org>
> 
> [...]

Here is the summary with links:
  - [net-next] net: ipa: make ipa_table_hash_support() inline
    https://git.kernel.org/netdev/net-next/c/0f13b5e6bf28

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


