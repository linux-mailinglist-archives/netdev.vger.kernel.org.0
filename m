Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 604A353A416
	for <lists+netdev@lfdr.de>; Wed,  1 Jun 2022 13:30:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352704AbiFALaQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jun 2022 07:30:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352625AbiFALaP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jun 2022 07:30:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FCDA6FA06
        for <netdev@vger.kernel.org>; Wed,  1 Jun 2022 04:30:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1B9B461405
        for <netdev@vger.kernel.org>; Wed,  1 Jun 2022 11:30:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 799F1C34119;
        Wed,  1 Jun 2022 11:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654083013;
        bh=hzGTLPv+hJ+E1IqbpUnO385YfaxQpg/ZtjlzEwiJxos=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=OxLZVx8mZdDtPu1VfJiUuak63sdbTER7F+e87BCtbqlJaZQLm4mL8hKHu/ycDZW88
         7TPxighzX0SfS8XAPTNq4X7TJEplA2Oq1yBnp9eyqHJ/Vl8SCvaMdnCVLssU2eFJ17
         V0rdrO3N4rwGdN8Wu9YQEaK5YCOY5Pj06Rqt1GaFPCKzT3Ut1lBaCmBp4tWwhQc6M3
         0xHaW7m59Op0LeGoAZuOszSbd9WinpyGmYz/XLFn3/2qXxYjBwKVvaG4jB9VDx9en7
         XLb5UUCzYJ8Of5qfzHi8sXL1PiYkoc0Tp/b/70YmgJqgRBgEnYPk5dlZB/MQnvWLGg
         lBfe6tzbo+PFg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 5F440F0394D;
        Wed,  1 Jun 2022 11:30:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net V3] net: ping6: Fix ping -6 with interface name
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165408301338.24154.17376561946057373479.git-patchwork-notify@kernel.org>
Date:   Wed, 01 Jun 2022 11:30:13 +0000
References: <20220531084544.15126-1-tariqt@nvidia.com>
In-Reply-To: <20220531084544.15126-1-tariqt@nvidia.com>
To:     Tariq Toukan <tariqt@nvidia.com>
Cc:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        dsahern@kernel.org, netdev@vger.kernel.org,
        yoshfuji@linux-ipv6.org, pabeni@redhat.com, ayal@nvidia.com,
        gal@nvidia.com, saeedm@nvidia.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Tue, 31 May 2022 11:45:44 +0300 you wrote:
> From: Aya Levin <ayal@nvidia.com>
> 
> When passing interface parameter to ping -6:
> $ ping -6 ::11:141:84:9 -I eth2
> Results in:
> PING ::11:141:84:10(::11:141:84:10) from ::11:141:84:9 eth2: 56 data bytes
> ping: sendmsg: Invalid argument
> ping: sendmsg: Invalid argument
> 
> [...]

Here is the summary with links:
  - [net,V3] net: ping6: Fix ping -6 with interface name
    https://git.kernel.org/netdev/net/c/e6652a8ef3e6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


