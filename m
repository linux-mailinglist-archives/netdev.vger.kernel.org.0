Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C28C7620E90
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 12:20:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234074AbiKHLUZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 06:20:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234077AbiKHLUS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 06:20:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5615A48761
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 03:20:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DC4A66150F
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 11:20:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 45A1BC433D7;
        Tue,  8 Nov 2022 11:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667906415;
        bh=Zpmmf/k2fBkw9GPjuMZ/sEyxoZjhsNgDC1Vazwso2+k=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=qdUqu/nbeKt7T+6dbI7cbjCaMEu+iyHSl0wQAQak/qQGF0kFT0EqtOdIIWHQ9E69n
         EKYFyIBhlGhOJO6yR0vzut05j+o/3isoCxYdVjy1XrIIYWecqPVTWp9Az40MdUNbOR
         4YHP69IoJAd9pvtpKrfDcHXW3tCiytCnoIxboBno974Ky/BE7L+d2wxc2kq78Bn37s
         aetNvIA8bHWZHyFmrz0flC/wwRow8ef/e/T9CZGpTYNDnU99uX6kK8n00eEJ8v5333
         EuTwyFBCxT51v4DF6r+gNAn0ZIEAkeEx95SsOZQUtbIcd8rLmq7BGhUoTq1i5p/6UN
         Nn5CpiUDiT3Lg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2D3E2E270D0;
        Tue,  8 Nov 2022 11:20:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] ethtool: Fail number of channels change when it
 conflicts with rxnfc
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166790641518.22212.6408101489854653988.git-patchwork-notify@kernel.org>
Date:   Tue, 08 Nov 2022 11:20:15 +0000
References: <20221106123127.522985-1-gal@nvidia.com>
In-Reply-To: <20221106123127.522985-1-gal@nvidia.com>
To:     Gal Pressman <gal@nvidia.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        jacob.e.keller@intel.com, tariqt@nvidia.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Sun, 6 Nov 2022 14:31:27 +0200 you wrote:
> Similar to what we do with the hash indirection table [1], when network
> flow classification rules are forwarding traffic to channels greater
> than the requested number of channels, fail the operation.
> Without this, traffic could be directed to channels which no longer
> exist (dropped) after changing number of channels.
> 
> [1] commit d4ab4286276f ("ethtool: correctly ensure {GS}CHANNELS doesn't conflict with GS{RXFH}")
> 
> [...]

Here is the summary with links:
  - [net-next,v2] ethtool: Fail number of channels change when it conflicts with rxnfc
    https://git.kernel.org/netdev/net-next/c/47f3ecf4763d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


