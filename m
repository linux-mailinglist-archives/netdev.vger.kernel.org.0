Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8246A53B594
	for <lists+netdev@lfdr.de>; Thu,  2 Jun 2022 11:02:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232709AbiFBJAS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jun 2022 05:00:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232705AbiFBJAR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jun 2022 05:00:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99C452004CB;
        Thu,  2 Jun 2022 02:00:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4950FB81F01;
        Thu,  2 Jun 2022 09:00:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 13410C36AE7;
        Thu,  2 Jun 2022 09:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654160413;
        bh=6NQyQsEyYucHVOkZbLnJ7urn0m0WnyT2Zt9bDJz9iLk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=R2753QVItjwhML4hrwNDUHP17Wgs1oqlCqs953uQQjJew6LjcgqHcHsWNPIAn2K/q
         UJ6DnNkLJgj+rcnaVng5AxtMFIEIp39U6aHPmfGnBVG+WvKcR0jxABzIMg07ON3NjM
         Xwm9isntYdxK9sUHgF4aL/9sNgVZH8LkWDBV9dMyojn1WlopJGGgple9tFvkqsgwK8
         bAHb7GI1nPq/CgtYDu2ERfEyrICsTOOc4iO9z7bOCLCUPJfHpo6F0yNZ+TX4k9ZGJ2
         afRBwHO0xma2WtRMrfsOn5XR3UIXy5oOr4Lv20nyp9HXEtit7dY2S5GuPII5eadUkR
         5UgBC5c+w7dRw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id EB61AF03950;
        Thu,  2 Jun 2022 09:00:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v5] ax25: Fix ax25 session cleanup problems
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165416041295.6334.1196583658510604194.git-patchwork-notify@kernel.org>
Date:   Thu, 02 Jun 2022 09:00:12 +0000
References: <20220530152158.108619-1-duoming@zju.edu.cn>
In-Reply-To: <20220530152158.108619-1-duoming@zju.edu.cn>
To:     Duoming Zhou <duoming@zju.edu.cn>
Cc:     linux-hams@vger.kernel.org, jreuter@yaina.de, ralf@linux-mips.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, thomas@osterried.de
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Mon, 30 May 2022 23:21:58 +0800 you wrote:
> There are session cleanup problems in ax25_release() and
> ax25_disconnect(). If we setup a session and then disconnect,
> the disconnected session is still in "LISTENING" state that
> is shown below.
> 
> Active AX.25 sockets
> Dest       Source     Device  State        Vr/Vs    Send-Q  Recv-Q
> DL9SAU-4   DL9SAU-3   ???     LISTENING    000/000  0       0
> DL9SAU-3   DL9SAU-4   ???     LISTENING    000/000  0       0
> 
> [...]

Here is the summary with links:
  - [net,v5] ax25: Fix ax25 session cleanup problems
    https://git.kernel.org/netdev/net/c/7d8a3a477b3e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


