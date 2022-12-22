Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94F1B653A5F
	for <lists+netdev@lfdr.de>; Thu, 22 Dec 2022 02:50:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230336AbiLVBuT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Dec 2022 20:50:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229742AbiLVBuS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Dec 2022 20:50:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75F97183AC;
        Wed, 21 Dec 2022 17:50:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DF2F0619AC;
        Thu, 22 Dec 2022 01:50:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 29A59C433F0;
        Thu, 22 Dec 2022 01:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671673816;
        bh=YSS8KTvGdWiJJFpKiJ442pKE5JQko5C12kkFhls4jlY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=RB+mxzMpVpazq4DMTVyN7IVO3RYS9OXiX+tvOZOEOdFil+YQTZgQOoqfyyAfQ6Ah5
         D7J3P2HEhYhomKvLQYB83+D8rrNyNuTx74mSF0KV0POyOjaPO0mR92bRj0Rsr1qn6l
         d5JsTwS8OIcAGXDDPkz1A+UfWrh77nSFBc6sbLmyWw1L8qkKxQVKX7IyxweeJKhKON
         N1YD6A/wfrESCUuE6bwEsUU+mSkBuWbYcR1W/R2UDlXL3389vF5wB1zc7XvL2rW0GB
         KKvXi7c+IlIzIUumAlQlmuEYfUJNvfpLcxBJGXaZoqCOCdPfo5VOB8UexUzGsodhCd
         Wz4TbvjDDMAEw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0FDDDC5C7C4;
        Thu, 22 Dec 2022 01:50:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/1] ice: xsk: do not use xdp_return_frame() on
 tx_buf->raw_buf
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167167381606.8581.8438557501998235094.git-patchwork-notify@kernel.org>
Date:   Thu, 22 Dec 2022 01:50:16 +0000
References: <20221220175448.693999-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20221220175448.693999-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, maciej.fijalkowski@intel.com,
        netdev@vger.kernel.org, magnus.karlsson@intel.com, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        bpf@vger.kernel.org, robin.cowley@thehutgroup.com,
        chandanx.rout@intel.com
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

On Tue, 20 Dec 2022 09:54:48 -0800 you wrote:
> From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> 
> Previously ice XDP xmit routine was changed in a way that it avoids
> xdp_buff->xdp_frame conversion as it is simply not needed for handling
> XDP_TX action and what is more it saves us CPU cycles. This routine is
> re-used on ZC driver to handle XDP_TX action.
> 
> [...]

Here is the summary with links:
  - [net,1/1] ice: xsk: do not use xdp_return_frame() on tx_buf->raw_buf
    https://git.kernel.org/netdev/net/c/53fc61be273a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


