Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10657476F5A
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 12:01:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236342AbhLPLAO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 06:00:14 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:52244 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236338AbhLPLAN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Dec 2021 06:00:13 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BE54961D5C
        for <netdev@vger.kernel.org>; Thu, 16 Dec 2021 11:00:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 34DD3C36AE4;
        Thu, 16 Dec 2021 11:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639652412;
        bh=RNu3NLiMp3bxDOBwB+eMYUZkZP2ASzdCm6LDHucxEkA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=aDgMEy7AfBVBLDLN2UCVx0/RTjkhWCBAP+m6mCXUW9xl4Z/r3J6CkztQHDlSnYkvE
         BeMxjMipG3K0ua2Qma8oqjMG2wp8ytS5GcDy2CxKGbBqLmsn1kpzC/2/xY7dAU0TIC
         QPXH16LZwwLDLbv65CMRgzHllfHsZiplBMT0OKMmEofgN1CQgkVubyFVEK51wVC2tY
         p5UQvBjyYTWodrEKvLkiIh+2kPwlMnG1q0uyxqsRh7ZG57cOW7+tOwWy6RuRnYtGCv
         PBN0XnfSwSdbYYuXz/l8fKCCS/EiJL+nJ/Qrw179XcyUd1jFUhnNxvAmtXSG3QAMUJ
         2lNJV5LruunYg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 25C9B609FE;
        Thu, 16 Dec 2021 11:00:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/8] gve improvements
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163965241215.2516.2668382185231661878.git-patchwork-notify@kernel.org>
Date:   Thu, 16 Dec 2021 11:00:12 +0000
References: <20211216004652.1021911-1-jeroendb@google.com>
In-Reply-To: <20211216004652.1021911-1-jeroendb@google.com>
To:     Jeroen de Borst <jeroendb@google.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 15 Dec 2021 16:46:44 -0800 you wrote:
> This patchset consists of unrelated changes:
> 
> A bug fix for an issue that disabled jumbo-frame support, a few code
> improvements and minor funcitonal changes and 3 new features:
>   Supporting tx|rx-coalesce-usec for DQO
>   Suspend/resume/shutdown
>   Optional metadata descriptors
> 
> [...]

Here is the summary with links:
  - [net-next,1/8] gve: Correct order of processing device options
    https://git.kernel.org/netdev/net-next/c/a10834a36c8a
  - [net-next,2/8] gve: Move the irq db indexes out of the ntfy block struct
    https://git.kernel.org/netdev/net-next/c/d30baacc0494
  - [net-next,3/8] gve: Update gve_free_queue_page_list signature
    https://git.kernel.org/netdev/net-next/c/13e7939c954a
  - [net-next,4/8] gve: remove memory barrier around seqno
    https://git.kernel.org/netdev/net-next/c/5fd07df47a7f
  - [net-next,5/8] gve: Add optional metadata descriptor type GVE_TXD_MTD
    https://git.kernel.org/netdev/net-next/c/497dbb2b97a0
  - [net-next,6/8] gve: Implement suspend/resume/shutdown
    https://git.kernel.org/netdev/net-next/c/974365e51861
  - [net-next,7/8] gve: Add consumed counts to ethtool stats
    https://git.kernel.org/netdev/net-next/c/2c9198356d56
  - [net-next,8/8] gve: Add tx|rx-coalesce-usec for DQO
    https://git.kernel.org/netdev/net-next/c/6081ac2013ab

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


