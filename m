Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67D8337B29A
	for <lists+netdev@lfdr.de>; Wed, 12 May 2021 01:33:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230095AbhEKXeT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 May 2021 19:34:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:55310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229848AbhEKXeQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 May 2021 19:34:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id AD41E6187E;
        Tue, 11 May 2021 23:33:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620775989;
        bh=88jrK9I4Dq2eASyjtJDd2o/SrR6b7wEGFnNd0e2gnVY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=mutFrnM2nGBNORcV5hBPMKQJY/VJvXAMzDgWOYEsxQxfzBmgybmBOFOV32ozMuLVH
         KTR2gK5At3VVoq5X+04TymHBWNke/ibILfYzujugVHmahRCsJuKO8ssf3u2swtEV0h
         N6OPukQ1gYQyPih1odlvzQou3U7UC6LaTVBjXK58bAinuGN+WB6K5dyRZ2UR7pEls+
         DoTr+VqfJ7i6u3i8IjkVdgszhIBF9MigYp0eLvo9N/3MmTZ86MMdns4Q5N2fLl0pZi
         siFLgks7ly8aqR8e1cnYYC6kgHhhS3wTXLY2AG7rull7zkRBep736ITHqja8rdIdnB
         DX8bV6K2umLMQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 9797A60A0B;
        Tue, 11 May 2021 23:33:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: ipa: memory region array is variable size
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162077598961.17752.12932657386514060582.git-patchwork-notify@kernel.org>
Date:   Tue, 11 May 2021 23:33:09 +0000
References: <20210511194204.863605-1-elder@linaro.org>
In-Reply-To: <20210511194204.863605-1-elder@linaro.org>
To:     Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, kuba@kernel.org, bjorn.andersson@linaro.org,
        evgreen@chromium.org, cpratapa@codeaurora.org,
        subashab@codeaurora.org, elder@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf.git (refs/heads/master):

On Tue, 11 May 2021 14:42:04 -0500 you wrote:
> IPA configuration data includes an array of memory region
> descriptors.  That was a fixed-size array at one time, but
> at some point we started defining it such that it was only
> as big as required for a given platform.  The actual number
> of entries in the array is recorded in the configuration data
> along with the array.
> 
> [...]

Here is the summary with links:
  - [net] net: ipa: memory region array is variable size
    https://git.kernel.org/bpf/bpf/c/440c3247cba3

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


