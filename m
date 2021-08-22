Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B82573F4196
	for <lists+netdev@lfdr.de>; Sun, 22 Aug 2021 22:50:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233191AbhHVUuu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Aug 2021 16:50:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:33888 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233019AbhHVUut (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 22 Aug 2021 16:50:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 2843761356;
        Sun, 22 Aug 2021 20:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629665408;
        bh=BBusbWPFRwmEvG3HpKuJ7ruvlYLvRLHv8PB13wgdl/0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=PWKVozzWTw1s1HdRo4pnB1ntlWqiQCPlfljVHFQeL8fZfxqtZEk4VDEC9Z6J7uIA+
         OiRhlugT14degPbfcO/TKsdI6hUpuYPBAVy4Hd0YIo24GZKFWkc97gVKFEnc1O0jr7
         zscYyLx1VetKNh0irGSejykytmmlqpS3epPsG2ZOHLzhdEPfc3zMpT0qQnwadPc8N2
         S8/6JoHurapbHwBLXdCUXajyCv6QSJWoPsSmgIS4a262RRk8nvWUtrYsx+trdgIcMG
         i5A7gIejq793N6lL+LX+dL44hdfGLZdHeikPZ+Es/jeAB4tCrm6yJ+TQRHYFQei1N5
         I4r2K3WL6QfEw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 1CDCB60AA1;
        Sun, 22 Aug 2021 20:50:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/4] mlxsw: Refactor parsing configuration
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162966540811.2709.14909922004255328605.git-patchwork-notify@kernel.org>
Date:   Sun, 22 Aug 2021 20:50:08 +0000
References: <20210822113716.1440716-1-idosch@idosch.org>
In-Reply-To: <20210822113716.1440716-1-idosch@idosch.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        jiri@nvidia.com, amcohen@nvidia.com, mlxsw@nvidia.com,
        idosch@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Sun, 22 Aug 2021 14:37:12 +0300 you wrote:
> From: Ido Schimmel <idosch@nvidia.com>
> 
> The Spectrum ASIC has a configurable limit on how deep into the packet
> it parses. By default, the limit is 96 bytes.
> 
> There are several cases where this parsing depth is not enough and there
> is a need to increase it: Decapsulation of VxLAN packets and
> timestamping of PTP packets.
> 
> [...]

Here is the summary with links:
  - [net-next,1/4] mlxsw: spectrum: Add infrastructure for parsing configuration
    https://git.kernel.org/netdev/net-next/c/2d91f0803b84
  - [net-next,2/4] mlxsw: Convert existing consumers to use new API for parsing configuration
    https://git.kernel.org/netdev/net-next/c/0071e7cdc386
  - [net-next,3/4] mlxsw: Remove old parsing depth infrastructure
    https://git.kernel.org/netdev/net-next/c/c3d2ed93b14d
  - [net-next,4/4] mlxsw: spectrum_router: Increase parsing depth for multipath hash
    https://git.kernel.org/netdev/net-next/c/43c1b83305fa

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


