Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FB8E3DED46
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 14:00:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235751AbhHCMAS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 08:00:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:40296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235667AbhHCMAR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Aug 2021 08:00:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 7D80560EE9;
        Tue,  3 Aug 2021 12:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627992006;
        bh=vOkc7CxuKfvMpX9FiFr6Ts6xMJl9C3ZX3688hB18s5s=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=C0Ft/yRwLqyV+suFJ72IjI9vdOKj6PF2LAeNIUu183EeUeWOW0GDAYDI/Cj5ueD2Y
         qFQ07TrYxX96WUvMCAUrwgnOK1Nj387QKkjoc6a1ivHsooAG1MAXK+RicaRi69tVyc
         qUPt7RbeSrg3dUN2XvhrnAWkqj5fLsvFannSIhdlrYurc3MHLSYOuMjNqd6gIXoxZA
         KIRyc/ZI8HhWWlJFWIqWH2s+8AyEptbi7DeiU5iNNDNXJefri98RkDuFfmALq1s3no
         9aZlulOdP8anoZH+/dqw4dZwEB+PzRE9FVM+0aGIpo07R74XuGDIQ6GwREuTRq1ebp
         InlwEPDNLIwcA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 7359360A6D;
        Tue,  3 Aug 2021 12:00:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] nfp: update ethtool reporting of pauseframe control
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162799200646.3942.6747781392375137250.git-patchwork-notify@kernel.org>
Date:   Tue, 03 Aug 2021 12:00:06 +0000
References: <20210803103911.22639-1-simon.horman@corigine.com>
In-Reply-To: <20210803103911.22639-1-simon.horman@corigine.com>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        oss-drivers@corigine.com, fei.qin@corigine.com,
        louis.peens@corigine.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Tue,  3 Aug 2021 12:39:11 +0200 you wrote:
> From: Fei Qin <fei.qin@corigine.com>
> 
> Pauseframe control is set to symmetric mode by default on the NFP.
> Pause frames can not be configured through ethtool now, but ethtool can
> report the supported mode.
> 
> Fixes: 265aeb511bd5 ("nfp: add support for .get_link_ksettings()")
> Signed-off-by: Fei Qin <fei.qin@corigine.com>
> Signed-off-by: Louis Peens <louis.peens@corigine.com>
> Signed-off-by: Simon Horman <simon.horman@corigine.com>
> 
> [...]

Here is the summary with links:
  - [net] nfp: update ethtool reporting of pauseframe control
    https://git.kernel.org/netdev/net/c/9fdc5d85a8fe

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


