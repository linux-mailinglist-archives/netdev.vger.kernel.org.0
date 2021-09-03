Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A54533FFEBD
	for <lists+netdev@lfdr.de>; Fri,  3 Sep 2021 13:12:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348738AbhICLLH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Sep 2021 07:11:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:54986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348173AbhICLLG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 Sep 2021 07:11:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id A447E610CF;
        Fri,  3 Sep 2021 11:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630667406;
        bh=gVyfEhAjth2Gt5bnKnNXASUDFb3oDWoEhOUin8EgURQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Qj0/sBYOqdMYa7/BCc8ywdAI64zNCxIKS1pMVtOslZkMh4XUI7BIitEuWcr/rqf/v
         kjh4pY98ZpozQn0XoSVCQdm61w1l0yljKpsltnK70Q27XRHMRLjoDkCFxD4+4cxx/O
         3FjtMUVLz5pplooYHFPIPBgHyizae5PPatQSRPfeD23mNI7uwpPdfFrzqoHFk1gg5E
         wyuvUgo1RfqruQA6ar86fAJpdwja/KRKH6OiZ5bpvkfZ+kU4Ahn8QPhtkArcUiB3+f
         At0aWiDe2dclQG9pXHvHdavIjzGgRHQuN1Edy3XizqCQbEa3pg8PfBXmz/QtGIM/Wx
         gKTfxmsRz7ZTw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 9A89460A17;
        Fri,  3 Sep 2021 11:10:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] drivers: net: smc911x: clean up inconsistent indenting
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163066740662.18620.4382052994399123004.git-patchwork-notify@kernel.org>
Date:   Fri, 03 Sep 2021 11:10:06 +0000
References: <20210902222557.56483-1-colin.king@canonical.com>
In-Reply-To: <20210902222557.56483-1-colin.king@canonical.com>
To:     Colin King <colin.king@canonical.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Thu,  2 Sep 2021 23:25:57 +0100 you wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> There are various function arguments that are not indented correctly,
> clean these up with correct indentation.
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> 
> [...]

Here is the summary with links:
  - drivers: net: smc911x: clean up inconsistent indenting
    https://git.kernel.org/netdev/net/c/73fc98154e9c

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


