Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 745F2349D95
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 01:21:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229979AbhCZAUj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 20:20:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:34684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229760AbhCZAUK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Mar 2021 20:20:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 454BB61A47;
        Fri, 26 Mar 2021 00:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616718010;
        bh=K28CxKpBygcwNzxyTTTRsvvZHGqBl3IumiPKXrYfIL4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=h3+B48LsUVi0LuEH/3WI7RjLN5luBS6vir8OXWcJSzgvcFLUqlBj+thiUuqswOAqB
         mZggFkRMO8W6X+bQh5/5o+Z4aafiRFPKbA+xWnlvxDH8dfdz5tSkh8NtSWma0POrTa
         vmYzJW53kkybwyACcLS64f2u0bVjXyafj0R6H6gfRtCgq5H9ZEDA8TekmdqpG7+GLc
         mQC1FD4PzngH+1dx0bzU2WHmxAFSrIClTMw4OsXv/EVJLk8vyS5eO+0YN23PN6B127
         nuaMcOdGjDdVDiGUtsrio4lQpt+9xpoOnzS6oFm+R5OkP51r008jy54vegluIkt0Kd
         GFuHl964vBfAg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 39B00625C0;
        Fri, 26 Mar 2021 00:20:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/2] net: gve: make cleanup for gve
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161671801023.29431.4174194340472988944.git-patchwork-notify@kernel.org>
Date:   Fri, 26 Mar 2021 00:20:10 +0000
References: <1616658992-135804-1-git-send-email-huangdaode@huawei.com>
In-Reply-To: <1616658992-135804-1-git-send-email-huangdaode@huawei.com>
To:     Daode Huang <huangdaode@huawei.com>
Cc:     csully@google.com, sagis@google.com, jonolson@google.com,
        davem@davemloft.net, kuba@kernel.org, awogbemila@google.com,
        yangchun@google.com, kuozhao@google.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Thu, 25 Mar 2021 15:56:30 +0800 you wrote:
> This patch set replace deprecated strlcpy by strscpy, remove
> repeat word "allowed" in gve driver.
> for more details, please refer to each patch.
> 
> Daode Huang (2):
>   net: gve: convert strlcpy to strscpy
>   net: gve: remove duplicated allowed
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] net: gve: convert strlcpy to strscpy
    https://git.kernel.org/netdev/net-next/c/c32773c96131
  - [net-next,2/2] net: gve: remove duplicated allowed
    https://git.kernel.org/netdev/net-next/c/f67435b555df

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


