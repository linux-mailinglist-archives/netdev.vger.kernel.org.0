Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B98D964CDB7
	for <lists+netdev@lfdr.de>; Wed, 14 Dec 2022 17:10:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238763AbiLNQKV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Dec 2022 11:10:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237942AbiLNQKS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Dec 2022 11:10:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7AE21145
        for <netdev@vger.kernel.org>; Wed, 14 Dec 2022 08:10:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8528F61B2A
        for <netdev@vger.kernel.org>; Wed, 14 Dec 2022 16:10:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E0D0EC433F0;
        Wed, 14 Dec 2022 16:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671034216;
        bh=sqdbZj3oQFkqgFhZQj7JKGO8wK4AAfvsWWjibHzUdH4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=gslN/8CGGsNk836BY5eJNz6fnlivEKG4SbTK0mgW+LlSOhCLEUdEiDIj+eCOiVbxz
         bEMlcpdpWHDD/MvOU0eSr6jkmDRHxUj1hPbc1MekcqdskiBm/KoS9+fm1woDZh6wvd
         FtrkwGzTro/SslvIfgmAOcBMVmbr+tO+0KlwCOaT+BF/25kd11VWb3qz60knc0nIjV
         0YjHEPkvKkIryNZGy+PhHBLVgmy8NpV+i8bWljzkyUzYk1U2851WaMPWiiDZ97JxEx
         B6DIpsTvjtTJnthxZkMZ60FJEuRIkODk9KqqIGjdxzj3uDbKfuhzwoBYwC/97K4wht
         0xP0j3A4W4egg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C924EE29F4E;
        Wed, 14 Dec 2022 16:10:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH iproute2-next 0/4] Implement new netlink attribute for
 devlink-port function in iproute2
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167103421681.12353.14774552981701429798.git-patchwork-notify@kernel.org>
Date:   Wed, 14 Dec 2022 16:10:16 +0000
References: <20221211115849.510284-1-shayd@nvidia.com>
In-Reply-To: <20221211115849.510284-1-shayd@nvidia.com>
To:     Shay Drory <shayd@nvidia.com>
Cc:     netdev@vger.kernel.org, stephen@networkplumber.org,
        dsahern@gmail.com, jiri@nvidia.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to iproute2/iproute2-next.git (main)
by David Ahern <dsahern@kernel.org>:

On Sun, 11 Dec 2022 13:58:45 +0200 you wrote:
> Patch implementing new netlink attribute for devlink-port function got
> merged to net-next.
> https://lore.kernel.org/netdev/20221206185119.380138-1-shayd@nvidia.com/
> 
> Now there is a need to support these new attribute in the userspace
> tool. Implement roce and migratable port function attributes in devlink
> userspace tool. Update documentation.
> 
> [...]

Here is the summary with links:
  - [iproute2-next,1/4] devlink: Add uapi changes for roce and migratable port function attrs
    (no matching commit)
  - [iproute2-next,2/4] devlink: Support setting port function roce cap
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=bb2eea918be7
  - [iproute2-next,3/4] devlink: Support setting port function migratable cap
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=32168d8a8894
  - [iproute2-next,4/4] devlink: Add documentation for roce and migratable port function attributes
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=fe036c3666a5

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


