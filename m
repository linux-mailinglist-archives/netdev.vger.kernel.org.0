Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA3B1440774
	for <lists+netdev@lfdr.de>; Sat, 30 Oct 2021 06:30:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231716AbhJ3Ecl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Oct 2021 00:32:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:41682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229606AbhJ3Eci (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 30 Oct 2021 00:32:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 88C7460F4B;
        Sat, 30 Oct 2021 04:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635568208;
        bh=+HNYF32DzIbwRMKjluXhoNWrmaH5cjZ7xumKusQNnfw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=OGImtsvj+cwzSbyyJOts8tI/xNWYGtMknOaZQt6ZfRjVjJ9X3PilamMpr6gf82eDp
         dYzeyiPyT1r76ZIHKy3ieSSs5o6aAkremfo/iOAxO6PnYzh9/5PnulP7XUSEsYBPSI
         F4IADJyQVyRQV7NuUwSo/vTGFjjDBMY35eCKo8RB94Qr5FSI5CHXgCy6YipCdvLn8g
         1RYW2iExXYF/XqgVZLyTi4jZkDwRlO3wt2d1YeOwi7I9q05uYNL1SkljJdWfVi34hk
         yq8ukft/V2IHIx2EoyRUfFBH4ACL9Tp+iAxLFnQL/PeTUuFXUDTGedPMnRUEO4gIV3
         vKhm82pDSqRMg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 7B0F260A47;
        Sat, 30 Oct 2021 04:30:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] bnxt_en: Remove not used other ULP define
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163556820849.7002.14853052068907393674.git-patchwork-notify@kernel.org>
Date:   Sat, 30 Oct 2021 04:30:08 +0000
References: <3a8ea720b28ec4574648012d2a00208f1144eff5.1635527693.git.leonro@nvidia.com>
In-Reply-To: <3a8ea720b28ec4574648012d2a00208f1144eff5.1635527693.git.leonro@nvidia.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, leonro@nvidia.com,
        linux-kernel@vger.kernel.org, michael.chan@broadcom.com,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 29 Oct 2021 20:18:15 +0300 you wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> There is only one bnxt ULP in the upstream kernel and definition
> for other ULP can be safely removed.
> 
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> 
> [...]

Here is the summary with links:
  - [net-next] bnxt_en: Remove not used other ULP define
    https://git.kernel.org/netdev/net-next/c/d269287761ab

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


