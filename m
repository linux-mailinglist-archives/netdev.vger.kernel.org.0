Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD68C3247C7
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 01:11:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235075AbhBYAKx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 19:10:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:39464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234547AbhBYAKw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Feb 2021 19:10:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id BE4CF64F11;
        Thu, 25 Feb 2021 00:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614211811;
        bh=13ZrnrWbJURGI9V3ZmlgrooZjGdus8OLxqZvp6eCfg8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=FGp8EVAf64yhpIejxvRwefw37McgJ84q6PJckOemOWgsoJ1CtOhpzxM1CbwqPF/IP
         8bZdU8ZYlCJMJly7/1YLIR0BWXYD+xAIO9MGPZbIF2o1trHaJ1y8v9ALF/YFRJ2Xrf
         7zuh6lKorzhxAlS9M8CYN6s0VhmhK9PYAqyXvQr4iK4LPjnh+uLGLT+fVId7v2m3Xg
         /imwv3L6RkiZ+uq+obVZNp/BMzu6uzlWDyakKubfqDO+SyKkDgcLfPR7wI30E+POD9
         P/8nWFHAFcCh4nFOf1CB41ccPcfvHvNmmwKqGKjDr9f87UwVErsfJa7O38jyCqy6fz
         Bn/hYsAZl1HQw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id B157660A0E;
        Thu, 25 Feb 2021 00:10:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v4 1/1] net: introduce CAN specific pointer in the struct
 net_device
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161421181172.15909.1583905121942567968.git-patchwork-notify@kernel.org>
Date:   Thu, 25 Feb 2021 00:10:11 +0000
References: <20210223070127.4538-1-o.rempel@pengutronix.de>
In-Reply-To: <20210223070127.4538-1-o.rempel@pengutronix.de>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     mkl@pengutronix.de, davem@davemloft.net, kuba@kernel.org,
        socketcan@hartkopp.net, robin@protonic.nl,
        syzbot+5138c4dd15a0401bec7b@syzkaller.appspotmail.com,
        kernel@pengutronix.de, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Tue, 23 Feb 2021 08:01:26 +0100 you wrote:
> Since 20dd3850bcf8 ("can: Speed up CAN frame receiption by using
> ml_priv") the CAN framework uses per device specific data in the AF_CAN
> protocol. For this purpose the struct net_device->ml_priv is used. Later
> the ml_priv usage in CAN was extended for other users, one of them being
> CAN_J1939.
> 
> Later in the kernel ml_priv was converted to an union, used by other
> drivers. E.g. the tun driver started storing it's stats pointer.
> 
> [...]

Here is the summary with links:
  - [net,v4,1/1] net: introduce CAN specific pointer in the struct net_device
    https://git.kernel.org/netdev/net/c/4e096a18867a

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


