Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0535A62F292
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 11:30:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241374AbiKRKaS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 05:30:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234455AbiKRKaR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 05:30:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F26D992087
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 02:30:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8EB076234A
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 10:30:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DAAAAC43146;
        Fri, 18 Nov 2022 10:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668767415;
        bh=3VARo0UC+peXKj6PXuSUHzdstGVvrICInRxSUXQ+ljA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=vQzLvAYIUVDbQyExrAnSB0L2H+4aLZ+st7D/Hb/PP1NJtK87e7jp/VFl159Go+R9t
         GJSw5GVi0sVq261AUraA3YbiXQ4u/944JoIpHpbJbTbzR97ls58h5LZmJMEhqXClDQ
         epkipi7uOLfMWR4boRVjr4KIRE/4rMth6fqP0z2q3ettRUfcIPZzubEi+b/uDoRqeC
         +v+hWvm3uXLg86PvLT+VMR3eqVwiiSaS4yr3tr05X1+8eqtjX5vrkvOggMsQdAkTs8
         NX3jQV1hbv6rpVAekCG0m73R8DiY3WCdz21Ho0MoWQvJgrb0gZ7VcmzJGdJbq+QfXg
         HmOqzS+zBIWrw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C7965E50D71;
        Fri, 18 Nov 2022 10:30:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] net: phy: mscc: macsec: do not copy encryption
 keys
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166876741581.29065.9945510210636356431.git-patchwork-notify@kernel.org>
Date:   Fri, 18 Nov 2022 10:30:15 +0000
References: <20221115154451.266160-1-atenart@kernel.org>
In-Reply-To: <20221115154451.266160-1-atenart@kernel.org>
To:     Antoine Tenart <atenart@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, sd@queasysnail.net, irusskikh@marvell.com,
        netdev@vger.kernel.org
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
by David S. Miller <davem@davemloft.net>:

On Tue, 15 Nov 2022 16:44:51 +0100 you wrote:
> Following 1b16b3fdf675 ("net: phy: mscc: macsec: clear encryption keys when freeing a flow"),
> go one step further and instead of calling memzero_explicit on the key
> when freeing a flow, simply not copy the key in the first place as it's
> only used when a new flow is set up.
> 
> Signed-off-by: Antoine Tenart <atenart@kernel.org>
> 
> [...]

Here is the summary with links:
  - [net-next,v2] net: phy: mscc: macsec: do not copy encryption keys
    https://git.kernel.org/netdev/net-next/c/0dc33c65835d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


