Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FD0A2E9F9C
	for <lists+netdev@lfdr.de>; Mon,  4 Jan 2021 22:41:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726246AbhADVkt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jan 2021 16:40:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:41754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726074AbhADVks (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Jan 2021 16:40:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 35235221F8;
        Mon,  4 Jan 2021 21:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609796408;
        bh=Wjm4tr4h4TNwlnqkpWRhVKi0NFdz+bsH9cf9tgSBseI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Z8PMwoxkOsh1B0yxNbzlwDpIrv90sSiI1GrpOzNCW+QIIjpIAt2sa1wcFiI9wqYef
         4hNNsBhjrAu1152bi7FPLTdspE0oOEx/XDrhh6M9bWzHLcZbYF5HSr28f82Mc7l0Ku
         eGyn/3JfsIG5HTpD94UFdmsHg+OgZ03ETZ4CilGCREVREBFtiogxPLLF0fsmnHIDlG
         t035r9g1pg2myIUUrklt/C/lRyDF3IsF/jI5o1xa9LRKGP3eYV4MneoFsY7957KsF9
         qGtt66NJ2LA736mlvH4uQTaAfYPKydLqvlqrLDKyoOU2BMOUgzTXMKJNEPmTx2yF4v
         ZWtZkoPFFMr5w==
Received: from pdx-korg-docbuild-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-1.ci.codeaurora.org (Postfix) with ESMTP id 25C84604FC;
        Mon,  4 Jan 2021 21:40:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] selftests: mlxsw: Set headroom size of correct port
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160979640814.4432.9378065121775652965.git-patchwork-notify@kernel.org>
Date:   Mon, 04 Jan 2021 21:40:08 +0000
References: <20201230114251.394009-1-idosch@idosch.org>
In-Reply-To: <20201230114251.394009-1-idosch@idosch.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        petrm@nvidia.com, mlxsw@nvidia.com, idosch@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed, 30 Dec 2020 13:42:51 +0200 you wrote:
> From: Ido Schimmel <idosch@nvidia.com>
> 
> The test was setting the headroom size of the wrong port. This was not
> visible because of a firmware bug that canceled this bug.
> 
> Set the headroom size of the correct port, so that the test will pass
> with both old and new firmware versions.
> 
> [...]

Here is the summary with links:
  - [net] selftests: mlxsw: Set headroom size of correct port
    https://git.kernel.org/netdev/net/c/2ff2c7e27439

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


