Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0D566B1C48
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 08:30:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229846AbjCIHa0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 02:30:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229799AbjCIHaW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 02:30:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74BD4618AB
        for <netdev@vger.kernel.org>; Wed,  8 Mar 2023 23:30:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 03AE961A3D
        for <netdev@vger.kernel.org>; Thu,  9 Mar 2023 07:30:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5D672C433EF;
        Thu,  9 Mar 2023 07:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678347020;
        bh=b3/0tYQwipOn9jk2XAVX8y3k4u9RMjEeC2gQAxhwZ3g=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ECJy/aRaTED/pEEEO7S+k0KodIWhJFrVfffuoBrx+1VuSEiO8u+tcITqmjJpVzik7
         Wn/FunDfxV0zA0RZ2wUZstZM81KUMPwFRNiFGnCDulDLSNvrxj4htDN6r47tf9W95P
         zxfcD81HpoUB51WhXTMYV2SjvprBm4qnaQNueTg3B7VVESUxTtDlgdU0MX2QOZX7k8
         fDMXl6Q1pCIp3+Yzf5xyHFVMez8WZ7rnNFO1AZyjtH2j5uFUKLkR0Ytyn/xwdrF0WM
         oQ8EcgrvZfGFYqM/x6KQNTppNgyx/to6pd1680WsiiWUmbTmZymoQ4wA/zXrnAC+is
         skz1lQtjZ9nxQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 42DECE61B6E;
        Thu,  9 Mar 2023 07:30:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] af_unix: fix struct pid leaks in OOB support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167834701926.22182.9958038836547552379.git-patchwork-notify@kernel.org>
Date:   Thu, 09 Mar 2023 07:30:19 +0000
References: <20230307164530.771896-1-edumazet@google.com>
In-Reply-To: <20230307164530.771896-1-edumazet@google.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, eric.dumazet@gmail.com,
        syzbot+7699d9e5635c10253a27@syzkaller.appspotmail.com,
        rao.shoaib@oracle.com, kuniyu@amazon.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Tue,  7 Mar 2023 16:45:30 +0000 you wrote:
> syzbot reported struct pid leak [1].
> 
> Issue is that queue_oob() calls maybe_add_creds() which potentially
> holds a reference on a pid.
> 
> But skb->destructor is not set (either directly or by calling
> unix_scm_to_skb())
> 
> [...]

Here is the summary with links:
  - [net] af_unix: fix struct pid leaks in OOB support
    https://git.kernel.org/netdev/net/c/2aab4b969002

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


