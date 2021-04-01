Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C74935235A
	for <lists+netdev@lfdr.de>; Fri,  2 Apr 2021 01:22:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235930AbhDAXUL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Apr 2021 19:20:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:38752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235711AbhDAXUJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Apr 2021 19:20:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 4DE5061106;
        Thu,  1 Apr 2021 23:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617319208;
        bh=GcpZFHxUBy2VFWiIPqZ9HG6w7qkSVBPeUuynatJ6bUU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=eKJPMKwe5cKQI+EZzmvpihJA1o+X5N2NIkh/goY6zXqpK4cArB7Nf05zHN9LBrbbR
         AMIs2yFsfOTpeB3z2rYAUJNO7StyuzteYemGL0SdofF3+2Nov38+kBe/N1xnKcKbzB
         DdUym3OPwZgrHHCVHjje9bkNzIAryyo37UGTgggF3qU0OjYTsdOt1T9ONEswJKPmQO
         AVoLj6+7qoON7PUO4kiqC4GknWCneOPmHRobjBfpaEDtVsmDvVr3cv9XvT1LtsTA6U
         875lFhMKTMgwDjnVVOLK2p8okEQmf04hTOg+l13U4q/p1WR0GT7hEop3Z84qLSvmQR
         N8ZDp+vmNAyZg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 3FDC0609CF;
        Thu,  1 Apr 2021 23:20:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/3][pull request] Intel Wired LAN Driver Updates
 2021-04-01
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161731920825.16404.648734978906101416.git-patchwork-notify@kernel.org>
Date:   Thu, 01 Apr 2021 23:20:08 +0000
References: <20210401172107.1191618-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20210401172107.1191618-1-anthony.l.nguyen@intel.com>
To:     Nguyen@ci.codeaurora.org, Anthony L <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        sassmann@redhat.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Thu,  1 Apr 2021 10:21:04 -0700 you wrote:
> This series contains updates to i40e driver only.
> 
> Arkadiusz fixes warnings for inconsistent indentation.
> 
> Magnus fixes an issue on xsk receive where single packets over time
> are batched rather than received immediately.
> 
> [...]

Here is the summary with links:
  - [net,1/3] i40e: Fix inconsistent indenting
    https://git.kernel.org/netdev/net/c/7a75a8412fdd
  - [net,2/3] i40e: fix receiving of single packets in xsk zero-copy mode
    https://git.kernel.org/netdev/net/c/528060ef3e11
  - [net,3/3] i40e: Fix display statistics for veb_tc
    https://git.kernel.org/netdev/net/c/c3214de929db

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


