Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59D903AF803
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 23:50:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231755AbhFUVwU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 17:52:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:45562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231181AbhFUVwT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Jun 2021 17:52:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 6F58E61040;
        Mon, 21 Jun 2021 21:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624312204;
        bh=sh3rywym6ivySTg/aftZ/gi4H3ghqJG4orLCYEU4848=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Iidj5tjpiGCYcd+PGPqEsuiy0fADFnwZ4q4N/QvpdQJ//7bYoOSMSx6sUXIRZcWOh
         4HGfWbVKO8XFE//lOk6SxEEKYBswsyOPotBxH2O/3Fz+5BtgwL1AsW6P+wmlzgMhr9
         jqcEug3uoTioaMCgmlIDtjI34luNAYDMK4BXuAV7Q9BoTqCe8A9dZf7XS7lXA8/GBa
         pqickFvl8Txe3zYqG1XRm+pav1H1kMI6lEcCyt8v8EHCT25Q9rGsrgdeLf4x2BJ52W
         /IXwBIILYVBI67JZmhJA+dcCmG6SLClphiW1K1eJ8SFdjXp9bfALllUwpJE4j74s2O
         5KK7Ccs7h8a2g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 5C3B660A37;
        Mon, 21 Jun 2021 21:50:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] mv88e6xxx: fixed adding vlan 0
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162431220437.17422.6366269633750145571.git-patchwork-notify@kernel.org>
Date:   Mon, 21 Jun 2021 21:50:04 +0000
References: <20210621085437.25777-1-eldargasanov2@gmail.com>
In-Reply-To: <20210621085437.25777-1-eldargasanov2@gmail.com>
To:     Eldar Gasanov <eldargasanov2@gmail.com>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, davem@davemloft.net,
        kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Mon, 21 Jun 2021 11:54:38 +0300 you wrote:
> 8021q module adds vlan 0 to all interfaces when it starts.
> When 8021q module is loaded it isn't possible to create bond
> with mv88e6xxx interfaces, bonding module dipslay error
> "Couldn't add bond vlan ids", because it tries to add vlan 0
> to slave interfaces.
> 
> There is unexpected behavior in the switch. When a PVID
> is assigned to a port the switch changes VID to PVID
> in ingress frames with VID 0 on the port. Expected
> that the switch doesn't assign PVID to tagged frames
> with VID 0. But there isn't a way to change this behavior
> in the switch.
> 
> [...]

Here is the summary with links:
  - mv88e6xxx: fixed adding vlan 0
    https://git.kernel.org/netdev/net/c/b8b79c414eca

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


