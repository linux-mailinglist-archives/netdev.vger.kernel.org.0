Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0523F6DEA87
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 06:30:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229642AbjDLEaW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 00:30:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbjDLEaV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 00:30:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F0744690;
        Tue, 11 Apr 2023 21:30:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C861462DDF;
        Wed, 12 Apr 2023 04:30:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 25F05C4339B;
        Wed, 12 Apr 2023 04:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681273819;
        bh=QznQgHQWqB9OE6OUu2uTp1NfY+mObvKx82/go7hdFFI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=CntLbe+LhKQI9eYsYtvmyPPNGXOBTI/39hXRjVw4F6mqk1gz7pFlTJ3fRKwlqAKxU
         3hv0aKK5I1cZopakE81w7hhKeHZMarjLCmEOIPhayqB7Q8v8ArrQ1RL/3xVggQogoO
         8op3iaakdUUA/yWPaBu038O/wj3Xk6iqSbLKc4ZY7588NQWFpt1cawUT6Wy773tY3v
         GVF92enhNsmCBC3T2pj9hNufKUBK1hFH3ZQXl5x1I6GlRp0LL0004A/W4cAwTcKqUI
         4i3QyNn1mXm9qNEhKSAx0vqqxqfzXzDdLSsOkZH3rG9AzTk+WOxh6Gc0BaTYPz6mbX
         3ooZ748mbc1jw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 02F30C395C3;
        Wed, 12 Apr 2023 04:30:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: bluetooth 2023-04-10
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168127381900.9603.16144066796062870419.git-patchwork-notify@kernel.org>
Date:   Wed, 12 Apr 2023 04:30:19 +0000
References: <20230410172718.4067798-1-luiz.dentz@gmail.com>
In-Reply-To: <20230410172718.4067798-1-luiz.dentz@gmail.com>
To:     Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 10 Apr 2023 10:27:18 -0700 you wrote:
> The following changes since commit b9881d9a761a7e078c394ff8e30e1659d74f898f:
> 
>   Merge branch 'bonding-ns-validation-fixes' (2023-04-07 08:47:20 +0100)
> 
> are available in the Git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth.git tags/for-net-2023-04-10
> 
> [...]

Here is the summary with links:
  - pull-request: bluetooth 2023-04-10
    https://git.kernel.org/netdev/net/c/160c13175e39

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


