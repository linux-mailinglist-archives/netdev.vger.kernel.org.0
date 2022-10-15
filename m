Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E32F85FF9A6
	for <lists+netdev@lfdr.de>; Sat, 15 Oct 2022 12:20:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229754AbiJOKU2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Oct 2022 06:20:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229655AbiJOKUW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Oct 2022 06:20:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FF9C2B1A3;
        Sat, 15 Oct 2022 03:20:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 54B29B80885;
        Sat, 15 Oct 2022 10:20:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 04A41C433D7;
        Sat, 15 Oct 2022 10:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665829216;
        bh=YKBMS0sko0ah9X9nz1vsXfEsklWkoU7vB7rsyBAGa0A=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=YFWKcUUYX/tQXXnlxn8v/SdD8ULBlHrreuZuxSEBiYRkwHWoPOAoBiAilpCFBYlSl
         TCYizka6Vl4ZAfSlpISRKndoONmEeCKI9aTnLhTNrwSROKYQsMpV70Q2ux57UqnQq2
         6IbVaFv3wc98I1o1pI6+yHbENqGVYJZ970iFco7Dl3EFLs5SQ2UGQeCAiWKKZJnMkN
         txBZRnAaIJIv4YSCZ3H2A1qEiymm+wSn591vXfB6TcDZpB67QlgQjy82Bs6lz5Mpxs
         ic5e7XxqXhqeyXNNKY0Y7zNWTz2BSvIqaiwbrg2qict+r2f2Bftpjgyd+ZQHeZ1WN8
         2relG+QfNjHQA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id DACD5E270EF;
        Sat, 15 Oct 2022 10:20:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] sunhme: Uninitialized variable in happy_meal_init()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166582921589.1299.4759077636776692922.git-patchwork-notify@kernel.org>
Date:   Sat, 15 Oct 2022 10:20:15 +0000
References: <Y0lzHssyY3VkxuAz@kili>
In-Reply-To: <Y0lzHssyY3VkxuAz@kili>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     seanga2@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
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
by David S. Miller <davem@davemloft.net>:

On Fri, 14 Oct 2022 17:33:02 +0300 you wrote:
> The "burst" string is only initialized for CONFIG_SPARC.  It should be
> set to "64" because that's what is used by PCI.
> 
> Fixes: 24cddbc3ef11 ("sunhme: Combine continued messages")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
> v2: Use "64" instead of ""
> 
> [...]

Here is the summary with links:
  - [net,v2] sunhme: Uninitialized variable in happy_meal_init()
    https://git.kernel.org/netdev/net/c/9408f3d321ed

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


