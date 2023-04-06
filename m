Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7134C6D96AE
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 14:03:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229710AbjDFMDI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 08:03:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236580AbjDFMCs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 08:02:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A86AA24C
        for <netdev@vger.kernel.org>; Thu,  6 Apr 2023 05:00:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 98C6B63E4A
        for <netdev@vger.kernel.org>; Thu,  6 Apr 2023 12:00:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id F2800C4339B;
        Thu,  6 Apr 2023 12:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680782418;
        bh=EM7i/bdbcC4r1HYHDrD+DOHrg6pZLvFaietKWEGHVYY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ZF1A3fJSNY3Kk+EHTRyXvizVxJLRtXdvqJ+tB6ZhhQJ/0VWVGowqv3AIPKsIOf6Qr
         unJsbZaQW2fyfIp7YyVRJ1ukwd9JnPBwbZWzj8kNtjYXlJTKQfhCyH1466X36WItgS
         uZ6E6bczDOUFSaHOfQ0xUbjqXO5uOOVOvPyk9D5avK86LOmSKwWbpXoDkSI8ISz3fW
         yscVBRws6UgKFzf47Pgi5O1tfNBIHjgWamlZphV3uDGPfEYqVt8f0za3OcgmLR/5nf
         XA+OZXkUfQthgjXS7bVKIDixMijxy12W8ftLel3d3aZrnVhbYm49CCdtSCzQSu5zHs
         3eAV1WroQsulg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id DE912E5EA85;
        Thu,  6 Apr 2023 12:00:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] selftests/net: fix typo in tcp_mmap
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168078241790.24469.11484886726890303426.git-patchwork-notify@kernel.org>
Date:   Thu, 06 Apr 2023 12:00:17 +0000
References: <20230405071556.1019623-1-edumazet@google.com>
In-Reply-To: <20230405071556.1019623-1-edumazet@google.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, eric.dumazet@gmail.com, lkp@intel.com,
        lixiaoyan@google.com, kuniyu@amazon.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Paolo Abeni <pabeni@redhat.com>:

On Wed,  5 Apr 2023 07:15:56 +0000 you wrote:
> kernel test robot reported the following warning:
> 
> All warnings (new ones prefixed by >>):
> 
>    tcp_mmap.c: In function 'child_thread':
> >> tcp_mmap.c:211:61: warning: 'lu' may be used uninitialized in this function [-Wmaybe-uninitialized]
>      211 |                         zc.length = min(chunk_size, FILE_SZ - lu);
> 
> [...]

Here is the summary with links:
  - [net-next] selftests/net: fix typo in tcp_mmap
    https://git.kernel.org/netdev/net-next/c/905a9eb5f636

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


