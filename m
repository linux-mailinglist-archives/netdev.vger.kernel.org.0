Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50B304A6105
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 17:10:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240855AbiBAQKN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 11:10:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240802AbiBAQKM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 11:10:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9D6BC061714
        for <netdev@vger.kernel.org>; Tue,  1 Feb 2022 08:10:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 67ACAB82D36
        for <netdev@vger.kernel.org>; Tue,  1 Feb 2022 16:10:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 23835C340ED;
        Tue,  1 Feb 2022 16:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643731810;
        bh=8JpoqqnYke4QgBWIf4+rjvEKW7OFpg9Kt7kGpd9OR4c=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=o+KymFmWheon1ilvxoVAHTM22rF+EmLS0WnJ//viFdRimfIhm9g+/Ey3m6rSqN93q
         rcT01sBU7ta0MOY2fIliV2WFMZ78DEAB0UqCypGHOYhlSxLT8oBtLvSBwaJprPK8My
         p8OT4iEUfh+S8oHC4tOZvJrQESSK6wiUyYV6fW3xpFx/rDyZxjY3Od6rE9NQpIZvHf
         UqUIez5Lbd0Yx/BdkkGuVMdpmPc4AibbEbx1f7dJSxFBh2qFmHaTAoiugLsuFSFysM
         TSt/gsVSmYcqklwfzgEauY8NfF2sJ/Em7ihOLSQdhuXSdADddLOeytd3wIaAYvodVb
         t+/y+mikg+7xQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0F6C4E5D08C;
        Tue,  1 Feb 2022 16:10:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH iproute2-next 1/2] tc_util: fix breakage from clang changes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164373181005.26399.969187929948949421.git-patchwork-notify@kernel.org>
Date:   Tue, 01 Feb 2022 16:10:10 +0000
References: <20220201042819.322106-1-stephen@networkplumber.org>
In-Reply-To: <20220201042819.322106-1-stephen@networkplumber.org>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     dsahern@gmail.com, netdev@vger.kernel.org, victor@mojatatu.com,
        jhs@mojatatu.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to iproute2/iproute2-next.git (main)
by David Ahern <dsahern@kernel.org>:

On Mon, 31 Jan 2022 20:28:18 -0800 you wrote:
> This fixes the indentation of types with newline flag.
> 
> Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
> ---
> The clang changes merged an earlier version of the changes
> to print_masked_type.
> 
> [...]

Here is the summary with links:
  - [iproute2-next,1/2] tc_util: fix breakage from clang changes
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=9948b6cb92c5
  - [iproute2-next,2/2] tc/f_flower: fix indentation
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=5f44590ddec5

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


