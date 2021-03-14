Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA65533A251
	for <lists+netdev@lfdr.de>; Sun, 14 Mar 2021 03:18:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233733AbhCNCKW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Mar 2021 21:10:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:52942 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232974AbhCNCKI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 13 Mar 2021 21:10:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 3A52864EDC;
        Sun, 14 Mar 2021 02:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615687808;
        bh=ViSUvwFz8dZsSC/xLMKQlypmn/cz7whpRd8DW1ygRoU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=tyQeyAgGvm1EjOs2YXizdSG7f1DXxDi/4Y8d4GM/6c9bpuoJb2gURotQL+jcuhxsn
         WIZ2Xyta3Fx3VngsXcl1WbyCrx3r78MYNsfakH4Z3+QSIc/KtPr1gRcsFkFl2kPt10
         HWSnCKK8vgWMXEVLNnkt76Kf6sZDwWDdkqF3gWjXQj8PpdFy1yq70MRA262/tSVYHG
         9sxtVNF1wjDLnoSNgKaK+xGASLG0M189P5uBxhzMJY4JOPa/9/2yDLgKM8ZzvjUS4B
         mv9cLa4pURDopODBwT6U2QdwjARxEF67WYt3gbQ7nT0rArNelf3MMrwqAbOe1Gim+t
         HHsdg2H7JcaYw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 2BAEC60A5C;
        Sun, 14 Mar 2021 02:10:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] drivers: net: vxlan.c: Fix declaration issue
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161568780817.10930.7181255867706244302.git-patchwork-notify@kernel.org>
Date:   Sun, 14 Mar 2021 02:10:08 +0000
References: <20210313083649.2scdqxdcozfpoana@sanjana-VirtualBox>
In-Reply-To: <20210313083649.2scdqxdcozfpoana@sanjana-VirtualBox>
To:     Sanjana Srinidhi <sanjanasrinidhi1810@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bkkarthik@pesu.pes.edu
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Sat, 13 Mar 2021 14:06:49 +0530 you wrote:
> Added a blank line after structure declaration.
> This is done to maintain code uniformity.
> 
> Signed-off-by: Sanjana Srinidhi <sanjanasrinidhi1810@gmail.com>
> ---
>  drivers/net/vxlan.c | 1 +
>  1 file changed, 1 insertion(+)

Here is the summary with links:
  - drivers: net: vxlan.c: Fix declaration issue
    https://git.kernel.org/netdev/net-next/c/6fadbdd6dd32

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


