Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AE3F584AEC
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 07:00:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234221AbiG2FAV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 01:00:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234028AbiG2FAT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 01:00:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35CC815810;
        Thu, 28 Jul 2022 22:00:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C583661E87;
        Fri, 29 Jul 2022 05:00:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 19C1FC43141;
        Fri, 29 Jul 2022 05:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659070816;
        bh=ts9QX6bXkNSNzxmknYoMkbHGOEsg8CSxlvBpXlATtG0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=iv3nBghkUxD3kFnMBstYk6NrotY/DTZ+Lb4ED1XqKfbFtzXTe27yAt2h6jIn+YaCQ
         JxfBJBPAMWbiNga17LIfHgPSYkyhwhuh7Pw6v++/nDdzkCPdge4KgUlwPu1du2h7sE
         ihskoOi3dM7XCmMWUbeAY3KvVyikt6cy5GDCEsAppLzA9HHnGr8Pq5PWP+XlJ/B9Z1
         5cnHxuPr9yHxRgq2hJ64qyhZnZ9Dc9rdQl3u8ZjBqF1os05ygSX5b9pbnCiJjE+NS4
         Cmv8EzxXjgu7cgs+sDND0fH724MyiZrHJyvYQ3mvLWd36pFkuqZh8u6QP1cKIAjMKp
         M3n7bCDNw4Cpg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id EE530C43144;
        Fri, 29 Jul 2022 05:00:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: usb: delete extra space and tab in blank line
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165907081597.3346.16848018508250716743.git-patchwork-notify@kernel.org>
Date:   Fri, 29 Jul 2022 05:00:15 +0000
References: <20220727081253.3043941-1-studentxswpy@163.com>
In-Reply-To: <20220727081253.3043941-1-studentxswpy@163.com>
To:     None <studentxswpy@163.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, oliver@neukum.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 27 Jul 2022 16:12:53 +0800 you wrote:
> From: Xie Shaowen <studentxswpy@163.com>
> 
> delete extra space and tab in blank line, there is no functional change.
> 
> Signed-off-by: Xie Shaowen <studentxswpy@163.com>
> ---
>  drivers/net/usb/catc.c       | 44 ++++++++++++++++++------------------
>  drivers/net/usb/cdc_subset.c | 10 ++++----
>  drivers/net/usb/kaweth.c     |  2 +-
>  drivers/net/usb/plusb.c      |  2 +-
>  drivers/net/usb/usbnet.c     |  2 +-
>  5 files changed, 30 insertions(+), 30 deletions(-)

Here is the summary with links:
  - [net-next] net: usb: delete extra space and tab in blank line
    https://git.kernel.org/netdev/net-next/c/efe3e6b5aeef

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


