Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35CDE386D6C
	for <lists+netdev@lfdr.de>; Tue, 18 May 2021 01:00:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243671AbhEQXBb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 19:01:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:50344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238738AbhEQXB2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 May 2021 19:01:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id A26EF6124C;
        Mon, 17 May 2021 23:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621292411;
        bh=J6uq023b7QYNjm+cH7/aANgO9WzsFsIFdU4Wji9qodY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=JCb9I1i4zrVOkigjPmVRSh+LYBVUp18mvKk14DKK0QyLDzkDiZO+9tnntRGTmnLzH
         Eov0xwcxPFCCQPyVNVtHwb7WwB/4QUnwkM/7EALrY6GgIvg5bZx14mNL0EbUDQ1aic
         asSHMsI47sRLJE1vq+39oOMhZMCzZQxB7i3UwrVU896IaVPN+p+Y5qYL4gxL8Y3XwG
         UIV35lmF/b7/66q70NVAMVRe7f2IkEgE9UDQjcTLwsPU+obElJzTBAp3XTca3beBX8
         4RoPWLNY/JzNP3XPpcaCWlYeSUAk3GcBGcn46LDl+Z16nXkBj3J/ip1dMRPCqBgG13
         1CM1l55hdRtsA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 9771960A4D;
        Mon, 17 May 2021 23:00:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/5] GVE bug fixes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162129241161.19462.3015918796925279307.git-patchwork-notify@kernel.org>
Date:   Mon, 17 May 2021 23:00:11 +0000
References: <20210517210815.3751286-1-awogbemila@google.com>
In-Reply-To: <20210517210815.3751286-1-awogbemila@google.com>
To:     David Awogbemila <awogbemila@google.com>
Cc:     netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Mon, 17 May 2021 14:08:10 -0700 you wrote:
> This patch series includes fixes to some bugs in the gve driver.
> 
> Catherine Sullivan (2):
>   gve: Check TX QPL was actually assigned
>   gve: Upgrade memory barrier in poll routine
> 
> David Awogbemila (3):
>   gve: Update mgmt_msix_idx if num_ntfy changes
>   gve: Add NULL pointer checks when freeing irqs.
>   gve: Drop skbs with invalid queue index.
> 
> [...]

Here is the summary with links:
  - [net,1/5] gve: Check TX QPL was actually assigned
    https://git.kernel.org/netdev/net/c/5aec55b46c62
  - [net,2/5] gve: Update mgmt_msix_idx if num_ntfy changes
    https://git.kernel.org/netdev/net/c/e96b491a0ffa
  - [net,3/5] gve: Add NULL pointer checks when freeing irqs.
    https://git.kernel.org/netdev/net/c/5218e919c8d0
  - [net,4/5] gve: Upgrade memory barrier in poll routine
    https://git.kernel.org/netdev/net/c/f81781835f0a
  - [net,5/5] gve: Correct SKB queue index validation.
    https://git.kernel.org/netdev/net/c/fbd4a28b4fa6

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


