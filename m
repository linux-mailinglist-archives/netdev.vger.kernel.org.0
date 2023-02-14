Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15A3B6957BB
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 05:10:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231517AbjBNEK3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 23:10:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231204AbjBNEKW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 23:10:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88E5517CEE;
        Mon, 13 Feb 2023 20:10:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 32F85B81B2A;
        Tue, 14 Feb 2023 04:10:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D611DC433AA;
        Tue, 14 Feb 2023 04:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676347818;
        bh=VinC5e70MSejP0NPx3FPvl1BxXRD+hMW9yvUgkbEVp0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=HgqVrwKOO+nLJP+ellkzGw5iL5jNfeeF5mjzd/AlPgWZbyjVKUcvrKY6v9YDpgmQz
         7w3fJSGlNe6de7tgUz49BIwKPJiX9QXBVX+4Z3jmVY7ziqQ0hddnB0Sti2tJBDN5wW
         thpsL00+h9XNJ55gJZbj2h/PCi6UsLABDHE7GVh61SQ01CHjpqIZi3Npw/PPAUMI6V
         ZBbBVFrBk+X2dwbOYzcsmxNKzsRJ+1jWwkXZ7Q72ibMMfZaTNVLnmL7nDNy+7sA+Wz
         zQvt4jo9Qw2ILDh3TDurDlO09GQhMFlz2I9oIMAEuO/o6iDjw/6CQFAKyyJb+SLCoc
         brNFJRaan03GA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B2959E49FA8;
        Tue, 14 Feb 2023 04:10:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] hv_netvsc: add missing NETDEV_XDP_ACT_NDO_XMIT
 xdp-features flag
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167634781871.18399.10317859838984239710.git-patchwork-notify@kernel.org>
Date:   Tue, 14 Feb 2023 04:10:18 +0000
References: <8e3747018f0fd0b5d6e6b9aefe8d9448ca3a3288.1676195726.git.lorenzo@kernel.org>
In-Reply-To: <8e3747018f0fd0b5d6e6b9aefe8d9448ca3a3288.1676195726.git.lorenzo@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, kys@microsoft.com,
        haiyangz@microsoft.com, wei.liu@kernel.org, decui@microsoft.com,
        lorenzo.bianconi@redhat.com, bpf@vger.kernel.org,
        linux-hyperv@vger.kernel.org
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
by Jakub Kicinski <kuba@kernel.org>:

On Sun, 12 Feb 2023 10:57:58 +0100 you wrote:
> Add missing ndo_xdp_xmit bit to xdp_features capability flag.
> 
> Fixes: 66c0e13ad236 ("drivers: net: turn on XDP features")
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>  drivers/net/hyperv/netvsc_drv.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)

Here is the summary with links:
  - [net-next] hv_netvsc: add missing NETDEV_XDP_ACT_NDO_XMIT xdp-features flag
    https://git.kernel.org/netdev/net-next/c/450bdf5bd6c6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


