Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 240C92FE178
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 06:21:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726014AbhAUFSM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 00:18:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:47022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726439AbhAUFLx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Jan 2021 00:11:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 916462395B;
        Thu, 21 Jan 2021 05:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611205809;
        bh=HaE3GOiqgQb70X7xxt/LkgczCAi2/i/OR54pIENbNio=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=VQR9y+4Kz6AyteY2h4wxhI5KnR0ozxfbYlEifTNvxADTSdDW8Z6rCZyszqbGgb/qk
         LBt80SiCOFKoQLag8n50uWbOOOXh4n/89HfXLwl2MI46FseB5GHPt6uqV3QOtipwKZ
         YSXe2uweHrapOKV2tVKl5WXRGF/xGT4JIPEgY9Txk54z3cAJFWaQBam2b6ZhgGq2Yb
         LPu/aXl/sgRjGo5eLiO2lOpok8AYJmJx0Z+lsO20t6dKb/1Q+IuY9jK4jcoFCUQyt8
         vFa20kiMhjanne2/p0xcXMEvmNMH4otG8bKcZJpTkSBoMSJUyjP5VCXDjnJbF6NBMa
         cITy0qi3Ek/JQ==
Received: from pdx-korg-docbuild-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-1.ci.codeaurora.org (Postfix) with ESMTP id 857EA600E0;
        Thu, 21 Jan 2021 05:10:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 0/4] net: inline rollback_registered() functions
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161120580954.27834.6435877219293871873.git-patchwork-notify@kernel.org>
Date:   Thu, 21 Jan 2021 05:10:09 +0000
References: <20210119202521.3108236-1-kuba@kernel.org>
In-Reply-To: <20210119202521.3108236-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Tue, 19 Jan 2021 12:25:17 -0800 you wrote:
> After recent changes to the error path of register_netdevice()
> we no longer need a version of unregister_netdevice_many() which
> does not set net_todo. We can inline the rollback_registered()
> functions into respective unregister_netdevice() calls.
> 
> v2: - add missing list_del() in the last patch
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/4] net: move net_set_todo inside rollback_registered()
    https://git.kernel.org/netdev/net-next/c/2014beea7eb1
  - [net-next,v2,2/4] net: inline rollback_registered()
    https://git.kernel.org/netdev/net-next/c/037e56bd965e
  - [net-next,v2,3/4] net: move rollback_registered_many()
    https://git.kernel.org/netdev/net-next/c/bcfe2f1a3818
  - [net-next,v2,4/4] net: inline rollback_registered_many()
    https://git.kernel.org/netdev/net-next/c/0cbe1e57a7b9

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


