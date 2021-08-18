Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E08B93F00BD
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 11:40:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232330AbhHRJkn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 05:40:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:34278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231685AbhHRJkm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Aug 2021 05:40:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id D5CAB60EBC;
        Wed, 18 Aug 2021 09:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629279607;
        bh=0fvRIpeJChIG3b+ddwk+hd8X2C41X4I/WrsBAxp94BM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=mu01o7tr1hAMh5VvFLC43OS7vXHBJyYKTvY25EU4WPRX+V9OVhslTFmoZbEa3Kj2r
         SRxESFe4IUz+cT7i1x92kabO57DMkBPr031X7lZ2oSxi7ebn6i+VHiDPEuP+p6LGx9
         2+mlQdftp6Jv6O0T0pGVGQuEPVE8bJdu2B9CLQLCra0060GLpuTuwnNXpZoUmmR0GM
         kUVB/r6A8r3Fblwhc8HXueXtoQDvMXmUi9fhGay9BUdn1lE+ZhIraTTSOJKgYnnFC4
         Hn2866xnFCTM/vYgfM17LSvMFCvUucff6T/dnZZWNEjZRHIZzfNpmmxd/8fNMOjgYo
         c6GqNjoIxfa4w==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id C7F2A60A48;
        Wed, 18 Aug 2021 09:40:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next 0/8] Update the virtual NCI device driver and add
 the NCI testcase
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162927960781.17257.8348464007150730422.git-patchwork-notify@kernel.org>
Date:   Wed, 18 Aug 2021 09:40:07 +0000
References: <20210817132818.8275-1-bongsu.jeon2@gmail.com>
In-Reply-To: <20210817132818.8275-1-bongsu.jeon2@gmail.com>
To:     Bongsu Jeon <bongsu.jeon2@gmail.com>
Cc:     shuah@kernel.org, krzysztof.kozlowski@canonical.com,
        netdev@vger.kernel.org, linux-nfc@lists.01.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        bongsu.jeon@samsung.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Tue, 17 Aug 2021 06:28:10 -0700 you wrote:
> From: Bongsu Jeon <bongsu.jeon@samsung.com>
> 
> This series updates the virtual NCI device driver and NCI selftest code
> and add the NCI test case in selftests.
> 
> 1/8 to use wait queue in virtual device driver.
> 2/8 to remove the polling code in selftests.
> 3/8 to fix a typo.
> 4/8 to fix the next nlattr offset calculation.
> 5/8 to fix the wrong condition in if statement.
> 6/8 to add a flag parameter to the Netlink send function.
> 7/8 to extract the start/stop discovery function.
> 8/8 to add the NCI testcase in selftests.
> 
> [...]

Here is the summary with links:
  - [v2,net-next,1/8] nfc: virtual_ncidev: Use wait queue instead of polling
    https://git.kernel.org/netdev/net-next/c/8675569d73ca
  - [v2,net-next,2/8] selftests: nci: Remove the polling code to read a NCI frame
    https://git.kernel.org/netdev/net-next/c/4ef956c64394
  - [v2,net-next,3/8] selftests: nci: Fix the typo
    https://git.kernel.org/netdev/net-next/c/366f6edf5dea
  - [v2,net-next,4/8] selftests: nci: Fix the code for next nlattr offset
    https://git.kernel.org/netdev/net-next/c/78a7b2a8a0fa
  - [v2,net-next,5/8] selftests: nci: Fix the wrong condition
    https://git.kernel.org/netdev/net-next/c/1d5b8d01db98
  - [v2,net-next,6/8] selftests: nci: Add the flags parameter for the send_cmd_mt_nla
    https://git.kernel.org/netdev/net-next/c/6ebbc9680a33
  - [v2,net-next,7/8] selftests: nci: Extract the start/stop discovery function
    https://git.kernel.org/netdev/net-next/c/72696bd8a09d
  - [v2,net-next,8/8] selftests: nci: Add the NCI testcase reading T4T Tag
    https://git.kernel.org/netdev/net-next/c/61612511e55c

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


