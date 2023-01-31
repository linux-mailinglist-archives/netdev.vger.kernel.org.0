Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD6FF6823A1
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 06:10:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229956AbjAaFK0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 00:10:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229880AbjAaFKU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 00:10:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D77124490;
        Mon, 30 Jan 2023 21:10:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 52F10B81985;
        Tue, 31 Jan 2023 05:10:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EB41AC4339E;
        Tue, 31 Jan 2023 05:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675141817;
        bh=xTOZGGWvovyr1Zhs1zk7wctK5EnEaaMitztFKQnR00I=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=L33nTl4YSbN+O9IgKxxDdWnQUkB6aepHnpiLYmylZ1H0nFJJNA6h5+FMBr9sfoY6e
         ToZ95mykT5xdGu2GKKBBYtmKL6CpRMSbhMm1MYJuvA7slqr5hIWR4NovuxPEbioeQn
         wbSAbvK3PAsM8APA1XEK4boJKfjFxyzhBlACB3uqx0b5QSssqy9+0lDNFITZ5mkF0d
         REk2J8d7UpKIJ5espizDWiAgVf2yglGnMZ1r1pCvF0WNFaBmZqWfaQYrT47lMPrnTH
         QRYV0YQNSKx74kdpKdbkv4xA1WKn2YPdfGTAzS93ntJ6JMD/WgaxxZP5clYcrtLlhL
         a6h67hPJqM5cA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D7E5BC1614B;
        Tue, 31 Jan 2023 05:10:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] sh: checksum: add missing linux/uaccess.h include
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167514181688.11863.771497291150527329.git-patchwork-notify@kernel.org>
Date:   Tue, 31 Jan 2023 05:10:16 +0000
References: <20230128073108.1603095-1-kuba@kernel.org>
In-Reply-To: <20230128073108.1603095-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, ysato@users.sourceforge.jp, dalias@libc.org,
        linux-sh@vger.kernel.org
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 27 Jan 2023 23:31:08 -0800 you wrote:
> SuperH does not include uaccess.h, even tho it calls access_ok().
> 
> Fixes: 68f4eae781dd ("net: checksum: drop the linux/uaccess.h include")
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> CC: ysato@users.sourceforge.jp
> CC: dalias@libc.org
> CC: linux-sh@vger.kernel.org
> 
> [...]

Here is the summary with links:
  - [net-next] sh: checksum: add missing linux/uaccess.h include
    https://git.kernel.org/netdev/net-next/c/2083656bb30d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


