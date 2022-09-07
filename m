Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DB855B050C
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 15:20:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229640AbiIGNUg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 09:20:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229700AbiIGNUe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 09:20:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44E792DA86
        for <netdev@vger.kernel.org>; Wed,  7 Sep 2022 06:20:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C0C29618CE
        for <netdev@vger.kernel.org>; Wed,  7 Sep 2022 13:20:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 204D9C433D7;
        Wed,  7 Sep 2022 13:20:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662556820;
        bh=mcYq2rY/n2rmdm+E29PQw+kqfs7JNEyhlLwhxtKUcls=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=OhLnqZXWkcRGJjWc2UT2O9jqFS/jHOlZBrebimU3Dgfy/o9WH05i2fnygFheLHTrv
         SlIvubxVakLYxvt/wZ4kfawf07twI9VpH9bvGI+4o33JNRrrrWkNtSzFw8FIOf0l4H
         haCQ9KVRLaOR2m0J/MP4c+XxXnLc19Wikl+y6pOuvPT7KkBeZ9J3JU1UmFxmGIjNXo
         5q1AZu95Z9vNkftH4bouzNgn7OvRZFuZwAfhoEBsTETsU/wne+3go+GbkiMfPM2uEL
         nrw0Eif5TsFcqzHBjloV4L+2DF6L4GBzeyRaStC7yya4EjiTXWA0J3jFzbskYcng85
         ynoAvHRiNJsUQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id EADA7C73FE7;
        Wed,  7 Sep 2022 13:20:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next V2 00/17] Introduce MACsec skb_metadata_dst and mlx5
 macsec offload
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166255681995.1987.3842975899867486366.git-patchwork-notify@kernel.org>
Date:   Wed, 07 Sep 2022 13:20:19 +0000
References: <20220906052129.104507-1-saeed@kernel.org>
In-Reply-To: <20220906052129.104507-1-saeed@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, saeedm@nvidia.com, netdev@vger.kernel.org,
        tariqt@nvidia.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon,  5 Sep 2022 22:21:12 -0700 you wrote:
> From: Saeed Mahameed <saeedm@nvidia.com>
> 
> v1->v2:
>    - attach mlx5 implementation patches.
> 
> This patchset introduces MACsec skb_metadata_dst to lay the ground
> for MACsec HW offload.
> 
> [...]

Here is the summary with links:
  - [net-next,V2,01/17] net/macsec: Add MACsec skb_metadata_dst Tx Data path support
    https://git.kernel.org/netdev/net-next/c/0a28bfd4971f
  - [net-next,V2,02/17] net/macsec: Add MACsec skb_metadata_dst Rx Data path support
    https://git.kernel.org/netdev/net-next/c/860ead89b851
  - [net-next,V2,03/17] net/macsec: Move some code for sharing with various drivers that implements offload
    https://git.kernel.org/netdev/net-next/c/b1671253c601
  - [net-next,V2,04/17] net/mlx5: Removed esp_id from struct mlx5_flow_act
    https://git.kernel.org/netdev/net-next/c/d1b2234b7fbf
  - [net-next,V2,05/17] net/mlx5: Generalize Flow Context for new crypto fields
    https://git.kernel.org/netdev/net-next/c/e227ee990bf9
  - [net-next,V2,06/17] net/mlx5: Introduce MACsec Connect-X offload hardware bits and structures
    https://git.kernel.org/netdev/net-next/c/8385c51ff5bc
  - [net-next,V2,07/17] net/mlx5: Add MACsec offload Tx command support
    https://git.kernel.org/netdev/net-next/c/8ff0ac5be144
  - [net-next,V2,08/17] net/mlx5: Add MACsec Tx tables support to fs_core
    https://git.kernel.org/netdev/net-next/c/ee534d7f81ba
  - [net-next,V2,09/17] net/mlx5e: Add MACsec TX steering rules
    https://git.kernel.org/netdev/net-next/c/e467b283ffd5
  - [net-next,V2,10/17] net/mlx5e: Implement MACsec Tx data path using MACsec skb_metadata_dst
    https://git.kernel.org/netdev/net-next/c/9515978eee0b
  - [net-next,V2,11/17] net/mlx5e: Add MACsec offload Rx command support
    https://git.kernel.org/netdev/net-next/c/aae3454e4d4c
  - [net-next,V2,12/17] net/mlx5: Add MACsec Rx tables support to fs_core
    https://git.kernel.org/netdev/net-next/c/15d187e285b3
  - [net-next,V2,13/17] net/mlx5e: Add MACsec RX steering rules
    https://git.kernel.org/netdev/net-next/c/3b20949cb21b
  - [net-next,V2,14/17] net/mlx5e: Implement MACsec Rx data path using MACsec skb_metadata_dst
    https://git.kernel.org/netdev/net-next/c/b7c9400cbc48
  - [net-next,V2,15/17] net/mlx5e: Add MACsec offload SecY support
    https://git.kernel.org/netdev/net-next/c/5a39816a75e5
  - [net-next,V2,16/17] net/mlx5e: Add MACsec stats support for Rx/Tx flows
    https://git.kernel.org/netdev/net-next/c/807a1b765b4f
  - [net-next,V2,17/17] net/mlx5e: Add support to configure more than one macsec offload device
    https://git.kernel.org/netdev/net-next/c/99d4dc66c823

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


