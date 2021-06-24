Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43CE93B3784
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 22:00:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232895AbhFXUC0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 16:02:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:42394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232759AbhFXUCY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Jun 2021 16:02:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 96DD2613C2;
        Thu, 24 Jun 2021 20:00:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624564804;
        bh=iqW6OKBD+Pd54AIhc1V9/0r7UUpEJ54FfBFonNp4wlQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=oO0ysNuqPIwg2+FIj618DpHbY3F9IM19JHT03HnM2bg2fLL9mt2LeQKyLud9xlY21
         zSflRO4c20dChYfj5BAZVGjwOte81EnxtHgtC9OmYnWvRYyhZDImJX3lUl22WSi9eJ
         HZ83SW57j5kSiwoLxBHA1hZ9fK/H1FCCSuWXO/cPLEzEBoqlyKnRCYFu3071Z1i/vV
         R1O2mWpDKI6oOCQVQaQYGVhM7+0RfE+odUPeQ4rlim2J0xuZX3Qjsr7xOwkPfLVVEQ
         70caBPBDFoMTuihe3TPz2hF9G0u4hfaMv0tUUNe63ponVWDxdSnwJHUxew+HW++O2f
         tIJizK1qU5h6g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 908D9609AC;
        Thu, 24 Jun 2021 20:00:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/2] Document the NXP SJA1110 switch as supported
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162456480458.15446.9074214993699449470.git-patchwork-notify@kernel.org>
Date:   Thu, 24 Jun 2021 20:00:04 +0000
References: <20210624145524.944878-1-olteanv@gmail.com>
In-Reply-To: <20210624145524.944878-1-olteanv@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        f.fainelli@gmail.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        corbet@lwn.net, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, vladimir.oltean@nxp.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Thu, 24 Jun 2021 17:55:22 +0300 you wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> Now that most of the basic work for SJA1110 support has been done in the
> sja1105 DSA driver, let's add the missing documentation bits to make it
> clear that the driver can be used.
> 
> Vladimir Oltean (2):
>   Documentation: net: dsa: add details about SJA1110
>   net: dsa: sja1105: document the SJA1110 in the Kconfig
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] Documentation: net: dsa: add details about SJA1110
    https://git.kernel.org/netdev/net-next/c/44531076338f
  - [net-next,2/2] net: dsa: sja1105: document the SJA1110 in the Kconfig
    https://git.kernel.org/netdev/net-next/c/75e994709f8a

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


