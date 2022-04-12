Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F30A4FCBF1
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 03:40:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243978AbiDLBml (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 21:42:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241055AbiDLBma (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 21:42:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6581024957
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 18:40:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 09C186153F
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 01:40:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5BE36C385A3;
        Tue, 12 Apr 2022 01:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649727613;
        bh=Fq+q+BrDYl+eLstY/i2l6jtu+bSMRBxfizpa6UnePAw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=S37G6YRA9axL5sxDgB+AbYSs0Grvc3CrdiMXvfAU71AuaJBnD+1lR7LVtI4hCnlAn
         EnHgBXXkq538GCmktaB0w7gkI7STqcbCMh4HWtksvSVazcxSmgHx69ypM+CYgAvL/4
         vz621kSnmIaQnIUsQ9eMpSqs/A8S4ktpTBjfPGP3xeIhKGRZ8DQtZE5WLegCwwVIR2
         cteyv2zIjpj6FIcJVTVfde86bWqX8q+HVEL5pWIbOnZU056OHsIkQebIuJGsuM7BO4
         aOYoywGohIUqqRltC3DadqBLm7jlFFVowaYEWvAljuNl36oMkd93vpoKsWVXgxDF2c
         +vBv8E3P41tXA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 41F97E8DD5E;
        Tue, 12 Apr 2022 01:40:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/2][pull request] Intel Wired LAN Driver Updates
 2022-04-08
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164972761326.2554.11728335884151317580.git-patchwork-notify@kernel.org>
Date:   Tue, 12 Apr 2022 01:40:13 +0000
References: <20220408163411.2415552-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20220408163411.2415552-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org
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

This series was applied to netdev/net.git (master)
by Tony Nguyen <anthony.l.nguyen@intel.com>:

On Fri,  8 Apr 2022 09:34:09 -0700 you wrote:
> This series contains updates to ice and iavf drivers.
> 
> Alexander fixes a use after free issue with aRFS for ice driver.
> 
> Mateusz reverts a commit that introduced issues related to device
> resets for iavf driver.
> 
> [...]

Here is the summary with links:
  - [net,1/2] ice: arfs: fix use-after-free when freeing @rx_cpu_rmap
    https://git.kernel.org/netdev/net/c/d7442f512b71
  - [net,2/2] Revert "iavf: Fix deadlock occurrence during resetting VF interface"
    https://git.kernel.org/netdev/net/c/7d59706dbef8

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


