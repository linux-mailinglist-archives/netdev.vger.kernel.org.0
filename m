Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99BFD431974
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 14:40:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231717AbhJRMmT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 08:42:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:46750 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231167AbhJRMmS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Oct 2021 08:42:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id D1C4260FDA;
        Mon, 18 Oct 2021 12:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634560806;
        bh=b4+rdq4Rd1kwbT3ywFTRo4E4wOrsblqhJWSJ7DL8HQM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=S7zPFNsXG3HYe/US4XtuhOlKFcy2DEZTzuG9eQZzubFYast2cxKVLxEKDaWPMgxLX
         a3x3/Ptxzlw5Na+LgHssB/d+0UkKAsliVqY1fdxlBfjje8fzSvVEcr6vtVlKcQmSs8
         zHRq/0KQO9n7i/TUVKChFtzG8R448UbQLhBSGY6BBbBtW85VLrK/ZUHWCp5AW6KRzE
         ymTtK7PmfscqUhiz5t+LYqJZNRa/vhtZcNumtiDGyNGhLYha8VEkx3oXkYSkQm76/Q
         ZX9XT2STY4W4qWOYXkToFnEAJFzmFAsafn5S3vMyL0DXnWBAHlHokB2OFHnQ/hjMiy
         qJHOvo1gYHzew==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id BA96B600E6;
        Mon, 18 Oct 2021 12:40:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: dsa: mt7530: correct ds->num_ports
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163456080675.22515.9678454844933633243.git-patchwork-notify@kernel.org>
Date:   Mon, 18 Oct 2021 12:40:06 +0000
References: <20211016062414.783863-1-dqfext@gmail.com>
In-Reply-To: <20211016062414.783863-1-dqfext@gmail.com>
To:     DENG Qingfang <dqfext@gmail.com>
Cc:     sean.wang@mediatek.com, Landen.Chao@mediatek.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, kuba@kernel.org, matthias.bgg@gmail.com,
        p.zabel@pengutronix.de, linux@armlinux.org.uk,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Sat, 16 Oct 2021 14:24:14 +0800 you wrote:
> Setting ds->num_ports to DSA_MAX_PORTS made DSA core allocate unnecessary
> dsa_port's and call mt7530_port_disable for non-existent ports.
> 
> Set it to MT7530_NUM_PORTS to fix that, and dsa_is_user_port check in
> port_enable/disable is no longer required.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: DENG Qingfang <dqfext@gmail.com>
> 
> [...]

Here is the summary with links:
  - [net] net: dsa: mt7530: correct ds->num_ports
    https://git.kernel.org/netdev/net/c/342afce10d6f

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


