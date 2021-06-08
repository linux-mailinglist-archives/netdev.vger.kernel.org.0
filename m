Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3787C3A066F
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 23:50:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234794AbhFHVwF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 17:52:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:47284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234779AbhFHVwC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Jun 2021 17:52:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 5C16F6139A;
        Tue,  8 Jun 2021 21:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623189009;
        bh=SuZf5CCqqwfWwZLQBRQFTsWwPtyHFG/LGSMt/78I1gM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=VaxR1TnZvcKdmaGZ206X230Obdb6HljyYAmmes4BQ34xqyg63YKY2Zg/EkLeP/B90
         BvjHJdtHP7AVosi4SLw//10D2g8k2ywqb6LaySDpuJIDqgROm+BL3oYk9+zPRQB3vE
         c4imgc0cOC1wfG0zJs8rdd222ZQRtIALVqGN7EBaHvqWjBDorsZgImOQ6iWqvdfl34
         5MbdIEqJPIMUa/r417ZOe0/0+0rBgAfwEqgC9Za6SC7QqK9lJTz4RCWUbL9XFMtOBm
         J8Zjr34UNC1Q0eUBtPzJqJKcEGTuAut9m10K/s8EAeyLJLLIs7gvnojyaNMBHxF6rf
         monlPBAlBSQ3w==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 50B0E609D2;
        Tue,  8 Jun 2021 21:50:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 00/10] net: WWAN subsystem improvements
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162318900932.8715.4669669259208557381.git-patchwork-notify@kernel.org>
Date:   Tue, 08 Jun 2021 21:50:09 +0000
References: <20210608040241.10658-1-ryazanov.s.a@gmail.com>
In-Reply-To: <20210608040241.10658-1-ryazanov.s.a@gmail.com>
To:     Sergey Ryazanov <ryazanov.s.a@gmail.com>
Cc:     loic.poulain@linaro.org, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Tue,  8 Jun 2021 07:02:31 +0300 you wrote:
> While working on WWAN netdev creation support, I notice a few things
> that could be done to make the wwan subsystem more developer and user
> friendly. This series implements them.
> 
> The series begins with a WWAN HW simulator designed simplify testing
> and make the WWAN subsystem available for a wider audience. The next two
> patches are intended to make the code a bit more clearer. This is
> followed by a few patches to make the port device naming more
> user-friendly. The series is finishes with a set of changes that allow
> the WWAN AT port to be used with terminal emulation software.
> 
> [...]

Here is the summary with links:
  - [01/10] wwan_hwsim: WWAN device simulator
    https://git.kernel.org/netdev/net-next/c/f36a111a74e7
  - [02/10] wwan_hwsim: add debugfs management interface
    https://git.kernel.org/netdev/net-next/c/9ee23f48f670
  - [03/10] net: wwan: make WWAN_PORT_MAX meaning less surprised
    https://git.kernel.org/netdev/net-next/c/b64d76b78226
  - [04/10] net: wwan: core: init port type string array using enum values
    https://git.kernel.org/netdev/net-next/c/64cc80c0ff2e
  - [05/10] net: wwan: core: spell port device name in lowercase
    https://git.kernel.org/netdev/net-next/c/392c26f7f133
  - [06/10] net: wwan: core: make port names more user-friendly
    https://git.kernel.org/netdev/net-next/c/f458709ff40b
  - [07/10] net: wwan: core: expand ports number limit
    https://git.kernel.org/netdev/net-next/c/72eedfc4bbc7
  - [08/10] net: wwan: core: implement TIOCINQ ioctl
    https://git.kernel.org/netdev/net-next/c/e263c5b2e891
  - [09/10] net: wwan: core: implement terminal ioctls for AT port
    https://git.kernel.org/netdev/net-next/c/c230035c2f2f
  - [10/10] net: wwan: core: purge rx queue on port close
    https://git.kernel.org/netdev/net-next/c/504672038b17

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


