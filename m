Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E4E9425392
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 15:00:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240801AbhJGNCK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 09:02:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:51518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240740AbhJGNCI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Oct 2021 09:02:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id EDB066117A;
        Thu,  7 Oct 2021 13:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633611614;
        bh=uIDXaQu59r8M0mhuQcxNZN3ShZz1DVm4UF6IknEVBDw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=u71Pg9M2Z6KworPMMLnq5Ys8OmtcTmn/gUu3cX/LOcmNdVn/JEUnzq65wuw99hqkT
         mwdRl7UjDM3RdjzdUviFBhZTSzHXeC6ae2N8C4sJ9S77o3RtRMpzG9JiZKLBb1HBX8
         QMdz1+RQGE9OnDmFezCvgYzPdMi7Tvi+EuGcTzPgzaSYhPXbxMy4SPBI7xKYekhOQU
         xlY6nrAR/gsttlPXWZuQOQJi6QHC3wE8p6qPEngWl2JhcG075PsVTLzFAZqKfsyEky
         xokKJhZkQSHnbwUUabI/bpQM9D/qozoRlVLK5xbKK+nd8xb+XYKtfzA4c7JtbxKoeE
         2FnuLuKAwJyhA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id DF25460A23;
        Thu,  7 Oct 2021 13:00:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: wireless-drivers-next-2021-10-07
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163361161390.30815.4394617074720651777.git-patchwork-notify@kernel.org>
Date:   Thu, 07 Oct 2021 13:00:13 +0000
References: <20211007080001.97852C43460@smtp.codeaurora.org>
In-Reply-To: <20211007080001.97852C43460@smtp.codeaurora.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net-next.git (refs/heads/master)
by David S. Miller <davem@davemloft.net>:

On Thu,  7 Oct 2021 08:00:01 +0000 (UTC) you wrote:
> Hi,
> 
> here's a pull request to net-next tree, more info below. Please let me know if
> there are any problems.
> 
> Kalle
> 
> [...]

Here is the summary with links:
  - pull-request: wireless-drivers-next-2021-10-07
    https://git.kernel.org/netdev/net-next/c/44cc24b04bed

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


