Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 604082B8469
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 20:10:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726950AbgKRTKH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 14:10:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:33510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726268AbgKRTKG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Nov 2020 14:10:06 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605726605;
        bh=hVmwv30NHYCXFiGeRwjLOsTQJXMm2vVkagSC6m0FZck=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=OpEUInwgsrt2tsNFXBVlG3QrNYIZjmHGJZ9jaBON+36e0jqjqeQM7xH2HdMvM/BPJ
         xVS9R+Xiqc7UUi7L/XJhmf5oZygw8D7bNRbaUo6Drg1uNVDsD3zH9XK1qfvZhGcfhI
         yL/hDOPV39hnANk0AJ7e1FlGq+XOREUAEoRVRvR4=
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] net: Have netpoll bring-up DSA management interface
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160572660568.17971.9397534654388103737.git-patchwork-notify@kernel.org>
Date:   Wed, 18 Nov 2020 19:10:05 +0000
References: <20201117035236.22658-1-f.fainelli@gmail.com>
In-Reply-To: <20201117035236.22658-1-f.fainelli@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, olteanv@gmail.com, davem@davemloft.net,
        kuba@kernel.org, edumazet@google.com, wangyunjian@huawei.com,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Mon, 16 Nov 2020 19:52:34 -0800 you wrote:
> DSA network devices rely on having their DSA management interface up and
> running otherwise their ndo_open() will return -ENETDOWN. Without doing
> this it would not be possible to use DSA devices as netconsole when
> configured on the command line. These devices also do not utilize the
> upper/lower linking so the check about the netpoll device having upper
> is not going to be a problem.
> 
> [...]

Here is the summary with links:
  - [net,v2] net: Have netpoll bring-up DSA management interface
    https://git.kernel.org/netdev/net/c/1532b9778478

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


