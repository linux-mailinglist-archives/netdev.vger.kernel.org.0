Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CAA85130DF
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 12:08:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234519AbiD1KKz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 06:10:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233947AbiD1KKa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 06:10:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CAF3384
        for <netdev@vger.kernel.org>; Thu, 28 Apr 2022 03:00:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CFB6CB82C87
        for <netdev@vger.kernel.org>; Thu, 28 Apr 2022 10:00:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 87958C385AC;
        Thu, 28 Apr 2022 10:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651140011;
        bh=EZIKsZctWF6WRVe8UpjDYwyKKVe1UzcaU2vLkW2OR/k=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=muOppFgs2O9Nx8BdFQpKIWfe9jRKUQHGdKE1ISNu5bVpnzpZWjFyn4WvXZFAoG7Q/
         IWciLk1fcjWcwRfgjOvrgfqAPhlL5xTV2bSEAs0NODc/0k3IAVRWm/fhNF56xirfZU
         oe5TyV1a9jvKQRuXjdLaRuo2VH70BMQM0PgWiVwqBpv9DxvT67W2gUzFEhizKuzKLd
         2d/B6P7D6L7x0XA4Uj67h3joPFWYX90K/Nn+9BO3/GvpOJpfrak2M99ihPiumbKWQ8
         xulU9gkmjIfFNY1apCJ4Um5liO+NqfG1N4lEyr6iL5pZ5O7Kf7ZRFYf7gbctY7y2u9
         PqO0f8CaFYlfA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 68BEDE8DD67;
        Thu, 28 Apr 2022 10:00:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: make sure net_rx_action() calls
 skb_defer_free_flush()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165114001142.30186.11257518855439776785.git-patchwork-notify@kernel.org>
Date:   Thu, 28 Apr 2022 10:00:11 +0000
References: <20220427204147.1310161-1-eric.dumazet@gmail.com>
In-Reply-To: <20220427204147.1310161-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, edumazet@google.com, idosch@nvidia.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Wed, 27 Apr 2022 13:41:47 -0700 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> I missed a stray return; in net_rx_action(), which very well
> is taken whenever trigger_rx_softirq() has been called on
> a cpu that is no longer receiving network packets,
> or receiving too few of them.
> 
> [...]

Here is the summary with links:
  - [net-next] net: make sure net_rx_action() calls skb_defer_free_flush()
    https://git.kernel.org/netdev/net-next/c/f3412b3879b4

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


