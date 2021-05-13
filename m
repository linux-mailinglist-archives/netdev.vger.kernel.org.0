Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B92D38009F
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 01:00:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231380AbhEMXBe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 May 2021 19:01:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:48716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231304AbhEMXBV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 May 2021 19:01:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 787A361451;
        Thu, 13 May 2021 23:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620946811;
        bh=WEEshH/I0CTWbbVGnSeUhz6+zr/M4z1QD6IYwewhkAc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=VftNXR0oQnmr7zKlpEg1GCMI1Qn4MPpqWOayrkhfGWMPwAJhsUZ+FDkPOWyC65jUI
         zNbz8p/cVQHHAT58a/KtM11RkdO1/fueAe8k91gT7r/8LVJdayiGNtEzY/PVzoRPMA
         rtSDxcTQhZ+ScgoY1SI/4KlBXGnZzTpVmv8d+sgZOdYDYKHv68GCio+6rZ0B/maBPK
         q+rwT+W4Pt71yFGgB1AOJKefJtWjBFpaCQtS6KQDDCfkCojv9tLtGULpx6eFbwo7m4
         9W5gocHjvhnmu17VFSgoEAp2CYJXiTnc6obQp5H/yMlAGKeFR1A9wONtXMBWFsxj4r
         MOQHGHd1xbR0g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 7281760970;
        Thu, 13 May 2021 23:00:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: caif: Drop unnecessary NULL check after container_of
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162094681146.5074.4595668618085728465.git-patchwork-notify@kernel.org>
Date:   Thu, 13 May 2021 23:00:11 +0000
References: <20210513165840.1339544-1-linux@roeck-us.net>
In-Reply-To: <20210513165840.1339544-1-linux@roeck-us.net>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Thu, 13 May 2021 09:58:40 -0700 you wrote:
> The first parameter passed to chnl_recv_cb() can never be NULL since all
> callers dereferenced it. Consequently, container_of() on it is also never
> NULL, even though the reference into the structure points to the first
> element of the structure. The NULL check is therefore unnecessary.
> On top of that, it is misleading to perform a NULL check on the result of
> container_of() because the position of the contained element could change,
> which would make the test invalid. Remove the unnecessary NULL check.
> 
> [...]

Here is the summary with links:
  - net: caif: Drop unnecessary NULL check after container_of
    https://git.kernel.org/netdev/net-next/c/0f3ee280331e

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


