Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CD9E3BF10D
	for <lists+netdev@lfdr.de>; Wed,  7 Jul 2021 22:51:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231290AbhGGUxr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Jul 2021 16:53:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:48546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230390AbhGGUxp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Jul 2021 16:53:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id DBE1261CD4;
        Wed,  7 Jul 2021 20:51:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625691064;
        bh=SZVDUdqff5gTFji4UiXG2Fkl+jtKpBpIGvLC9xKuEmk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=MM7zykcXHMX4KB/oaE+s7E88wLTifefS7Ug5usAKXSv/MLQLVxFB42JU6ZK4rP1ku
         Pdvf2UHVFJ6JI3YTcvyatv4M1EAldYG7rJkJ07D19LgQj9YJqmPCoj3K+cZBBGnLNK
         5pBm4G3QsOcOSYuhko3v8F3kILGY44vqUpPMr8JsTk4f/rcRXwpH77zclSkXrtg2VJ
         OYmigNPGhiOc2au5IlRFhJ5xJWza5FaxTqT+s9YgMMhQpa/hDCSSA2wZFp28bP/i1o
         xAzM4jysISx4G8qTogNAvC+8Z9KFpglMCnc4FKv7qoj5YAbNxhn1gG9SHIaKSq1SRB
         yysZoo6E5ts7A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id CE19B609F6;
        Wed,  7 Jul 2021 20:51:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/2] Fix selftests icmp_redirect.sh failures
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162569106483.4918.15429567546752508101.git-patchwork-notify@kernel.org>
Date:   Wed, 07 Jul 2021 20:51:04 +0000
References: <20210707081530.1107289-1-liuhangbin@gmail.com>
In-Reply-To: <20210707081530.1107289-1-liuhangbin@gmail.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, dsahern@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Wed,  7 Jul 2021 16:15:28 +0800 you wrote:
> This patchset fixes 2 failures for selftests icmp_redirect.sh.
> 
> The first patch is for IPv6 redirecting tests. When disable option
> CONFIG_IPV6_SUBTREES, there is not "from ::" info in ip route output.
> So we should not check this key word.
> 
> The second patch is for testing "mtu exception plus redirect", which do
> a PMTU update first and do redirect second. For topology like
> 
> [...]

Here is the summary with links:
  - [net,1/2] selftests: icmp_redirect: remove from checking for IPv6 route get
    https://git.kernel.org/netdev/net/c/24b671aad4ea
  - [net,2/2] selftests: icmp_redirect: IPv6 PMTU info should be cleared after redirect
    https://git.kernel.org/netdev/net/c/0e02bf5de46a

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


