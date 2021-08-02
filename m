Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07D9E3DE22C
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 00:10:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233146AbhHBWKc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 18:10:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:56948 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232097AbhHBWKQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Aug 2021 18:10:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 878E860FC1;
        Mon,  2 Aug 2021 22:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627942206;
        bh=7Smff6jAz9XqHy6/lmnG1SQ23TKAWtJBRH7fNgctK68=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=s3kW8DyRGURB7i8OJ2aj6B0VdBoKj/OiP3v1yMyccuU4rjpCOf2Do1HTw2twGhkg3
         YwWz4TNwFMokKOiPJplSyOD/I7z8DvzGGq3VpyXovhlQGW/aYqbRVUlNsn4WTz6/CK
         RbrRl6q3E3/P3b+OXHzWg5xk5DwZHTEiGPlOMPXEMgnT17NcrStEB2MqoF2BhEVXFF
         pdQGfBiA5j2LPn16A2N9CqMcmr6RA1sWbIaEhpc9LN5IvJNyb3VRRSij674eJyxmyM
         k2DGe5p/nC7+JQIriHigdM52StzYEfmDLYGp/UARQi6DO6QKCFJD7uDaNHnCFEZUH+
         j/zxszptA0NVQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 7B5CF60A45;
        Mon,  2 Aug 2021 22:10:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] qlcnic: make the array random_data static const,
 makes object smaller
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162794220650.7989.7845752677380482646.git-patchwork-notify@kernel.org>
Date:   Mon, 02 Aug 2021 22:10:06 +0000
References: <20210801151659.146113-1-colin.king@canonical.com>
In-Reply-To: <20210801151659.146113-1-colin.king@canonical.com>
To:     Colin King <colin.king@canonical.com>
Cc:     shshaikh@marvell.com, manishc@marvell.com,
        GR-Linux-NIC-Dev@marvell.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Sun,  1 Aug 2021 16:16:59 +0100 you wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> Don't populate the array random_data on the stack but instead it
> static const. Makes the object code smaller by 66 bytes.
> 
> Before:
>    text    data     bss     dec     hex filename
>   52895   10976       0   63871    f97f ../qlogic/qlcnic/qlcnic_ethtool.o
> 
> [...]

Here is the summary with links:
  - qlcnic: make the array random_data static const, makes object smaller
    https://git.kernel.org/netdev/net-next/c/a6afdb041a2d

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


