Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A9C1423572
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 03:30:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237084AbhJFBb6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 21:31:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:56028 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233994AbhJFBb6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Oct 2021 21:31:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id B140061165;
        Wed,  6 Oct 2021 01:30:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633483806;
        bh=ztwYD56B2KsP6fFIZTzjt6Ah2BKEvH+8TjKy0lSXtR8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=JFt1cj/jAAxMnRzI7LT0wZlhB7QxakOz3XjHPVzOkNLA0wFuTAXtoTLs7pcZzM8CP
         vynfn/aCHZS4iUveHIa1LZ8a/1NzKE3vv6pqvm+1Fxo3XndCveV1zcwL+gWPWQ8lgs
         8QrJg+4ZXxwiAn5+C92knzpKKPyTuQuGzNvc+WYolHcBx4wtccxnT50yz1Byu20Qir
         354MgdYY7KU9py9nIQPW+5nPOZfmiRuAPOiQaxEa6DvAuqvQoQ7jJbpmzvRY/DSbwF
         t34affnFhb4rX+nH5Y4KondLaeHFz5VgUFDh2KTjhXm3NxW3sOhPBm8/2ggNN4NjPQ
         3/tgAjBZJ1iBA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id A531A60A3A;
        Wed,  6 Oct 2021 01:30:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] net: phy: at803x: add QCA9561 support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163348380667.13576.6605500363351075672.git-patchwork-notify@kernel.org>
Date:   Wed, 06 Oct 2021 01:30:06 +0000
References: <20211005225401.10653-1-mail@david-bauer.net>
In-Reply-To: <20211005225401.10653-1-mail@david-bauer.net>
To:     David Bauer <mail@david-bauer.net>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed,  6 Oct 2021 00:54:01 +0200 you wrote:
> Add support for the embedded fast-ethernet PHY found on the QCA9561
> WiSoC platform. It supports the usual Atheros PHY featureset including
> the cable tester.
> 
> Tested on a Xiaomi MiRouter 4Q (QCA9561)
> 
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> Signed-off-by: David Bauer <mail@david-bauer.net>
> 
> [...]

Here is the summary with links:
  - [net-next,v2] net: phy: at803x: add QCA9561 support
    https://git.kernel.org/netdev/net-next/c/fada2ce09308

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


