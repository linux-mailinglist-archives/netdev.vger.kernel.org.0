Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F2F53DE22B
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 00:10:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233218AbhHBWKX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 18:10:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:56968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232132AbhHBWKQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Aug 2021 18:10:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id A35276101D;
        Mon,  2 Aug 2021 22:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627942206;
        bh=dYLWJI3DM+bzCd7pgmC35vStchDlya9FykKbPSowZYI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=LZwj+nVFmY3xyV03EzpRTu7gALTz0XL3PUzZKGmUcoAiaVpmpBz20itPYteTB41zB
         W0vY+8tyox8V57XeLVXMf0HUPXZG2visTKpNbro+K8A86mXPGe4poemug1B8x9mpsy
         gLDYTzudwjGk1BNURAWGYvPnBe+D8cgM/BzKLCfqQ1wu2xaPdhDhkYMf2h23FRu8dz
         PEJbsEpBPP/tiZBE2UwgYLkD8o0DBBID3zK/PLg8k2j0Zkx9U0Ar2ycxtNWcIqDfTW
         E5lBy55CYlf3mCNc0vDLJd/ovWM6RyIUYLr+Wf63kssmI7CX141FDBMqXfSwoVbna4
         fyp/OfAB8qp2A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 9967660A49;
        Mon,  2 Aug 2021 22:10:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] cxgb4: make the array match_all_mac static,
 makes object smaller
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162794220662.7989.12235886027159585782.git-patchwork-notify@kernel.org>
Date:   Mon, 02 Aug 2021 22:10:06 +0000
References: <20210801151205.145924-1-colin.king@canonical.com>
In-Reply-To: <20210801151205.145924-1-colin.king@canonical.com>
To:     Colin King <colin.king@canonical.com>
Cc:     rajur@chelsio.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Sun,  1 Aug 2021 16:12:05 +0100 you wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> Don't populate the array match_all_mac on the stack but instead it
> static const. Makes the object code smaller by 75 bytes.
> 
> Before:
>    text    data     bss     dec     hex filename
>   46701    8960      64   55725    d9ad ../chelsio/cxgb4/cxgb4_filter.o
> 
> [...]

Here is the summary with links:
  - cxgb4: make the array match_all_mac static, makes object smaller
    https://git.kernel.org/netdev/net-next/c/e688bdb7099c

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


