Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB6646C4185
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 05:20:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229852AbjCVEUY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 00:20:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229739AbjCVEUV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 00:20:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B3D5574C7
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 21:20:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 29795B81B04
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 04:20:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9CFA5C433D2;
        Wed, 22 Mar 2023 04:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679458817;
        bh=FcEDol2no8rc4l5+dEACERKO1w7mkXMiJeldUx+q+sY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=eHF5KGv70k6S6QIQF7pUAhiu+Bk9SQfYY2mEoxWyvmSg3aCc7V84jJCuXPxe9neH8
         bjstmPwzpZJFzvd6j3TYayEOT6OfNrlva+WYzNc2YbPE1PPmK3s0Q/tr5AXLMn2Bcc
         mLcf5WPhv635TNcp5bptM8cEK7WWKCkaudChlPsw1dw2KTK9cbynyxipCclGfp97Rf
         w+CLuuIpvKrsFRdXNEGdRJ6QlUqX8RDn9F1KfH9RnLqL77fl9NAICrJ1IK6crCFx+M
         iU1qLUJWaFaU5oWsns701/ik3XWVNTalMpSvqAxK4LgLGDTPUWmrL0RvFQF/Po1rfz
         bISiNypziRZ3Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8272FE4F0DA;
        Wed, 22 Mar 2023 04:20:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] erspan: do not use skb_mac_header() in ndo_start_xmit()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167945881753.16584.11996040637032676730.git-patchwork-notify@kernel.org>
Date:   Wed, 22 Mar 2023 04:20:17 +0000
References: <20230320163427.8096-1-edumazet@google.com>
In-Reply-To: <20230320163427.8096-1-edumazet@google.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, eric.dumazet@gmail.com,
        syzkaller@googlegroups.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 20 Mar 2023 16:34:27 +0000 you wrote:
> Drivers should not assume skb_mac_header(skb) == skb->data in their
> ndo_start_xmit().
> 
> Use skb_network_offset() and skb_transport_offset() which
> better describe what is needed in erspan_fb_xmit() and
> ip6erspan_tunnel_xmit()
> 
> [...]

Here is the summary with links:
  - [net] erspan: do not use skb_mac_header() in ndo_start_xmit()
    https://git.kernel.org/netdev/net/c/8e50ed774554

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


