Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC31C49E47D
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 15:20:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242298AbiA0OUR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 09:20:17 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:57048 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230206AbiA0OUP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 09:20:15 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8417EB822B1;
        Thu, 27 Jan 2022 14:20:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2BCA1C340EC;
        Thu, 27 Jan 2022 14:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643293213;
        bh=drD/99iubcEXh6VUfs07yNuLkBGqoS0MzBApa9Isd+8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=gwuuub6z2YY3ykgEqgP3TewRigaOF0Q/VB9SiF36HEMe0KiNG3C7E9otR645GDSXr
         cr3lpAz7unm9NMFVR2/gLuNUn78JIXDnfFYksTZAZOKhqDffvwTXMGZ6u+1lcFbQQQ
         OjTWwo4awjib10eg6he2O2hQY6ByB2hdHILyI45RxcHTsEVJYeongs0t+z2rzOv27g
         GnEd2rHe7B02wboFktMwvCts6rKiYM+RWNnhM2DgDdIK1crILXHI+pX0TdVBas1x6N
         xf/1r7o4Om75e2Yelu/eN+Sh8f5GrdKeei0KbTFJbCqbYCCHsyK0MYGpBgdkxKJr3q
         qAk+P4pV/D5nA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 19AA1E6BAC6;
        Thu, 27 Jan 2022 14:20:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] ptp: replace snprintf with sysfs_emit
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164329321310.24382.11763650540218634087.git-patchwork-notify@kernel.org>
Date:   Thu, 27 Jan 2022 14:20:13 +0000
References: <e4fa9680b8b939901adcf91123ab1778a0a7a38d.1643182187.git.yang.guang5@zte.com.cn>
In-Reply-To: <e4fa9680b8b939901adcf91123ab1778a0a7a38d.1643182187.git.yang.guang5@zte.com.cn>
To:     David Yang <davidcomponentone@gmail.com>
Cc:     richardcochran@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, yang.guang5@zte.com.cn,
        zealci@zte.com.cn
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 27 Jan 2022 08:02:36 +0800 you wrote:
> From: Yang Guang <yang.guang5@zte.com.cn>
> 
> coccinelle report:
> ./drivers/ptp/ptp_sysfs.c:17:8-16:
> WARNING: use scnprintf or sprintf
> ./drivers/ptp/ptp_sysfs.c:390:8-16:
> WARNING: use scnprintf or sprintf
> 
> [...]

Here is the summary with links:
  - ptp: replace snprintf with sysfs_emit
    https://git.kernel.org/netdev/net-next/c/e2cf07654efb

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


