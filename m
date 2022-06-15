Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFC2754C852
	for <lists+netdev@lfdr.de>; Wed, 15 Jun 2022 14:20:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347868AbiFOMUR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jun 2022 08:20:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235232AbiFOMUQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jun 2022 08:20:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2697B366A3;
        Wed, 15 Jun 2022 05:20:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CF077B81D92;
        Wed, 15 Jun 2022 12:20:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5AC9DC34115;
        Wed, 15 Jun 2022 12:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655295613;
        bh=eDPWJ22K5Yb0l4NNxcNbEGmohnUi3JOvIlFiu925Tp8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=HblmdovLimj0OLJSV+33FXd9CEZCXH4qIDgEpnL57XEGg0SuXURAmEhxwUFWAfDDM
         8Y/IJert6xQaeTG4amu0DStjL4SFCl03TW7X67sM1ZIr56seVgOuxsEA7mqBs+YOOo
         injtJwjKiAtrE96PyzYQ7fTqa/FfCaBraL2fZcz1RfEJvDe/o4tvQr6IMWx9se98Tj
         I0j0bXfilGLg2MD0PVwjBM99I/DfdifXwiYBIUBdsOaOxJUF7LlIfU0HA7PGJtOoQ0
         5YqZWp3ER22F7qCxhoM790wND2bsBxILzt3+I6RM4YEZNAnlwdLvamcxyKFgVIXoyd
         d3Mrh2GIwQMjw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3F990E6D466;
        Wed, 15 Jun 2022 12:20:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v5] net: ax25: Fix deadlock caused by skb_recv_datagram in
 ax25_recvmsg
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165529561325.20387.9560588021294882995.git-patchwork-notify@kernel.org>
Date:   Wed, 15 Jun 2022 12:20:13 +0000
References: <20220614092557.6713-1-duoming@zju.edu.cn>
In-Reply-To: <20220614092557.6713-1-duoming@zju.edu.cn>
To:     Duoming Zhou <duoming@zju.edu.cn>
Cc:     linux-hams@vger.kernel.org, pabeni@redhat.com, jreuter@yaina.de,
        ralf@linux-mips.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, thomas@osterried.de
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by David S. Miller <davem@davemloft.net>:

On Tue, 14 Jun 2022 17:25:57 +0800 you wrote:
> The skb_recv_datagram() in ax25_recvmsg() will hold lock_sock
> and block until it receives a packet from the remote. If the client
> doesn`t connect to server and calls read() directly, it will not
> receive any packets forever. As a result, the deadlock will happen.
> 
> The fail log caused by deadlock is shown below:
> 
> [...]

Here is the summary with links:
  - [net,v5] net: ax25: Fix deadlock caused by skb_recv_datagram in ax25_recvmsg
    https://git.kernel.org/netdev/net/c/219b51a6f040

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


