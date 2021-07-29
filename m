Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 427163DAE1D
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 23:20:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233789AbhG2VUN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 17:20:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:55566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229510AbhG2VUJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Jul 2021 17:20:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id BAEF060F01;
        Thu, 29 Jul 2021 21:20:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627593605;
        bh=G4tI57fYZvsSUdzReQWAOjceHWzfpb6X6xjLDMyW8h0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=TaYr+LIkko51HkqNDqzzqymhs11YNvaQ8GyMRvJ6qo6/NzDD/yJYTqVm+zr5lLRI1
         ooxEfavx+WizEi0DOVwJE00W7dhkSLDYRj69lCvX0ulbWqngyQA+T7dytvmPMLFIBt
         i1UtND7OO27WkupB7vqVFa5mLczmHWHoQJJH77AwMmSTcjoEHINGuHiPcM7/Rzc0s6
         EkL3HLdtb5UZi1jH/pl/oLh/uw8R2fnRnKVoViAviN5LYuY536Sipfhb0qksjPa78j
         xrXMQ01NPogN8qA0Cl4SBCapUncDARqAg0nfH+tP6Kv4WQhtY2iIhPNwcrueTrgPyE
         dpxRml9McHIsg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id A9DA560A59;
        Thu, 29 Jul 2021 21:20:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] bcm63xx_enet: delete a redundant assignment
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162759360569.14384.15979544016088111992.git-patchwork-notify@kernel.org>
Date:   Thu, 29 Jul 2021 21:20:05 +0000
References: <20210729040300.25928-1-tangbin@cmss.chinamobile.com>
In-Reply-To: <20210729040300.25928-1-tangbin@cmss.chinamobile.com>
To:     Tang Bin <tangbin@cmss.chinamobile.com>
Cc:     davem@davemloft.net, kuba@kernel.org, f.fainelli@gmail.com,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        zhangshengju@cmss.chinamobile.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Thu, 29 Jul 2021 12:03:00 +0800 you wrote:
> In the function bcm_enetsw_probe(), 'ret' will be assigned by
> bcm_enet_change_mtu(), so 'ret = 0' make no sense.
> 
> Signed-off-by: Zhang Shengju <zhangshengju@cmss.chinamobile.com>
> Signed-off-by: Tang Bin <tangbin@cmss.chinamobile.com>
> ---
> Changes from v1
>  - fix up the subject
> 
> [...]

Here is the summary with links:
  - [v2] bcm63xx_enet: delete a redundant assignment
    https://git.kernel.org/netdev/net-next/c/3e12361b6d23

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


