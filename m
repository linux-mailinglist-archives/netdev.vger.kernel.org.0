Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72BBB4865B6
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 15:00:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239897AbiAFOAc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 09:00:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239848AbiAFOAO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 09:00:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AEF0C061245
        for <netdev@vger.kernel.org>; Thu,  6 Jan 2022 06:00:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 07EBEB82185
        for <netdev@vger.kernel.org>; Thu,  6 Jan 2022 14:00:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id ABD93C36AF6;
        Thu,  6 Jan 2022 14:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641477610;
        bh=gPBxP0d9gXR+OxA8UoO76NXbwFYqWGztz3N96UJ0kYg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=FAQlTfytq9KWAHXYahvF3sjqUximCG88Q3r2VUz6sh/U4m5oi0XetoxipT4epPxRh
         2D/VnqV9yTPeLqeOSIZ8BglQ5KpfPOELu2aHx+ueLo5dTNREREWCpRgyc432gFB27t
         KuLwt65GoUB3KFnzTtVz8DryelMlMDJzci4Op21q3QDgI8Q7ctiUcKfQM87kqjhEEh
         Qq21FSGK4ItJSoy1lMpR/eXBXuAfCeIiXdvY2+ubKIaRJBFxiQhcLlD80kfstctyFr
         430gU46B4W+lt5vdnmLX5Le+uEE/A9gAu+rqsuFN+wG7L4wBZnvb4ktNXn7bs+FIdQ
         KKlETAUVx3ajg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9829FF79404;
        Thu,  6 Jan 2022 14:00:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] veth: Do not record rx queue hint in veth_xmit
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164147761061.14327.18077699517123305606.git-patchwork-notify@kernel.org>
Date:   Thu, 06 Jan 2022 14:00:10 +0000
References: <ef4cf3168907944502c81d8bf45e24eea1061e47.1641427152.git.daniel@iogearbox.net>
In-Reply-To: <ef4cf3168907944502c81d8bf45e24eea1061e47.1641427152.git.daniel@iogearbox.net>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        laurent.bernaille@datadoghq.com, maciej.fijalkowski@intel.com,
        toshiaki.makita1@gmail.com, eric.dumazet@gmail.com,
        pabeni@redhat.com, john.fastabend@gmail.com, willemb@google.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu,  6 Jan 2022 01:46:06 +0100 you wrote:
> Laurent reported that they have seen a significant amount of TCP retransmissions
> at high throughput from applications residing in network namespaces talking to
> the outside world via veths. The drops were seen on the qdisc layer (fq_codel,
> as per systemd default) of the phys device such as ena or virtio_net due to all
> traffic hitting a _single_ TX queue _despite_ multi-queue device. (Note that the
> setup was _not_ using XDP on veths as the issue is generic.)
> 
> [...]

Here is the summary with links:
  - [net-next] veth: Do not record rx queue hint in veth_xmit
    https://git.kernel.org/netdev/net-next/c/710ad98c363a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


