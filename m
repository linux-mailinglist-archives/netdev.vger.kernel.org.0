Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D69664841DA
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 13:50:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233178AbiADMuN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 07:50:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233163AbiADMuM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 07:50:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E620C061761;
        Tue,  4 Jan 2022 04:50:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E05DEB81244;
        Tue,  4 Jan 2022 12:50:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id AFAECC36AF4;
        Tue,  4 Jan 2022 12:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641300609;
        bh=pqWgyV2GGCmf0gLVJa5+wLB4vn2ze4T0YwJBOVWaPJc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=aMej/ihQgn6yTboOAzvYwhFFcVhRuB4Iv1vboHyO3GFKGdlHSAHHdiy7OU7Xr5KOB
         gGG5WwFCJ5d/gPh51qi9WmTSGpw3cXsHTts/l1um+5YQGVgd9E1+Pc6yCsASMGrxv6
         DQRRdJ4EUyk0aB9/ICIJV1I40x8FRVu4coatlCA+v5bw/odOJ3AEX9C2ndntHOwZVI
         9LfSjF+yO1MLs890CsL2hR4tKSW6XCongPx0gV9M1ibanhCik9k508xoCTRj3nT3+S
         GyCoCqfOQbXfJoXRe///yjDyPwltIh6KxNh/TbybS35MlBX3f7EU4mFSft+MRrL8/t
         HejFELnmpd/wg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8ED38F79407;
        Tue,  4 Jan 2022 12:50:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 0/2] ipv4: Namespaceify two sysctls related with mtu
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164130060955.30501.3669535229260196174.git-patchwork-notify@kernel.org>
Date:   Tue, 04 Jan 2022 12:50:09 +0000
References: <20220104105739.601448-1-xu.xin16@zte.com.cn>
In-Reply-To: <20220104105739.601448-1-xu.xin16@zte.com.cn>
To:     CGEL <cgel.zte@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, xu.xin16@zte.com.cn, edumazet@google.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue,  4 Jan 2022 10:57:39 +0000 you wrote:
> From: xu xin <xu.xin16@zte.com.cn>
> 
> The following patch series enables the min_pmtu and mtu_expires to
> be visible and configurable per net namespace. Different namespace
> application might have different requirements on the setting of
> min_pmtu and mtu_expires.
> 
> [...]

Here is the summary with links:
  - [1/2] Namespaceify min_pmtu sysctl
    https://git.kernel.org/netdev/net-next/c/1de6b15a434c
  - [2/2] Namespaceify mtu_expires sysctl
    https://git.kernel.org/netdev/net-next/c/1135fad20480

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


