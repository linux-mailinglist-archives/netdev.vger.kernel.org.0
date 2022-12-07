Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26249645306
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 05:30:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229652AbiLGEaU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 23:30:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229628AbiLGEaS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 23:30:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B42615656F
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 20:30:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4CAFB619F9
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 04:30:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9E367C4314E;
        Wed,  7 Dec 2022 04:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670387416;
        bh=BlyH2GZVXdW/Pze9Msahe6lxtiJjHLCPBEhOMt7niaY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ea/RcVRhne2aLz+BthzFsORIIuRKk+ymi3CbcegesJSKN8jJiTfA/yrfSYjKHBxXS
         hDRPd7LYyJko6OyHq4PJHewLSxFfUHGQ6pigEmbPFkt6+pAp2rQC70rWZU0bMEepND
         HFw3DAh7elnEW0e3gUkc0pjssdwpZkXfcfDLhHkkLewZwny2zRpOraUDY0DYlOep3t
         GtQtaKzh8fNr640RtX/22TXM83ZIICmuQ0JwXkAO3qdE03GmLVyVev7MGVA0St/zov
         UlLKEEwMOpOvCeXVzj+X5sTGOZ901+5G8yuGeO1edEcOeW+AYldKFADYW+GR27oVmT
         D9yKzZ6kB9Ynw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7C5A7C5C7C6;
        Wed,  7 Dec 2022 04:30:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] bonding: get correct NA dest address
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167038741650.14983.10283981324971213207.git-patchwork-notify@kernel.org>
Date:   Wed, 07 Dec 2022 04:30:16 +0000
References: <20221206032055.7517-1-liuhangbin@gmail.com>
In-Reply-To: <20221206032055.7517-1-liuhangbin@gmail.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, j.vosburgh@gmail.com, davem@davemloft.net,
        kuba@kernel.org, jtoppins@redhat.com, pabeni@redhat.com,
        edumazet@google.com
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

On Tue,  6 Dec 2022 11:20:55 +0800 you wrote:
> In commit 4d633d1b468b ("bonding: fix ICMPv6 header handling when receiving
> IPv6 messages"), there is a copy/paste issue for NA daddr. I found that
> in my testing and fixed it in my local branch. But I forgot to re-format
> the patch and sent the wrong mail.
> 
> Fix it by reading the correct dest address.
> 
> [...]

Here is the summary with links:
  - [net] bonding: get correct NA dest address
    https://git.kernel.org/netdev/net/c/1f154f3b56a1

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


