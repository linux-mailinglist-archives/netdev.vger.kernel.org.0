Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D86F53F1942
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 14:30:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239585AbhHSMar (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 08:30:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:47406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238208AbhHSMan (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Aug 2021 08:30:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 6350761155;
        Thu, 19 Aug 2021 12:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629376207;
        bh=3fy6RbaEo/xaTXFYKa98Ao5xySvoF4T0jDtR6J6cUj0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=goPtPoAoP9lu8CP+zWfX/rlbMb9Lou+dQBGrU9BSUYxPIHqDYPbx8PFuoq/2cYFs/
         vNXgZJAUk8uTEz+6/dP209I1c9dYwli2yjm9KU81wxwbuH99u0kYi+RyQYh1nYskCO
         Mg5T93swo45fIIxe+lLAtBiTD8ssSci7NvSr5pG9aJoxh4aZjG832aYokDUwWmLc9q
         HD0K2fZHgQ/O0dSpZcnpo8jdsxdfC0HJU6zHem5OcKJKv3AVybKokyEjBB4Q89IWWz
         Wfy/rk0tOHmHVh18Clmx8OMY53yII8lVlywuzolf9yiJVI3ilKWD4hoWOpXOTau6T3
         yWJd8/RZgfhHw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 5B07560A89;
        Thu, 19 Aug 2021 12:30:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: hns3: make array spec_opcode static const,
 makes object smaller
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162937620736.15458.15267386747257846939.git-patchwork-notify@kernel.org>
Date:   Thu, 19 Aug 2021 12:30:07 +0000
References: <20210819115813.6692-1-colin.king@canonical.com>
In-Reply-To: <20210819115813.6692-1-colin.king@canonical.com>
To:     Colin King <colin.king@canonical.com>
Cc:     yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        davem@davemloft.net, kuba@kernel.org, tanhuazhong@huawei.com,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Thu, 19 Aug 2021 12:58:13 +0100 you wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> Don't populate the array spec_opcode on the stack but instead it
> static const. Makes the object code smaller by 158 bytes:
> 
> Before:
>    text   data   bss     dec    hex filename
>   12271   3976   128   16375   3ff7 .../hisilicon/hns3/hns3pf/hclge_cmd.o
> 
> [...]

Here is the summary with links:
  - net: hns3: make array spec_opcode static const, makes object smaller
    https://git.kernel.org/netdev/net-next/c/0bc277cb8234

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


