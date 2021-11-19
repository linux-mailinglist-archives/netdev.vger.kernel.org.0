Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBBD145707E
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 15:20:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235809AbhKSOXS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 09:23:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:58750 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234615AbhKSOXR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Nov 2021 09:23:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 62C68619E3;
        Fri, 19 Nov 2021 14:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637331609;
        bh=BSNW4ptDwaVEVLXQrsHdEluqzO3Hj/8cwTWAHtFXq3U=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=R7HDDh4ZUeMKCq32Ukjsy1ZuAV1sZXRInd4rljU36H1TsUcF0Q5fnINvymm3gCIL5
         81wlDyimZDhcgBAz/ZPJcd2MXAs1RGPDr2Usv0oWubwARjyk6grlIX3YmPFMufp1DJ
         8LiBHRYlTTvXnCl07aXa5/6sdPTdkAMLUXiUoRpJ1YJsrdCcuDicSTSJa3B08Dd1oy
         IM6uHEuly2uhvDXjXb86M3NVHgPNRpS48N5eBt67jmDH39uuF75DBI1jGkPdoKHMyc
         ARtwy4NfL/9K69sXVAWJXjADtFkQ8H+XbRWG/Q320UhHtx92mySW6rSZGQjQnfhBkW
         fd6YrzJvno2Tg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 57A5B60A0F;
        Fri, 19 Nov 2021 14:20:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] nfp: flower: correction of error handling
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163733160935.14640.6949962515977497155.git-patchwork-notify@kernel.org>
Date:   Fri, 19 Nov 2021 14:20:09 +0000
References: <20211119085801.3879-1-simon.horman@corigine.com>
In-Reply-To: <20211119085801.3879-1-simon.horman@corigine.com>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        oss-drivers@corigine.com, yu.xiao@corigine.com,
        yinjun.zhang@corigine.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 19 Nov 2021 09:58:01 +0100 you wrote:
> From: Yu Xiao <yu.xiao@corigine.com>
> 
> Removing reduplicated error handling when running into error path
> of `nfp_compile_flow_metadata`.
> 
> Signed-off-by: Yu Xiao <yu.xiao@corigine.com>
> Signed-off-by: Yinjun Zhang <yinjun.zhang@corigine.com>
> Signed-off-by: Simon Horman <simon.horman@corigine.com>
> 
> [...]

Here is the summary with links:
  - [net-next] nfp: flower: correction of error handling
    https://git.kernel.org/netdev/net-next/c/eaa54d66145e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


