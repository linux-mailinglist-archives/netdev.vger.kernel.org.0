Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21B9A413FE9
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 05:10:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230430AbhIVDLh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Sep 2021 23:11:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:35214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230054AbhIVDLg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Sep 2021 23:11:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 13EB76115A;
        Wed, 22 Sep 2021 03:10:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632280207;
        bh=6FBTz2toAIgmo5Vr3DFfild0yN/e4opUzPVjNwZZp70=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=QwE63g/3LB6T5i8RpUdplYCAtFxIQgJ3hrH5gK9lmHiJjOpwikVZV9XlmHYt2r3b8
         bapww9+BnaC2Shie+okzQoc+u18axhavgOpmlXeHxRoSTDo6bPIyw8TXVYxjVuApRE
         pULfJVoqEFJlCf1Ej0XSxNV4LJwOZZ3uNZF+5zXrFh3AUst7sUgKoyRDd47dWt9w47
         PQpD7O1mdNzgZzjRH8SQTxBVYMpajZE47uSXEFrNvkea0bXuty7WcTR561UfdMNSmg
         k98h0sFOPAibMdkCZzJHRKaeJOOoCOqJ/b/YWcgMPDg8kCnvC42jcSLE9ADU4oREY1
         9mEGtsHrsYA3A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 02A7A60A7C;
        Wed, 22 Sep 2021 03:10:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/3] s390/qeth: fixes 2021-09-21
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163228020700.28047.10149739218296607530.git-patchwork-notify@kernel.org>
Date:   Wed, 22 Sep 2021 03:10:07 +0000
References: <20210921145217.1584654-1-jwi@linux.ibm.com>
In-Reply-To: <20210921145217.1584654-1-jwi@linux.ibm.com>
To:     Julian Wiedmann <jwi@linux.ibm.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, hca@linux.ibm.com,
        kgraul@linux.ibm.com, wintera@linux.ibm.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Tue, 21 Sep 2021 16:52:14 +0200 you wrote:
> Hi Dave & Jakub,
> 
> please apply the following patch series for qeth to netdev's net tree.
> 
> This brings two fixes for deadlocks when a device is removed while it
> has certain types of async work pending. And one additional fix for a
> missing NULL check in an error case.
> 
> [...]

Here is the summary with links:
  - [net,1/3] s390/qeth: fix NULL deref in qeth_clear_working_pool_list()
    https://git.kernel.org/netdev/net/c/248f064af222
  - [net,2/3] s390/qeth: Fix deadlock in remove_discipline
    https://git.kernel.org/netdev/net/c/ee909d0b1dac
  - [net,3/3] s390/qeth: fix deadlock during failing recovery
    https://git.kernel.org/netdev/net/c/d2b59bd4b06d

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


