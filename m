Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 921D23F2D98
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 16:00:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238242AbhHTOAq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 10:00:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:33150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240766AbhHTOAp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Aug 2021 10:00:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 96FB361152;
        Fri, 20 Aug 2021 14:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629468007;
        bh=WJnuDpCHimnBxzEut5tIKfqiNkDpjGJmWyeYhZ26wXU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=j0nfsx9h0vHhXoQ+sxE88FQJPl1eBntPByBMxNBCnZeUPo1m/NP4vYUywBcUDl28W
         ROfyLfewll0h2ntJOkOxU/QG9My0RgwqtprcDqUShUrmptnm+fCbmc6mRFKmO2vRa8
         f+0K6pE9G2pYHv3g3cwHN3XJTmA3IzkYI2aOxiNzCiQJakEXT0xYrXFNF4/y47mfPX
         h/fDtlTSLZP6sjWyBNzYfudNjpV4yHrrAMki1QfDHDo8k9xwL2QNxZkSkhoNWusMBo
         Geot99XWcOU8uc7ej2dXEusfpId98ZpBdLtwkWNsQbFORkeLLkLmoikOAQksrtXNNE
         X/geQz7X1xWRw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 8BE6560A94;
        Fri, 20 Aug 2021 14:00:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next PATCH v2] octeontx2-pf: Add check for non zero mcam flows
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162946800756.1573.9198099270423870491.git-patchwork-notify@kernel.org>
Date:   Fri, 20 Aug 2021 14:00:07 +0000
References: <1629447922-3988-1-git-send-email-sbhatta@marvell.com>
In-Reply-To: <1629447922-3988-1-git-send-email-sbhatta@marvell.com>
To:     Subbaraya Sundeep <sbhatta@marvell.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        sgoutham@marvell.com, hkelam@marvell.com, gakula@marvell.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Fri, 20 Aug 2021 13:55:22 +0530 you wrote:
> From: Sunil Goutham <sgoutham@marvell.com>
> 
> This patch ensures that mcam flows are allocated
> before adding or destroying the flows.
> 
> Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
> Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
> 
> [...]

Here is the summary with links:
  - [net-next,v2] octeontx2-pf: Add check for non zero mcam flows
    https://git.kernel.org/netdev/net-next/c/a515e5b53cc6

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


