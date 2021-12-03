Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EA45467955
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 15:20:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381455AbhLCOXk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Dec 2021 09:23:40 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:53406 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381425AbhLCOXh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Dec 2021 09:23:37 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B4244B827EA;
        Fri,  3 Dec 2021 14:20:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 61B52C56748;
        Fri,  3 Dec 2021 14:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638541210;
        bh=yV3wdHzXaKOwKj+kN5SAnF3kYw3yz1aTyYemhpCNt2Q=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=HmPx/dg5h69N4YEhu8fqd20nqRkamtWUyc5fVK/tuPAeOOyg8jkNaVU03Im3Aw1Qk
         RjBbXG+eoN9GYinYZJJ4bIrVQT1hLKCDOTfo1swFjnx8A9MTizfjl/8T31sDTPEj1H
         uLUjXon8cxq/9xCVp1diThFfmLtPmCItAxB46gjpx874VnAeqdvDKi1dXkq72mCFSY
         TrY+DzUGJp1C8kzHGlDX04DyeYuutzml2RfUBqtIAcGtQ/XzJ9oVqboW4drAAsHiqr
         ujgAomDVLCK9oA8MuAWSeQxqeSq7DFMUnbbxz7E9XozurbMz0uqUlJCfoHX1t7Sa8Q
         IJAc9iew1qurw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 48C9B60C76;
        Fri,  3 Dec 2021 14:20:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] selftests: net/fcnal-test.sh: add exit code
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163854121029.27426.1385573117041703444.git-patchwork-notify@kernel.org>
Date:   Fri, 03 Dec 2021 14:20:10 +0000
References: <20211203023213.5021-1-zhijianx.li@intel.com>
In-Reply-To: <20211203023213.5021-1-zhijianx.li@intel.com>
To:     Li Zhijian <zhijianx.li@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, shuah@kernel.org,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org, philip.li@intel.com, lkp@intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri,  3 Dec 2021 10:32:13 +0800 you wrote:
> Previously, the selftest framework always treats it as *ok* even though
> some of them are failed actually. That's because the script always
> returns 0.
> 
> It supports PASS/FAIL/SKIP exit code now.
> 
> CC: Philip Li <philip.li@intel.com>
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Li Zhijian <zhijianx.li@intel.com>
> 
> [...]

Here is the summary with links:
  - selftests: net/fcnal-test.sh: add exit code
    https://git.kernel.org/netdev/net/c/0f8a3b48f91b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


