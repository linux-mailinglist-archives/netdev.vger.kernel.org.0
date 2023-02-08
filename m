Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 809BB68EC1B
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 10:50:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230224AbjBHJu2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 04:50:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231220AbjBHJuX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 04:50:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A9CC10A95;
        Wed,  8 Feb 2023 01:50:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 03868615EA;
        Wed,  8 Feb 2023 09:50:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5CEF6C4339B;
        Wed,  8 Feb 2023 09:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675849819;
        bh=cLiPbOJ8zntt3fSqPa689jgruBIOeqFLTn5rcFwFJJA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=m+5QnJSzY7JbT+QW/JcxM0+Lkfwu9rZOkcKacMD02O5xiOKp+7sk56E4ur+Xyl/hd
         ureYbVa+mQYqpcrgu2hYiaQP0C13hETs9JkE6TbwSj89XQrtM/3svD2IVjiZPXSpv3
         ITT+0rT2Y7NStsbpueGxRzx3IfajFiEgeLOq4t70kIMM0+nTAkfcxO4daX7+0tqR5S
         430/cpfUlPBJKmi/YNMFS7CjiV+mdUCd5kCeSNKrLnToCdwXGQqerbjKW/IaPJEcb7
         VHrQwEA+r+ktr5VjFD1MS0ikzi3nUz47eIluGKfwKiBP7/R7p7D+PHQ4MTCQAhIW/X
         bZL3ILqueUaQA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3EF27E4D032;
        Wed,  8 Feb 2023 09:50:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next 00/15] taprio automatic queueMaxSDU and new TXQ
 selection procedure
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167584981925.2615.15266963787745673788.git-patchwork-notify@kernel.org>
Date:   Wed, 08 Feb 2023 09:50:19 +0000
References: <20230207135440.1482856-1-vladimir.oltean@nxp.com>
In-Reply-To: <20230207135440.1482856-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us,
        vinicius.gomes@intel.com, kurt@linutronix.de,
        jacob.e.keller@intel.com, gerhard@engleder-embedded.com,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        intel-wired-lan@lists.osuosl.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue,  7 Feb 2023 15:54:25 +0200 you wrote:
> This patch set addresses 2 design limitations in the taprio software scheduler:
> 
> 1. Software scheduling fundamentally prioritizes traffic incorrectly,
>    in a way which was inspired from Intel igb/igc drivers and does not
>    follow the inputs user space gives (traffic classes and TC to TXQ
>    mapping). Patch 05/15 handles this, 01/15 - 04/15 are preparations
>    for this work.
> 
> [...]

Here is the summary with links:
  - [v2,net-next,01/15] net/sched: taprio: delete peek() implementation
    https://git.kernel.org/netdev/net-next/c/ecc0cc98632a
  - [v2,net-next,02/15] net/sched: taprio: continue with other TXQs if one dequeue() failed
    https://git.kernel.org/netdev/net-next/c/1638bbbe4ece
  - [v2,net-next,03/15] net/sched: taprio: refactor one skb dequeue from TXQ to separate function
    https://git.kernel.org/netdev/net-next/c/92f966674f6a
  - [v2,net-next,04/15] net/sched: taprio: avoid calling child->ops->dequeue(child) twice
    https://git.kernel.org/netdev/net-next/c/4c22942734f0
  - [v2,net-next,05/15] net/sched: taprio: give higher priority to higher TCs in software dequeue mode
    https://git.kernel.org/netdev/net-next/c/2f530df76c8c
  - [v2,net-next,06/15] net/sched: taprio: calculate tc gate durations
    https://git.kernel.org/netdev/net-next/c/a306a90c8ffe
  - [v2,net-next,07/15] net/sched: taprio: rename close_time to end_time
    https://git.kernel.org/netdev/net-next/c/e5517551112f
  - [v2,net-next,08/15] net/sched: taprio: calculate budgets per traffic class
    https://git.kernel.org/netdev/net-next/c/d2ad689dec10
  - [v2,net-next,09/15] net/sched: taprio: calculate guard band against actual TC gate close time
    https://git.kernel.org/netdev/net-next/c/a1e6ad30fa19
  - [v2,net-next,10/15] net/sched: make stab available before ops->init() call
    https://git.kernel.org/netdev/net-next/c/1f62879e3632
  - [v2,net-next,11/15] net/sched: taprio: warn about missing size table
    https://git.kernel.org/netdev/net-next/c/a3d91b2c6f6b
  - [v2,net-next,12/15] net/sched: keep the max_frm_len information inside struct sched_gate_list
    https://git.kernel.org/netdev/net-next/c/a878fd46fe43
  - [v2,net-next,13/15] net/sched: taprio: automatically calculate queueMaxSDU based on TC gate durations
    https://git.kernel.org/netdev/net-next/c/fed87cc6718a
  - [v2,net-next,14/15] net/sched: taprio: split segmentation logic from qdisc_enqueue()
    https://git.kernel.org/netdev/net-next/c/2d5e8071c47a
  - [v2,net-next,15/15] net/sched: taprio: don't segment unnecessarily
    https://git.kernel.org/netdev/net-next/c/39b02d6d104a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


