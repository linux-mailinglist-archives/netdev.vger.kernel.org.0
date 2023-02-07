Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7476D68DC5B
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 16:00:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232333AbjBGPA2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 10:00:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232382AbjBGPAW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 10:00:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9968A1352F
        for <netdev@vger.kernel.org>; Tue,  7 Feb 2023 07:00:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 077B4B819B3
        for <netdev@vger.kernel.org>; Tue,  7 Feb 2023 15:00:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9E611C4339C;
        Tue,  7 Feb 2023 15:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675782018;
        bh=J/ooOZ1kf8+bPdm4I7hFk+gVQwSOrfTL9wu4uJgymCw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=tH5gyWyYE1MTKZ56CSo+ueKkmF86CWlpjonfmF17oMQDKL60Q+kpY8PYyXilpLlpl
         CWZLtaeXAkZzBx7Vmv5qDEOr3vZE+PqRuyTb0jCigBrlVs87eU7i7SVghPjWFkSYF1
         g0yv3dmYAqI6mP5z08eO9pwaXr4hX0Jtyb46q2YMp/ZzJnB3Ljq9MriBN1vD1hABah
         Es/YrcQPnv6a7hoTNj95jlSV7QEXFFfJwoRXDJ6EgICuFXebAdDZ7f5veROkYNyYgS
         yL4Rr6cLHloBPimxpYdBTIMI5CH1O3t1mi+w0ryuKFTRbxHoykNHfRQToVrLWw72/N
         Y6c9otF70AfZg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 803F4E55F06;
        Tue,  7 Feb 2023 15:00:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] ethtool: mm: fix get_mm() return code not
 propagating to user space
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167578201852.23595.20965494230083707.git-patchwork-notify@kernel.org>
Date:   Tue, 07 Feb 2023 15:00:18 +0000
References: <20230206094932.446379-1-vladimir.oltean@nxp.com>
In-Reply-To: <20230206094932.446379-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, mkubecek@suse.cz
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Mon,  6 Feb 2023 11:49:32 +0200 you wrote:
> If ops->get_mm() returns a non-zero error code, we goto out_complete,
> but there, we return 0. Fix that to propagate the "ret" variable to the
> caller. If ops->get_mm() succeeds, it will always return 0.
> 
> Fixes: 2b30f8291a30 ("net: ethtool: add support for MAC Merge layer")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> [...]

Here is the summary with links:
  - [net-next] ethtool: mm: fix get_mm() return code not propagating to user space
    https://git.kernel.org/netdev/net-next/c/ca8e4cbff6d5

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


