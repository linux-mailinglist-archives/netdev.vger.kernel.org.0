Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15021410B3D
	for <lists+netdev@lfdr.de>; Sun, 19 Sep 2021 13:20:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231172AbhISLVk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Sep 2021 07:21:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:57584 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229570AbhISLVe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 19 Sep 2021 07:21:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id EE7FA61242;
        Sun, 19 Sep 2021 11:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632050409;
        bh=JgOlWT0pbtf7IVNWGZ6Y18loUrVLEywZaq+kJszZk28=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=McYbWhBfv9t4VvwDDYNBAFiHD5PCAfs8VVqsgoYw+7amWtY1FVzDJQMZdARAMaRQn
         hazuosxKMmRlMk0usDx33Hr4ru7oaQ7Eu2ss3lGTe1ZN4DQaSSNmYS8wGQOS2rBI2E
         xuHGod568wdnTud8oD6FGIZWQcY82cc9McjeggXmX6hTd0MjHZ8oy0dp6gX8RyRMkf
         xxHDsllhbtBBvdVrmvOBu6qVTu47B1+YjZcG8ZB9bwMYVRW8ovX3Pjen8jLg9Hmu4b
         bQIKEvC1FsPbDIOUfImizS/Z3q0twtxXmCJlP4VMMP3bMnA/ZTc2IoLSbwEpl8sQr4
         Vq6Wlj0OSvCow==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id E19AC60A37;
        Sun, 19 Sep 2021 11:20:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net][RESEND] xen-netback: correct success/error reporting for
 the SKB-with-fraglist case
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163205040891.14261.10527748339776839114.git-patchwork-notify@kernel.org>
Date:   Sun, 19 Sep 2021 11:20:08 +0000
References: <ef9e1ab6-17b9-c2d7-ef6c-99ef6726a765@suse.com>
In-Reply-To: <ef9e1ab6-17b9-c2d7-ef6c-99ef6726a765@suse.com>
To:     Jan Beulich <JBeulich@suse.com>
Cc:     netdev@vger.kernel.org, paul@xen.org, wl@xen.org,
        xen-devel@lists.xenproject.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Fri, 17 Sep 2021 08:27:10 +0200 you wrote:
> When re-entering the main loop of xenvif_tx_check_gop() a 2nd time, the
> special considerations for the head of the SKB no longer apply. Don't
> mistakenly report ERROR to the frontend for the first entry in the list,
> even if - from all I can tell - this shouldn't matter much as the overall
> transmit will need to be considered failed anyway.
> 
> Signed-off-by: Jan Beulich <jbeulich@suse.com>
> Reviewed-by: Paul Durrant <paul@xen.org>

Here is the summary with links:
  - [net,RESEND] xen-netback: correct success/error reporting for the SKB-with-fraglist case
    https://git.kernel.org/netdev/net/c/3ede7f84c7c2

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


