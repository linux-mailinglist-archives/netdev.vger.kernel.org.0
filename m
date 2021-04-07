Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D3A5357707
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 23:40:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233888AbhDGVkW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 17:40:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:46518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233656AbhDGVkT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Apr 2021 17:40:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 2123B61205;
        Wed,  7 Apr 2021 21:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617831609;
        bh=ZwaUl9sLrbbxgNXIb7aCmGXwm21nyydF5HAEikvJznw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Zb4EwogKgJruWMlmvhHXzMvt0b0o2/sOyTIbdSlHZkfWTun9hdocPcLGV+RgpLPRG
         t9Nxdzmeze1gNNADLQ5VQVXy3nZAT+QuTgHLuTYZd12b5EMyjSgd5eHWh6cuFgoECB
         n1IVF5fC65lXNL/s+xVuek8zWnRTtrbu67QdffpMliLBwuQmS7eU8/yksmy9+8atqW
         qwMfqxVPW7nF/vQbv5LGlCJ6C2oX03bXBUzvoeAVJ3XfyGdlASrIponLBlPYp22a+E
         Fz+HW314zIB7wgdfavKUHi3M2q3x91IDSHKhN2+ceAyLP9gESbtHqrof7u5mTPM6oA
         pNC0ndyjQzuJw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 0ED0960A71;
        Wed,  7 Apr 2021 21:40:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] mlxsw: core: Remove critical trip points from
 thermal zones
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161783160905.25121.369474007143495180.git-patchwork-notify@kernel.org>
Date:   Wed, 07 Apr 2021 21:40:09 +0000
References: <20210406122733.773304-1-idosch@idosch.org>
In-Reply-To: <20210406122733.773304-1-idosch@idosch.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        jiri@nvidia.com, vadimp@nvidia.com, mlxsw@nvidia.com,
        idosch@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue,  6 Apr 2021 15:27:33 +0300 you wrote:
> From: Vadim Pasternak <vadimp@nvidia.com>
> 
> Disable software thermal protection by removing critical trip points
> from all thermal zones.
> 
> The software thermal protection is redundant given there are two layers
> of protection below it in firmware and hardware. The first layer is
> performed by firmware, the second, in case firmware was not able to
> perform protection, by hardware.
> The temperature threshold set for hardware protection is always higher
> than for firmware.
> 
> [...]

Here is the summary with links:
  - [net-next] mlxsw: core: Remove critical trip points from thermal zones
    https://git.kernel.org/netdev/net-next/c/d567fd6e82fa

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


