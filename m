Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2989B63349B
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 06:01:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230139AbiKVFAb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 00:00:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbiKVFAZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 00:00:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABA512B18E
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 21:00:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5291DB81980
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 05:00:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0DD3EC4347C;
        Tue, 22 Nov 2022 05:00:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669093222;
        bh=tGyGt1a1pAF9MwFEZL3fX/BEv048uVtUzaf/5qcAKAg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Q1NxcgQXgxIJev7hkFvjaBk+T/IoD5jODDL8xUt5d4DiT1u6IJIgM4vxe/CvW8aH5
         nqJMTmz5q7aMdg4AnYTr8DhnnAKyB6bPihIgHqeMMbZb3n7RZsPsfTDULtB/wOlphx
         jlBJ7MGw5SX0MANbLTMTCX2TxpNbEqgIWPwTyulcUW0U2BB6jHLPkcLfpRTiRc7mVb
         zbgdynbT5sAlovBqjbG5AQyK890Ac5FVPy1iKc3qR0J5i5ONMw4DK3m7F/wOEqBL3S
         eTPpPeV5R8/TinB0f3ooQHTJdCDShuJhOw8eiQiZFTD2eVP0ptmzpDjRZNe+ByXIIU
         Lox1hrQnYS6DA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id DF6FDE29F41;
        Tue, 22 Nov 2022 05:00:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/1] ice: fix handling of burst Tx timestamps
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166909322190.4259.8135563868996111154.git-patchwork-notify@kernel.org>
Date:   Tue, 22 Nov 2022 05:00:21 +0000
References: <20221118222729.1565317-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20221118222729.1565317-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, jacob.e.keller@intel.com,
        netdev@vger.kernel.org, richardcochran@gmail.com,
        siddaraju.dh@intel.com, gurucharanx.g@intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 18 Nov 2022 14:27:29 -0800 you wrote:
> From: Jacob Keller <jacob.e.keller@intel.com>
> 
> Commit 1229b33973c7 ("ice: Add low latency Tx timestamp read") refactored
> PTP timestamping logic to use a threaded IRQ instead of a separate kthread.
> 
> This implementation introduced ice_misc_intr_thread_fn and redefined the
> ice_ptp_process_ts function interface to return a value of whether or not
> the timestamp processing was complete.
> 
> [...]

Here is the summary with links:
  - [net,1/1] ice: fix handling of burst Tx timestamps
    https://git.kernel.org/netdev/net/c/30f158740984

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


