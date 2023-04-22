Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3ED846EB74A
	for <lists+netdev@lfdr.de>; Sat, 22 Apr 2023 06:10:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229616AbjDVEK3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Apr 2023 00:10:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbjDVEK2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Apr 2023 00:10:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BDA71FD8
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 21:10:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BBADD60BA1
        for <netdev@vger.kernel.org>; Sat, 22 Apr 2023 04:10:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1B3A8C433D2;
        Sat, 22 Apr 2023 04:10:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682136626;
        bh=cZzEqant4alzSXM14bgRrvayZ6czhuF3OCgroj+lbU8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=WnCnSGsOz9BDN1ltHRQRyNbMxzeZ6M71I49Lk3UsGTH3LVryWJIjn1HZ4Cewlgyup
         f3YBeFcS5dSINZG582E2C7x8oTejamhmRu4boq7t+Jvjl3Dmtl96/u+6WBeA7BFdiV
         UHDAuzTSVroVL5BOYetyiimQe+M6ziwSIfadWpO0R3kW3EhGrsdHtlriC/7PBstBk0
         rxSWAZ2wynemwYWhOwpWN/HCmx1qrMdYLVqEwib228RTR2V7qVwuFzgGgNaQ9hIkVe
         YyozixfulCCHFv33js10xBtbdOOsPYaa+OmKuhaK3j/0uUHKl0O21LOF94aNCZq9mU
         pXP33bItNzyRA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id F2ABDE270DB;
        Sat, 22 Apr 2023 04:10:25 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next 01/15] net/mlx5: DR,
 Fix dumping of legacy modify_hdr in debug dump
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168213662598.14731.606611570337031161.git-patchwork-notify@kernel.org>
Date:   Sat, 22 Apr 2023 04:10:25 +0000
References: <20230421013850.349646-2-saeed@kernel.org>
In-Reply-To: <20230421013850.349646-2-saeed@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, saeedm@nvidia.com, netdev@vger.kernel.org,
        tariqt@nvidia.com, kliteyn@nvidia.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (main)
by Saeed Mahameed <saeedm@nvidia.com>:

On Thu, 20 Apr 2023 18:38:36 -0700 you wrote:
> From: Yevgeny Kliteynik <kliteyn@nvidia.com>
> 
> The steering dump parser expects to see 0 as rewrite num of actions
> in case pattern/args aren't supported - parsing of legacy modify header
> is based on this assumption.
> Fix this to align to parser's expectation.
> 
> [...]

Here is the summary with links:
  - [net-next,01/15] net/mlx5: DR, Fix dumping of legacy modify_hdr in debug dump
    https://git.kernel.org/netdev/net-next/c/075056005d8c
  - [net-next,02/15] net/mlx5: DR, Calculate sync threshold of each pool according to its type
    https://git.kernel.org/netdev/net-next/c/72b2cff68405
  - [net-next,03/15] net/mlx5: DR, Add more info in domain dbg dump
    https://git.kernel.org/netdev/net-next/c/cedb6665bc33
  - [net-next,04/15] net/mlx5: DR, Add memory statistics for domain object
    https://git.kernel.org/netdev/net-next/c/57295e069cd8
  - [net-next,05/15] Revert "net/mlx5: Expose steering dropped packets counter"
    https://git.kernel.org/netdev/net-next/c/e267b8a52ca5
  - [net-next,06/15] Revert "net/mlx5: Expose vnic diagnostic counters for eswitch managed vports"
    https://git.kernel.org/netdev/net-next/c/0a431418f685
  - [net-next,07/15] net/mlx5: Add vnic devlink health reporter to PFs/VFs
    https://git.kernel.org/netdev/net-next/c/b0bc615df488
  - [net-next,08/15] net/mlx5e: Add vnic devlink health reporter to representors
    https://git.kernel.org/netdev/net-next/c/cf14af140a5a
  - [net-next,09/15] net/mlx5e: RX, Fix releasing page_pool pages twice for striding RQ
    https://git.kernel.org/netdev/net-next/c/c8e9090233a7
  - [net-next,10/15] net/mlx5e: RX, Fix XDP_TX page release for legacy rq nonlinear case
    https://git.kernel.org/netdev/net-next/c/40afb3b14496
  - [net-next,11/15] net/mlx5e: RX, Hook NAPIs to page pools
    https://git.kernel.org/netdev/net-next/c/a880f814739c
  - [net-next,12/15] net/mlx5: Include linux/pci.h for pci_msix_can_alloc_dyn()
    https://git.kernel.org/netdev/net-next/c/45e261b7b821
  - [net-next,13/15] net/mlx5: E-Switch, Remove redundant dev arg from mlx5_esw_vport_alloc()
    https://git.kernel.org/netdev/net-next/c/8ca52ada6267
  - [net-next,14/15] net/mlx5: E-Switch, Remove unused mlx5_esw_offloads_vport_metadata_set()
    https://git.kernel.org/netdev/net-next/c/38d9a740f68d
  - [net-next,15/15] net/mlx5: Update op_mode to op_mod for port selection
    https://git.kernel.org/netdev/net-next/c/f9c895a72a39

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


