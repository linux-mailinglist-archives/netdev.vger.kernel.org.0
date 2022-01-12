Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 830B948BDF9
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 05:50:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350778AbiALEuM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 23:50:12 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:58792 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232412AbiALEuL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jan 2022 23:50:11 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 939E76184A
        for <netdev@vger.kernel.org>; Wed, 12 Jan 2022 04:50:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EB77CC36AEB;
        Wed, 12 Jan 2022 04:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641963011;
        bh=9WUxbiPyuSrwhNhmRsCErtpkvcbIIwUlgVonuiO1xpg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=i9ZnFBhEBpGsnkeltsztMPw9sJAc228FGPxn0TsanFqwpZQD5pZYLXoI4FarE6cq0
         nK7v1yvAszM/6lstLz76XGpHpX1g22F8cNx+fwAry4fHl+AXnN+wMQHkZW9z/tL8n4
         A4U8ApztcgKnQP1D/zTNxk6moVajSrg3zTgjy0W9pVMKkyWm8AhI2WXOeng+xqiT8S
         r0jOuMjv/r8E+9rcMfRkeW8//oD2idYenSGF1+6AiIvzrww6+ZV0etu7qffVgYCY3q
         5YS/A496JJBGueksfYWNUQqksNUcTWkB/RGxovPo3oRR5D+lRaXNRTFRMKdYaoNGJw
         W1d+bK/vApxFA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D0CA9F60795;
        Wed, 12 Jan 2022 04:50:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net 0/4] ipv4: Fix accidental RTO_ONLINK flags passed to
 ip_route_output_key_hash()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164196301084.21433.5520835462235159586.git-patchwork-notify@kernel.org>
Date:   Wed, 12 Jan 2022 04:50:10 +0000
References: <cover.1641821242.git.gnault@redhat.com>
In-Reply-To: <cover.1641821242.git.gnault@redhat.com>
To:     Guillaume Nault <gnault@redhat.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, wenxu@ucloud.cn,
        varun@chelsio.com, saeedm@nvidia.com, leon@kernel.org,
        vladbu@nvidia.com, ogerlitz@mellanox.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 10 Jan 2022 14:43:04 +0100 you wrote:
> The IPv4 stack generally uses the last bit of ->flowi4_tos as a flag
> indicating link scope for route lookups (RTO_ONLINK). Therefore, we
> have to be careful when copying a TOS value to ->flowi4_tos. In
> particular, the ->tos field of IPv4 packets may have this bit set
> because of ECN. Also tunnel keys generally accept any user value for
> the tos.
> 
> [...]

Here is the summary with links:
  - [v2,net,1/4] xfrm: Don't accidentally set RTO_ONLINK in decode_session4()
    https://git.kernel.org/netdev/net/c/23e7b1bfed61
  - [v2,net,2/4] gre: Don't accidentally set RTO_ONLINK in gre_fill_metadata_dst()
    https://git.kernel.org/netdev/net/c/f7716b318568
  - [v2,net,3/4] libcxgb: Don't accidentally set RTO_ONLINK in cxgb_find_route()
    https://git.kernel.org/netdev/net/c/a915deaa9abe
  - [v2,net,4/4] mlx5: Don't accidentally set RTO_ONLINK before mlx5e_route_lookup_ipv4_get()
    https://git.kernel.org/netdev/net/c/48d67543e01d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


