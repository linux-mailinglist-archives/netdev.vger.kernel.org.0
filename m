Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D29C56D2E32
	for <lists+netdev@lfdr.de>; Sat,  1 Apr 2023 06:50:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233179AbjDAEuX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Apr 2023 00:50:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229850AbjDAEuW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Apr 2023 00:50:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 710681A971
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 21:50:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3089EB83363
        for <netdev@vger.kernel.org>; Sat,  1 Apr 2023 04:50:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 973E6C433EF;
        Sat,  1 Apr 2023 04:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680324618;
        bh=lMBQ/CH19OTDiUqav8yotNWDzYV77pPzp0S3LsHOUr0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=NGXbq9pY0YyfTs0ju851CjqUJKNqsW/Zd03JQyF1jlV6ZeeMJOjYb10XmqjzYKjrU
         2t+A2r2hLhXBSo5/gw7hvUBmKGpXjEKXyYm+hyaum8tAQkj3/lIzFPCK2JxUXSeK16
         6Shk8uOZY735BPVk3McD8rUBTeQbOlWDib7mrrNJewnRQYsMJjHs9ojlLQCsAcoCJw
         PBEiliRS+s00mGzB/06W4e+teBQG+D3caLgi9zEByj9RbY/YUK+t03FJLPD6AzJQkp
         umghjgbgbWE6VuOKdMeDv0g9+nqlwGX6UtdFHND8zgLqis4EPB3ZL+jPJhZk/QCWaI
         DTZNUqAY5lSkA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 754C2E21EE4;
        Sat,  1 Apr 2023 04:50:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/3][pull request] Intel Wired LAN Driver Updates
 2023-03-30 (documentation, ice)
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168032461847.19187.8838065686054637783.git-patchwork-notify@kernel.org>
Date:   Sat, 01 Apr 2023 04:50:18 +0000
References: <20230330165935.2503604-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20230330165935.2503604-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (main)
by Tony Nguyen <anthony.l.nguyen@intel.com>:

On Thu, 30 Mar 2023 09:59:32 -0700 you wrote:
> This series contains updates to driver documentation and the ice driver.
> 
> Tony removes links and addresses related to the out-of-tree driver from the
> Intel ethernet driver documentation.
> 
> Jake removes a comment that is no longer valid to the ice driver.
> 
> [...]

Here is the summary with links:
  - [net-next,1/3] Documentation/eth/intel: Update address for driver support
    https://git.kernel.org/netdev/net-next/c/8ba732befd6f
  - [net-next,2/3] Documentation/eth/intel: Remove references to SourceForge
    https://git.kernel.org/netdev/net-next/c/79d872c62b16
  - [net-next,3/3] ice: remove comment about not supporting driver reinit
    https://git.kernel.org/netdev/net-next/c/503d473c983b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


