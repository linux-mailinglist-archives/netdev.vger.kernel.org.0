Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AFA73CFC80
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 16:41:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240082AbhGTOAM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 10:00:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:47500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239998AbhGTNup (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Jul 2021 09:50:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 576B861241;
        Tue, 20 Jul 2021 14:30:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626791406;
        bh=Mq8VZpG5vgU2S7Ar52dlla//NUzwbdhgnLFot/NGkNQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=aquPh6K4HJMHQsns+Yy5DyL0VB7hrm3Xa8vhXxTg4iAg4F+iQXg3+0OTfgldI41Jm
         bzIp+uUxCkjA3C99MZ9Y75XuKMnkl1ex2p6mx1OOfqF9+UavsZo0TISnJS7JFpxdt2
         wFkJ6v2Syqh9Y4tRZakpAqWvFhhkHoY106OSpgoqqRP4Q/YIig+Y9854KwWwR49Ysn
         CPyLG0cBnWZ85jO+jCFgNgu0lJB8yOaESniwGg8nWGNIlg1u54s3dAHRUmcAQurw4v
         cqTTNkoFGz+nm4ngXU2o/zGgZarlWUb+ouGhp0RDT7GzYs0N99Yg46CTCxVZoHaRMn
         RlNsz+zshEXjA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 47E3E60CCF;
        Tue, 20 Jul 2021 14:30:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v7] net: phy: intel-xway: Add RGMII internal delay
 configuration
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162679140628.23944.4619317676188906245.git-patchwork-notify@kernel.org>
Date:   Tue, 20 Jul 2021 14:30:06 +0000
References: <20210720115647.15285-1-ms@dev.tdt.de>
In-Reply-To: <20210720115647.15285-1-ms@dev.tdt.de>
To:     Martin Schiller <ms@dev.tdt.de>
Cc:     hauke@hauke-m.de, martin.blumenstingl@googlemail.com,
        f.fainelli@gmail.com, andrew@lunn.ch, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue, 20 Jul 2021 13:56:47 +0200 you wrote:
> This adds the possibility to configure the RGMII RX/TX clock skew via
> devicetree.
> 
> Simply set phy mode to "rgmii-id", "rgmii-rxid" or "rgmii-txid" and add
> the "rx-internal-delay-ps" or "tx-internal-delay-ps" property to the
> devicetree.
> 
> [...]

Here is the summary with links:
  - [net-next,v7] net: phy: intel-xway: Add RGMII internal delay configuration
    https://git.kernel.org/netdev/net-next/c/be393dd685d2

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


