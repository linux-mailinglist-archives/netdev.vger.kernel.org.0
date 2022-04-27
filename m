Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62413511570
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 13:33:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231921AbiD0LAq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 07:00:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231796AbiD0LAM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 07:00:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECD4C3C848E
        for <netdev@vger.kernel.org>; Wed, 27 Apr 2022 03:37:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 68E4961CF3
        for <netdev@vger.kernel.org>; Wed, 27 Apr 2022 10:00:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B9027C385A7;
        Wed, 27 Apr 2022 10:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651053611;
        bh=+ssqOugrkGKsWzzAq1dtMotoiVMenCeGSVFir1/BoP0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=qmxhSe1OQf0BBqk0SF4y8scB2bTqSnGSH38g0c6U04jREKuQOYvGR6UylBCa8/IbQ
         ACOY7kl3KXCSyTMQMsw7Sz3Fwof/FFx+W9IZbKawKa4fsqGl/w60RDuLgObqYBiTZK
         za8hqD8d+xq+8P47gr7FEhjUULD8PB4cLvbXgpwp1yQ4MkOMMFzEZ6zdqjPWzEU3GQ
         g/ZdfLzmL/yfjIJeIVj7/VFf3nkRMsc6NIEAk1OGYLPgYXeBpfge0D8Mi2wpLiPgAs
         AXj7OnGzVAjZ4djxT7MOyL7PstLq7ZECH5GGZd1t4+8pJiIHfYEiV5ZTTXK128aow1
         Lo4DgAxE8etMA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9DECCF0383D;
        Wed, 27 Apr 2022 10:00:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/4][pull request] Intel Wired LAN Driver Updates
 2022-04-26
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165105361163.21913.10691958952592365332.git-patchwork-notify@kernel.org>
Date:   Wed, 27 Apr 2022 10:00:11 +0000
References: <20220426203018.3790378-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20220426203018.3790378-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Tony Nguyen <anthony.l.nguyen@intel.com>:

On Tue, 26 Apr 2022 13:30:14 -0700 you wrote:
> This series contains updates to ice driver only.
> 
> Ivan Vecera removes races related to VF message processing by changing
> mutex_trylock() call to mutex_lock() and moving additional operations
> to occur under mutex.
> 
> Petr Oros increases wait time after firmware flash as current time is
> not sufficient.
> 
> [...]

Here is the summary with links:
  - [net,1/4] ice: Fix incorrect locking in ice_vc_process_vf_msg()
    https://git.kernel.org/netdev/net/c/aaf461af729b
  - [net,2/4] ice: Protect vf_state check by cfg_lock in ice_vc_process_vf_msg()
    https://git.kernel.org/netdev/net/c/77d64d285be5
  - [net,3/4] ice: wait 5 s for EMP reset after firmware flash
    https://git.kernel.org/netdev/net/c/b537752e6cbf
  - [net,4/4] ice: fix use-after-free when deinitializing mailbox snapshot
    https://git.kernel.org/netdev/net/c/b668f4cd715a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


