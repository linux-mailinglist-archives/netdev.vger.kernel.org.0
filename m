Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB572348628
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 02:00:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239469AbhCYBAZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 21:00:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:51062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239444AbhCYBAJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Mar 2021 21:00:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id BBADC61A13;
        Thu, 25 Mar 2021 01:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616634008;
        bh=c1GsxziC1SL/5Zo/0LfKJx/xYjd+9aMHtvY+RB2yUm0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=jLyMYnJ65yDa41x7HeNc3IwlcJtvfjJ0UWO54PtbIuFKBY49WNVrxlO7jWGbcSz2i
         dmxKbn0j9W/eQ2X0QKceB0PVWAkDHkS8oAP+CRXFgN0vPlWkF7CCthy4mUNZ+b87De
         +9Hk8wGtm1T+MznCQZ0ssFaFat+LVkvGrrj7iXPxeJIf2ycqJwtTcrUVXfHmfK3wVA
         fs2Dxdy5bVlBX15JKvajLJ8X0XrouX4yQzegbGjrbcqnrzmwkFoVXyfFulYFyfz1Ju
         UbDlD77dJupfhh0aUC2DotNWIP0wYC1w55nQNPGhf6VPhTYchWqTcjUvDeF1l3cSBg
         OOucnSM57Z9TQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id AB69060A6A;
        Thu, 25 Mar 2021 01:00:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] 6lowpan: Fix some typos in nhc_udp.c
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161663400869.21739.6444031329527811807.git-patchwork-notify@kernel.org>
Date:   Thu, 25 Mar 2021 01:00:08 +0000
References: <20210324062224.13032-1-wanghai38@huawei.com>
In-Reply-To: <20210324062224.13032-1-wanghai38@huawei.com>
To:     Wang Hai <wanghai38@huawei.com>
Cc:     alex.aring@gmail.com, jukka.rissanen@linux.intel.com,
        davem@davemloft.net, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, linux-wpan@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 24 Mar 2021 14:22:24 +0800 you wrote:
> s/Orignal/Original/
> s/infered/inferred/
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Wang Hai <wanghai38@huawei.com>
> ---
>  net/6lowpan/nhc_udp.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Here is the summary with links:
  - [net-next] 6lowpan: Fix some typos in nhc_udp.c
    https://git.kernel.org/netdev/net-next/c/da1da87fa7fc

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


