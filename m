Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD25643E554
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 17:40:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230254AbhJ1Pmg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 11:42:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:41216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229946AbhJ1Pmf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Oct 2021 11:42:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 4FA91610C8;
        Thu, 28 Oct 2021 15:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635435608;
        bh=RhNp0ZDgNabWMlYljqrqlsicwJVv4uK8mY93cUQZpvY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=K9uEFhNkUPDkUy0Vtx9CpQsvF8Mo4SmjgrJ+ilxr7B1meYGp2JudEZD28juKUxGbX
         wzTr7jNjaBP7g8KAufQwTOSpIApfngWgnn7yJhwtxBxDqO8jzxHu5Zw6QN3Yod5tHG
         TYJtOZ632qBJXT2EAhBv2MJtW9DPHKBuHcaOv7KfMsmFEUFS3wyW4+lhDtS3Pk58lz
         ICqAew/G8KIqRQnYzQ5N8zvkdubmywG8+Rdfj7lUksrfm16qDfbM1roSZ1cnvL/BdS
         ATlfGyj+3nvOtG0U82woWNCpq5rRaQmZuyORrNsvx7Q0oTM922Dn3jv2jiWis2zmM3
         YcyaBsxhtUYTQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 3C8F1609CC;
        Thu, 28 Oct 2021 15:40:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf] riscv, bpf: Fix potential NULL dereference
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163543560824.29178.17218180216053026996.git-patchwork-notify@kernel.org>
Date:   Thu, 28 Oct 2021 15:40:08 +0000
References: <20211028125115.514587-1-bjorn@kernel.org>
In-Reply-To: <20211028125115.514587-1-bjorn@kernel.org>
To:     =?utf-8?b?QmrDtnJuIFTDtnBlbCA8Ympvcm5Aa2VybmVsLm9yZz4=?=@ci.codeaurora.org
Cc:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-riscv@lists.infradead.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 28 Oct 2021 14:51:15 +0200 you wrote:
> The bpf_jit_binary_free() function requires a non-NULL argument. When
> the RISC-V BPF JIT fails to converge in NR_JIT_ITERATIONS steps,
> jit_data->header will be NULL, which triggers a NULL
> dereference. Avoid this by checking the argument, prior calling the
> function.
> 
> Fixes: ca6cb5447cec ("riscv, bpf: Factor common RISC-V JIT code")
> Signed-off-by: Björn Töpel <bjorn@kernel.org>
> 
> [...]

Here is the summary with links:
  - [bpf] riscv, bpf: Fix potential NULL dereference
    https://git.kernel.org/netdev/net/c/27de809a3d83

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


