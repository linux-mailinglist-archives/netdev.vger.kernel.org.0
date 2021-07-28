Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68B2E3D8D60
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 14:00:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236217AbhG1MAM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 08:00:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:54974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234758AbhG1MAG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Jul 2021 08:00:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 519C060F91;
        Wed, 28 Jul 2021 12:00:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627473605;
        bh=+w8uRcP+PlyXqAXzjRgqMr0AStxVrxmXG3ZtiR4di0E=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=W1m/Hwc7ks22bh8vEscMNQoex/R6L8qfcoQMuShZdk6W/rI6fud08y+oDYv9Sm45p
         VGcxMjc83TibxSdgByP08J/HjoScYZpDnaiwVohFzOkQmXLlN9MsKlaDWxjIythBn3
         6FhvNbUmI/1Tqx8KZLvsFaEpUTKsoy/ZNZeMb3gWb0DEH+tfGlMcj75oyT7DfADmsc
         fjlUcwyK0bO7xA2FmMz4WSkSXPdksvI0KLdrCzvj1C+SEv9XDJshueOCAs+ua5rDHc
         QlxY/Zd6E+W6N2X61KSqxeESbpGVKsEiITsviZezYgufswnkHiCjXGAGpx5fDriItv
         a+6Jd4geJZS4w==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 40F0760A6C;
        Wed, 28 Jul 2021 12:00:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: let flow have same hash in two directions
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162747360526.13277.18400122814387528993.git-patchwork-notify@kernel.org>
Date:   Wed, 28 Jul 2021 12:00:05 +0000
References: <20210728105418.7379-1-zhangkaiheb@126.com>
In-Reply-To: <20210728105418.7379-1-zhangkaiheb@126.com>
To:     zhang kai <zhangkaiheb@126.com>
Cc:     davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, krzysztof.kozlowski@canonical.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed, 28 Jul 2021 18:54:18 +0800 you wrote:
> using same source and destination ip/port for flow hash calculation
> within the two directions.
> 
> Signed-off-by: zhang kai <zhangkaiheb@126.com>
> ---
>  net/core/flow_dissector.c | 18 +++++++++---------
>  1 file changed, 9 insertions(+), 9 deletions(-)

Here is the summary with links:
  - net: let flow have same hash in two directions
    https://git.kernel.org/netdev/net/c/1e60cebf8294

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


