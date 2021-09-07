Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3614840261E
	for <lists+netdev@lfdr.de>; Tue,  7 Sep 2021 11:20:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245230AbhIGJVM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Sep 2021 05:21:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:51076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244918AbhIGJVL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Sep 2021 05:21:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 86272610FE;
        Tue,  7 Sep 2021 09:20:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631006405;
        bh=MDOaGKQD9X9XBXcgBmfLq8LoutzLOAu2NRUIPTIqHHA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=j0NZRFH+ehCTJf7hj8Y+BZKoKgfFrZV9xPd4DnysZi7ZhhBWLy8DGg8G4mZyv2ns+
         ex+ZzmTCevgrhTv4guSIsWM7us/P+EZRUOPGPPlQ4QyHNoX5Rai/MQj97a2dHZc1dz
         /xVux90WmO66VCiHdZv7+73h7LnqEVzmt8LT+WAm055nTKCpDhVAGH9lrxvez/tPTx
         WjR23/r5359iTOSwggTal59qsM1ejCKFoEMk5zgzMkHSXdjjdrty+zOtbOvmb7o7JP
         7vz4qfMeksasAhLmt+Q6tiXjMhYFC5MTUb62WihE65EvWM19mzwwktJFq3Xf3JX35B
         j9rHLxoVzXsXg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 78CC860A49;
        Tue,  7 Sep 2021 09:20:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: can 2021-09-07
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163100640548.23379.14698383966753828696.git-patchwork-notify@kernel.org>
Date:   Tue, 07 Sep 2021 09:20:05 +0000
References: <20210907065252.1061052-1-mkl@pengutronix.de>
In-Reply-To: <20210907065252.1061052-1-mkl@pengutronix.de>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        linux-can@vger.kernel.org, kernel@pengutronix.de
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net.git (refs/heads/master):

On Tue,  7 Sep 2021 08:52:50 +0200 you wrote:
> Hello Jakub, hello David,
> 
> this is a pull request of 2 patches for net/master.
> 
> The first patch is by my and silences a warning in the rcar_canfd
> driver, if it's compiled with CONFIG_OF disabled.
> 
> [...]

Here is the summary with links:
  - pull-request: can 2021-09-07
    https://git.kernel.org/netdev/net/c/1c990729e198
  - [net,2/2] can: c_can: fix null-ptr-deref on ioctl()
    https://git.kernel.org/netdev/net/c/644d0a5bcc33

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


