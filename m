Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E27B40DA22
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 14:41:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239906AbhIPMlt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Sep 2021 08:41:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:43258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239845AbhIPMl3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Sep 2021 08:41:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 7303860F46;
        Thu, 16 Sep 2021 12:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631796008;
        bh=/t8/SRS8NbJGE0zcQ/XCr31EnfvtR8eVVeSaIDu2uNo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Hv1Gq843khWpjlj0W4rehwZHT8MHhPwK6C+3EYdaZza4JkF0OWdkVPDbUZ4rTsXaV
         OoaUNOwIbbqoEt3fnulOHstq4L3imK83oUYX2mCB7fZrw4owXNm3xk1yMSCREKC4Ih
         j/Ea0YyZx9p7TAlToxbytlqmg3CBrTc7U1Mz5n4/3AVpNSOw27nHcKGFeTqK4xi59C
         ETYL0BBddar6vw26wC/6aO+YvCUXbOT6GiTsY0rIN8Ku69SLFW/vJdejzZmb42fkJX
         tTKSkubqbINmzAtNgRiiy7VZc6KcmvJ94E69Zl6hRDhOO2VDX5AFoMmZA41wF5EwKg
         5sz2FRxMZGLaw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 69C2460A9E;
        Thu, 16 Sep 2021 12:40:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: hinic: Make use of the helper function dev_err_probe()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163179600842.19379.10223404987723526794.git-patchwork-notify@kernel.org>
Date:   Thu, 16 Sep 2021 12:40:08 +0000
References: <20210915145835.7569-1-caihuoqing@baidu.com>
In-Reply-To: <20210915145835.7569-1-caihuoqing@baidu.com>
To:     Cai Huoqing <caihuoqing@baidu.com>
Cc:     luobin9@huawei.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 15 Sep 2021 22:58:34 +0800 you wrote:
> When possible use dev_err_probe help to properly deal with the
> PROBE_DEFER error, the benefit is that DEFER issue will be logged
> in the devices_deferred debugfs file.
> And using dev_err_probe() can reduce code size, and simplify the code.
> 
> Signed-off-by: Cai Huoqing <caihuoqing@baidu.com>
> 
> [...]

Here is the summary with links:
  - net: hinic: Make use of the helper function dev_err_probe()
    https://git.kernel.org/netdev/net-next/c/4fd3ff3b29ae

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


