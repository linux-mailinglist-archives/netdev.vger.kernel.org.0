Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1C364506A4
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 15:21:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236374AbhKOOYi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 09:24:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:38612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236401AbhKOOXG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Nov 2021 09:23:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 80BDE6323A;
        Mon, 15 Nov 2021 14:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636986011;
        bh=dBg1okxfLgHqPmHfiqz5SN/J6gC0J1H18Rwvn9ngNEE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=jO9hNVbGC5PjZrTJuoGwba/pjLtw0z+xR0JDvhyDXYweizaTmcktxocLiks508vxB
         twvZYafNp3uG6n4zthB+BzcQhcxT/frS/du/e7QIcXZjISFgqe3T6Pgz/rUg9600ES
         bXHJsjBUDE3ajONkASMZLYO3AfcwzEKUhnki1zvX1sJvls3L9QcgNgRjFn313jj5Hf
         byQ1MWk2rKqg+Yp+XOLl29gAhdCeyOFKZNaie+N1eJCKcDHWHjmkyrqat0eEdb5lBc
         5qVVF6yYEZj2eacJh0WrITbK24Sv+n4W+Z8KZNAcU1uoxdH92UbdX4iSE8KYdpz0jB
         D4tSStDOX1siQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 74E7A6095A;
        Mon, 15 Nov 2021 14:20:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: usb: ax88179_178a: add TSO feature
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163698601147.19991.2692958037645304656.git-patchwork-notify@kernel.org>
Date:   Mon, 15 Nov 2021 14:20:11 +0000
References: <20211115034941.793347-1-jackychou@asix.com.tw>
In-Reply-To: <20211115034941.793347-1-jackychou@asix.com.tw>
To:     Jacky Chou <jackychou@asix.com.tw>
Cc:     kuba@kernel.org, davem@davemloft.net, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        louis@asix.com.tw
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon, 15 Nov 2021 11:49:41 +0800 you wrote:
> On low-effciency embedded platforms, transmission performance is poor
> due to on Bulk-out with single packet.
> Adding TSO feature improves the transmission performance and reduces
> the number of interrupt caused by Bulk-out complete.
> 
> Reference to module, net: usb: aqc111.
> 
> [...]

Here is the summary with links:
  - net: usb: ax88179_178a: add TSO feature
    https://git.kernel.org/netdev/net-next/c/16b1c4e01c89

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


