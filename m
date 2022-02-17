Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FFDF4B9E5B
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 12:11:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239530AbiBQLKt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 06:10:49 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239506AbiBQLKb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 06:10:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B76E0296906
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 03:10:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 377AAB82120
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 11:10:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B558BC340FC;
        Thu, 17 Feb 2022 11:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645096212;
        bh=3udDxl547socn5FOm5YZ/uSgClJyl7RyjDJByCnK3IY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=vDykQNmBqcrns9q0Y6fnBYoLcpI6pm7Xo8xUhurRbDrIFQEbJPkNPnRy3HPT63XCV
         Pyii/bl0viZZilA/Ff+xKRpD6v+jIdEAaCC7AFBRbMnuyqPjU0uEHx0/hgcC+jvGLp
         lnhnNih6Ys54v+cVefJWHHl+9jVWkLHkYEmvugE1zvEDpDyICZyOWjIAZzH0Ex7fkN
         DP9SE29c6xcMArCCdm8ntJwu/DKUoPq1hh+mlfpTh7OCyhsrT1rqC3WTVvtKOy1ekf
         y2aO+YLdYHf7jgnnw2LlFnspitdU/6RX7bT6T5jYxNr3rHCvxg5MZ21TIFi5IUC/mn
         DYzFqqbmTIAsg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 95F40E7BB07;
        Thu, 17 Feb 2022 11:10:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next 01/15] net/mlx5e: Fix spelling mistake "supoported" ->
 "supported"
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164509621260.23140.8278725694702204217.git-patchwork-notify@kernel.org>
Date:   Thu, 17 Feb 2022 11:10:12 +0000
References: <20220217075632.831542-2-saeed@kernel.org>
In-Reply-To: <20220217075632.831542-2-saeed@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        colin.i.king@gmail.com, roid@nvidia.com, saeedm@nvidia.com
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by Saeed Mahameed <saeedm@nvidia.com>:

On Wed, 16 Feb 2022 23:56:18 -0800 you wrote:
> From: Colin Ian King <colin.i.king@gmail.com>
> 
> There is a spelling mistake in a NL_SET_ERR_MSG_MOD error
> message.  Fix it.
> 
> Fixes: 3b49a7edec1d ("net/mlx5e: TC, Reject rules with multiple CT actions")
> Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
> Reviewed-by: Roi Dayan <roid@nvidia.com>
> Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
> 
> [...]

Here is the summary with links:
  - [net-next,01/15] net/mlx5e: Fix spelling mistake "supoported" -> "supported"
    https://git.kernel.org/netdev/net-next/c/9625bf39bd41
  - [net-next,02/15] net/mlx5e: Add support for using xdp->data_meta
    https://git.kernel.org/netdev/net-next/c/c1e80bf4ad3e
  - [net-next,03/15] net/mlx5e: Generalize packet merge error message
    https://git.kernel.org/netdev/net-next/c/b98d2d722f81
  - [net-next,04/15] net/mlx5e: Default to Striding RQ when not conflicting with CQE compression
    https://git.kernel.org/netdev/net-next/c/1d5024f88dad
  - [net-next,05/15] net/mlx5e: RX, Restrict bulk size for small Striding RQs
    https://git.kernel.org/netdev/net-next/c/4b5fba4a3ac7
  - [net-next,06/15] net/mlx5e: E-Switch, Add PTP counters for uplink representor
    https://git.kernel.org/netdev/net-next/c/7c5f940d264e
  - [net-next,07/15] net/mlx5e: E-Switch, Add support for tx_port_ts in switchdev mode
    https://git.kernel.org/netdev/net-next/c/bfbdd77ac52f
  - [net-next,08/15] net/mlx5e: TC, Move flow hashtable to be per rep
    https://git.kernel.org/netdev/net-next/c/d1a3138f7913
  - [net-next,09/15] net/mlx5e: Pass actions param to actions_match_supported()
    https://git.kernel.org/netdev/net-next/c/0610f8dc0309
  - [net-next,10/15] net/mlx5e: Add post act offload/unoffload API
    https://git.kernel.org/netdev/net-next/c/314e1105831b
  - [net-next,11/15] net/mlx5e: Create new flow attr for multi table actions
    https://git.kernel.org/netdev/net-next/c/8300f225268b
  - [net-next,12/15] net/mlx5e: Use multi table support for CT and sample actions
    https://git.kernel.org/netdev/net-next/c/a81283263bb0
  - [net-next,13/15] net/mlx5e: TC, Clean redundant counter flag from tc action parsers
    https://git.kernel.org/netdev/net-next/c/2a829fe25d28
  - [net-next,14/15] net/mlx5e: TC, Make post_act parse CT and sample actions
    https://git.kernel.org/netdev/net-next/c/7843bd604081
  - [net-next,15/15] net/mlx5e: TC, Allow sample action with CT
    https://git.kernel.org/netdev/net-next/c/b070e70381ee

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


