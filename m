Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A486407CBB
	for <lists+netdev@lfdr.de>; Sun, 12 Sep 2021 11:50:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232900AbhILJvW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Sep 2021 05:51:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:42998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229540AbhILJvU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 12 Sep 2021 05:51:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 84114610F9;
        Sun, 12 Sep 2021 09:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631440206;
        bh=4TRWOIiGVpoVJIYaFMIbs/S7yZrhcIKXwISgeXK9DQk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=gcfLYvlb/WhqPLUm4pUc/7cAgR7m4iwVnhuQRbXb85GmijCaUwCDdDp8BpG7wwGiA
         DiiGcDBSicxCLck2UOGLOlrOLuYIalykB66n4W8mF7YbkweNDaRnWVrMjFgG4LmTEL
         KJanGgKGUoC/V+TIqXac1fA74l/MQOqloVUoqUpPIoEx0PoEkBxKFsy358ZRdEryq2
         a6IKRyQGwrYYaeyk1aPr7iihsm8rsqmamS804VYcW7HtQgeibzej3h/c6rZTOnhIR7
         TBLsMmcIACj8h/9yjTP8R/Qe5kc/jcvrv18mDglZxDjRgI9P+x4+De3nMYmzgNeaEa
         rvKB6Ug7wb68g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 74FFC60A59;
        Sun, 12 Sep 2021 09:50:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] selftest: net: fix typo in altname test
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163144020647.29472.8920224532853672159.git-patchwork-notify@kernel.org>
Date:   Sun, 12 Sep 2021 09:50:06 +0000
References: <4e795ea14ace83249e256dc3845d3cd68ba3eefe.1631369140.git.aclaudi@redhat.com>
In-Reply-To: <4e795ea14ace83249e256dc3845d3cd68ba3eefe.1631369140.git.aclaudi@redhat.com>
To:     Andrea Claudi <aclaudi@redhat.com>
Cc:     netdev@vger.kernel.org, jiri@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Sat, 11 Sep 2021 16:14:18 +0200 you wrote:
> If altname deletion of the short alternative name fails, the error
> message printed is: "Failed to add short alternative name".
> This is obviously a typo, as we are testing altname deletion.
> 
> Fix this using a proper error message.
> 
> Fixes: f95e6c9c4617 ("selftest: net: add alternative names test")
> Signed-off-by: Andrea Claudi <aclaudi@redhat.com>
> 
> [...]

Here is the summary with links:
  - [net] selftest: net: fix typo in altname test
    https://git.kernel.org/netdev/net/c/1b704b27beb1

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


