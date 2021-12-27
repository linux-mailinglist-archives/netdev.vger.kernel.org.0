Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0449247FDE7
	for <lists+netdev@lfdr.de>; Mon, 27 Dec 2021 15:50:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237223AbhL0OuM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Dec 2021 09:50:12 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:47198 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237206AbhL0OuK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Dec 2021 09:50:10 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 680AD6102C;
        Mon, 27 Dec 2021 14:50:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C55D8C36AEA;
        Mon, 27 Dec 2021 14:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640616609;
        bh=nXr/2roQy0fQKkme9c2zWu2ugxNo52GxfhZUVv6FzXM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=HI9FZX1vBPnFcS9yGSAFmDso9i/x/meIcBwVsNyHy/Fc2EinBMxKKV2N9I+jwKcgh
         n27w1fujFapsBD16omTkTP1AWMrGsBMfmI7R2wCn5V2Svlj+xaMZwlThnXlNRltQB/
         4UeIcxHvL8EeKTi1eu7dTOhrLryQ0KqaTiQLNIy7u5R9kW/1UPeG2RCJY/ialfiD8s
         T4vbBjFOdeNt5q81E5gj1u0VFa2OqbnJWI/nc6fYCZAGRlsIeiBHC19/51g/qnah3S
         hPS5HCC7uGV+eICvqYS9Ee9UiZNPPVSUv3rlPvOto+iqoXpXuZCAi+BEqPopbe0h/a
         nEHocqVfvcK3g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9EA94C395DD;
        Mon, 27 Dec 2021 14:50:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: udp: fix alignment problem in udp4_seq_show()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164061660964.26121.4854651677382199300.git-patchwork-notify@kernel.org>
Date:   Mon, 27 Dec 2021 14:50:09 +0000
References: <20211227082951.844543-1-xingwu.yang@gmail.com>
In-Reply-To: <20211227082951.844543-1-xingwu.yang@gmail.com>
To:     yangxingwu <xingwu.yang@gmail.com>
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon, 27 Dec 2021 16:29:51 +0800 you wrote:
> $ cat /pro/net/udp
> 
> before:
> 
>   sl  local_address rem_address   st tx_queue rx_queue tr tm->when
> 26050: 0100007F:0035 00000000:0000 07 00000000:00000000 00:00000000
> 26320: 0100007F:0143 00000000:0000 07 00000000:00000000 00:00000000
> 27135: 00000000:8472 00000000:0000 07 00000000:00000000 00:00000000
> 
> [...]

Here is the summary with links:
  - net: udp: fix alignment problem in udp4_seq_show()
    https://git.kernel.org/netdev/net/c/6c25449e1a32

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


