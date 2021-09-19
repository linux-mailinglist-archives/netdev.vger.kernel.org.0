Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F165B410B7A
	for <lists+netdev@lfdr.de>; Sun, 19 Sep 2021 14:10:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231876AbhISMLh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Sep 2021 08:11:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:42522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229662AbhISMLd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 19 Sep 2021 08:11:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 7009961283;
        Sun, 19 Sep 2021 12:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632053408;
        bh=1hkcgje5jrmk0YrF6UzQWueVG8tXzuS1tnwkK5Ovq7g=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Ll8MSQqID8Bk8W5ygWJFyDnCLI1M4IcFjPvHofQdmzO7voJLt+ISrnlxRS3zNqJk+
         9GZNZMltl7XPqapFeTu4F4v9m/MU1M2MZS5kJXu0MljY2u9PwsXG1oXHWAZtIB/kvD
         yYn01DF/AImnEUqUp5Iii9pK0KMqRcl+e9+hKvuG55O+UWHyCpPT6qldKkc6Ay7Qc+
         IJ1p/yNyR08p8OczudBdsmS9trQJXqRAYiIgNRPPNxXIZjr4nQ7273bHNqtiMIeVzl
         I/TKvBT05Hf2Gdu6TlWJP8JOdlAX7yrLqQDsv+0RGXJjiTNn5AxKUmTsq2xBitDyIQ
         qeMlf3yNBsjLg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 518F760A53;
        Sun, 19 Sep 2021 12:10:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net] net: dsa: tear down devlink port regions when tearing
 down the devlink port on error
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163205340833.3254.3994725403915466356.git-patchwork-notify@kernel.org>
Date:   Sun, 19 Sep 2021 12:10:08 +0000
References: <20210917142916.688090-1-vladimir.oltean@nxp.com>
In-Reply-To: <20210917142916.688090-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Fri, 17 Sep 2021 17:29:16 +0300 you wrote:
> Commit 86f8b1c01a0a ("net: dsa: Do not make user port errors fatal")
> decided it was fine to ignore errors on certain ports that fail to
> probe, and go on with the ports that do probe fine.
> 
> Commit fb6ec87f7229 ("net: dsa: Fix type was not set for devlink port")
> noticed that devlink_port_type_eth_set(dlp, dp->slave); does not get
> called, and devlink notices after a timeout of 3600 seconds and prints a
> WARN_ON. So it went ahead to unregister the devlink port. And because
> there exists an UNUSED port flavour, we actually re-register the devlink
> port as UNUSED.
> 
> [...]

Here is the summary with links:
  - [v2,net] net: dsa: tear down devlink port regions when tearing down the devlink port on error
    https://git.kernel.org/netdev/net/c/fd292c189a97

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


