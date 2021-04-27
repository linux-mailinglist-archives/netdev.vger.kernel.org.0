Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66FCA36CDB1
	for <lists+netdev@lfdr.de>; Tue, 27 Apr 2021 23:10:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239132AbhD0VKy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Apr 2021 17:10:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:38812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239013AbhD0VKx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Apr 2021 17:10:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id EA7E2613FE;
        Tue, 27 Apr 2021 21:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619557810;
        bh=0Tr2fgyofvmedd5gT54TNbSsDHSuz0kVSk0coryaDHo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=hIpgjGD8oIe6adFCrjXY3dBwVK7OoBVHkWFQuRJSZsto9ve6SB1S+mMD0Gh6/sW8r
         PIZuGrCVOqcPJES/d3I6KGTSBwnCoS55kqxJg3b6572tzu4Njlckn7ZDCaH9F1dsfC
         TRxRGmvYF9srJufAtb+lnQqacfi9Dz/+RxsdeqbYi+A/G3t3yhCW0qE8bX2kZR+Reh
         TfU4Nh5y8xqvLnVsO5XTvhEoLgHrLuSlCCa72Ll3z+38Xxp+L5OvVj1WCZxX4ggfWf
         2l4SvJwnbCq87ZB7A9Hr6/SxBpXBst5Bom6fy8WvorwW0VsUI1YTO1McB3AKirLaQ+
         SxH2z7PDL2qVA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id E0AAC60A3A;
        Tue, 27 Apr 2021 21:10:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: dsa: mv88e6xxx: Fix 6095/6097/6185 ports in
 non-SERDES CMODE
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161955780991.15707.4300930057049071112.git-patchwork-notify@kernel.org>
Date:   Tue, 27 Apr 2021 21:10:09 +0000
References: <20210426161734.1735032-1-tobias@waldekranz.com>
In-Reply-To: <20210426161734.1735032-1-tobias@waldekranz.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon, 26 Apr 2021 18:17:34 +0200 you wrote:
> The .serdes_get_lane op used the magic value 0xff to indicate a valid
> SERDES lane and 0 signaled that a non-SERDES mode was set on the port.
> 
> Unfortunately, "0" is also a valid lane ID, so even when these ports
> where configured to e.g. RGMII the driver would set them up as SERDES
> ports.
> 
> [...]

Here is the summary with links:
  - [net-next] net: dsa: mv88e6xxx: Fix 6095/6097/6185 ports in non-SERDES CMODE
    https://git.kernel.org/netdev/net-next/c/6066234aa338

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


