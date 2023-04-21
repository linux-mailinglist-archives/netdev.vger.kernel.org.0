Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CDBC6EA1DA
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 04:50:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233429AbjDUCuX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 22:50:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233422AbjDUCuV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 22:50:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA7C02D5A
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 19:50:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 584A264D10
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 02:50:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B2323C4339B;
        Fri, 21 Apr 2023 02:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682045419;
        bh=sIkVl4NMn9qLyqNE1UpPbR/GQHlbp6Rv/KTJN+goDWA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=eLFWzQlT+s1Q0SN4CZBZDgt/t4MUyWOPdT6mAwCc4yau7gldpiLJ8uNHmSbQrvA0G
         9++HQ6/iDXd1hdhuRfj9gk+nup71FZc1hUY5XaO9XJAKYTrm7arJ/5CEMzk0d3n9JY
         V4LzohuKtEZFyQ1f4PtU3nzGfaFaT6/3p73hZhmmaVino7hvt5/R/EEp9JeTD/Jp0e
         3jJk43xpb2Qm5ArGieEoskCS4F5g8sidmkOanAXW+keQrOHDIccn23vc9DjA35Oxq+
         +kzJaqyIY+QMl3+YMii0ml4bkVrCKTJBOzSjQwmOLvp6GNbjK36HRUL4J/0joIIsjH
         pjiadmSIWhkxg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8EFCBC395C8;
        Fri, 21 Apr 2023 02:50:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: skbuff: update and rename __kfree_skb_defer()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168204541957.19656.7376141255783199267.git-patchwork-notify@kernel.org>
Date:   Fri, 21 Apr 2023 02:50:19 +0000
References: <20230420020005.815854-1-kuba@kernel.org>
In-Reply-To: <20230420020005.815854-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com
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

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 19 Apr 2023 19:00:05 -0700 you wrote:
> __kfree_skb_defer() uses the old naming where "defer" meant
> slab bulk free/alloc APIs. In the meantime we also made
> __kfree_skb_defer() feed the per-NAPI skb cache, which
> implies bulk APIs. So take away the 'defer' and add 'napi'.
> 
> While at it add a drop reason. This only matters on the
> tx_action path, if the skb has a frag_list. But getting
> rid of a SKB_DROP_REASON_NOT_SPECIFIED seems like a net
> benefit so why not.
> 
> [...]

Here is the summary with links:
  - [net-next] net: skbuff: update and rename __kfree_skb_defer()
    https://git.kernel.org/netdev/net-next/c/8fa66e4a1bdd

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


