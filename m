Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FF2A4553BC
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 05:20:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242916AbhKREXJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 23:23:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:37520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241844AbhKREXI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Nov 2021 23:23:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id D5B6B61B4C;
        Thu, 18 Nov 2021 04:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637209208;
        bh=SRSJYw/fXnmAbQyCzX59ZNUDOWHqx9hMhU7+PcfvaYM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=t/X/r+AnXeGi/bSIBK+iL+qLW1JpqWGkebjN1aM+yU4dk/QyANw+xlUhwLi2w1lpk
         Mh9MicupTXupNQZXhiO3lK+9JCG6T1TGfRdXb9csvBx1aLhjj+hemCcZKy4p0fxs4s
         TPLEZ8VTzxiVdAgsO/cdHJS6+dyILGKAwEgORTSpKUKceT04dAX9TIlqJAEDsyyUoc
         1rUvV2Ol8+sCDZHDU6gjlSb5eMPx8LbDYzWllJv5AWdTRfBd0fQ37ISMW7cWN2sAsu
         TVb/xu1j6FxdgKCstcO/nLnFwU+v1rK3Z6ASwQzfQ3RyOzhAEXKz1sIHTldPZD5gtk
         5MxGldMpHmsvw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id C7B8E60A4E;
        Thu, 18 Nov 2021 04:20:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] tipc: check for null after calling kmemdup
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163720920881.25224.18328251664437117777.git-patchwork-notify@kernel.org>
Date:   Thu, 18 Nov 2021 04:20:08 +0000
References: <20211115160143.5099-1-tadeusz.struk@linaro.org>
In-Reply-To: <20211115160143.5099-1-tadeusz.struk@linaro.org>
To:     Tadeusz Struk <tadeusz.struk@linaro.org>
Cc:     davem@davemloft.net, jmaloy@redhat.com, ying.xue@windriver.com,
        kuba@kernel.org, netdev@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        dvyukov@google.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 15 Nov 2021 08:01:43 -0800 you wrote:
> kmemdup can return a null pointer so need to check for it, otherwise
> the null key will be dereferenced later in tipc_crypto_key_xmit as
> can be seen in the trace [1].
> 
> Cc: Jon Maloy <jmaloy@redhat.com>
> Cc: Ying Xue <ying.xue@windriver.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: netdev@vger.kernel.org
> Cc: tipc-discussion@lists.sourceforge.net
> Cc: linux-kernel@vger.kernel.org
> Cc: stable@vger.kernel.org # 5.15, 5.14, 5.10
> 
> [...]

Here is the summary with links:
  - [v2] tipc: check for null after calling kmemdup
    https://git.kernel.org/netdev/net/c/3e6db079751a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


