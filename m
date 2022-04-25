Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7896F50DDC5
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 12:21:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241528AbiDYKX3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 06:23:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240786AbiDYKXT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 06:23:19 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 864714E3BD;
        Mon, 25 Apr 2022 03:20:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id CF4DACE1280;
        Mon, 25 Apr 2022 10:20:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1B812C385AB;
        Mon, 25 Apr 2022 10:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650882011;
        bh=rb3VKiZtMW7GNR57XP26aVP9HD27dKwGNnRfLeQmH3I=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=uyPBtOrXByQdvmtA74nqywMg0256FX9pFUxUqxET+nLZwnYUB5gz2kVhEADT8h95Q
         QDdBHs8YaskmUjyuET4wCgw7rHtOJ97B56OczFjA2yo5WUuiDjbtt1uK/jSpJvk3zL
         uvJNwfZVCmZf61l96Qe/5fKiYVCx9ESkAtYngZtmqUsygasLTWUPpOR8cVwvdaVlgl
         5UPHEwWX6CyJi4IOgNlZumPq2V1EJgVceWzeccd+7+e8eiZ2nmT6J43dmm9sfFJ4jF
         lQeor2slgqt8I/AyDbttbGYKAissV3Gsm2FX2XiEgkAcgAH0s2+ZUg6ulGV4Rn0DWU
         ST5MWjk2emP9w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 02499E85D90;
        Mon, 25 Apr 2022 10:20:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net/smc: sync err code when tcp connection was refused
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165088201100.28755.12445423825500453173.git-patchwork-notify@kernel.org>
Date:   Mon, 25 Apr 2022 10:20:11 +0000
References: <20220421094027.683992-1-liuyacan@corp.netease.com>
In-Reply-To: <20220421094027.683992-1-liuyacan@corp.netease.com>
To:     None <liuyacan@corp.netease.com>
Cc:     kgraul@linux.ibm.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, linux-s390@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        tonylu@linux.alibaba.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Thu, 21 Apr 2022 17:40:27 +0800 you wrote:
> From: liuyacan <liuyacan@corp.netease.com>
> 
> In the current implementation, when TCP initiates a connection
> to an unavailable [ip,port], ECONNREFUSED will be stored in the
> TCP socket, but SMC will not. However, some apps (like curl) use
> getsockopt(,,SO_ERROR,,) to get the error information, which makes
> them miss the error message and behave strangely.
> 
> [...]

Here is the summary with links:
  - [net] net/smc: sync err code when tcp connection was refused
    https://git.kernel.org/netdev/net/c/4e2e65e2e56c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


