Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5213C3C1AEF
	for <lists+netdev@lfdr.de>; Thu,  8 Jul 2021 23:20:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231299AbhGHVWt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Jul 2021 17:22:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:38986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230442AbhGHVWq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Jul 2021 17:22:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 5C47461878;
        Thu,  8 Jul 2021 21:20:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625779204;
        bh=U/xdc67l36+ujSI+gBxJCgNM0lytoG1nwCUyZhP9Gfg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=F5+bjJa6yGRSyRZUF6S3FnK3NEIBYYcB2OxxCVgTgk+MvShNDFG9AcwgBRmDgcR9Q
         ixhjKE8CA+YIGrcohL8434Pwdej++/K5Lnk4d2Ru0A4CcpFlsrjc9CJtbBcdo2dTYL
         pKHzxOm9bifnDis+61TSOKbEK+aurbu2XmlmrXwy+zpZh1ax5mGvM/1olMZ8owu5oQ
         1W/oOHE3/gZYUcenY1XKK4U6pk/T6pbZq6Ql36NnaFKcg9dp3W52z8zn2rjHFdjZJd
         PPOzSxKm9Nz6GMCFIbvEdGg3pyLl1Lgni/sy1+vRDsYMYWkvEM6zCHRMp/5QKe25zB
         Dm5G9PDMBiYUw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 4F3F4609DA;
        Thu,  8 Jul 2021 21:20:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 0/3] net/ncsi: Add NCSI Intel OEM command to keep PHY link
 up
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162577920431.534.17888318132713618711.git-patchwork-notify@kernel.org>
Date:   Thu, 08 Jul 2021 21:20:04 +0000
References: <20210708122754.555846-1-i.mikhaylov@yadro.com>
In-Reply-To: <20210708122754.555846-1-i.mikhaylov@yadro.com>
To:     Ivan Mikhaylov <i.mikhaylov@yadro.com>
Cc:     davem@davemloft.net, kuba@kernel.org, sam@mendozajonas.com,
        joel@jms.id.au, benh@kernel.crashing.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, openbmc@lists.ozlabs.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Thu, 8 Jul 2021 15:27:51 +0300 you wrote:
> Add NCSI Intel OEM command to keep PHY link up and prevents any channel
> resets during the host load on i210. Also includes dummy response handler for
> Intel manufacturer id.
> 
> Changes from v1:
>  1. sparse fixes about casts
>  2. put it after ncsi_dev_state_probe_cis instead of
>     ncsi_dev_state_probe_channel because sometimes channel is not ready
>     after it
>  3. inl -> intel
> 
> [...]

Here is the summary with links:
  - [v2,1/3] net/ncsi: fix restricted cast warning of sparse
    https://git.kernel.org/netdev/net/c/27fa107d3b8d
  - [v2,2/3] net/ncsi: add NCSI Intel OEM command to keep PHY up
    https://git.kernel.org/netdev/net/c/abd2fddc94a6
  - [v2,3/3] net/ncsi: add dummy response handler for Intel boards
    https://git.kernel.org/netdev/net/c/163f5de509a8

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


