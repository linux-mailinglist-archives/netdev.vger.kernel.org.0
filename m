Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8FF232F54A
	for <lists+netdev@lfdr.de>; Fri,  5 Mar 2021 22:30:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229517AbhCEVaT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Mar 2021 16:30:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:53780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229488AbhCEVaH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Mar 2021 16:30:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 42DC0650A5;
        Fri,  5 Mar 2021 21:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614979807;
        bh=DTONL60yEpVRMvsgkLaTmP8j8bp5a2QBpaR+fUy8OOQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=mIH5yr/Id4rvxl9Mrwzc7P2UfDx4hxYVO6SxzXaUCNRBqfWvHaQpfmTTkR0uHAFTt
         ++ffVLs//ObkblamZEK4XVYXEn1jF+yiuVe+tayTMVflgO4Wj6GH29+/s/aLM+dOZ4
         1VTzqjHk3SML/sFYlGCByObNAx4mV3BLvQW+EYL7DDSNgTz4xnvXm78XHJoxpdvmxa
         uylYf2dreNlm5Pzk/x7zHZVXvI6alL1Sjv/rnjhD0zWQhrcm94Ng5nsTMA/uOKZBar
         MgyTv69oRIqlqRmO2TtUlEg3YmbFEJc36r25fVSpb8aKcEbJM05nJt1ioL5PnEyPHR
         2Bel4nFb4TC3g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 3BB4660A13;
        Fri,  5 Mar 2021 21:30:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCHv2] gianfar: fix jumbo packets+napi+rx overrun crash
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161497980724.1292.9780244989230491690.git-patchwork-notify@kernel.org>
Date:   Fri, 05 Mar 2021 21:30:07 +0000
References: <20210304195252.16360-1-michael-dev@fami-braun.de>
In-Reply-To: <20210304195252.16360-1-michael-dev@fami-braun.de>
To:     Michael Braun <michael-dev@fami-braun.de>
Cc:     claudiu.manoil@nxp.com, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Thu,  4 Mar 2021 20:52:52 +0100 you wrote:
> From: Michael Braun <michael-dev@fami-braun.de>
> 
> When using jumbo packets and overrunning rx queue with napi enabled,
> the following sequence is observed in gfar_add_rx_frag:
> 
>    | lstatus                              |       | skb                   |
> t  | lstatus,  size, flags                | first | len, data_len, *ptr   |
> 
> [...]

Here is the summary with links:
  - [PATCHv2] gianfar: fix jumbo packets+napi+rx overrun crash
    https://git.kernel.org/netdev/net/c/d8861bab48b6

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


