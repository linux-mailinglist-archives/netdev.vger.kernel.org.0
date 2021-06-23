Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51A003B2155
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 21:40:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229982AbhFWTmZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 15:42:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:43940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229801AbhFWTmX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Jun 2021 15:42:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 1C99961075;
        Wed, 23 Jun 2021 19:40:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624477205;
        bh=M6XVm8hVu6XqxvQb9xNRjPxREhTl4ksQeXrcmcr+pCw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=rYxYaISyKiGvX3+5B7WY9Qud6eSjQ1JPzi05kx4N00RpclqoQElkQgG9ThBme3VVt
         nmfIIIcwKXAk1ZtrLNFRbVsGE6chPL5gLJomRuRDL5dwqDzvd5tKc7/J8Bi84d+cHV
         Bz6yBHs/n7cT/MwtVOrYSiRWh7AivTlu+rGJuxoe232UucdDADlayq8JyMM7hut3V3
         HnHkgyHNdToKchbSUx4E+S4Hwec6ACUWirA0aDZiTsPBSaFsousDu5bMAnbjShyOBr
         gstqsBkKEdyjsVDD/7JWYKc3c0M+rwpuatuqB6aOE4BxUivwdIcPcRbDFC5C+Yw6ho
         SY/yM9nHbC2PQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 0CA34609AC;
        Wed, 23 Jun 2021 19:40:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] selftests: icmp_redirect: support expected failures
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162447720504.16324.2481093653689153603.git-patchwork-notify@kernel.org>
Date:   Wed, 23 Jun 2021 19:40:05 +0000
References: <YNGVaO0pN9VqR8tJ@xps-13-7390>
In-Reply-To: <YNGVaO0pN9VqR8tJ@xps-13-7390>
To:     Andrea Righi <andrea.righi@canonical.com>
Cc:     shuah@kernel.org, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue, 22 Jun 2021 09:46:48 +0200 you wrote:
> According to a comment in commit 99513cfa16c6 ("selftest: Fixes for
> icmp_redirect test") the test "IPv6: mtu exception plus redirect" is
> expected to fail, because of a bug in the IPv6 logic that hasn't been
> fixed yet apparently.
> 
> We should probably consider this failure as an "expected failure",
> therefore change the script to return XFAIL for that particular test and
> also report the total amount of expected failures at the end of the run.
> 
> [...]

Here is the summary with links:
  - selftests: icmp_redirect: support expected failures
    https://git.kernel.org/netdev/net-next/c/0a36a75c6818

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


