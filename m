Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 956CF42B011
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 01:20:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233603AbhJLXWK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 19:22:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:44922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229588AbhJLXWJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Oct 2021 19:22:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id F046560EB6;
        Tue, 12 Oct 2021 23:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634080807;
        bh=YCaYVjkcwjPrsoyCaSeUGdtWpkb0UI6VuvFjqcPNRJk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ZEb54yobX/QrX4/YU5btWQPquVTH7a8Vmi6Pon5RBPRMFRnY7UBy4dAzlQHDZCMg2
         GbS2t2YecvZ/CXQRaDjavXhug6MTohers16RYTNwZmQ1Ge32qT9B948e/GC2XDkS9h
         V3Q45N4q0xX7Ex5CRIZZUapEAWoZFFcxSHmjt90PVs93jqejDU0UNwjEQyU4K86Asx
         1kGD7j25EChma7GzabfrqRgsPkbZWOVUzGTonNhCZqDQ56RShuzNZcuIAYeihjTjw8
         Tn72u15hA+lEJzAndxfte6BhwqHuuKC2cDYcfL3n96tL5k1VzzKAZJuYP0s20BNlt3
         ByUw+3D0mKJ/g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id E360E60989;
        Tue, 12 Oct 2021 23:20:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] nfp: flow_offload: move flow_indr_dev_register from app
 init to app start
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163408080692.16326.11276933838018698438.git-patchwork-notify@kernel.org>
Date:   Tue, 12 Oct 2021 23:20:06 +0000
References: <20211012124850.13025-1-louis.peens@corigine.com>
In-Reply-To: <20211012124850.13025-1-louis.peens@corigine.com>
To:     Louis Peens <louis.peens@corigine.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        oss-drivers@corigine.com, simon.horman@corigine.com,
        baowen.zheng@corigine.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 12 Oct 2021 14:48:50 +0200 you wrote:
> From: Baowen Zheng <baowen.zheng@corigine.com>
> 
> In commit 74fc4f828769 ("net: Fix offloading indirect devices dependency
> on qdisc order creation"), it adds a process to trigger the callback to
> setup the bo callback when the driver regists a callback.
> 
> In our current implement, we are not ready to run the callback when nfp
> call the function flow_indr_dev_register, then there will be error
> message as:
> 
> [...]

Here is the summary with links:
  - [v2] nfp: flow_offload: move flow_indr_dev_register from app init to app start
    https://git.kernel.org/netdev/net/c/60d950f443a5

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


