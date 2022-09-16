Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80F145BAC33
	for <lists+netdev@lfdr.de>; Fri, 16 Sep 2022 13:20:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230439AbiIPLUV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Sep 2022 07:20:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230505AbiIPLUT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Sep 2022 07:20:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3552D52FF9
        for <netdev@vger.kernel.org>; Fri, 16 Sep 2022 04:20:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CDD4AB82660
        for <netdev@vger.kernel.org>; Fri, 16 Sep 2022 11:20:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 81BD7C433D7;
        Fri, 16 Sep 2022 11:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663327215;
        bh=DAVKEhTgvzmXobN5Z3K8IuHJR7AmDkhhd25blASn3Z4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ffSdQPJkubTygUcwDUNvTvl7SPyU8Y0cswWxYzRHaCW/AzGXeJFWflU+bTuRT5lQi
         F2bU6pzm73abdkGwOkgGjx3iqm3TVeRZtV39XnodkVKTAkkd+0QCb9vdDuxhDmr1CD
         b8T39e9UF8X2lGL03E+qz1lqyOZ2WjhInrpHg8agSb7Lek/mblIKK1HmbXPMF9Aywq
         qO4JbS06vjK2MXDjihw/5a2kebjpGnuj0a1lwIfSSLv+q8+Ea/UGzIskiEGvebwapj
         zZKnr53oZAoNE6VP9MdPlJZYGRFcuiVH1OsiVU12EjX7xz0y8Lf+MW6HW/rRV595tR
         unUp3cU8B4f8g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 57441C59A58;
        Fri, 16 Sep 2022 11:20:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/4][pull request] Intel Wired LAN Driver Updates
 2022-09-08 (ice, iavf)
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166332721534.14472.14270656867114096863.git-patchwork-notify@kernel.org>
Date:   Fri, 16 Sep 2022 11:20:15 +0000
References: <20220908203701.2089562-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20220908203701.2089562-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Thu,  8 Sep 2022 13:36:57 -0700 you wrote:
> This series contains updates to ice and iavf drivers.
> 
> Dave removes extra unplug of auxiliary bus on reset which caused a
> scheduling while atomic to be reported for ice.
> 
> Ding Hui defers setting of queues for TCs to ensure valid configuration
> and restores old config if invalid for ice.
> 
> [...]

Here is the summary with links:
  - [net,1/4] ice: Don't double unplug aux on peer initiated reset
    https://git.kernel.org/netdev/net/c/23c619190318
  - [net,2/4] ice: Fix crash by keep old cfg when update TCs more than queues
    https://git.kernel.org/netdev/net/c/a509702cac95
  - [net,3/4] iavf: Fix change VF's mac address
    https://git.kernel.org/netdev/net/c/f66b98c868f2
  - [net,4/4] iavf: Fix cached head and tail value for iavf_get_tx_pending
    https://git.kernel.org/netdev/net/c/809f23c0423a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


