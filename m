Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9988543652F
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 17:10:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231629AbhJUPMY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 11:12:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:37468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231533AbhJUPMX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Oct 2021 11:12:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id D9CB9611CE;
        Thu, 21 Oct 2021 15:10:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634829007;
        bh=9p7D1MG/ql8WzkSbKIyaxURYPpAAPm5mIncQafOQyiU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=q+qNuD69Z7e76v+xlo1621J8FDyOAITY8koyXXSgm6LptiaQdd/xBmggQ2BlEYy9/
         3+DgXYpzV5zSYW+Gw5Mt24sg85rKEIIoALYYxR2ufsFAEbYTjKu9KkA10M6t+DdVZR
         58vjyGEy5ghRlqpxYnjrfqqqi/VdfkcQeNIBKx1vUqNBPHJN2Ay2J8hTXn3ucfU3LX
         +OGN21I2V8d0V9D6hsI/7v2W7+J/ePRJ75Q6WImN/6ScfGhRCjR5sGooIqLursZe5I
         IrGd+676YgBpcjvUlHb5nMW+09B9ayFbKHR+PfaguLyf+PgbuMm5XSnWYkoangB1tJ
         n6qk+5OmXYa4A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id CFF6260A44;
        Thu, 21 Oct 2021 15:10:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCHv2] usbnet: sanity check for maxpacket
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163482900784.14016.9961969841902136645.git-patchwork-notify@kernel.org>
Date:   Thu, 21 Oct 2021 15:10:07 +0000
References: <20211021122944.21816-1-oneukum@suse.com>
In-Reply-To: <20211021122944.21816-1-oneukum@suse.com>
To:     Oliver Neukum <oneukum@suse.com>
Cc:     syzkaller-bugs@googlegroups.com, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        syzbot+76bb1d34ffa0adc03baa@syzkaller.appspotmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 21 Oct 2021 14:29:44 +0200 you wrote:
> maxpacket of 0 makes no sense and oopses as we need to divide
> by it. Give up.
> 
> V2: fixed typo in log and stylistic issues
> 
> Signed-off-by: Oliver Neukum <oneukum@suse.com>
> Reported-by: syzbot+76bb1d34ffa0adc03baa@syzkaller.appspotmail.com
> 
> [...]

Here is the summary with links:
  - [PATCHv2] usbnet: sanity check for maxpacket
    https://git.kernel.org/netdev/net/c/397430b50a36

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


