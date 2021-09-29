Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70AD141BC01
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 03:00:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243553AbhI2BBu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 21:01:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:52906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243521AbhI2BBt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Sep 2021 21:01:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 62206613D0;
        Wed, 29 Sep 2021 01:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632877207;
        bh=4ntuuqobgpC4pwkcswEOHa5njU23sxBo1ci+pXNHnNU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=rOz9XTIHgDA9kjXbFQsV6JPgRpKll/oYUYqys0Nwx9e2nV6F33n3nf0C0ZGaezSYZ
         ybDcZxeDDSo8gNbNgJy11GOLDesjkIIGgWRslSy2QJg36ZVNKIvIXqkrokKeMGKKAc
         M5+7Ubz88QHDYt4Knw73GBi+7K13w0gQJxNN294HtXmOU5GcWTcZSRLsASRSbtrqPZ
         d+9gz7Q3lBoYv/t0J1HVc7P0CvzkH3wJIVDE7vwQIR37w+wrxFtjMc2xxk3SewUA9R
         zAl86Ltrf9cjhSyISn3I5uTdVGqnYHJjcTsqV3LIUqIirz/s2ookflpZiA3j3lvrPd
         5Hrag1yqyH+SA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 573CE608FE;
        Wed, 29 Sep 2021 01:00:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: qrtr: combine nameservice into main module
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163287720735.1190.7481361805015480385.git-patchwork-notify@kernel.org>
Date:   Wed, 29 Sep 2021 01:00:07 +0000
References: <20210928171156.6353-1-luca@z3ntu.xyz>
In-Reply-To: <20210928171156.6353-1-luca@z3ntu.xyz>
To:     Luca Weiss <luca@z3ntu.xyz>
Cc:     linux-arm-msm@vger.kernel.org,
        ~postmarketos/upstreaming@lists.sr.ht, mani@kernel.org,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue, 28 Sep 2021 19:11:57 +0200 you wrote:
> Previously with CONFIG_QRTR=m a separate ns.ko would be built which
> wasn't done on purpose and should be included in qrtr.ko.
> 
> Rename qrtr.c to af_qrtr.c so we can build a qrtr.ko with both af_qrtr.c
> and ns.c.
> 
> Signed-off-by: Luca Weiss <luca@z3ntu.xyz>
> 
> [...]

Here is the summary with links:
  - net: qrtr: combine nameservice into main module
    https://git.kernel.org/netdev/net-next/c/a365023a76f2

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


