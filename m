Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9141545497C
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 16:00:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232487AbhKQPDo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 10:03:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:34864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238760AbhKQPDM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Nov 2021 10:03:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 4FD6361BFA;
        Wed, 17 Nov 2021 15:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637161214;
        bh=c63/pgJA5nk2NtTu8mB9XVzWIrs4e6E6AgDEI5EG0hQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=UnvN3xULMq1PnYqTSePEleB4cC4NWJjDxLN4vabok09VIREHiIPiQB3NCSrZS6cVI
         0Q5lLpb7nQq5Sms17hRBWAmqv/JM6vx9XKI9nEQbEAOkJJbmamIH6hn53msuSrY4H0
         VIBPtFPtE49fI773etwOGz0A0ma/w0QQRq2YJNEykZv0fmgRlwQXxD3ixA5iiPQYEI
         wh5WC13KcR0H/zKHF9KxM94N29seRgQI1AxnOF3kvAljmgVjZrlaX1+2bqcFZSnHKq
         xa5VI7k3cT1V2J/uAtBa0WODwT6o7SsCgeRV6m+BCxGLGIPkg2JNX0AqpMSf+c1DYw
         yvcSe+5QAZIcg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 461DA609D3;
        Wed, 17 Nov 2021 15:00:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull request: bluetooth 2021-11-16
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163716121428.17032.4368994013199405510.git-patchwork-notify@kernel.org>
Date:   Wed, 17 Nov 2021 15:00:14 +0000
References: <20211116213313.985961-1-luiz.dentz@gmail.com>
In-Reply-To: <20211116213313.985961-1-luiz.dentz@gmail.com>
To:     Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue, 16 Nov 2021 13:33:13 -0800 you wrote:
> The following changes since commit d0f1c248b4ff71cada1b9e4ed61a1992cd94c3df:
> 
>   Merge tag 'for-net-next-2021-10-01' of git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next (2021-10-05 07:41:16 -0700)
> 
> are available in the Git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next.git tags/for-net-next-2021-11-16
> 
> [...]

Here is the summary with links:
  - pull request: bluetooth 2021-11-16
    https://git.kernel.org/netdev/net-next/c/b32563b6ccba

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


