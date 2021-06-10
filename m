Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 840193A35A3
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 23:10:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231389AbhFJVMJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 17:12:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:47474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231268AbhFJVMB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Jun 2021 17:12:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id A547161425;
        Thu, 10 Jun 2021 21:10:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623359404;
        bh=tepJxd2R/BsavcDBhc0HOMN+ui/IFgWclRdeD7RgmIk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=kK351N5VZceN9GrSFRUWBrpYRNeXWdq3PBDzUVwSZ3wE4LZO/aYxOGtsnbmANQLDX
         PEmotEx1uH0wHSG64FgfnnuG5VL5jasyQUbHgpXpYU+PqNdOad/5D1zZWS0IBghBlE
         XT+XtkO0NUQhKd7TIZKpdLTXHt0f25LqBZESfp9iI0Ib+INs9NzLA6ShsWUQ2T+pdB
         c1eDGsQ6Q5qxkRcLEKarXNIuMuQz+WZ3uzwrnsmw0YS551w8Xy24rTEQe2wTNiWyn5
         aJzMVhTtmK6Th1WuTPd9DGd+l8RQihaVSmJ6h3nDO16sSAyHFCLf3tJwopiJePNe0v
         cID02TUOJOzaA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 967E460D02;
        Thu, 10 Jun 2021 21:10:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH -next] dccp: tfrc: fix doc warnings in tfrc_equation.c
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162335940461.9889.13117955024428183893.git-patchwork-notify@kernel.org>
Date:   Thu, 10 Jun 2021 21:10:04 +0000
References: <20210610132603.597563-1-libaokun1@huawei.com>
In-Reply-To: <20210610132603.597563-1-libaokun1@huawei.com>
To:     Baokun Li <libaokun1@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, dccp@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        weiyongjun1@huawei.com, yuehaibing@huawei.com,
        yangjihong1@huawei.com, yukuai3@huawei.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Thu, 10 Jun 2021 21:26:03 +0800 you wrote:
> Add description for `tfrc_invert_loss_event_rate` to fix the W=1 warnings:
> 
>  net/dccp/ccids/lib/tfrc_equation.c:695: warning: Function parameter or
>   member 'loss_event_rate' not described in 'tfrc_invert_loss_event_rate'
> 
> Signed-off-by: Baokun Li <libaokun1@huawei.com>
> 
> [...]

Here is the summary with links:
  - [-next] dccp: tfrc: fix doc warnings in tfrc_equation.c
    https://git.kernel.org/netdev/net-next/c/cb8e2e4300fc

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


