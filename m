Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9BA854E9B5
	for <lists+netdev@lfdr.de>; Thu, 16 Jun 2022 21:00:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230288AbiFPTAQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jun 2022 15:00:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229672AbiFPTAQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jun 2022 15:00:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38AFD22B0C
        for <netdev@vger.kernel.org>; Thu, 16 Jun 2022 12:00:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AD24C61D03
        for <netdev@vger.kernel.org>; Thu, 16 Jun 2022 19:00:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0C1E5C341C0;
        Thu, 16 Jun 2022 19:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655406014;
        bh=C9E7LjDRD0a0IySj14VmXw6eeNFIO9TJVVPKqpDEE24=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=S/huzHhz7iq6o+IvcrzB04yTDuBLcF81OxoRVyYnTAoYIOu5ImD1yr6UQ/KJ/XWoQ
         HqvJVQFKM6t9DZQTzxogU1fzZk8jwypPqLmbcSAydUbqmMq18jWkzrvHFv78AXAt7a
         voXPXYTT+hOX1OuZRqJm5a/u/fnmagLVEeNahLnmFqqtP7tkh61Bz7wFsHjPF3OOaB
         kuUXMAtzrMYQSusQq/1X9GHREzlBfsE/RTY07Tnt8UcZDUffFdUoTXqiRzl4rW2iQ6
         he792hbZ5kx3bbz7KzRMvX/kFwMF64iVmAzs86L64RVg8FRm2DOiuQuL4K70yGiVyn
         s6F9dFGhyNVaQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id DF99CFD99FF;
        Thu, 16 Jun 2022 19:00:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH iproute2] man: tc-fw: Document masked handle usage
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165540601391.13716.8851514585739351065.git-patchwork-notify@kernel.org>
Date:   Thu, 16 Jun 2022 19:00:13 +0000
References: <20220614142657.2112576-1-idosch@nvidia.com>
In-Reply-To: <20220614142657.2112576-1-idosch@nvidia.com>
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     netdev@vger.kernel.org, stephen@networkplumber.org,
        dsahern@gmail.com, taspelund@nvidia.com, mlxsw@nvidia.com
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

This patch was applied to iproute2/iproute2-next.git (main)
by David Ahern <dsahern@kernel.org>:

On Tue, 14 Jun 2022 17:26:57 +0300 you wrote:
> The tc-fw filter can be used to match on the packet's fwmark by adding a
> filter with a matching handle. It also supports matching on specific
> bits of the fwmark by specifying the handle together with a mask. This
> is documented in the usage message below, but not in the man page.
> 
> Document it in the man page together with an example.
> 
> [...]

Here is the summary with links:
  - [iproute2] man: tc-fw: Document masked handle usage
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=bfffaf136091

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


