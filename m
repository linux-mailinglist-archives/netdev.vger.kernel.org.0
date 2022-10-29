Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9811861203E
	for <lists+netdev@lfdr.de>; Sat, 29 Oct 2022 06:50:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229822AbiJ2EuY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Oct 2022 00:50:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229752AbiJ2EuU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Oct 2022 00:50:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D13F5D700
        for <netdev@vger.kernel.org>; Fri, 28 Oct 2022 21:50:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 07ECF60ABF
        for <netdev@vger.kernel.org>; Sat, 29 Oct 2022 04:50:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5F574C43143;
        Sat, 29 Oct 2022 04:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667019018;
        bh=e5FzjFokCoTxDWwPaGaYbFwtVSmKJl6+WhsT5zxgjug=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=CvK7DKmn48trTRsnV1b5OVSOPDvYQBjUogokAiYpjEXU2dIblKtuQzqgjLVdqIbn2
         p7pmR5JKmRWU/wG7eRa0KJd0mxm/oSPghJkca5WpA2DdA5LxCPMYH1XxUqut9d1jEs
         KicQmu/UHdkEnKj6SZcV1Qb4tL7dKUCwdglkJ81jxqdQunrVB7nKdDprGZGlKF/Uzo
         8ZHR/B+di4eCgy/Yvze1LL9xibolyO8zISvPb7LCs7eLyl2JCn4SFECCw55En46Pbm
         aGlsnjTiC4YY2IzQmcUVxLJaibI54mX7sGZS4MM+rNSFTOBYTWx/1G80CsJT9yzUHJ
         /aMiPUWyLIO7A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 44F4DC41677;
        Sat, 29 Oct 2022 04:50:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] netlink: hide validation union fields from kdoc
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166701901827.13014.348770049050367704.git-patchwork-notify@kernel.org>
Date:   Sat, 29 Oct 2022 04:50:18 +0000
References: <20221027212107.2639255-1-kuba@kernel.org>
In-Reply-To: <20221027212107.2639255-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Thu, 27 Oct 2022 14:21:07 -0700 you wrote:
> Mark the validation fields as private, users shouldn't set
> them directly and they are too complicated to explain in
> a more succinct way (there's already a long explanation
> in the comment above).
> 
> The strict_start_type field is set directly and has a dedicated
> comment so move that above the "private" section.
> 
> [...]

Here is the summary with links:
  - [net] netlink: hide validation union fields from kdoc
    https://git.kernel.org/netdev/net/c/7354c9024f28

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


