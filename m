Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 159EA57B3DD
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 11:31:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238414AbiGTJa1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 05:30:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235940AbiGTJaY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 05:30:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F0CE205EA
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 02:30:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D779961B39
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 09:30:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3A002C341CE;
        Wed, 20 Jul 2022 09:30:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658309421;
        bh=Q8PK08i+2OXnvqKtfKUKxA5aa036pbBDm+ufAiU3CCM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=TeDfoMjMBc03ADRsdIjnEIlYjQNryPeAdsHu7SE6z/P3jq3Rspm0LBt3HkGK2DqZA
         P1jft/9FXrzN43qWFynRoqUP2vUSeMlvg/Cerz9robZjaWQegEAAvY5oCRIRkGO6CE
         VY8XggdVEQiq9H7XfcZ0iWpkRTp1ZDRczJmSSWt7IRaRew92AaPylfi7E9p+4bYmJK
         TKBoAGJQGuSItQ1FMwDJ433MV3spgV1apgLZDEMyB2XHBcj/M5mqKailpCITCSzgN5
         DVpx9kvHsPlIye1+drphCYdp3mnIiUklAPN3MQyga/b29qR0+RK9kC6VlxnI9ngcL9
         J54ZrGPZ48A3A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 212DCE451BE;
        Wed, 20 Jul 2022 09:30:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3] vmxnet3: Implement ethtool's get_channels command
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165830942113.20880.1962436234630950420.git-patchwork-notify@kernel.org>
Date:   Wed, 20 Jul 2022 09:30:21 +0000
References: <20220719042955.4607-1-andrey.turkin@gmail.com>
In-Reply-To: <20220719042955.4607-1-andrey.turkin@gmail.com>
To:     Andrey Turkin <andrey.turkin@gmail.com>
Cc:     netdev@vger.kernel.org, doshir@vmware.com, pv-drivers@vmware.com
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Tue, 19 Jul 2022 04:29:55 +0000 you wrote:
> Some tools (e.g. libxdp) use that information.
> 
> Signed-off-by: Andrey Turkin <andrey.turkin@gmail.com>
> ---
> 
> Notes:
>     v2:
>      - Replaced #ifdef with IS_ENABLED
>      - Fixed a compilation warning
>     v3:
>      - Removed explicit 0 assignments of unused fields.
> 
> [...]

Here is the summary with links:
  - [v3] vmxnet3: Implement ethtool's get_channels command
    https://git.kernel.org/netdev/net-next/c/ffcdd1197da6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


