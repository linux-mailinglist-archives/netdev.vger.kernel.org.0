Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC9B83B48F8
	for <lists+netdev@lfdr.de>; Fri, 25 Jun 2021 20:50:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229671AbhFYSw0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Jun 2021 14:52:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:41556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229700AbhFYSwZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Jun 2021 14:52:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 037726197C;
        Fri, 25 Jun 2021 18:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624647004;
        bh=7YJ+9QIFkfFm5YYWxvFXH7zZijCIN6TtFlrNbkef5Yk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=lCPF+5vcBeNcQENQu9jcmUTg1vV+EGRZjnJ/0HBSlhDtbKP+GwmM5FZi4uVLqqDsY
         Qn5OOqCHwlwtQEYVQd2wSBw5MYKvZzk0xnqZxef1FCFrbUocCUVQfZvIrf0wrJhSm8
         VT0qEc747LmljEFmnRGjuL8woJZO0lJ7RyJt8HQXTexWEPMsadVo5GVGuWCgfbKu1f
         +BvIHizhUEGYgfZw0kdSy/MGefy5IlWkw0ZqE39ZNwjETLqBH3jFGY62tSt28Mpa4H
         1pZU+m9DZYzsJj5XS324ZiX+ODFcxfUA3ginyWraOibuCjFcBQTgkgqkvOW+yNlmk9
         C+40uUnPI3z1g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id F157D60A71;
        Fri, 25 Jun 2021 18:50:03 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next: PATCH] net: mdiobus: withdraw fwnode_mdbiobus_register
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162464700398.1054.580442039496894060.git-patchwork-notify@kernel.org>
Date:   Fri, 25 Jun 2021 18:50:03 +0000
References: <20210625103853.459277-1-mw@semihalf.com>
In-Reply-To: <20210625103853.459277-1-mw@semihalf.com>
To:     Marcin Wojtas <mw@semihalf.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, jon@solid-run.com,
        tn@semihalf.com, jaz@semihalf.com, hkallweit1@gmail.com,
        andrew@lunn.ch, nathan@kernel.org, sfr@canb.auug.org.au
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Fri, 25 Jun 2021 12:38:53 +0200 you wrote:
> The newly implemented fwnode_mdbiobus_register turned out to be
> problematic - in case the fwnode_/of_/acpi_mdio are built as
> modules, a dependency cycle can be observed during the depmod phase of
> modules_install, eg.:
> 
> depmod: ERROR: Cycle detected: fwnode_mdio -> of_mdio -> fwnode_mdio
> depmod: ERROR: Found 2 modules in dependency cycles!
> 
> [...]

Here is the summary with links:
  - [net-next:] net: mdiobus: withdraw fwnode_mdbiobus_register
    https://git.kernel.org/netdev/net-next/c/ac53c26433b5

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


