Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 550DE4F75B3
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 08:10:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238795AbiDGGMS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 02:12:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229698AbiDGGMM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 02:12:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67EC919E3A8
        for <netdev@vger.kernel.org>; Wed,  6 Apr 2022 23:10:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 02F6B61D14
        for <netdev@vger.kernel.org>; Thu,  7 Apr 2022 06:10:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5F1D2C385A5;
        Thu,  7 Apr 2022 06:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649311812;
        bh=Wx2IkbAxnst5V0Nz40aYlCU83XQFKt/eTg51ujqqvQ0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=rQ5+RH2ccfiGLQUDfJ/3zX5jf0ZF1tMgZyHLFQ2iycGiAEwYf4KubEjdVr1Ofgfwi
         FbYmFbJ22KrQw+pq0VXIghoXLCevwPjYLfLbnRbcYPGqMPFYEUJrtbfotnjFwUdI5W
         FyuaxDNGQmJGLo8kVdFAB4bye3R2eEjGwgaZ9OwAt7uZUpgzLn6l9OCkzwI9r32p0R
         x6hCCsUku+Xy9W+BxJ3CmJs7pYsll8L5jLprwn5jQ670P2ZEtuGAYDr0OkrsbFe7nh
         JfWdF6aXJ+CA8mkgPd+lti5/81Mo6SvzLTMYFMkI7N07CL1N1gDGXs6GpycIJN9RaP
         fXL9TfuCI2Tcw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 344C3E85B8C;
        Thu,  7 Apr 2022 06:10:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] drivers: net: slip: fix NPD bug in sl_tx_timeout()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164931181220.23961.18191397636572007546.git-patchwork-notify@kernel.org>
Date:   Thu, 07 Apr 2022 06:10:12 +0000
References: <20220405132206.55291-1-duoming@zju.edu.cn>
In-Reply-To: <20220405132206.55291-1-duoming@zju.edu.cn>
To:     Duoming Zhou <duoming@zju.edu.cn>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.or,
        gregkh@linuxfoundation.org, alexander.deucher@amd.com,
        broonie@kernel.org, jirislaby@kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by Jakub Kicinski <kuba@kernel.org>:

On Tue,  5 Apr 2022 21:22:06 +0800 you wrote:
> When a slip driver is detaching, the slip_close() will act to
> cleanup necessary resources and sl->tty is set to NULL in
> slip_close(). Meanwhile, the packet we transmit is blocked,
> sl_tx_timeout() will be called. Although slip_close() and
> sl_tx_timeout() use sl->lock to synchronize, we don`t judge
> whether sl->tty equals to NULL in sl_tx_timeout() and the
> null pointer dereference bug will happen.
> 
> [...]

Here is the summary with links:
  - drivers: net: slip: fix NPD bug in sl_tx_timeout()
    https://git.kernel.org/netdev/net/c/ec4eb8a86ade

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


