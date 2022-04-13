Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCE904FF65B
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 14:00:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233575AbiDMMCo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 08:02:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235451AbiDMMCf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 08:02:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9333D2C673;
        Wed, 13 Apr 2022 05:00:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2D55761E05;
        Wed, 13 Apr 2022 12:00:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 80DCFC385A6;
        Wed, 13 Apr 2022 12:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649851213;
        bh=//BKps608RkvWlYmcUvnGAXwPzgsV2ij/OG3q7Efm/8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ntXGinvBMDuv00540tIZPImiM9II5aZCGGXXdYNAvqDm8kSYOyCNjht2CsVOna7dR
         +1X1+07908SDP+2caeuF90YmJkFd+g39wBmAqX37iEAfYY/Nd9h3GFpGm8qEuJjrf9
         t+60bn9LO8Sj0nKWh5FxntSdMurY2+sv/I0Gpc/eM+Ji1J5ltyStFqxayNSjXSOgKw
         zTl1BREi52Fz501oHLrtWxHqOC8rbxPsqkNeWbZBpXbx33hRUrxjIHiOmabNHxSDwQ
         K8NypZIHOFoCRBHeFQvDk2Et0nCGIchYUzlQ6sbFUdZj0CGVWIfTDXIwzbQ/9Lw8CM
         w8scZ51vP6qoQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 5F631E7399B;
        Wed, 13 Apr 2022 12:00:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next PATCH v5 0/7] Add octeon_ep driver
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164985121338.29697.16905786191397026617.git-patchwork-notify@kernel.org>
Date:   Wed, 13 Apr 2022 12:00:13 +0000
References: <20220413033503.3962-1-vburru@marvell.com>
In-Reply-To: <20220413033503.3962-1-vburru@marvell.com>
To:     Veerasenareddy Burru <vburru@marvell.com>
Cc:     davem@davemloft.net, kuba@kernel.org, corbet@lwn.net,
        netdev@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
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

On Tue, 12 Apr 2022 20:34:56 -0700 you wrote:
> This driver implements networking functionality of Marvell's Octeon
> PCI Endpoint NIC.
> 
> This driver support following devices:
>  * Network controller: Cavium, Inc. Device b200
> 
> V4 -> V5:
>    - Fix warnings reported by clang.
>    - Address comments from community reviews.
> 
> [...]

Here is the summary with links:
  - [net-next,v5,1/7] octeon_ep: Add driver framework and device initialization
    https://git.kernel.org/netdev/net-next/c/862cd659a6fb
  - [net-next,v5,2/7] octeon_ep: add hardware configuration APIs
    https://git.kernel.org/netdev/net-next/c/1f2c2d0cee02
  - [net-next,v5,3/7] octeon_ep: Add mailbox for control commands
    https://git.kernel.org/netdev/net-next/c/4ca2fbdd0bb6
  - [net-next,v5,4/7] octeon_ep: add Tx/Rx ring resource setup and cleanup
    https://git.kernel.org/netdev/net-next/c/397dfb57dcc2
  - [net-next,v5,5/7] octeon_ep: add support for ndo ops
    https://git.kernel.org/netdev/net-next/c/6a610a46bad1
  - [net-next,v5,6/7] octeon_ep: add Tx/Rx processing and interrupt support
    https://git.kernel.org/netdev/net-next/c/37d79d059606
  - [net-next,v5,7/7] octeon_ep: add ethtool support for Octeon PCI Endpoint NIC
    https://git.kernel.org/netdev/net-next/c/5cc256e79bff

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


