Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B21FB6C008F
	for <lists+netdev@lfdr.de>; Sun, 19 Mar 2023 11:50:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229883AbjCSKu0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Mar 2023 06:50:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229713AbjCSKuZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Mar 2023 06:50:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5931E13D78
        for <netdev@vger.kernel.org>; Sun, 19 Mar 2023 03:50:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5EA12B80B1B
        for <netdev@vger.kernel.org>; Sun, 19 Mar 2023 10:50:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E6311C433EF;
        Sun, 19 Mar 2023 10:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679223019;
        bh=NdW/RMN2GdHkVSoAueu7s2ftqKlue2il/E2071Dwp3E=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=rwgLt442xsrnR/AzX08Z5gRiGPp2qjANukKc4HCnUxhRBKWmX79UqlwoeREwAZocQ
         2GqwMRFLZl9fq+lHgFk3OBMD+VeZ/81qXzshF7cGC3oB4BXMeRXLPMxNzPc1fLciS+
         rpQ9RhPf/KgKtshmwJRAIUookOSbDHtmNu343wn+ifppOX17yzwGswPa2SZjUBcn2c
         4xDk4VIe/wEyQzQvLufiSFPDVTRTNCnjD70tyGrg2SjoseWda7OvEeiXxufUTABuFA
         gcU+a40edZzlbuZh0VgpZTxQTOT9wdNu84W0vPsyAzjplMHlq708tQq9q9gNPpjCrl
         575l5pgHarffg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CEA2CE2A03D;
        Sun, 19 Mar 2023 10:50:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/5][pull request] Intel Wired LAN Driver Updates
 2023-03-16 (igb, igbvf, igc)
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167922301884.22899.6761423474918953666.git-patchwork-notify@kernel.org>
Date:   Sun, 19 Mar 2023 10:50:18 +0000
References: <20230316173144.2003469-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20230316173144.2003469-1-anthony.l.nguyen@intel.com>
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

This series was applied to netdev/net.git (main)
by Tony Nguyen <anthony.l.nguyen@intel.com>:

On Thu, 16 Mar 2023 10:31:39 -0700 you wrote:
> This series contains updates to igb, igbvf, and igc drivers.
> 
> Lin Ma removes rtnl_lock() when disabling SRIOV on remove which was
> causing deadlock on igb.
> 
> Akihiko Odaki delays enabling of SRIOV on igb to prevent early messages
> that could get ignored and clears MAC address when PF returns nack on
> reset; indicating no MAC address was assigned for igbvf.
> 
> [...]

Here is the summary with links:
  - [net,1/5] igb: revert rtnl_lock() that causes deadlock
    https://git.kernel.org/netdev/net/c/65f69851e44d
  - [net,2/5] igb: Enable SR-IOV after reinit
    https://git.kernel.org/netdev/net/c/50f303496d92
  - [net,3/5] intel/igbvf: free irq on the error path in igbvf_request_msix()
    https://git.kernel.org/netdev/net/c/85eb39bb39cb
  - [net,4/5] igbvf: Regard vf reset nack as success
    https://git.kernel.org/netdev/net/c/02c83791ef96
  - [net,5/5] igc: fix the validation logic for taprio's gate list
    https://git.kernel.org/netdev/net/c/2b4cc3d3f4d8

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


