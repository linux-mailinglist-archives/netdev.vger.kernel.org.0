Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A7D348584A
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 19:30:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242949AbiAESae (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 13:30:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242942AbiAESaM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 13:30:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A31CC06118A;
        Wed,  5 Jan 2022 10:30:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 59778B81D0E;
        Wed,  5 Jan 2022 18:30:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 06859C36AF3;
        Wed,  5 Jan 2022 18:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641407410;
        bh=+J3HnZxk+4QJ8ogW2tzZ+jri+cDuSKj+ahhoaVQY0BQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=QZU/sQe0rDaUz4y4X37wu9+hxb+S/sOrdK3IDdnG1scGoSnguodDFt5RpLQ6Uc7ir
         pdui+p1XH/7j58jEdp3XW8EDaV6fpZp+MkBuWOJg10HIL9Ftb9VD2srXx9ZO6peAv9
         AQKdDlmolSIGKTC2bC0yqoLRFY95w8OoGK1N/R00TgRs9uwuIDXTwJQ667Pt9/l4Ts
         c9uzvVITIXdlFf4N9Z+Hq9V5EdF6PAGbTnHOhzPZwogAvwdnq592yzMJBd7hMpbC3J
         /asBO9EO1GLr/hhj2l8lyaCcOhVnQlXvwE65sWQKoWIclCXrkpDP4HdMmv2TUOcA41
         v2tQcOz62jPFA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E161CF79404;
        Wed,  5 Jan 2022 18:30:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] selftests: set amt.sh executable
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164140740991.21440.232631211017183713.git-patchwork-notify@kernel.org>
Date:   Wed, 05 Jan 2022 18:30:09 +0000
References: <20220105144436.13415-1-ap420073@gmail.com>
In-Reply-To: <20220105144436.13415-1-ap420073@gmail.com>
To:     Taehee Yoo <ap420073@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        shuah@kernel.org, linux-kselftest@vger.kernel.org,
        liuhangbin@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed,  5 Jan 2022 14:44:36 +0000 you wrote:
> amt.sh test script will not work because it doesn't have execution
> permission. So, it adds execution permission.
> 
> Reported-by: Hangbin Liu <liuhangbin@gmail.com>
> Fixes: c08e8baea78e ("selftests: add amt interface selftest script")
> Signed-off-by: Taehee Yoo <ap420073@gmail.com>
> 
> [...]

Here is the summary with links:
  - [net] selftests: set amt.sh executable
    https://git.kernel.org/netdev/net/c/db54c12a3d7e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


