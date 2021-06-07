Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0390D39E81A
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 22:10:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231664AbhFGUMF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 16:12:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:39448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231535AbhFGUMB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Jun 2021 16:12:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 16E40611ED;
        Mon,  7 Jun 2021 20:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623096610;
        bh=sny0frkdgUSGY7p9WEXd18G+XjsfJTuCqFDlxv/G8N0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=GROx4+EXNBYulC0URpARpvxhoYLyWWiLUOXrgsoIEo5cDeCEMbhJ2uBcC+1MBJEnh
         1cKzy52J22hLZNBb/s7vNJvmtC7xxU+Bbax0ipakm2dRxDOLwg61h0+TYJxlDg62q0
         DlispyyI78Uqcidnof0qJPlxMGb0X8FBhHYnN7m6j0vbiwbctRIa02Pj8cZFYW1JmH
         soA8uCyZKqWFj2jrjuBboTBKjkMwHjOCnUlr+B6NjYeVuVO5ZhRfHFtWVAkcqhnovm
         EFdV+4wFUw6av/PaqG7AZIm7gQnOQhomoCcm+aXjYatqDOvySlxHhF1ZjwXDnL/RnP
         qMjnKKWPg9CEQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 07D2260BFB;
        Mon,  7 Jun 2021 20:10:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] [v2] virtio_net: Remove BUG() to avoid machine dead
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162309661002.3673.10077511814763103311.git-patchwork-notify@kernel.org>
Date:   Mon, 07 Jun 2021 20:10:10 +0000
References: <1622907060-8417-1-git-send-email-xianting_tian@126.com>
In-Reply-To: <1622907060-8417-1-git-send-email-xianting_tian@126.com>
To:     Xianting Tian <xianting_tian@126.com>
Cc:     mst@redhat.com, jasowang@redhat.com, davem@davemloft.net,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        xianting.tian@linux.alibaba.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Sat,  5 Jun 2021 11:31:00 -0400 you wrote:
> From: Xianting Tian <xianting.tian@linux.alibaba.com>
> 
> We should not directly BUG() when there is hdr error, it is
> better to output a print when such error happens. Currently,
> the caller of xmit_skb() already did it.
> 
> Signed-off-by: Xianting Tian <xianting.tian@linux.alibaba.com>
> 
> [...]

Here is the summary with links:
  - [v2] virtio_net: Remove BUG() to avoid machine dead
    https://git.kernel.org/netdev/net-next/c/85eb1389458d

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


