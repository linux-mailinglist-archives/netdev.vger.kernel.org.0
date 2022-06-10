Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42C54545B98
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 07:20:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345679AbiFJFUR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 01:20:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344794AbiFJFUQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 01:20:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B520F3B02E
        for <netdev@vger.kernel.org>; Thu,  9 Jun 2022 22:20:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 37A0861E21
        for <netdev@vger.kernel.org>; Fri, 10 Jun 2022 05:20:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 82436C3411B;
        Fri, 10 Jun 2022 05:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654838414;
        bh=KxwWVK2e1SFoKzyThOLG3c8oR1poVvzW2TJYyN2quNY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=q+2JlbMPUPo5hjiaYYuOXlZ+/Uxhm5sHgtkPdwx30zl4bD9R3IJY+wtLN2BlpWjKR
         f32cIPKeEqHMYbzzP1iuNVLfcJ8HK5JaNGUvoGJ4Zg9qU2IB9HFDm8+HmHosBSaD3s
         yfnKHknTU3Ww5Y0esKZPTDLllLYZQPdKbjBA0mw3+z075MRXrF1gfIldOLVLEC4d+q
         JzE0fC7YPmB6lUHSwzxli1zC3e68aRDe07pgdyt/AVpA9ziFfIs+PvG99LDfGmbkUE
         zvq+/cZG0LvDH6qSaw5GT+qKNmgpIo1bqRI3Sx7ZS0aTBKxqbxiXAcfSNXHwmXjnI9
         hJhoKPj9x+y8Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 639FEE737FE;
        Fri, 10 Jun 2022 05:20:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/2] nfp: fixes for v5.19
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165483841439.4442.2421968117974193794.git-patchwork-notify@kernel.org>
Date:   Fri, 10 Jun 2022 05:20:14 +0000
References: <20220608092901.124780-1-simon.horman@corigine.com>
In-Reply-To: <20220608092901.124780-1-simon.horman@corigine.com>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, oss-drivers@corigine.com,
        fei.qin@corigine.com, etienne.vanderlinde@corigine.com
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed,  8 Jun 2022 11:28:59 +0200 you wrote:
> Hi,
> 
> this short series includes two fixes for the NFP driver.
> 
> 1. Restructure GRE+VLAN flower offload to address a miss match
>    between the NIC firmware and driver implementation which
>    prevented these features from working in combination.
> 
> [...]

Here is the summary with links:
  - [net,1/2] nfp: avoid unnecessary check warnings in nfp_app_get_vf_config
    https://git.kernel.org/netdev/net/c/03d5005ff735
  - [net,2/2] nfp: flower: restructure flow-key for gre+vlan combination
    https://git.kernel.org/netdev/net/c/a0b843340dae

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


