Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15DA55993D8
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 06:07:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345859AbiHSEBE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 00:01:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236204AbiHSEA6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 00:00:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7AA9C2F8F
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 21:00:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4F53461538
        for <netdev@vger.kernel.org>; Fri, 19 Aug 2022 04:00:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 99E78C433D7;
        Fri, 19 Aug 2022 04:00:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660881656;
        bh=wlr3A5rkJfabFW0BzSLITvXFMSUZ8/F6t2v/maKzRYw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=fmtLMHpIYTjlvqJXp/DbNe1FUe/bxLgYQrAYvb7hSQFaTVuqWQK8P8So/BY3gqBwO
         hiCZORY5W4QFGjIYZl4R5P8H13AE3fNQbPapNW/dUJeELnpzF6WZehKVPHAL/Kf2x6
         hWYf/eK9KraLTGuu8lHsvPCuuh+jXOoUKPDRm4B3ahN5kzKbnca+WtQLxZdDcYFZzw
         ya8wV5nPfJA5JRn8YeCMRx0rjuGCu9JIEysmx92BEaKzfSM5YMAxeiDO6JVO+8dlc+
         4XqdspS+Bl39o9lL+8NjH1kfv89lZiTR+w4ZxOMdJ+ROACCjZOiXQw5WMJDvbMC7I2
         O0mYxSDuWJdmg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 796A4E2A052;
        Fri, 19 Aug 2022 04:00:56 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/4] selftests: mlxsw: Add ordering tests for unified
 bridge model
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166088165648.14408.6467742450991542889.git-patchwork-notify@kernel.org>
Date:   Fri, 19 Aug 2022 04:00:56 +0000
References: <cover.1660747162.git.petrm@nvidia.com>
In-Reply-To: <cover.1660747162.git.petrm@nvidia.com>
To:     Petr Machata <petrm@nvidia.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org, idosch@nvidia.com,
        amcohen@nvidia.com, shuah@kernel.org, mlxsw@nvidia.com
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
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 17 Aug 2022 17:28:24 +0200 you wrote:
> Amit Cohen writes:
> 
> Commit 798661c73672 ("Merge branch 'mlxsw-unified-bridge-conversion-part-6'")
> converted mlxsw driver to use unified bridge model. In the legacy model,
> when a RIF was created / destroyed, it was firmware's responsibility to
> update it in the relevant FID classification records. In the unified bridge
> model, this responsibility moved to software.
> 
> [...]

Here is the summary with links:
  - [net-next,1/4] selftests: mlxsw: Add ingress RIF configuration test for 802.1D bridge
    https://git.kernel.org/netdev/net-next/c/2cd87cea7842
  - [net-next,2/4] selftests: mlxsw: Add ingress RIF configuration test for 802.1Q bridge
    https://git.kernel.org/netdev/net-next/c/3a5ddc886847
  - [net-next,3/4] selftests: mlxsw: Add ingress RIF configuration test for VXLAN
    https://git.kernel.org/netdev/net-next/c/cbeb6e1195d1
  - [net-next,4/4] selftests: mlxsw: Add egress VID classification test
    https://git.kernel.org/netdev/net-next/c/1623d5719fdf

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


