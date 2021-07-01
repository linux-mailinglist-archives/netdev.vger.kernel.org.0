Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 618D63B97B4
	for <lists+netdev@lfdr.de>; Thu,  1 Jul 2021 22:38:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236531AbhGAUjE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Jul 2021 16:39:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:40038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234144AbhGAUjC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Jul 2021 16:39:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 4F3AC61410;
        Thu,  1 Jul 2021 20:36:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625171791;
        bh=xNxdSTWt9tw2e2Y+92mM/IEh8drfaMRESlpo53nksJw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=RMmqe393zqwnOJAzBJFHBzuwrVa8iPkx2A5feECMH694llAWiq/zGBMbtlZy5BVLY
         f0hp2C/pZLr9dbvn+1bhTVIWDAYCfF5Tx+w0lgpeK07klKwTz4916L6qd2gqXEOP/m
         ZANNRxVE7xQhpq8tygCkJy0IBr6q45AAav7DI4wdz1Jn7ktQ0zvDbhQtln5HCpcebz
         I3kI1046z7yZjzQOah8KT24gX7cKNitpwv/2eU+4B6AW3I/IwnE2h4q8yu/2m5Gmxc
         c+3bjhfjYCOsgP0EVBZBBHLkV1P4dXaAM3mOPy7G/GZ+iIqsczXxhaIdL0x25dY36Y
         M9nj++xl09m5Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 440A260A37;
        Thu,  1 Jul 2021 20:36:31 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] tcp: consistently disable header prediction for mptcp
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162517179127.24244.9662695530837774355.git-patchwork-notify@kernel.org>
Date:   Thu, 01 Jul 2021 20:36:31 +0000
References: <7f941e06e6434902ea4a0a572392f65cd2745447.1625053058.git.pabeni@redhat.com>
In-Reply-To: <7f941e06e6434902ea4a0a572392f65cd2745447.1625053058.git.pabeni@redhat.com>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, edumazet@google.com, davem@davemloft.net,
        kuba@kernel.org, dcaratti@redhat.com,
        mathew.j.martineau@linux.intel.com, mptcp@lists.linux.dev
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed, 30 Jun 2021 13:42:13 +0200 you wrote:
> The MPTCP receive path is hooked only into the TCP slow-path.
> The DSS presence allows plain MPTCP traffic to hit that
> consistently.
> 
> Since commit e1ff9e82e2ea ("net: mptcp: improve fallback to TCP"),
> when an MPTCP socket falls back to TCP, it can hit the TCP receive
> fast-path, and delay or stop triggering the event notification.
> 
> [...]

Here is the summary with links:
  - [net] tcp: consistently disable header prediction for mptcp
    https://git.kernel.org/netdev/net/c/71158bb1f2d2

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


