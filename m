Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D44D838B7F4
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 22:00:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239558AbhETUBh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 16:01:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:54420 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238332AbhETUBc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 May 2021 16:01:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 00D7B6135C;
        Thu, 20 May 2021 20:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621540810;
        bh=RkzgR3UO/59f5ZMiYTFtG/ZRLkG7zTixNPT6XKlHaHA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Uiy92zDfdemgsNbWBHSg7eUoPEgbJp5oI0H4Hf+RExZHSjv0Rf3O8UMZrG2q6uOud
         0EiemV8YR7p2Ed1AHncTk/zNx0lVq8VoL7bUveZmE8+photQEKvMP4roIy60IVWFfc
         jbLiEq+TdJvQL2nBTNU/E6YDyPBU3WuLgp67DS3V7WCUgVRqEwhCTMo1KAU0+eZCNh
         TDv9J5CaPgEeffgKQBRUc8pF+i0teuFZEqmk0NjjhiwJ+lhdll8SeIcTW5pR6kKWcM
         rEDtHBw0PbVuBZ83U9IXDOuNO39p14NDSwYu0u9rv9uY1P6tlsEuHMcWlO/KlVmsWv
         Q8Y2Zk32gRIlg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id E985F60A4F;
        Thu, 20 May 2021 20:00:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] selftests: Add .gitignore for nci test suite
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162154080995.16251.177596405013047761.git-patchwork-notify@kernel.org>
Date:   Thu, 20 May 2021 20:00:09 +0000
References: <20210519213333.3947830-1-dmatlack@google.com>
In-Reply-To: <20210519213333.3947830-1-dmatlack@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     netdev@vger.kernel.org, linux-nfc@lists.01.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        bongsu.jeon@samsung.com, shuah@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed, 19 May 2021 21:33:33 +0000 you wrote:
> Building the nci test suite produces a binary, nci_dev, that git then
> tries to track. Add a .gitignore file to tell git to ignore this binary.
> 
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
>  tools/testing/selftests/nci/.gitignore | 1 +
>  1 file changed, 1 insertion(+)
>  create mode 100644 tools/testing/selftests/nci/.gitignore

Here is the summary with links:
  - selftests: Add .gitignore for nci test suite
    https://git.kernel.org/netdev/net/c/8570e75a5543

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


