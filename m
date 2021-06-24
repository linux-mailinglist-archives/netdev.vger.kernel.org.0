Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B69C63B394C
	for <lists+netdev@lfdr.de>; Fri, 25 Jun 2021 00:45:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232838AbhFXWmY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 18:42:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:47706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229643AbhFXWmX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Jun 2021 18:42:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 55111613AD;
        Thu, 24 Jun 2021 22:40:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624574403;
        bh=OKgEB73NCuefgeU3fi95dRm1KPK46StpjrjmgDWJ+6w=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Q+d0YkVafeNmDCGrnu9oQSL+/O4BxVn+WsAErcn3eyX5ZksceKhhPJxHEreCSBX0r
         aUcm5gY1Qf3yml/XY4zVY4FEQ+HK0GaZE3MJiJkB4GkUuBDoJQ+cJxCpI/8GVHnItP
         qQpIwBPSPXOzij3t95wkQH5o5h2QblSzgi6l6Z106+vYu+3F9rTDueg94EPxEnql30
         itl4qg7tahUgDBylAPxOR+IdbzhwlH6E7AxqtP79xYV5z9l0ZBCJk62/zgnznBCJB1
         ZQfcAfILsrsgnTRkulxkscpKpln4Y8nUezarhylK26uMA3tZqvjty1Pp1nHmBxY5L2
         rgjBjHR4yHdpA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 4B01860A3C;
        Thu, 24 Jun 2021 22:40:03 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] gve: Fix warnings reported for DQO patchset
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162457440330.29082.5547197130022643735.git-patchwork-notify@kernel.org>
Date:   Thu, 24 Jun 2021 22:40:03 +0000
References: <20210624220852.3733930-1-bcf@google.com>
In-Reply-To: <20210624220852.3733930-1-bcf@google.com>
To:     Bailey Forrest <bcf@google.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        willemb@google.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Thu, 24 Jun 2021 15:08:52 -0700 you wrote:
> https://patchwork.kernel.org/project/netdevbpf/list/?series=506637&state=*
> 
> - Remove unused variable
> - Use correct integer type for string formatting.
> - Remove `inline` in C files
> 
> Fixes: 9c1a59a2f4bc ("gve: DQO: Add ring allocation and initialization")
> Fixes: a57e5de476be ("gve: DQO: Add TX path")
> Signed-off-by: Bailey Forrest <bcf@google.com>
> Reviewed-by: Willem de Bruijn <willemb@google.com>
> 
> [...]

Here is the summary with links:
  - [net-next] gve: Fix warnings reported for DQO patchset
    https://git.kernel.org/netdev/net-next/c/e8192476de58

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


