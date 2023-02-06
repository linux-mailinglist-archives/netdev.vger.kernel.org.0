Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0625868B875
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 10:20:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229919AbjBFJUW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 04:20:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229794AbjBFJUV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 04:20:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6D1E271E;
        Mon,  6 Feb 2023 01:20:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 75CB160DC5;
        Mon,  6 Feb 2023 09:20:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C1D82C4339C;
        Mon,  6 Feb 2023 09:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675675218;
        bh=OegxfcEyf5Nf5kPUq8IOFVH7UZhs1aBFNRSa20On3FA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=OR0AxMinUgPKmE1wEbk+KNtAweK3JAnjUltnkS+DlSz4vCl7T5Jx9EMdI5m9e4vWS
         4xaDXUSBUNrg0AVq7h25InQ1sprLd43c0CN2Abmt4RTsMiXEPqwT/u+VFeRbx1XCNY
         xgf3655+77wuKzbmSB9UMqtW34leZt1UUZc4HfWDhkpdGjq6jnf3aIGg4B+vLwVqQ4
         hinAccnJt3zlrtwGkH5CnLaz+6WZQ7eU8/Pb0pT+cUiGrYDzK+fsQ4PD0RbBht6s0H
         u1USvuGSXv4xl+3TfR6PLyve4dCLyu8kro3IRir5Sl9OoZtHq6PH6onoV3DULxaRD7
         zTrFTLObnquUQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 98004E55F08;
        Mon,  6 Feb 2023 09:20:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] virtio-net: Maintain reverse cleanup order
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167567521861.4325.7567495408942675202.git-patchwork-notify@kernel.org>
Date:   Mon, 06 Feb 2023 09:20:18 +0000
References: <20230203133738.33527-1-parav@nvidia.com>
In-Reply-To: <20230203133738.33527-1-parav@nvidia.com>
To:     Parav Pandit <parav@nvidia.com>
Cc:     mst@redhat.com, jasowang@redhat.com, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, ast@kernel.org, daniel@iogearbox.net,
        hawk@kernel.org, john.fastabend@gmail.com,
        virtualization@lists.linux-foundation.org, bpf@vger.kernel.org,
        jiri@nvidia.com
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
by David S. Miller <davem@davemloft.net>:

On Fri, 3 Feb 2023 15:37:38 +0200 you wrote:
> To easily audit the code, better to keep the device stop()
> sequence to be mirror of the device open() sequence.
> 
> Acked-by: Michael S. Tsirkin <mst@redhat.com>
> Reviewed-by: Jiri Pirko <jiri@nvidia.com>
> Signed-off-by: Parav Pandit <parav@nvidia.com>
> 
> [...]

Here is the summary with links:
  - [net-next] virtio-net: Maintain reverse cleanup order
    https://git.kernel.org/netdev/net-next/c/27369c9c2b72

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


