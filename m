Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 634CA45B996
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 13:00:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241912AbhKXMDX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 07:03:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:58218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241859AbhKXMDS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Nov 2021 07:03:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 8FEF661055;
        Wed, 24 Nov 2021 12:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637755208;
        bh=2x66CPb3TS7OZYOxCm6SQGm4K5jRiimJ/ekKSbLyE6g=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=OLu7kpz2GVhqEgPkxDgR/HxcwzrhrbI1Tun3umc0T8aGA7Z/B6OusebPJFYBqyLCg
         B6+kTtTvpRvhyGAS0d1Vfbo/Uleu+xuzRRZhTv6UlyzMm3UsVI3UhPHvrTOgtBfHQS
         /3I4iQWPEgGbDFzMiY33Vo9aLaQudKD6jdPjuS5tUgsPmck4pmaMWqxUTQ9HHl3M4g
         YBUD2JKlnM5eWAZvAD35BIMsv0a9bZgV+8bHARF9y+FhlDZT+8LaJUgY4t3TDOZPCO
         h8r2PSoln5kwH/1FXTEyf1RnAj3oevAkyfZo2agDJN66fKjBt3F32rMP6ndbiKWmTa
         f9K8nAyYuVE+g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 8697C609B9;
        Wed, 24 Nov 2021 12:00:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v8] net/ncsi : Add payload to be 32-bit aligned to fix
 dropped packets
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163775520854.1662.10651574507891086617.git-patchwork-notify@kernel.org>
Date:   Wed, 24 Nov 2021 12:00:08 +0000
References: <20211122163818.GA11306@gmail.com>
In-Reply-To: <20211122163818.GA11306@gmail.com>
To:     Kumar Thangavel <kumarthangavel.hcl@gmail.com>
Cc:     sam@mendozajonas.com, davem@davemloft.net, kuba@kernel.org,
        openbmc@lists.ozlabs.org, linux-aspeed@lists.ozlabs.org,
        netdev@vger.kernel.org, patrickw3@fb.com, amithash@fb.com,
        sdasari@fb.com, velumanit@hcl.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon, 22 Nov 2021 22:08:18 +0530 you wrote:
> Update NC-SI command handler (both standard and OEM) to take into
> account of payload paddings in allocating skb (in case of payload
> size is not 32-bit aligned).
> 
> The checksum field follows payload field, without taking payload
> padding into account can cause checksum being truncated, leading to
> dropped packets.
> 
> [...]

Here is the summary with links:
  - [v8] net/ncsi : Add payload to be 32-bit aligned to fix dropped packets
    https://git.kernel.org/netdev/net/c/ac132852147a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


