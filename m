Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D84F6DDC57
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 15:40:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229848AbjDKNkW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 09:40:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229805AbjDKNkV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 09:40:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B74CAC
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 06:40:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BABCE62121
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 13:40:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1DB5DC433A7;
        Tue, 11 Apr 2023 13:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681220418;
        bh=5TxPs+GjGhIkPLTyaQekp9c33tL0pzWJHlgX5k4Fq48=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=i90tPDXoXTEHSImIIZAsHQCVX9y/kKlzy0a3pdNOprXo81fRrMqgEp6MD7d1bp2/W
         8DGDSxwxsykpDzWgy0Pm7MLMwZNTSF3KenPKtp9FsrAUTwVoJQ4AIqMbFy5TvAuXG/
         IiUg25tNBUmPeW22pfSBrHi5EvoaCAhzp03wjaAn1UfG+dZ+YFrrP2wuMOb/8T+jVb
         33+Y5zKF4ao0lGL0vqzV1WmJCjTpac5koAUqib9oRztbZmRlwN+zPPO/onnOVtNuyN
         GsUBynj+ddQhCLzceZrGx0lffAu4PMZj9vsp35MFm1MybFFoHlggy4HW13pMqw0FMx
         cMDy+ddL2aiRQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0704AE52441;
        Tue, 11 Apr 2023 13:40:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] tools: ynl: throw a more meaningful exception if
 family not supported
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168122041802.18873.10885118752075407158.git-patchwork-notify@kernel.org>
Date:   Tue, 11 Apr 2023 13:40:18 +0000
References: <20230407145609.297525-1-kuba@kernel.org>
In-Reply-To: <20230407145609.297525-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, kory.maincent@bootlin.com
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Paolo Abeni <pabeni@redhat.com>:

On Fri,  7 Apr 2023 07:56:09 -0700 you wrote:
> cli.py currently throws a pure KeyError if kernel doesn't support
> a netlink family. Users who did not write ynl (hah) may waste
> their time investigating what's wrong with the Python code.
> Improve the error message:
> 
> Traceback (most recent call last):
>   File "/home/kicinski/devel/linux/tools/net/ynl/lib/ynl.py", line 362, in __init__
>     self.family = GenlFamily(self.yaml['name'])
>                   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>   File "/home/kicinski/devel/linux/tools/net/ynl/lib/ynl.py", line 331, in __init__
>     self.genl_family = genl_family_name_to_id[family_name]
>                        ~~~~~~~~~~~~~~~~~~~~~~^^^^^^^^^^^^^
> KeyError: 'netdev'
> 
> [...]

Here is the summary with links:
  - [net-next] tools: ynl: throw a more meaningful exception if family not supported
    https://git.kernel.org/netdev/net-next/c/ebe3bdc4359e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


