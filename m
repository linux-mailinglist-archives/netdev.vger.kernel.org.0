Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2C453AD204
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 20:20:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229475AbhFRSWP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 14:22:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:49946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235154AbhFRSWN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Jun 2021 14:22:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 50748613ED;
        Fri, 18 Jun 2021 18:20:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624040403;
        bh=YZXDHEiAHJ+1uypHZRStDKgICoaBK0OZqOFPPhfmMtQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=kcFE0P0VEdRNCCKj3X2QVZOUuUugUFWKPJwXaN5yimptJuSQRTdqPMcYUHGq6Kzcx
         AGx7AXbkVXy/OHpFQlekHMeMeX244Y/Vu2E8Ydl9etB22CRli2DJGykZlfB+DyojXS
         ML9hh/M/I/BD4iGvPx1WsSafpAVEZLcSCFdw8Qar/NqqfJt5K8ieXHI9hFv1fQJHc0
         CI/cHUpSTeywI+nGXkGl63911VMM0kr48rS8luqydNaBzNe5x8T09yB/Q/9Vh2chEz
         n4K4a/UJkOYKAV+k9tRM3J0lP9gAyo5WeA89fYj0FeMVqsPsKyxwoLWueAtKGeB0I1
         9AbRHumhwpVIQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 41EA460A17;
        Fri, 18 Jun 2021 18:20:03 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf] samples/bpf: Fix the error return code of xdp_redirect's
 main()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162404040326.13927.11610901471551028240.git-patchwork-notify@kernel.org>
Date:   Fri, 18 Jun 2021 18:20:03 +0000
References: <20210616042534.315097-1-wanghai38@huawei.com>
In-Reply-To: <20210616042534.315097-1-wanghai38@huawei.com>
To:     Wang Hai <wanghai38@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        kpsingh@kernel.org, bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (refs/heads/master):

On Wed, 16 Jun 2021 12:25:34 +0800 you wrote:
> Fix to return a negative error code from the error handling
> case instead of 0, as done elsewhere in this function.
> 
> If bpf_map_update_elem() failed, main() should return a negative error.
> 
> Fixes: 832622e6bd18 ("xdp: sample program for new bpf_redirect helper")
> Signed-off-by: Wang Hai <wanghai38@huawei.com>
> 
> [...]

Here is the summary with links:
  - [bpf] samples/bpf: Fix the error return code of xdp_redirect's main()
    https://git.kernel.org/bpf/bpf-next/c/7c6090ee2a7b

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


