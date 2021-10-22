Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9ACBB437FD2
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 23:10:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234214AbhJVVM0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 17:12:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:47026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234089AbhJVVMZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Oct 2021 17:12:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 1387360FE3;
        Fri, 22 Oct 2021 21:10:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634937007;
        bh=+XUVavPyAtUwbYBtbutfWQpCqktxU9ydEFodXBdxkCY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=smKvDOIsba2n2UKzWNiI0F0tiEyvNZgibjs/vjv8cstugtFANr5xJeBSdAcUBhuG1
         RWNgs6cTQKGi6tM+or211Z06+/kxD2u0LZOOB+FpVn7hW3uz7qrAJXZkXLN1v0lqx+
         yux4MlaRJoXiT6wJJKkUPyRHF2JcgTcGptR7G2snI6rjnoQwlE1syCpZyxtLYeu7zV
         hn4L81ar6RSuCf9NIPkLK3mjDIHsLg0+5z68d8mcKCrm2LouhZ1LUkSB9NYAgRBdx2
         Tf6biU9bQZ9MDGeX+4mTv98v2EYT6DFdaarvjzbx0mo5Y8Xpb4NvjujDiPdFnVyJEq
         Fog+JEeXfIerQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 0017A609E2;
        Fri, 22 Oct 2021 21:10:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] fcnal-test: kill hanging ping/nettest binaries on cleanup
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163493700699.924.8890698872840131946.git-patchwork-notify@kernel.org>
Date:   Fri, 22 Oct 2021 21:10:06 +0000
References: <20211021140247.29691-1-fw@strlen.de>
In-Reply-To: <20211021140247.29691-1-fw@strlen.de>
To:     Florian Westphal <fw@strlen.de>
Cc:     netdev@vger.kernel.org, dsahern@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 21 Oct 2021 16:02:47 +0200 you wrote:
> On my box I see a bunch of ping/nettest processes hanging
> around after fcntal-test.sh is done.
> 
> Clean those up before netns deletion.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>
> 
> [...]

Here is the summary with links:
  - [net] fcnal-test: kill hanging ping/nettest binaries on cleanup
    https://git.kernel.org/netdev/net/c/1f83b835a3ea

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


