Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACCA6434CA6
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 15:50:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230243AbhJTNwa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 09:52:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:49530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230020AbhJTNw3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Oct 2021 09:52:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 03C5661373;
        Wed, 20 Oct 2021 13:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634737815;
        bh=zDc2PQx2O9H/yNGfT5TXI8kQn5I9KScjIpeUyoY6XBw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=N7WfrzwHBGxlEN2Z09GoTR0fom1kep7/z1qUx6RX6lsSdSs5n/ZJt72va3MA3Y7ud
         MSKxXAjRokdgwopUYCUridg8dzAArqU6yoqWW/o8AQHBV3SDutYCdgsI/Hbg2M4DPJ
         Kmrwxj4d1Guk5mRt61rHatr1akD2+2EtSIWygf0pg9L+ynmi4XZ5mgMr5PFawwMqSy
         kD1HcS1kiTFyZ0b8pEbpHMER8vI+Gu3bDDZLnEvlvXNlq/dokRdX4LNihDy3dimCeg
         XQXYdC1j9XPYo9lpW7JoQxMLlKkjtyoNji7lIxW8PhIyEnp6Ji8VpzOowRccQliVLX
         ExcwMZHTjazZQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id F11AA60A4E;
        Wed, 20 Oct 2021 13:50:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] nfc: st95hf: Make spi remove() callback return zero
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163473781498.13902.15621474452127110763.git-patchwork-notify@kernel.org>
Date:   Wed, 20 Oct 2021 13:50:14 +0000
References: <20211019204916.3834554-1-u.kleine-koenig@pengutronix.de>
In-Reply-To: <20211019204916.3834554-1-u.kleine-koenig@pengutronix.de>
To:     =?utf-8?q?Uwe_Kleine-K=C3=B6nig_=3Cu=2Ekleine-koenig=40pengutronix=2Ede=3E?=@ci.codeaurora.org
Cc:     krzysztof.kozlowski@canonical.com, netdev@vger.kernel.org,
        kernel@pengutronix.de
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue, 19 Oct 2021 22:49:16 +0200 you wrote:
> If something goes wrong in the remove callback, returning an error code
> just results in an error message. The device still disappears.
> 
> So don't skip disabling the regulator in st95hf_remove() if resetting
> the controller via spi fails. Also don't return an error code which just
> results in two error messages.
> 
> [...]

Here is the summary with links:
  - nfc: st95hf: Make spi remove() callback return zero
    https://git.kernel.org/netdev/net/c/641e3fd1a038

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


