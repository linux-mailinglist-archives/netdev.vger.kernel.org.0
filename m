Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 945F2399541
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 23:10:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229854AbhFBVL7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 17:11:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:59262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229626AbhFBVLt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Jun 2021 17:11:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 5956A613F3;
        Wed,  2 Jun 2021 21:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622668206;
        bh=z0LigpFrYJVEfe2RvNMkxORLJxJtKdKqBW24cP/i2OA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=uYzes3lng/6SXeO6s0E0RonIQZ4zXgF2gHmy6pG04yyvnYz5DgXFtwEP4bpg4z8m/
         5O4imxPgVrGiLMKMgJs8ScijAGXWAhqyWC3DKOGwsxmo8vyYdBa9hJL+08TnjsAg4q
         fsLMEch63RcMlkhrkhwbzEIBsw2qazo+7lx++/IufXtegyb/SyFAGdFh0xtQPERKJq
         qKIPEXORuSwc+ZgZuoUg5ai9BMI7OKVJG6LqNEa03rqqLVqcbGHrbp8hUjCabrOQ3G
         ACNll25Ql/zQLDsyoTHQo87zNzpxfBgjZo+TNy4XHG4xBVlI4RzrfH0cCn9GAM3z5V
         G8YsUeoVKCUBQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 4DBF260CE0;
        Wed,  2 Jun 2021 21:10:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] ethtool: Fix a typo
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162266820631.24657.258503896682078355.git-patchwork-notify@kernel.org>
Date:   Wed, 02 Jun 2021 21:10:06 +0000
References: <20210602065428.104529-1-zhengyongjun3@huawei.com>
In-Reply-To: <20210602065428.104529-1-zhengyongjun3@huawei.com>
To:     Zheng Yongjun <zhengyongjun3@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 2 Jun 2021 14:54:28 +0800 you wrote:
> atribute  ==> attribute
> 
> Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
> ---
>  net/ethtool/netlink.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - [net-next] ethtool: Fix a typo
    https://git.kernel.org/netdev/net-next/c/b676c7f1c383

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


