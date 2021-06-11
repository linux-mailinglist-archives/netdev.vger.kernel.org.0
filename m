Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F7183A49B5
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 22:00:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230454AbhFKUCM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 16:02:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:56756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230184AbhFKUCF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Jun 2021 16:02:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 086EB613E1;
        Fri, 11 Jun 2021 20:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623441607;
        bh=/dyKgNxMLCn0tn0sGR8ZFthoyTReDZ38QMG9XYMXW2Q=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Rx3o9NVoudsIBOW9/EXxFDDifexN5KGJqmTLhYwnU86AzPLIJfdib2VY5QXezKZ8b
         XdrOVoT/vEbd2Dc1sol/Qkvw3MNHDWF5Q6LsqRdy9ITtPqcgdb9tpXPcQWaOLLEA31
         uudrBQOok/9zOPna6STK7Djne/B9JQBhNC1Q36ezJCBPOMtJgnjA5MrTkLvEIaDWdD
         6yMZ9c13DrXR6bEK3Uz46iRHd43uVGt2RJsyaarkjTKmVYAL3yDWt36F8mbi4DwMAF
         2bNYAvMR7CYIceHlwxe711KE2WBeXvm5bija/sfHtb5jdIaQaiMkLN5OB3WcgvVC33
         gQNPlEsJtSeIw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id EB58460CE4;
        Fri, 11 Jun 2021 20:00:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] nfc: fdp: remove unnecessary labels
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162344160695.3583.8265428452075429197.git-patchwork-notify@kernel.org>
Date:   Fri, 11 Jun 2021 20:00:06 +0000
References: <20210610024616.1804-1-samirweng1979@163.com>
In-Reply-To: <20210610024616.1804-1-samirweng1979@163.com>
To:     samirweng1979 <samirweng1979@163.com>
Cc:     krzysztof.kozlowski@canonical.com, davem@davemloft.net,
        kuba@kernel.org, unixbhaskar@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, wengjianfeng@yulong.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Thu, 10 Jun 2021 10:46:16 +0800 you wrote:
> From: wengjianfeng <wengjianfeng@yulong.com>
> 
> Some labels are meaningless, so we delete them and use the
> return statement instead of the goto statement.
> 
> Signed-off-by: wengjianfeng <wengjianfeng@yulong.com>
> 
> [...]

Here is the summary with links:
  - nfc: fdp: remove unnecessary labels
    https://git.kernel.org/netdev/net-next/c/43fa32d1cc1b

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


