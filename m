Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14DB9498535
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 17:49:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243921AbiAXQtI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 11:49:08 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:39034 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243913AbiAXQtH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 11:49:07 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5997960915;
        Mon, 24 Jan 2022 16:49:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B2892C340E8;
        Mon, 24 Jan 2022 16:49:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643042946;
        bh=jCkhpF0JwQ9vfFt2yel1D5nOCXvE8buWEryRKkSbWpU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=LG7EfHoLhxnaIx1P7MIvW1UamJrkox33TMRbFEADdCsVwFWPIqmFKR3oUItbwH0/e
         vCAM8nbWekDW5nH0/xGVVmx5KWgfST9RNrVg1G/9h/4NqAZJZCtQZdGax022CnE6go
         s2QuQss+eu9ubKcCs2Wn+UFxOQu+1nRFL0vDuYH1WyuYOt8oJaM6pCxJvi/NkdnSCa
         OnbGqnGhW4YEBi2uepDw9ZcY4U8NtDjOEhkSmL86J0m+Jrvuv3NEPDpamoX665CTyu
         bi1ESeF1tzeEMxvapG+sPQisAB3b80mcgzjnTKtVyAk38Kf+PSpZFmnFPkI/oCJZP8
         H+Lqz9OX7XQyg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A092AF6079F;
        Mon, 24 Jan 2022 16:49:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next] selftests: xsk: fix rx_full stats test
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164304294665.22498.1744310661834463735.git-patchwork-notify@kernel.org>
Date:   Mon, 24 Jan 2022 16:49:06 +0000
References: <20220121123508.12759-1-magnus.karlsson@gmail.com>
In-Reply-To: <20220121123508.12759-1-magnus.karlsson@gmail.com>
To:     Magnus Karlsson <magnus.karlsson@gmail.com>
Cc:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com, jonathan.lemon@gmail.com,
        bpf@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (master)
by Daniel Borkmann <daniel@iogearbox.net>:

On Fri, 21 Jan 2022 13:35:08 +0100 you wrote:
> From: Magnus Karlsson <magnus.karlsson@intel.com>
> 
> Fix the rx_full stats test so that it correctly reports pass even when
> the fill ring is not full of buffers.
> 
> Fixes: 872a1184dbf2 ("selftests: xsk: Put the same buffer only once in the fill ring")
> Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
> 
> [...]

Here is the summary with links:
  - [bpf-next] selftests: xsk: fix rx_full stats test
    https://git.kernel.org/bpf/bpf-next/c/b4ec6a192312

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


