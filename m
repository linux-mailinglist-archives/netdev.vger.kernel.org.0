Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EDC32D89F9
	for <lists+netdev@lfdr.de>; Sat, 12 Dec 2020 21:32:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407874AbgLLUbJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Dec 2020 15:31:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:55588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726572AbgLLUaz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 12 Dec 2020 15:30:55 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607805014;
        bh=id7snsBAJzpijXDLvnlTS/2oL18B8cE2j11JlhXYRjk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=YAC8tXr5UaOgtUIjsvfbRNtsjl0+2HQidQCTHpXhmifWeeKKx4VOg5GedQmFe1H1N
         lYFd6lx9Ic9325tck5PepX4/vFovxIHdJSLv2m1l6Cr89YqnqpWf9kWGm1JXUvVKk2
         whJ4IpuB72p0b/AbfdDFa8xaK2BTSj6uOzQ/R8TAu6xSdy9FeCx//b5nQDAmXGbk2C
         oDbUQKRjfVUPY8HpUDFt8DRGaj+HHzYLGKBLxJDjjVwl2BIZn7qFAPbUyDttXRFzJL
         SP8SGQRt6bcuDH9ldM+Vg0UtoSPQcR/40Wk0qxlGrV0mv9kvwPkBckJukhdw0PlFSj
         1E/eWRY3jUqUw==
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: wireless-drivers-next-2020-12-12
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160780501439.18453.6643968659386890631.git-patchwork-notify@kernel.org>
Date:   Sat, 12 Dec 2020 20:30:14 +0000
References: <20201212050839.EF50EC433C6@smtp.codeaurora.org>
In-Reply-To: <20201212050839.EF50EC433C6@smtp.codeaurora.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net-next.git (refs/heads/master):

On Sat, 12 Dec 2020 05:08:39 +0000 (UTC) you wrote:
> Hi,
> 
> here's a pull request to net-next tree, more info below. Please let me know if
> there are any problems.
> 
> Kalle
> 
> [...]

Here is the summary with links:
  - pull-request: wireless-drivers-next-2020-12-12
    https://git.kernel.org/netdev/net-next/c/e5795aacd71b

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


