Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7C3363C60B
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 18:03:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236585AbiK2RDJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 12:03:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236578AbiK2RCl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 12:02:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CBBA6D955
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 09:00:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 17E326186A
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 17:00:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 624D6C433D6;
        Tue, 29 Nov 2022 17:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669741218;
        bh=kOPKaWdq8Z15fYALUzxSR3d0Ak069amBR+jD3w4tYzA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=VK93GCnutmcv7hBZIJ2TqQD4JovNYrsrw/BfwHAK+RVngnI75VygcC0Ojq95GCbiA
         5991ImJS4uGTJk55Wtx19bT8L0/Z2B/EMhrY6XEiONqifRiBkt+PDAstCrbQZQVTmh
         /gJqOcQm5nEoTOjRJx0hnefe3DjloeY40M3/ekw7cY5EqklpT5sLvcGBl0eFqzdL/r
         mrxpGJt95zSGyBd7ear/QUGUpbcTP28dIEf9a0IZcK84gvmyIqTXey+qMfkL+b0KuM
         D4JpurJPnquNF7LuIss9gb3QdnCvbXC4aap2o88Az3HNJn45tJDWOySwN1ZLghIn6Q
         P8GxAnmo/gfxQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 420ACC395EC;
        Tue, 29 Nov 2022 17:00:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] packet: do not set TP_STATUS_CSUM_VALID on
 CHECKSUM_COMPLETE
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166974121826.7750.14696229039794308157.git-patchwork-notify@kernel.org>
Date:   Tue, 29 Nov 2022 17:00:18 +0000
References: <20221128161812.640098-1-willemdebruijn.kernel@gmail.com>
In-Reply-To: <20221128161812.640098-1-willemdebruijn.kernel@gmail.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com, al.drozdov@gmail.com,
        alexanderduyck@fb.com, willemb@google.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Mon, 28 Nov 2022 11:18:12 -0500 you wrote:
> From: Willem de Bruijn <willemb@google.com>
> 
> CHECKSUM_COMPLETE signals that skb->csum stores the sum over the
> entire packet. It does not imply that an embedded l4 checksum
> field has been validated.
> 
> Fixes: 682f048bd494 ("af_packet: pass checksum validation status to the user")
> Signed-off-by: Willem de Bruijn <willemb@google.com>
> 
> [...]

Here is the summary with links:
  - [net] packet: do not set TP_STATUS_CSUM_VALID on CHECKSUM_COMPLETE
    https://git.kernel.org/netdev/net/c/b85f628aa158

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


