Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3B022FAF80
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 05:37:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731493AbhASEgA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 23:36:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:38322 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731396AbhASEat (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Jan 2021 23:30:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 335F4214D8;
        Tue, 19 Jan 2021 04:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611030609;
        bh=gczwcXhAY7/GZbRdQ7dlY2MKpfTICdaW8CtKl7frhzY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=l/yW+a96Ndwt0+l5AUNBRFboIahOvKYoFwfiFna+PlxvG9pfo3VrOXvrAb/NI4KYp
         GV6muUknUlD0YxtPNe0WAy7zY8BRKybpwXAH+YWpnLnqAAGQqA3BnxY1PkWa8niLOT
         SIuUIVjyrBVS7c1EEsRs5swYOH7jnVCSwNjjJtejFl4fvVrPMFvodZVTFh4EbkKmAg
         a18rQex2RqaKFTAk4pS1sVvlY2yFCAUq+owMYcsd/jRB28ljEdAiISS0JSIMPW6I8B
         LPjYBcmfLda0IFmOAXa/y+To7Xj9j+Gksk2rsjIzwqZ53cEfP20/sodJYDzcaTeehZ
         f9CvZ0P5uyJKg==
Received: from pdx-korg-docbuild-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-1.ci.codeaurora.org (Postfix) with ESMTP id 2576660460;
        Tue, 19 Jan 2021 04:30:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [Patch net-next] net_sched: fix RTNL deadlock again caused by
 request_module()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161103060914.4335.6975760467315017794.git-patchwork-notify@kernel.org>
Date:   Tue, 19 Jan 2021 04:30:09 +0000
References: <20210117005657.14810-1-xiyou.wangcong@gmail.com>
In-Reply-To: <20210117005657.14810-1-xiyou.wangcong@gmail.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     netdev@vger.kernel.org, cong.wang@bytedance.com,
        syzbot+82752bc5331601cf4899@syzkaller.appspotmail.com,
        syzbot+b3b63b6bff456bd95294@syzkaller.appspotmail.com,
        syzbot+ba67b12b1ca729912834@syzkaller.appspotmail.com,
        jhs@mojatatu.com, jiri@resnulli.us
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Sat, 16 Jan 2021 16:56:57 -0800 you wrote:
> From: Cong Wang <cong.wang@bytedance.com>
> 
> tcf_action_init_1() loads tc action modules automatically with
> request_module() after parsing the tc action names, and it drops RTNL
> lock and re-holds it before and after request_module(). This causes a
> lot of troubles, as discovered by syzbot, because we can be in the
> middle of batch initializations when we create an array of tc actions.
> 
> [...]

Here is the summary with links:
  - [net-next] net_sched: fix RTNL deadlock again caused by request_module()
    https://git.kernel.org/netdev/net-next/c/d349f9976868

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


