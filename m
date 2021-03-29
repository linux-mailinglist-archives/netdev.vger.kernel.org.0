Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D533134DC79
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 01:30:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230402AbhC2XaN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 19:30:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:40054 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230329AbhC2XaJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Mar 2021 19:30:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 4E95F619AD;
        Mon, 29 Mar 2021 23:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617060609;
        bh=MMAITfiyicp/WxswzbZCB0B7qxpcn4ft+zl1YYnv+dU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=X5LVD+s7FJzCyEGx7ijqsZwkEJyjVonjW+xouaaw6Ax7/nptmFAyDWdX6ZSDYYFum
         so5iJO8rGilzTfhi6GUDWoHe6RmhstzwdFJUOOLcIAXyhicUmuAAHir1qt8KfmTu2G
         qNF/yseB8rOj7leBn/QwTU+GVyScd1lGisk5FwsfJuwdXM3gH+JWeBQUcFookW4wY8
         EBt25Jtz6FUiiwS6EL50J3qo/6DJzvb5DioWlLv2c5VH7CUy26lMEAGUqJDOrCA0m3
         ILbYBdrc6smRrUU79oHVffN5QR4ZiCiIq+6fJcPUn0O/TacpNIVd5PyXUt6pg27mkm
         PMhu3HzywZLxg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 494B360074;
        Mon, 29 Mar 2021 23:30:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] ieee802154: hwsim: remove redundant initialization of
 variable res
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161706060929.18537.14903111106609831882.git-patchwork-notify@kernel.org>
Date:   Mon, 29 Mar 2021 23:30:09 +0000
References: <20210329112354.87503-1-colin.king@canonical.com>
In-Reply-To: <20210329112354.87503-1-colin.king@canonical.com>
To:     Colin King <colin.king@canonical.com>
Cc:     alex.aring@gmail.com, stefan@datenfreihafen.org,
        davem@davemloft.net, kuba@kernel.org, linux-wpan@vger.kernel.org,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon, 29 Mar 2021 12:23:54 +0100 you wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> The variable res is being initialized with a value that is
> never read and it is being updated later with a new value.
> The initialization is redundant and can be removed.
> 
> Addresses-Coverity: ("Unused value")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> 
> [...]

Here is the summary with links:
  - ieee802154: hwsim: remove redundant initialization of variable res
    https://git.kernel.org/netdev/net-next/c/24ad92c841c9

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


