Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37E6668F742
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 19:40:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230092AbjBHSkZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 13:40:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231517AbjBHSkT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 13:40:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5393C195;
        Wed,  8 Feb 2023 10:40:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E032D617A6;
        Wed,  8 Feb 2023 18:40:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 43784C4339B;
        Wed,  8 Feb 2023 18:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675881617;
        bh=vL7I0MQLJ2PfY3MCgdpW7AWufrijJC8mjRMBcMTGNXU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=HU0qhczcP8vTJTsZ38EFURAotqIiRWiCyW7g7ymooUV822R4zk5wMlYl/vE4hlYtu
         HfLwqEPlA+qY7sf/Z8XUFOXNGs69TTTrRexkcN3LvapEFNF1mcOcsKSme+ThtRyxSe
         5tY1vPAOcEaGtPpeRlOGby5fGDh8TdzRggWG4a1BkUG7S5AlsXlD5YsnyhRskHPF4n
         dlnYtus6lqYBdk2Q/hjBpAdhM4Y795xk9MJFdhZCQgQZ1VBYtA9oqgTsdqkkQRaK0r
         3i4wecNTzg3qzN1l1hPRFt9/NnZjuwQYfgjh/pv5qqWDC5SRGA6HeNlGqmT12F+Yax
         Eb9IAcU436zUQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 24F82E55F07;
        Wed,  8 Feb 2023 18:40:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next] sfc: move xdp_features configuration in
 efx_pci_probe_post_io()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167588161714.31809.126831373422389159.git-patchwork-notify@kernel.org>
Date:   Wed, 08 Feb 2023 18:40:17 +0000
References: <9bd31c9a29bcf406ab90a249a28fc328e5578fd1.1675875404.git.lorenzo@kernel.org>
In-Reply-To: <9bd31c9a29bcf406ab90a249a28fc328e5578fd1.1675875404.git.lorenzo@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, edumazet@google.com,
        lorenzo.bianconi@redhat.com, ecree.xilinx@gmail.com,
        habetsm.xilinx@gmail.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (master)
by Martin KaFai Lau <martin.lau@kernel.org>:

On Wed,  8 Feb 2023 17:58:40 +0100 you wrote:
> Move xdp_features configuration from efx_pci_probe() to
> efx_pci_probe_post_io() since it is where all the other basic netdev
> features are initialised.
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>  drivers/net/ethernet/sfc/efx.c       | 8 ++++----
>  drivers/net/ethernet/sfc/siena/efx.c | 8 ++++----
>  2 files changed, 8 insertions(+), 8 deletions(-)

Here is the summary with links:
  - [bpf-next] sfc: move xdp_features configuration in efx_pci_probe_post_io()
    https://git.kernel.org/bpf/bpf-next/c/9b0651e429a0

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


