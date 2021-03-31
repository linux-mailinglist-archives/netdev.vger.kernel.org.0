Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D75234F58C
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 02:41:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232927AbhCaAks (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 20:40:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:46636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232824AbhCaAkK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Mar 2021 20:40:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id B6BBC619BD;
        Wed, 31 Mar 2021 00:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617151209;
        bh=AeOa//ScJD6APnI7lSycDxHBsN3TuVOr3TOfJDlBUZo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=BEASKN1eT8D7qIysnme2Om6ocH7Ioq7kC4NFV2p7UK4vyh4ZuC/41k7WocirpVFpA
         xNR1287VoX0OtFRBYj/3+ALtLh4cJHBsUb1HkvBuraGpZgabIDNO0GXa+uUumy5kj5
         L4UPtEUTVPIb/2U834jK3yM6JvVU7/LMCaHu2V/grXIf9bpX02ryq6Uzub+h3T2JTH
         4NY4RjpHwuVnPzQgn8iG76ItFZLi6wdobc3BiYscaOj4XRFRUBQSm+uVtpnkBRNSLh
         p6+lBbFGk5+mKTJQ8nQi36ww2smUqYmNbIYdJ8It3iA0ZNQeOj9dKlU5OfNBiJmqwK
         0qF3nOpp2NjIQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id A91FB60A56;
        Wed, 31 Mar 2021 00:40:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/4] ionic: code cleanup for heartbeat,
 dma error counts, sizeof, stats
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161715120968.12125.12303356288232188326.git-patchwork-notify@kernel.org>
Date:   Wed, 31 Mar 2021 00:40:09 +0000
References: <20210330195210.49069-1-snelson@pensando.io>
In-Reply-To: <20210330195210.49069-1-snelson@pensando.io>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        drivers@pensando.io
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Tue, 30 Mar 2021 12:52:06 -0700 you wrote:
> These patches are a few more bits of code cleanup found in
> testing and review: count all our dma error instances, make
> better use of sizeof, fix a race in our device heartbeat check,
> and clean up code formatting in the ethtool stats collection.
> 
> Shannon Nelson (4):
>   ionic: count dma errors
>   ionic: fix sizeof usage
>   ionic: avoid races in ionic_heartbeat_check
>   ionic: pull per-q stats work out of queue loops
> 
> [...]

Here is the summary with links:
  - [net-next,1/4] ionic: count dma errors
    https://git.kernel.org/netdev/net-next/c/0f4e7f4e77b2
  - [net-next,2/4] ionic: fix sizeof usage
    https://git.kernel.org/netdev/net-next/c/230efff47adb
  - [net-next,3/4] ionic: avoid races in ionic_heartbeat_check
    https://git.kernel.org/netdev/net-next/c/b2b9a8d7ed13
  - [net-next,4/4] ionic: pull per-q stats work out of queue loops
    https://git.kernel.org/netdev/net-next/c/aa620993b1e5

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


