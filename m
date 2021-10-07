Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD612425CC1
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 22:00:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241666AbhJGUCE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 16:02:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:43180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232977AbhJGUCB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Oct 2021 16:02:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 5A9A261108;
        Thu,  7 Oct 2021 20:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633636807;
        bh=x3PT3xb1Ue5CPveoXm5yN8BSwttpG1W6/uF972aHNPw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=oXt8MKRKQrnUJ/+9TydAkCxaSHt8m0jhHyjUtZP9jyDldmQnTy8FyfnO5eQbvs1sk
         xTsdx9xSdUtTiUQS+czQKYMCGDJ8eFhDLDYvaLNDRcbx6qnowIGX8iSsdAAEUvgftJ
         83O4vt1CgsHIfwnR+7xxsywvq5wrQSrjTAKlyCLv+yiW+nTHNSN/dGfqCxgXeXn2ZJ
         2F+epW/R9CiMVP+z2e9v1gb4VRIMQ7ZHV/g2G/dkc578mkTsrI809Z8l6NRBkqPobZ
         nRlrXBfbHpiDajNofh0Iosb8tP49zQTDVxccBzMeM7QgWwUx1l0we6Da2oRPryZP5T
         TMdqWkOFj4H2Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 4FDF960A23;
        Thu,  7 Oct 2021 20:00:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next] bpf, tests: Add more LD_IMM64 tests
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163363680732.2891.16730750818375886407.git-patchwork-notify@kernel.org>
Date:   Thu, 07 Oct 2021 20:00:07 +0000
References: <20211007143006.634308-1-johan.almbladh@anyfinetworks.com>
In-Reply-To: <20211007143006.634308-1-johan.almbladh@anyfinetworks.com>
To:     Johan Almbladh <johan.almbladh@anyfinetworks.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (master)
by Daniel Borkmann <daniel@iogearbox.net>:

On Thu,  7 Oct 2021 16:30:06 +0200 you wrote:
> This patch adds new tests for the two-instruction LD_IMM64. The new tests
> verify the operation with immediate values of different byte patterns.
> Mainly intended to cover JITs that want to be clever when loading 64-bit
> constants.
> 
> Signed-off-by: Johan Almbladh <johan.almbladh@anyfinetworks.com>
> 
> [...]

Here is the summary with links:
  - [bpf-next] bpf, tests: Add more LD_IMM64 tests
    https://git.kernel.org/bpf/bpf-next/c/af4bb50d4647

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


