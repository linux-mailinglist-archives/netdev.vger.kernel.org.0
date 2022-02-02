Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CA6C4A6B41
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 06:10:21 +0100 (CET)
Received: (majordomo@0.0.0.0) by vger.kernel.org via listexpand
        id S232518AbiBBFKQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 00:10:16 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:48798 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229580AbiBBFKN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 00:10:13 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 609ACB83009
        for <netdev@vger.kernel.org>; Wed,  2 Feb 2022 05:10:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 070ABC340F3;
        Wed,  2 Feb 2022 05:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643778611;
        bh=oyIax/FpMm7DszQ3xXwFcpfykzPUwYZ3OFWBKAJ8MBI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=FoFpohdahnCufHlOALIEbd9TTKcnNqyl1DEXxllT3zQk+ZwHElthS6N+MrFn5mIex
         aHnKRUkad9uMZcfXMKhbSzfU/1ZOQO2L50vbKCVgztO1J+2RTuF3YCBcFIVxKxi0Pr
         jmTO25gbyho4Ckblcx8clTDPZbPfyvVxX6bcojXFXEkvA0+rCtNzAT3B2vtccRNimf
         Eyb6Ea++6+DdxDDytP5Tyzpv6eAS3rud+43GD86Oq2olSRFrlG8j9V8VUyBBb5rgXS
         hHoZH6/x8/5VvP79Pa3topDMoUr03kK1pkxdukYfhVhJfzzj3z/S8YCYvQ/Ao6CAQM
         qh333hS5eD2ZA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E30E5E5D07E;
        Wed,  2 Feb 2022 05:10:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH V2 net-next] sfc: The size of the RX recycle ring should be
 more flexible
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164377861092.30544.4725309458508653960.git-patchwork-notify@kernel.org>
Date:   Wed, 02 Feb 2022 05:10:10 +0000
References: <20220131111054.cp4f6foyinaarwbn@gmail.com>
In-Reply-To: <20220131111054.cp4f6foyinaarwbn@gmail.com>
To:     Martin Habets <habetsm.xilinx@gmail.com>
Cc:     ihuguet@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ecree.xilinx@gmail.com, netdev@vger.kernel.org, dinang@xilinx.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 31 Jan 2022 11:10:54 +0000 you wrote:
> Ideally the size would depend on the link speed, but the recycle
> ring is created when the interface is brought up before the driver
> knows the link speed. So size it for the maximum speed of a given NIC.
> PowerPC is only supported on SFN7xxx and SFN8xxx NICs.
> 
> With this patch on a 40G NIC the number of calls to alloc_pages and
> friends went down from about 18% to under 2%.
> On a 10G NIC the number of calls to alloc_pages and friends went down
> from about 15% to 0 (perf did not capture any calls during the 60
> second test).
> On a 100G NIC the number of calls to alloc_pages and friends went down
> from about 23% to 4%.
> 
> [...]

Here is the summary with links:
  - [V2,net-next] sfc: The size of the RX recycle ring should be more flexible
    https://git.kernel.org/netdev/net-next/c/000fe940e51f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


