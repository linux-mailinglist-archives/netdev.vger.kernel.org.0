Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2758940DA2D
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 14:41:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239835AbhIPMmD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Sep 2021 08:42:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:43474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239648AbhIPMln (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Sep 2021 08:41:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 888556124E;
        Thu, 16 Sep 2021 12:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631796008;
        bh=YXrE0jYauWoBrTFboha2/UM6aaZegc7QP9ZBgfz89mg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=MdxvfvsvQ02uDAUIUr9mbw2QbqtzmrKkxTy5RrTnnuVZ7kOAN9rY9uVsOxcxl15WQ
         UQTpT7KE3PMnk9KKmLEPXZYBCIroXQS+YB/WQoVmBLPp4PFmGGhlghvg1aCRpF0AUt
         SCLbLqiXCxq57PhPIvEgKlSPvVxHV4ph4Jh3VddMKU6YU0HVSSkmqeKEIowLmxyWXs
         P6FOLJCLL+KPWa4fJ5QuyaZjwN15lL9oE1mPibyYj1Nu+8zoDILJ4hC0ioALdDM53x
         lyQe18jdU9pjg1u7JQnG6Q7DgntnrLW5Hklm2XG/Vg4Vcp43g6CFjv4Y8uhH5JVAlJ
         SBsqYZFYIrEHA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 7F571609CD;
        Thu, 16 Sep 2021 12:40:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: atl1e: Make use of the helper function dev_err_probe()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163179600851.19379.5225525484343807820.git-patchwork-notify@kernel.org>
Date:   Thu, 16 Sep 2021 12:40:08 +0000
References: <20210915145757.7304-1-caihuoqing@baidu.com>
In-Reply-To: <20210915145757.7304-1-caihuoqing@baidu.com>
To:     Cai Huoqing <caihuoqing@baidu.com>
Cc:     chris.snook@gmail.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 15 Sep 2021 22:57:56 +0800 you wrote:
> When possible use dev_err_probe help to properly deal with the
> PROBE_DEFER error, the benefit is that DEFER issue will be logged
> in the devices_deferred debugfs file.
> And using dev_err_probe() can reduce code size, and simplify the code.
> 
> Signed-off-by: Cai Huoqing <caihuoqing@baidu.com>
> 
> [...]

Here is the summary with links:
  - net: atl1e: Make use of the helper function dev_err_probe()
    https://git.kernel.org/netdev/net-next/c/b0ab7096dd9b

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


