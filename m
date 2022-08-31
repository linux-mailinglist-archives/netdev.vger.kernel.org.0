Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D941A5A7E91
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 15:20:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230309AbiHaNUV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 09:20:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229794AbiHaNUS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 09:20:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 992634C613;
        Wed, 31 Aug 2022 06:20:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2C02B61AAC;
        Wed, 31 Aug 2022 13:20:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 80440C433D6;
        Wed, 31 Aug 2022 13:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661952016;
        bh=kfskSvGs0EaG0N6+EOLLY3xTESBBvnf66NZHzdfg9Cw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=DmMJV86gkP0DyhvQ3h85XHKfuuEKPIrq6sQDqe7K+arVHKWOEnKwZ6yUMhKVbQwUJ
         9uhBf8GswS03puTQhvs5liFWSkefvL+dOLH89yzNBVkDuufipzxM9zwiRbBvo0kVsm
         NCY/vV1WucRzUBvtkXGDuTaTg9HQvmJfOxrmEeQmdupG8e10Hwysr9UDYAZI2FHGMm
         4FWKVCLSHnzpkut0pohMsR0KzQvYaqCJerjfl4PKbLWW4eEY5SewmSAe6ZVfC3OZEl
         G3mgOLoFE+4plKkW+o2L+HjNGKug8AgGqnu7SfCwCL2QgLuzSXybiGLpyoj4zXudpP
         aJrVkGis8sODQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6555BE924D9;
        Wed, 31 Aug 2022 13:20:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 0/5] thunderbolt: net: Enable full end-to-end flow control
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166195201641.2919.1480626545715329070.git-patchwork-notify@kernel.org>
Date:   Wed, 31 Aug 2022 13:20:16 +0000
References: <20220830153250.15496-1-mika.westerberg@linux.intel.com>
In-Reply-To: <20220830153250.15496-1-mika.westerberg@linux.intel.com>
To:     Mika Westerberg <mika.westerberg@linux.intel.com>
Cc:     linux-usb@vger.kernel.org, michael.jamet@intel.com,
        YehezkelShB@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, andreas.noever@gmail.com,
        lukas@wunner.de, netdev@vger.kernel.org
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

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue, 30 Aug 2022 18:32:45 +0300 you wrote:
> Hi all,
> 
> Thunderbolt/USB4 host controllers support full end-to-end flow control
> that prevents dropping packets if there are not enough hardware receive
> buffers. So far it has not been enabled for the networking driver yet
> but this series changes that. There is one snag though: the second
> generation (Intel Falcon Ridge) had a bug that needs special quirk to
> get it working. We had that in the early stages of the Thunderbolt/USB4
> driver but it got dropped because it was not needed at the time. Now we
> add it back as a quirk for the host controller (NHI).
> 
> [...]

Here is the summary with links:
  - [1/5] net: thunderbolt: Enable DMA paths only after rings are enabled
    https://git.kernel.org/netdev/net-next/c/ff7cd07f3064
  - [2/5] thunderbolt: Show link type for XDomain connections too
    https://git.kernel.org/netdev/net-next/c/f9cad07b840e
  - [3/5] thunderbolt: Add back Intel Falcon Ridge end-to-end flow control workaround
    https://git.kernel.org/netdev/net-next/c/54669e2f17cb
  - [4/5] net: thunderbolt: Enable full end-to-end flow control
    https://git.kernel.org/netdev/net-next/c/8bdc25cf62c7
  - [5/5] net: thunderbolt: Update module description with mention of USB4
    https://git.kernel.org/netdev/net-next/c/e550ed4b87ad

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


