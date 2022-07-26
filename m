Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 321D25814B6
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 16:00:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239142AbiGZOAU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 10:00:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238868AbiGZOAR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 10:00:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FBB3D48
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 07:00:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3CF54B81615
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 14:00:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E02D4C433B5;
        Tue, 26 Jul 2022 14:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658844012;
        bh=JTC417El+CUs57vvMncV+ly5z5naqXGH++ZVORHJmK0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=VLmpkhCpQri1xVRvF5yjpaUkOBVrcbLBcPWymxj5H4TKPGnxHufJBsNFtmz+vCwv5
         AYqU/T2tPyPo+O7Y5SKGPYrGww5Wy7gFFnNHgwNwsB0Wg8KgJsXT1fVByZFm0n7Tj2
         1Lxa62EX3CBZvvhR0GUNAXTMTK0jMMLD8ErX3j7IFOTGYbU+PnawHUGN+3MgCP5qnN
         Wk8NI/7/Gh0eNBZsTIsGy8mMEDgKnqO0nsisxwNnN4DuXQaH9Qz20BxAmzEyf1/4pa
         gCcsK7rdI53JZ2+eLoaD8O+bQ7STDvfRrXDBmL/Fsb41e/VUDIt7rl/mrA6LkD51oS
         dA/7H7oyOMT5A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id BCB50C43143;
        Tue, 26 Jul 2022 14:00:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] bridge: Do not send empty IFLA_AF_SPEC attribute
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165884401276.3194.15777870435593251642.git-patchwork-notify@kernel.org>
Date:   Tue, 26 Jul 2022 14:00:12 +0000
References: <20220725001236.95062-1-bpoirier@nvidia.com>
In-Reply-To: <20220725001236.95062-1-bpoirier@nvidia.com>
To:     Benjamin Poirier <bpoirier@nvidia.com>
Cc:     netdev@vger.kernel.org, roopa@nvidia.com, razor@blackwall.org,
        horatiu.vultur@microchip.com, henrik.bjoernlund@microchip.com,
        bridge@lists.linux-foundation.org, idosch@nvidia.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Mon, 25 Jul 2022 09:12:36 +0900 you wrote:
> After commit b6c02ef54913 ("bridge: Netlink interface fix."),
> br_fill_ifinfo() started to send an empty IFLA_AF_SPEC attribute when a
> bridge vlan dump is requested but an interface does not have any vlans
> configured.
> 
> iproute2 ignores such an empty attribute since commit b262a9becbcb
> ("bridge: Fix output with empty vlan lists") but older iproute2 versions as
> well as other utilities have their output changed by the cited kernel
> commit, resulting in failed test cases. Regardless, emitting an empty
> attribute is pointless and inefficient.
> 
> [...]

Here is the summary with links:
  - [net] bridge: Do not send empty IFLA_AF_SPEC attribute
    https://git.kernel.org/netdev/net/c/9b134b1694ec

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


