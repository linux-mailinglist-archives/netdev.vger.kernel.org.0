Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 832A53453E1
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 01:31:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231246AbhCWAap (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 20:30:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:41226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230414AbhCWAaK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Mar 2021 20:30:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id AC3D9619A5;
        Tue, 23 Mar 2021 00:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616459409;
        bh=X9v4NcfD9rUYyBXtWv13v7WaeqrgwRJBdA965Ni4R+M=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=O0YkMefA6yW4sY8+/KlHUXZUaOMGZO7W5juL6LulAkDC3gcGUEHSlsVPGuDRsb9gO
         oC0UO+acd5gYwchPNUUfkXVzzNGL4OqhQ8s3bZ8QZlxpX2N1x6zSqWS8RmAlifQb9q
         3Bq5xyK5djvsJg//sa4cPYgU5LIdfuXq2hMNkcu25u9O4FAiz3ZOIw9DX4GDPF0+Tv
         Pk37zVM+aUUiVtjyzMeB5eM4xOjmOJFTTLZi/IEfYS8JdkfGKBnSO6bNr1uZw0C9wr
         qNlmLsdymCPicoP3pLgkC5fVlr6zn5rEMopnYk/90gSjPDhim6suer/0xeCYkn76AV
         dMjsCU3l1H7Cg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 9937E60A1B;
        Tue, 23 Mar 2021 00:30:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] isdn: capi: fix mismatched prototypes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161645940962.31154.6242142892110069086.git-patchwork-notify@kernel.org>
Date:   Tue, 23 Mar 2021 00:30:09 +0000
References: <20210322164447.876440-1-arnd@kernel.org>
In-Reply-To: <20210322164447.876440-1-arnd@kernel.org>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     isdn@linux-pingi.de, arnd@arndb.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Mon, 22 Mar 2021 17:44:29 +0100 you wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> gcc-11 complains about a prototype declaration that is different
> from the function definition:
> 
> drivers/isdn/capi/kcapi.c:724:44: error: argument 2 of type ‘u8 *’ {aka ‘unsigned char *’} declared as a pointer [-Werror=array-parameter=]
>   724 | u16 capi20_get_manufacturer(u32 contr, u8 *buf)
>       |                                        ~~~~^~~
> In file included from drivers/isdn/capi/kcapi.c:13:
> drivers/isdn/capi/kcapi.h:62:43: note: previously declared as an array ‘u8[64]’ {aka ‘unsigned char[64]’}
>    62 | u16 capi20_get_manufacturer(u32 contr, u8 buf[CAPI_MANUFACTURER_LEN]);
>       |                                        ~~~^~~~~~~~~~~~~~~~~~~~~~~~~~
> drivers/isdn/capi/kcapi.c:790:38: error: argument 2 of type ‘u8 *’ {aka ‘unsigned char *’} declared as a pointer [-Werror=array-parameter=]
>   790 | u16 capi20_get_serial(u32 contr, u8 *serial)
>       |                                  ~~~~^~~~~~
> In file included from drivers/isdn/capi/kcapi.c:13:
> drivers/isdn/capi/kcapi.h:64:37: note: previously declared as an array ‘u8[8]’ {aka ‘unsigned char[8]’}
>    64 | u16 capi20_get_serial(u32 contr, u8 serial[CAPI_SERIAL_LEN]);
>       |                                  ~~~^~~~~~~~~~~~~~~~~~~~~~~
> 
> [...]

Here is the summary with links:
  - isdn: capi: fix mismatched prototypes
    https://git.kernel.org/netdev/net/c/5ee7d4c7fbc9

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


