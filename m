Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 060D8404829
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 12:00:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233526AbhIIKBg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 06:01:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:56016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233434AbhIIKBQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Sep 2021 06:01:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 03112611F2;
        Thu,  9 Sep 2021 10:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631181607;
        bh=JK0tfADM6jsetF8P6xhCOJfpmkR6e+7C7/ZVfkHMPvg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=iYlcdxFAe0sNgnqoeTVKvy3wnh3PTCmpCXvpgMDd0+h23wIKpd/2CxvNV8ybKAle9
         302Ub8cLWuYpfBlsbfrJDKHsmeXAcGqwb89NZ099K89Vti4W/qe6+ViQXgaXRN6682
         8zaPlatEe2nkD8af2rdLLfaJqdUdupb+BYXkXmVJ0SVdQxpOYZESujnwcgf5RMM0fH
         9f6fsYVvL3UKLBnHoF6T9ZxZw4oFCGkY8iPpGcCC6xbmA1+MpEEEBxXbEvm1IyqUVL
         VF1jhVgoWKRL9AnpNMrWDLZdKb6N3BeQxI2yftXccuSK1E5DIPUuHltmac6uKlxwSW
         FXs0OVMGI/I2g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id EEBE6608FC;
        Thu,  9 Sep 2021 10:00:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] vhost_net: fix OoB on sendmsg() failure.
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163118160697.750.1314062590023388342.git-patchwork-notify@kernel.org>
Date:   Thu, 09 Sep 2021 10:00:06 +0000
References: <463c1b02ca6f65fc1183431d8d85ec8154a2c28e.1631090797.git.pabeni@redhat.com>
In-Reply-To: <463c1b02ca6f65fc1183431d8d85ec8154a2c28e.1631090797.git.pabeni@redhat.com>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, mst@redhat.com, jasowang@redhat.com,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed,  8 Sep 2021 13:42:09 +0200 you wrote:
> If the sendmsg() call in vhost_tx_batch() fails, both the 'batched_xdp'
> and 'done_idx' indexes are left unchanged. If such failure happens
> when batched_xdp == VHOST_NET_BATCH, the next call to
> vhost_net_build_xdp() will access and write memory outside the xdp
> buffers area.
> 
> Since sendmsg() can only error with EBADFD, this change addresses the
> issue explicitly freeing the XDP buffers batch on error.
> 
> [...]

Here is the summary with links:
  - vhost_net: fix OoB on sendmsg() failure.
    https://git.kernel.org/netdev/net/c/3c4cea8fa7f7

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


