Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC6523DA6D3
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 16:50:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237763AbhG2OuL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 10:50:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:49468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229864AbhG2OuI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Jul 2021 10:50:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 9C87A60EBB;
        Thu, 29 Jul 2021 14:50:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627570205;
        bh=j3Pa5yorPsCcmTNZNk48ih+QnX9PtTD6RceUgPazZz0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=WRYCvLymeY21tV22krNCcIWDmgjzpKmTzpNiMUrSYT5s/ahAwz9AHf9LK+AkBcRgX
         mZaR+KRQLq4J1HbSxYPC0v05Ud4xwkYsC9CYSqrFx+nsf/LcQTygMq0v+jiTyzPtYt
         PyvQEOOEACx+391XBVhUPVlZJ9R8I3jfiUpsp/7+OfQ2KRKSi8lESNJbxE0GYZhd7/
         2LY0NiR6SVJjQLxNJwqoGEJ/YJ6sPDQ/MiJRMtDNdKpm6uvEsjKXs3O2uR3+NH1kF9
         MD2XPIiqrZyP70x/0EbmhoxStfbKyoKaBK/MnzDJCp8gys57KdX1RGdb/ZWLpvcu9D
         HqqjFLwWPMMqg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 93E7460A7B;
        Thu, 29 Jul 2021 14:50:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] qede: Remove the qede module version
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162757020560.26339.12991898884828087680.git-patchwork-notify@kernel.org>
Date:   Thu, 29 Jul 2021 14:50:05 +0000
References: <20210729100042.10332-1-pkushwaha@marvell.com>
In-Reply-To: <20210729100042.10332-1-pkushwaha@marvell.com>
To:     Prabhakar Kushwaha <pkushwaha@marvell.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        malin1024@gmail.com, smalin@marvell.com, aelior@marvell.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Thu, 29 Jul 2021 13:00:42 +0300 you wrote:
> From: Shai Malin <smalin@marvell.com>
> 
> Removing the qede module version which is not needed and not allowed
> with inbox drivers.
> 
> Signed-off-by: Prabhakar Kushwaha <pkushwaha@marvell.com>
> Signed-off-by: Ariel Elior <aelior@marvell.com>
> Signed-off-by: Shai Malin <smalin@marvell.com>
> 
> [...]

Here is the summary with links:
  - qede: Remove the qede module version
    https://git.kernel.org/netdev/net-next/c/88ea96f8c14e

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


