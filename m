Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF00F6427AD
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 12:40:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230522AbiLELkh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 06:40:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231168AbiLELkU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 06:40:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8F0B638A;
        Mon,  5 Dec 2022 03:40:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5AEF8B80EFE;
        Mon,  5 Dec 2022 11:40:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 086B8C433C1;
        Mon,  5 Dec 2022 11:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670240416;
        bh=Dnag4KYR87UxalELQSKEhSo9fyf55ONeAifg/ubORhc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=LInkuSFZcND/F0Ms/Y+axDZDPwnaHWJ3AoOUlNKnhCeFVReBQrXrTGYcSsspQFVyL
         xreVe2cFdwoWr2EwHV7C3u9UQC68FiCGf9G1wLBVzNfjZZxLJB0nS5bYqe3De+1WzZ
         i+AE/N7IIsbUIpaJImZ+/6GCTRZ4D2awTxNWvTyxc60u7j2fy1Z3DoqQWdxENggEj0
         JweQ8cWVHdL2QmU5sBTBip1JRmlmYymyN0Zpcb0+gmO/f/asqAaGIanJmKVZlugVOq
         sOZzvplK48/7J/pRkx2UWMvK0+xUgWCX+cNlne++n4+0lT8UtEpVjq+5BMoP+39d3Q
         Z+p15U9Yow7SQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id DDE7EC395E5;
        Mon,  5 Dec 2022 11:40:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] xen-netfront: Fix NULL sring after live migration
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167024041589.2981.8835947614822583831.git-patchwork-notify@kernel.org>
Date:   Mon, 05 Dec 2022 11:40:15 +0000
References: <7ae75e4582993c6d3e89511aec9c84426405f6a4.1669960461.git.lin.liu@citrix.com>
In-Reply-To: <7ae75e4582993c6d3e89511aec9c84426405f6a4.1669960461.git.lin.liu@citrix.com>
To:     Lin Liu <lin.liu@citrix.com>
Cc:     jgross@suse.com, sstabellini@kernel.org,
        oleksandr_tyshchenko@epam.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        xen-devel@lists.xenproject.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
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
by David S. Miller <davem@davemloft.net>:

On Fri, 2 Dec 2022 08:52:48 +0000 you wrote:
> A NAPI is setup for each network sring to poll data to kernel
> The sring with source host is destroyed before live migration and
> new sring with target host is setup after live migration.
> The NAPI for the old sring is not deleted until setup new sring
> with target host after migration. With busy_poll/busy_read enabled,
> the NAPI can be polled before got deleted when resume VM.
> 
> [...]

Here is the summary with links:
  - [net] xen-netfront: Fix NULL sring after live migration
    https://git.kernel.org/netdev/net/c/d50b7914fae0

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


