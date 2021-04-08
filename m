Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF7CA358EB9
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 22:50:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232386AbhDHUuV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 16:50:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:54296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231676AbhDHUuU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Apr 2021 16:50:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 07B7A61168;
        Thu,  8 Apr 2021 20:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617915009;
        bh=9TGPcz2atTpO6TbXEiz/3pY7ArrP+JIDGwM5z7gEF+Q=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=l6F4QpygFsxaswzQcSmqSpI2e7y6KAfL0PT1yn3ptgVbvrxHlAzsohQjfHSv+6uJp
         n8Nh5be4GlJUNDeMsja6mM3ERgz+7eK9qcO4mS+EMPw7axzr91YnjqnMY3bvwZOhIH
         vP0jIXyWg2DpG9aTIxA9uy6KHzqHltA8uLHALzFYoNAVFXbdsITOfPF0PLnRxfIoez
         O2+x1Y8Wxhtofc0a+H4NdoU1agnc4SCA0zxqK1KX7szkv24jQMhLpDe6rk+/FykDeE
         H1RoFEEDhdZ+92wnbmcwpORe6LoR+7aF418UpnuCp1K9xiFmtVE3jQe04aWL6ZZAnO
         7NTdMgo1OR22Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id EFE6160A71;
        Thu,  8 Apr 2021 20:50:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: qed: remove unused including <linux/version.h>
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161791500897.32359.12249669222869344285.git-patchwork-notify@kernel.org>
Date:   Thu, 08 Apr 2021 20:50:08 +0000
References: <1617865241-42742-1-git-send-email-tiantao6@hisilicon.com>
In-Reply-To: <1617865241-42742-1-git-send-email-tiantao6@hisilicon.com>
To:     Tian Tao <tiantao6@hisilicon.com>
Cc:     aelior@marvell.com, GR-everest-linux-l2@marvell.com,
        netdev@vger.kernel.org, songzhiqi1@huawei.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Thu, 8 Apr 2021 15:00:41 +0800 you wrote:
> Remove including <linux/version.h> that don't need it.
> 
> Signed-off-by: Tian Tao <tiantao6@hisilicon.com>
> Signed-off-by: Zhiqi Song <songzhiqi1@huawei.com>
> ---
>  include/linux/qed/qed_ll2_if.h | 1 -
>  1 file changed, 1 deletion(-)

Here is the summary with links:
  - net: qed: remove unused including <linux/version.h>
    https://git.kernel.org/netdev/net-next/c/fbe82b3db3e5

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


