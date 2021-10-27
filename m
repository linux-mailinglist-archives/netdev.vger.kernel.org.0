Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9176B43D18B
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 21:20:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243673AbhJ0TWd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 15:22:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:41928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240730AbhJ0TWc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Oct 2021 15:22:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 017D560F22;
        Wed, 27 Oct 2021 19:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635362407;
        bh=oEMnwBGN5e3TfwMZF6+cu7+ZE+PMIGdkBM5rQMuJFlU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=S2fn1XSefu1iTa3R/hcGuvh8LWM0rGSaC1HpUHmdKkeZz/wv5KNInzXy3EL38rBXp
         QdbTMlgTYhdYs4r5H39YqyvhMX1fvREflOqTlMt0uWBxhrwnFgWKXQ4k12cbijgBiI
         nnBVkMyAWi+3Fj4Tef5CdoQYHe2CToQ2fVDa8tlJgUneAOGjL7K5gcmhM20E8WDpSq
         5uQ1/dreriRWipdgPP0+9vXHaeDwxCeRzsaxEUAnakbC4vfHGKdw92XjngZpj4hBGT
         3CC/q6Ns+rH0nnb5RQL+H5yj94OEaKP2gxjiNTok2HELDLWK9ZFbEQYar5QRLlnaxp
         FC81yiRhmnJOQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id E8D9160A17;
        Wed, 27 Oct 2021 19:20:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] usbnet: fix error return code in usbnet_probe()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163536240694.6049.9179035734607540392.git-patchwork-notify@kernel.org>
Date:   Wed, 27 Oct 2021 19:20:06 +0000
References: <20211026124015.3025136-1-wanghai38@huawei.com>
In-Reply-To: <20211026124015.3025136-1-wanghai38@huawei.com>
To:     Wang Hai <wanghai38@huawei.com>
Cc:     oneukum@suse.com, davem@davemloft.net, kuba@kernel.org,
        johan@kernel.org, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 26 Oct 2021 20:40:15 +0800 you wrote:
> Return error code if usb_maxpacket() returns 0 in usbnet_probe()
> 
> Fixes: 397430b50a36 ("usbnet: sanity check for maxpacket")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Wang Hai <wanghai38@huawei.com>
> ---
> v1->v2: change '-EINVAL' to '-ENODEV'
>  drivers/net/usb/usbnet.c | 1 +
>  1 file changed, 1 insertion(+)

Here is the summary with links:
  - [net,v2] usbnet: fix error return code in usbnet_probe()
    https://git.kernel.org/netdev/net/c/6f7c88691191

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


