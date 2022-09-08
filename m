Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FC7D5B23BF
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 18:40:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230460AbiIHQkm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 12:40:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229943AbiIHQkl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 12:40:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F9003DF19;
        Thu,  8 Sep 2022 09:40:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4D85EB82066;
        Thu,  8 Sep 2022 16:40:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E901FC433D7;
        Thu,  8 Sep 2022 16:40:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662655238;
        bh=NMdI3A+LJADAzvV0+YIrtLBHvDnJuM7zrjrHQ4V9cjQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=a4CfBOorlJ5dxINih+rJWatF9YdKqTA/Yuh0/0YEnjdNeIBsFFsPZDRJENkItgW8v
         BzyoPiaCi/bdYUkp0XK7gGklw+tZLXqW9mvG2c/aEPNFBOXa6kkaQjXF8KHYV9gCSG
         DqgfWs1mkWOsWtdbYjO9oSC0oIo5IUACrHfra3zcKlTaiJu2CW8jaS5jeKQ9qJRKK1
         JgbjkgChGOFcHzOaI3Kh2iotLS88gPDXiqar00FoUh0x6PcD2F2g4X3KR334UD4mp4
         Eqc4DW7E5U4xs+t8pqSJooxnppiPyKO8+WvIbTbhkyjLz8xemAs1Ormr5nscyJDtI2
         Idzl81JS+1QuQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CBB13C04E59;
        Thu,  8 Sep 2022 16:40:37 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [GIT PULL] Networking for 6.0-rc5
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166265523782.4080.15618867285882380321.git-patchwork-notify@kernel.org>
Date:   Thu, 08 Sep 2022 16:40:37 +0000
References: <20220908110610.28284-1-pabeni@redhat.com>
In-Reply-To: <20220908110610.28284-1-pabeni@redhat.com>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     torvalds@linux-foundation.org, kuba@kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
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

This pull request was applied to netdev/net.git (master)
by Linus Torvalds <torvalds@linux-foundation.org>:

On Thu,  8 Sep 2022 13:06:10 +0200 you wrote:
> Hi Linus!
> 
> The following changes since commit 42e66b1cc3a070671001f8a1e933a80818a192bf:
> 
>   Merge tag 'net-6.0-rc4' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2022-09-01 09:20:42 -0700)
> 
> are available in the Git repository at:
> 
> [...]

Here is the summary with links:
  - [GIT,PULL] Networking for 6.0-rc5
    https://git.kernel.org/netdev/net/c/26b1224903b3

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


