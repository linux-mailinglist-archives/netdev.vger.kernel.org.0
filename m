Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D656747A0EF
	for <lists+netdev@lfdr.de>; Sun, 19 Dec 2021 15:30:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234849AbhLSOaO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Dec 2021 09:30:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230483AbhLSOaO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Dec 2021 09:30:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC8D0C061574;
        Sun, 19 Dec 2021 06:30:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6B01060EB1;
        Sun, 19 Dec 2021 14:30:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B3EB1C36AE7;
        Sun, 19 Dec 2021 14:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639924212;
        bh=Qny2sjQySbXk3dQjRlY8kV/10SyC62AaBUtkCv1exiU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=rvhGQP2wNzSqYZj61e17VQn0J14Tq2dhga/DF3aiR6CwakL87MbsZEnV114gkM4xX
         7anmzEBG/avsJLiC+gzG5wkKg02Bh39KpR7Cb2gZSlFOcSgJzmoyJvh4+/1vh+EVzl
         gTnceXFKYDdTZ9fgEmVZFzxT5/P+BG4C3XUH4c3K7teGtMLpKuwK8KdbGtH6uZNYt2
         NgczK9cJ8p3uj0lS+SbptixcDNq87u+TqSEBDjnDxM+lnz6lS9bV+EOATZYi70nMaf
         kyC3tE9v1I1OgxlueKmMdElemxi4ryeqR2lrLx4sahRJGn+oLOZzIpUo29sdbOZ4sH
         fQ6nmNeQVVFZg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 9818060A9C;
        Sun, 19 Dec 2021 14:30:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v8 net-next 00/13] allow user to offload tc action to net
 device
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163992421261.25478.13959206033604654129.git-patchwork-notify@kernel.org>
Date:   Sun, 19 Dec 2021 14:30:12 +0000
References: <20211217181629.28081-1-simon.horman@corigine.com>
In-Reply-To: <20211217181629.28081-1-simon.horman@corigine.com>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     davem@davemloft.net, kuba@kernel.org,
        alexandre.belloni@bootlin.com, andrew@lunn.ch,
        claudiu.manoil@nxp.com, xiyou.wangcong@gmail.com,
        f.fainelli@gmail.com, idosch@nvidia.com, jhs@mojatatu.com,
        jiri@resnulli.us, leon@kernel.org, michael.chan@broadcom.com,
        ozsh@nvidia.com, petrm@nvidia.com, roid@nvidia.com,
        saeedm@nvidia.com, vivien.didelot@gmail.com, vladbu@nvidia.com,
        vladimir.oltean@nxp.com, baowen.zheng@corigine.com,
        louis.peens@corigine.com, UNGLinuxDriver@microchip.com,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, oss-drivers@corigine.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 17 Dec 2021 19:16:16 +0100 you wrote:
> Baowen Zheng says:
> 
> Allow use of flow_indr_dev_register/flow_indr_dev_setup_offload to offload
> tc actions independent of flows.
> 
> The motivation for this work is to prepare for using TC police action
> instances to provide hardware offload of OVS metering feature - which calls
> for policers that may be used by multiple flows and whose lifecycle is
> independent of any flows that use them.
> 
> [...]

Here is the summary with links:
  - [v8,net-next,01/13] flow_offload: fill flags to action structure
    https://git.kernel.org/netdev/net-next/c/40bd094d65fc
  - [v8,net-next,02/13] flow_offload: reject to offload tc actions in offload drivers
    https://git.kernel.org/netdev/net-next/c/144d4c9e800d
  - [v8,net-next,03/13] flow_offload: add index to flow_action_entry structure
    https://git.kernel.org/netdev/net-next/c/5a9959008fb6
  - [v8,net-next,04/13] flow_offload: rename offload functions with offload instead of flow
    https://git.kernel.org/netdev/net-next/c/9c1c0e124ca2
  - [v8,net-next,05/13] flow_offload: add ops to tc_action_ops for flow action setup
    https://git.kernel.org/netdev/net-next/c/c54e1d920f04
  - [v8,net-next,06/13] flow_offload: allow user to offload tc action to net device
    https://git.kernel.org/netdev/net-next/c/8cbfe939abe9
  - [v8,net-next,07/13] flow_offload: add skip_hw and skip_sw to control if offload the action
    https://git.kernel.org/netdev/net-next/c/7adc57651211
  - [v8,net-next,08/13] flow_offload: rename exts stats update functions with hw
    https://git.kernel.org/netdev/net-next/c/bcd64368584b
  - [v8,net-next,09/13] flow_offload: add process to update action stats from hardware
    https://git.kernel.org/netdev/net-next/c/c7a66f8d8a94
  - [v8,net-next,10/13] net: sched: save full flags for tc action
    https://git.kernel.org/netdev/net-next/c/e8cb5bcf6ed6
  - [v8,net-next,11/13] flow_offload: add reoffload process to update hw_count
    https://git.kernel.org/netdev/net-next/c/13926d19a11e
  - [v8,net-next,12/13] flow_offload: validate flags of filter and actions
    https://git.kernel.org/netdev/net-next/c/c86e0209dc77
  - [v8,net-next,13/13] selftests: tc-testing: add action offload selftest for action and filter
    https://git.kernel.org/netdev/net-next/c/eb473bac4a4b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


