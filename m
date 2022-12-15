Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E6CE64DCFD
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 15:40:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229785AbiLOOkU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Dec 2022 09:40:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229658AbiLOOkS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Dec 2022 09:40:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D53D2E6BB;
        Thu, 15 Dec 2022 06:40:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CCEE060A0B;
        Thu, 15 Dec 2022 14:40:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 272EDC433F0;
        Thu, 15 Dec 2022 14:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671115216;
        bh=1y4XJbZR7xGuVEK0oM2ozMxNE2Gyyox9Hv4icG+6KUI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=eQXH6aDbGLq4N0KdFWRksfHgH967CfowbHwwSFcUId8JYgZYp2iiqnXOd54L1Bivr
         PG50MDXbuVYC2SjwxAezMuxUlO1YcJuhP3KmQaaV0mghkUkiXt6OjClcziD6fL64z0
         qgmxtHNoWPCvjZu2yz1xsxz4T62IgZ9chGcjXq0cb0HT79Y0CdeGT/OVIifB9iFUEp
         3nGmEpkzzQdFpqO9918E9PQWWmsjTdLavH+ZVCS6H+ll0vgXQyV3Ud3Cpij29iFyMu
         qcj09mqeqIn3/PeDAEljP8FkMUfrFUrsXdwcCxy2BU6Whff69F16tUkAbII5pm9yQj
         htRISVMEeaHQQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0CBD5C197B4;
        Thu, 15 Dec 2022 14:40:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] ravb: Fix "failed to switch device to config mode"
 message during unbind
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167111521604.32410.3850134562584373463.git-patchwork-notify@kernel.org>
Date:   Thu, 15 Dec 2022 14:40:16 +0000
References: <20221214105118.2495313-1-biju.das.jz@bp.renesas.com>
In-Reply-To: <20221214105118.2495313-1-biju.das.jz@bp.renesas.com>
To:     Biju Das <biju.das.jz@bp.renesas.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, p.zabel@pengutronix.de, s.shtylyov@omp.ru,
        geert+renesas@glider.be, liuhangbin@gmail.com,
        mitsuhiro.kimura.kc@renesas.com, netdev@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, fabrizio.castro.jz@renesas.com,
        stable@vger.kernel.org, leonro@nvidia.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Wed, 14 Dec 2022 10:51:18 +0000 you wrote:
> This patch fixes the error "ravb 11c20000.ethernet eth0: failed to switch
> device to config mode" during unbind.
> 
> We are doing register access after pm_runtime_put_sync().
> 
> We usually do cleanup in reverse order of init. Currently in
> remove(), the "pm_runtime_put_sync" is not in reverse order.
> 
> [...]

Here is the summary with links:
  - [net,v2] ravb: Fix "failed to switch device to config mode" message during unbind
    https://git.kernel.org/netdev/net/c/c72a7e42592b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


