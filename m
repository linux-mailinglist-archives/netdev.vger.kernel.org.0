Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A3EA465CCB
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 04:40:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355223AbhLBDnk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 22:43:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355206AbhLBDng (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 22:43:36 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA372C061574
        for <netdev@vger.kernel.org>; Wed,  1 Dec 2021 19:40:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DF939B8221B
        for <netdev@vger.kernel.org>; Thu,  2 Dec 2021 03:40:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7A0F2C53FCC;
        Thu,  2 Dec 2021 03:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638416409;
        bh=6rb7q9giGQs1i4nJF7905QwDcGISezeYUOM2InGNFKI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=eW4KOs7gpxjeBn5WxBG3VmNFf8nBuHl0EWwAAmVyf/woAmdt+H83rtlwLslYoc41I
         SywoUU7H5qQqTEITa8HuhZ8YYYMubaVnRo4dE0y30qKvGSjFVzULGfKbCdhQ6IxVLl
         r5jabzdTJAXmoRAVQqh6U03lJTyg0JqcqebRnTa3FdAysmPJYxtzzjx8kVniSo1zZz
         UJ0xrfCYOLPj70OSXe1OI2zxh9vc2COwFJ0W6nJXsUpIDbUMY0kvfRY7/ioZL3oHew
         FTJ3GEsLF4Mw/LsOLolUuhV0p4QmdMhOSg7EwBvFKro7bW21rb3BTHC07LfMaGRi8s
         fbiv0ZWUsLmWQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 6149A609E7;
        Thu,  2 Dec 2021 03:40:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: annotate data-races on txq->xmit_lock_owner
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163841640939.8122.82867991310086962.git-patchwork-notify@kernel.org>
Date:   Thu, 02 Dec 2021 03:40:09 +0000
References: <20211130170155.2331929-1-eric.dumazet@gmail.com>
In-Reply-To: <20211130170155.2331929-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com, syzkaller@googlegroups.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 30 Nov 2021 09:01:55 -0800 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> syzbot found that __dev_queue_xmit() is reading txq->xmit_lock_owner
> without annotations.
> 
> No serious issue there, let's document what is happening there.
> 
> [...]

Here is the summary with links:
  - [net] net: annotate data-races on txq->xmit_lock_owner
    https://git.kernel.org/netdev/net/c/7a10d8c810cf

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


