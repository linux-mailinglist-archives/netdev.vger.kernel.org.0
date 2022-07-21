Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AD2C57C1D6
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 03:10:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229766AbiGUBKU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 21:10:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229918AbiGUBKT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 21:10:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA86F25283
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 18:10:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E49F461E8E
        for <netdev@vger.kernel.org>; Thu, 21 Jul 2022 01:10:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4E5E7C341CA;
        Thu, 21 Jul 2022 01:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658365815;
        bh=iiAaHcFI1jJPvLicTF7Ncmsvw56NOOfe0dFnbJoc9Fw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=eAT8LaVN8x5SZFORF1XqIHaskNWc8YkIEJzKM98uKNiRcS/Q3N0CXZweogAgFfqSw
         S27JffFKns/CF9Ee299W5i/lA6IqiHISILV7ReJOfdQY2yT+WDL9zp62Uu8O4SzIeg
         Y0y7pXxzzGoNolTMwLbC5vMswoN/Nwp0n3kwJcYlaR3Y658KKk3uzK7cO40ywM3O6b
         RkL+dlVcfX042p74L34KWHfvuQ85bNh+XZ0knVhoALmNwbnbmgoMPw2MHibMDFe+AQ
         kcwd47rxCQ06tNnCZTVT1nk0wRNw1H8+QwHtFq2Xbp7y//3dIwL9RnjFHaabGP8NXN
         Drg8ZoLF1rtOg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 35348D9DDDD;
        Thu, 21 Jul 2022 01:10:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next V2 01/13] net/mlx5e: Report header-data split state through
 ethtool
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165836581521.10081.13992627967235940137.git-patchwork-notify@kernel.org>
Date:   Thu, 21 Jul 2022 01:10:15 +0000
References: <20220719203529.51151-2-saeed@kernel.org>
In-Reply-To: <20220719203529.51151-2-saeed@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, saeedm@nvidia.com, netdev@vger.kernel.org,
        tariqt@nvidia.com, gal@nvidia.com
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Saeed Mahameed <saeedm@nvidia.com>:

On Tue, 19 Jul 2022 13:35:17 -0700 you wrote:
> From: Gal Pressman <gal@nvidia.com>
> 
> HW-GRO (SHAMPO) packet merger scheme implies header-data split in the
> driver, report it through the ethtool interface.
> 
> Signed-off-by: Gal Pressman <gal@nvidia.com>
> Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
> Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
> 
> [...]

Here is the summary with links:
  - [net-next,V2,01/13] net/mlx5e: Report header-data split state through ethtool
    https://git.kernel.org/netdev/net-next/c/07071e47da44
  - [net-next,V2,02/13] net/mlx5e: Fix mqprio_rl handling on devlink reload
    https://git.kernel.org/netdev/net-next/c/0bb7228f7096
  - [net-next,V2,03/13] net/mlx5e: HTB, reduce visibility of htb functions
    https://git.kernel.org/netdev/net-next/c/efe317997ec9
  - [net-next,V2,04/13] net/mlx5e: HTB, move ids to selq_params struct
    https://git.kernel.org/netdev/net-next/c/4f8d1d3adc8d
  - [net-next,V2,05/13] net/mlx5e: HTB, move section comment to the right place
    https://git.kernel.org/netdev/net-next/c/66d95936488c
  - [net-next,V2,06/13] net/mlx5e: HTB, move stats and max_sqs to priv
    https://git.kernel.org/netdev/net-next/c/db83f24d89e6
  - [net-next,V2,07/13] net/mlx5e: HTB, hide and dynamically allocate mlx5e_htb structure
    https://git.kernel.org/netdev/net-next/c/aaffda6b3668
  - [net-next,V2,08/13] net/mlx5e: HTB, remove priv from htb function calls
    https://git.kernel.org/netdev/net-next/c/28df4a0117e2
  - [net-next,V2,09/13] net/mlx5e: HTB, change functions name to follow convention
    https://git.kernel.org/netdev/net-next/c/3685eed56f81
  - [net-next,V2,10/13] net/mlx5e: HTB, move htb functions to a new file
    https://git.kernel.org/netdev/net-next/c/462b00599936
  - [net-next,V2,11/13] net/mlx5: Expose ts_cqe_metadata_size2wqe_counter
    https://git.kernel.org/netdev/net-next/c/2e5e4185ff89
  - [net-next,V2,12/13] net/mlx5e: Add resiliency for PTP TX port timestamp
    https://git.kernel.org/netdev/net-next/c/58a518948f60
  - [net-next,V2,13/13] net/mlx5: CT: Remove warning of ignore_flow_level support for non PF
    https://git.kernel.org/netdev/net-next/c/22df2e93622f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


