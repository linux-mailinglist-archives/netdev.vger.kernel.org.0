Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5037C4025F9
	for <lists+netdev@lfdr.de>; Tue,  7 Sep 2021 11:10:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244703AbhIGJLN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Sep 2021 05:11:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:45560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243468AbhIGJLM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Sep 2021 05:11:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 5925F61102;
        Tue,  7 Sep 2021 09:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631005806;
        bh=uPbfy4mODdIz4BjAVSEGBJX/mpjICUVdEQbd7dDa7k4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=XpQH2Po+oHFilzA1jwKByu9ZlpRnXV3MFn/9Qd2zpj/q2XW1jXk4TJYBNJUwIMid3
         ftyA9YwyiVVh/r8EqIFI6WR+BLJ2A8gyoJFIh/CVG2hmXEeZlCq+jZtwp4/AHo1JfO
         qwyGCH19tAX25uYa18+YEGBUZL04sRlitQuLou6Hmgpo7PrMujekM7uTWjyqtOqDAs
         Q4w5GyNuOkLMuu7OtOwVk8cg3eUJmR66N10t8WGkCVmcrShQHA2+G3bZC4n/3+U9WT
         ZJhGKUEQnxkdGnhtORleccFNNmKi2pdDlNoA2kuNNbIXEKRxeAoYEaDMVN26fcnTe9
         ITXEOA4+6q57g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 4D979609F5;
        Tue,  7 Sep 2021 09:10:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: wireless-drivers-2021-09-07
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163100580631.1890.9498522128656095721.git-patchwork-notify@kernel.org>
Date:   Tue, 07 Sep 2021 09:10:06 +0000
References: <20210907033842.CE38EC43460@smtp.codeaurora.org>
In-Reply-To: <20210907033842.CE38EC43460@smtp.codeaurora.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net.git (refs/heads/master):

On Tue,  7 Sep 2021 03:38:42 +0000 (UTC) you wrote:
> Hi,
> 
> here's a pull request to net tree, more info below. Please let me know if there
> are any problems.
> 
> Kalle
> 
> [...]

Here is the summary with links:
  - pull-request: wireless-drivers-2021-09-07
    https://git.kernel.org/netdev/net/c/8f110f35f962

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


