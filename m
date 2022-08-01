Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEAB85872F2
	for <lists+netdev@lfdr.de>; Mon,  1 Aug 2022 23:16:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235033AbiHAVP5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Aug 2022 17:15:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233386AbiHAVPu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Aug 2022 17:15:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CEBA1128;
        Mon,  1 Aug 2022 14:15:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0C3BBB8172B;
        Mon,  1 Aug 2022 21:15:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B6667C43470;
        Mon,  1 Aug 2022 21:15:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659388546;
        bh=z4STz0zY+wUTcihzBrpybXxi5b1yhtshpxdoX96QmY8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=LEGvapVFftR0gHZ8QT6u+5VvCJLimGMhel6aU7X4dAVxzUNbuTV38HkNBE82WPeDe
         N9OBLMlE10iNYx59dfR0gadPYkMhSIo/IghrGIY4WvA2beOIvm2yLFJOW5BGFws0uO
         /phFOVHx3P6jLkxb7iKKrACNQQhKpOlBHigBoRaAWQp01kJSLJ61fiMK4hC/rcoDLA
         TygKdvCV9GxeebtK7JjHw3f5NQlMOZA2oroCfDN2saXXWCAhHQWKpLJszJj/b0GUgO
         fDwYdabK1IYKVnThAcFJMX5W0daVAjCNlG5TlTK12MD/XC3ai5o6nwFmmAAiexUTcQ
         vRuWxCEHt3ibw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9CCA7C43145;
        Mon,  1 Aug 2022 21:15:46 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull request: bluetooth-next 2022-07-22
From:   patchwork-bot+bluetooth@kernel.org
Message-Id: <165938854663.17345.13441892409944440799.git-patchwork-notify@kernel.org>
Date:   Mon, 01 Aug 2022 21:15:46 +0000
References: <20220723002232.964796-1-luiz.dentz@gmail.com>
In-Reply-To: <20220723002232.964796-1-luiz.dentz@gmail.com>
To:     Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to bluetooth/bluetooth-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 22 Jul 2022 17:22:32 -0700 you wrote:
> The following changes since commit 6e0e846ee2ab01bc44254e6a0a6a6a0db1cba16d:
> 
>   Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2022-07-21 13:03:39 -0700)
> 
> are available in the Git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next.git tags/for-net-next-2022-07-22
> 
> [...]

Here is the summary with links:
  - pull request: bluetooth-next 2022-07-22
    https://git.kernel.org/bluetooth/bluetooth-next/c/4a934eca7b39

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


