Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B97C3390C41
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 00:30:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232948AbhEYWbs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 May 2021 18:31:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:58290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232455AbhEYWbl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 May 2021 18:31:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 2F59D6140F;
        Tue, 25 May 2021 22:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621981811;
        bh=0I6PC5vUG3HHw90V4WXPKOBOH9IYtxirnkddBO4Cwtc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=pUidv/UjD0WbGfWjtPmMQtoNlHh1XsdkiUX1EJQMhFE6czJI9k2r742bXE/bnenfv
         GHh3SnUVxQ1qc6HIQjOArZxHghH930s4AuppNyvYGQ5rDYOcc9rDsyT3y+/W5X79hE
         g69DVW7NsoiKcWC2wcCABJnAqYVlUtZe0390qOJ47sZsrFOoOrw7lSsgOjkZPl9emG
         iAJ7u62zxHKKG8tP+GGiCAH5ULvi5JqYduUXjNEiIrREKHJJS3xyFon1yaPO7mqzmw
         Y2xJ2VLfo9umSh3g1qY7oLP9q1igBD71TNVuFlpNv5KN37bI1gdhyhodfGvWATJsWK
         OFLDNXrhk0HiQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 22BA060C29;
        Tue, 25 May 2021 22:30:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: hns3: switch to dim algorithm for adaptive
 interrupt moderation
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162198181113.18500.9820013936632485809.git-patchwork-notify@kernel.org>
Date:   Tue, 25 May 2021 22:30:11 +0000
References: <1621934523-52698-1-git-send-email-tanhuazhong@huawei.com>
In-Reply-To: <1621934523-52698-1-git-send-email-tanhuazhong@huawei.com>
To:     Huazhong Tan <tanhuazhong@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        salil.mehta@huawei.com, yisen.zhuang@huawei.com,
        huangdaode@huawei.com, linuxarm@huawei.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue, 25 May 2021 17:22:03 +0800 you wrote:
> The Linux kernel has support for a dynamic interrupt moderation
> algorithm known as "dimlib". Replace the custom driver-specific
> implementation of dynamic interrupt moderation with the kernel's
> algorithm.
> 
> Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
> 
> [...]

Here is the summary with links:
  - [net-next] net: hns3: switch to dim algorithm for adaptive interrupt moderation
    https://git.kernel.org/netdev/net-next/c/307ea4ce3edd

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


