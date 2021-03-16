Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0AD033DC7A
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 19:21:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239993AbhCPSUu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 14:20:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:59388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239927AbhCPSUJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Mar 2021 14:20:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 007756511C;
        Tue, 16 Mar 2021 18:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615918809;
        bh=WYUaeFif51LCqtlUrokoMzBcTRE15cs9DDuOiTDsrrc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=rinDcxOTzkoslRaQ77cGX+6KxC6SikZ9x1h6HzVPJBZxkkGiMtepZ4Ix9rNGQRFCr
         0avhezna+kJ2xuPscoNUxF/+nK+HIpLBUkIDzWam+qAw2WcPsqX8jt4Xsh1aiB9DNH
         pfIDJRv5w8SGDgnH8jHpBP/QGKbjm49g4eUtjl6Gis4MWDfrLdCNxZ3Ln3/9p1mdUm
         +1tDxCI0NHzoR0Agh5uUepRCZHjnBE6pO4FGvUt9kK3tYTPT2r88rNwAsPyfKpAkV7
         CjAHOVkXBKuYjcIjJSxcj5hL53MpR2XOXPanGR2efy0yzaNWf7Vxa0xoG/JJpzyku2
         Mk432Od9BJNMQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id EC7B860965;
        Tue, 16 Mar 2021 18:20:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: dsa: sja1105: fix error return code in
 sja1105_cls_flower_add()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161591880896.7330.18210169419702758432.git-patchwork-notify@kernel.org>
Date:   Tue, 16 Mar 2021 18:20:08 +0000
References: <20210315144323.4110640-1-weiyongjun1@huawei.com>
In-Reply-To: <20210315144323.4110640-1-weiyongjun1@huawei.com>
To:     'w00385741 <weiyongjun1@huawei.com>
Cc:     olteanv@gmail.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, kuba@kernel.org, baowen.zheng@corigine.com,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        hulkci@huawei.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon, 15 Mar 2021 14:43:23 +0000 you wrote:
> From: Wei Yongjun <weiyongjun1@huawei.com>
> 
> The return value 'rc' maybe overwrite to 0 in the flow_action_for_each
> loop, the error code from the offload not support error handling will
> not set. This commit fix it to return -EOPNOTSUPP.
> 
> Fixes: 6a56e19902af ("flow_offload: reject configuration of packet-per-second policing in offload drivers")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
> 
> [...]

Here is the summary with links:
  - [net-next] net: dsa: sja1105: fix error return code in sja1105_cls_flower_add()
    https://git.kernel.org/netdev/net-next/c/6f0d32509a92

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


