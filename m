Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16DD96120B9
	for <lists+netdev@lfdr.de>; Sat, 29 Oct 2022 08:30:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229553AbiJ2Gaa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Oct 2022 02:30:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbiJ2Ga1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Oct 2022 02:30:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC3E16386B
        for <netdev@vger.kernel.org>; Fri, 28 Oct 2022 23:30:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 89803B82EB7
        for <netdev@vger.kernel.org>; Sat, 29 Oct 2022 06:30:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 20A5EC4347C;
        Sat, 29 Oct 2022 06:30:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667025022;
        bh=LkFtdzLoWusAW2LmLHIb0kPvOt7FYiJW4LJqPzHmtK0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=m+zz3u3yHtP6/cBLPhbxTafomak6QqS+YlyD28zpO5Hq4gK+uxUK/+J0durv/EnDD
         ge/kQTzLfxLfiFFZTvtWCcxjSYBKrTmsWcSzH0YG0urSTIsfsJSAGloaOZr6ihJ6Zi
         VRQ3J5uInk4DfqXkIWuga04xHvQqHIquixQj0jnzDBajDjJ9VD3OoHUPL4/+GYn9r8
         yAF7EbMDMj0cBZMlIUDdnbstnj/RfqKZGOUHGzUPDmIdL8e4v24QeYPas7cFOfZjKT
         3lB14PmVk7J34Wj7bTAezK5hRmT8vYQQpMV2MZm1+77SITorDPthlC1CDxMciJAcX0
         XwTvGxMH7Cmug==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id F16DAC4314C;
        Sat, 29 Oct 2022 06:30:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net/packet: add PACKET_FANOUT_FLAG_IGNORE_OUTGOING
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166702502198.25217.15372550708206277434.git-patchwork-notify@kernel.org>
Date:   Sat, 29 Oct 2022 06:30:21 +0000
References: <20221027211014.3581513-1-willemdebruijn.kernel@gmail.com>
In-Reply-To: <20221027211014.3581513-1-willemdebruijn.kernel@gmail.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com,
        vincent.whitchurch@axis.com, cpascoe@google.com, willemb@google.com
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Thu, 27 Oct 2022 17:10:14 -0400 you wrote:
> From: Willem de Bruijn <willemb@google.com>
> 
> Extend packet socket option PACKET_IGNORE_OUTGOING to fanout groups.
> 
> The socket option sets ptype.ignore_outgoing, which makes
> dev_queue_xmit_nit skip the socket.
> 
> [...]

Here is the summary with links:
  - [net-next] net/packet: add PACKET_FANOUT_FLAG_IGNORE_OUTGOING
    https://git.kernel.org/netdev/net-next/c/58ba426388d9

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


