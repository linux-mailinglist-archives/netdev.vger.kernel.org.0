Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BB986E74AC
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 10:10:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231895AbjDSIKW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 04:10:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230377AbjDSIKU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 04:10:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A136194
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 01:10:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AB0EF63C3C
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 08:10:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 08D2FC4339B;
        Wed, 19 Apr 2023 08:10:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681891819;
        bh=3CpzZ42OO3XQ22x1SBHY49Ps6VIZcASXj3EHnHlFaCU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=erLI8Z985cZ7opqjw2GIZ7KEfenZMYjEVlm5Wmmny6ewoJ2lagdpOUiku9A/w8yDL
         +AC9ssPJBcxfUFbJOmUf6+rixWbvV2OLCGLw8y49QJAUa+jyu+nJbQkE5iR3iTLhUs
         zmN6mxTwpNwo21o6SB5TsINnQ/imvcTvU9W2XVXlUDo69PEudNEqUmi7L4bZwVwdQQ
         fRVC/FTyrPINdKU7gMvaEV5jvkJ6sy5qwMBjQ4zdwId7h0ujk17NZkNmWtr9mvS5UR
         domy8vBiMcYK8mjUUprUqZdHFr5niKZENjXR7dtlwLND4Qlvjbi+VDWlBNYPtKGKzh
         wwRfZiQuN8cdg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E3592E3309C;
        Wed, 19 Apr 2023 08:10:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCHv2 net] net: rpl: fix rpl header size calculation
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168189181892.29892.10122569755950131186.git-patchwork-notify@kernel.org>
Date:   Wed, 19 Apr 2023 08:10:18 +0000
References: <20230417130052.2316819-1-aahringo@redhat.com>
In-Reply-To: <20230417130052.2316819-1-aahringo@redhat.com>
To:     Alexander Aring <aahringo@redhat.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, dsahern@kernel.org,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        alex.aring@gmail.com, daniel@iogearbox.net, ymittal@redhat.com,
        mcascell@redhat.com, torvalds@linuxfoundation.org, mcr@sandelman.ca
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Mon, 17 Apr 2023 09:00:52 -0400 you wrote:
> This patch fixes a missing 8 byte for the header size calculation. The
> ipv6_rpl_srh_size() is used to check a skb_pull() on skb->data which
> points to skb_transport_header(). Currently we only check on the
> calculated addresses fields using CmprI and CmprE fields, see:
> 
> https://www.rfc-editor.org/rfc/rfc6554#section-3
> 
> [...]

Here is the summary with links:
  - [PATCHv2,net] net: rpl: fix rpl header size calculation
    https://git.kernel.org/netdev/net/c/4e006c7a6dac

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


