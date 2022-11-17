Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32E7962DCFE
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 14:40:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239915AbiKQNkV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 08:40:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240179AbiKQNkT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 08:40:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 837741ADAD;
        Thu, 17 Nov 2022 05:40:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1E97D61E1D;
        Thu, 17 Nov 2022 13:40:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 81BC7C433D6;
        Thu, 17 Nov 2022 13:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668692417;
        bh=9Bhh+HTYDF5HSYFBu9NiNMJy1n6Upm620xHE3vXTJn0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=INQRd+MHyqpP8PKB58imsrLqao6BhC8eR2qYkUVfxJFy/EiMBD1+Fb1d8xToHQbJ+
         YWft2UkhIgWeBc4UompJlBKZvClm8aTO5ekqpa/mzRb6xn4T61WmYuqByt/G4VVv4l
         LyT8Ip9orKQY9UBqxMW1g9fnf7L+5SgbrKfOmQuBbLyEGeVApRLln09GXVE00r4Kxs
         QD9Lc9LUbW1o69WbWqvKJN/0FQlq4EKh9044tIccXvO9eNx/HCzXgKExA0MoCsBxq5
         BZuxR65g8Vp5j1EAwuqeCNSJX43nfdakTzhjhfwoof5Ic7vCwNoq00/hH9QWeNqUtH
         exMBNK5AePTmQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6724FE29F44;
        Thu, 17 Nov 2022 13:40:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: ethernet: renesas: Fix return type in
 rswitch_etha_wait_link_verification()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166869241740.18320.12642855887431162608.git-patchwork-notify@kernel.org>
Date:   Thu, 17 Nov 2022 13:40:17 +0000
References: <Y3OPo6AOL6PTvXFU@kili>
In-Reply-To: <Y3OPo6AOL6PTvXFU@kili>
To:     Dan Carpenter <error27@gmail.com>
Cc:     s.shtylyov@omp.ru, yoshihiro.shimoda.uh@renesas.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, andrew@lunn.ch, netdev@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, kernel-janitors@vger.kernel.org
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
by Paolo Abeni <pabeni@redhat.com>:

On Tue, 15 Nov 2022 16:09:55 +0300 you wrote:
> The rswitch_etha_wait_link_verification() is supposed to return zero
> on success or negative error codes.  Unfortunately it is declared as a
> bool so the caller treats everything as success.
> 
> Fixes: 3590918b5d07 ("net: ethernet: renesas: Add support for "Ethernet Switch"")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> [...]

Here is the summary with links:
  - [net-next] net: ethernet: renesas: Fix return type in rswitch_etha_wait_link_verification()
    https://git.kernel.org/netdev/net-next/c/b4b221bd79a1

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


