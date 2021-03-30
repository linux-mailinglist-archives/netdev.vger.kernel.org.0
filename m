Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F25634F2B6
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 23:01:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232558AbhC3VAm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 17:00:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:59974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232589AbhC3VAJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Mar 2021 17:00:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 94AF7619D2;
        Tue, 30 Mar 2021 21:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617138009;
        bh=OncdSW4JcucGRs101uXdj9r3gDT40CGVXwmSKMVjtQU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=CL5IJSaBJ64dVXSLZ2HXvfyinjMF0Y+8w5WXmwpQIf8Cs6IpLsS+NCF5Hpy2xnQRI
         TkR402DQzSbnBrX0kexB7vRp8Plb5exDlrITq45RbqpcusUEnBxk+FhrJNzgW/lMDV
         6GX79U1iFUD9W/xri4YajYXdKkrtIDBp23r/CHJjYnxq11dI2KGYOtzxasGEIdWWvu
         DmHT7SSAek0fz/wwoAs0VrJu2UR+/DltraK9wQKCjoIVv6vCuSM3CzTQx2B8jd7DS/
         K9D5yKSNsCxkJkticEKPkA6LfJSrYsMYZ1jL6rCavNjNEehDfyGdMxvq98Qp6B0KNU
         2bcwzuJ3dhBVw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 8F18760A3B;
        Tue, 30 Mar 2021 21:00:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] sch_htb: fix null pointer dereference on a null new_q
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161713800958.19867.14538661492222426931.git-patchwork-notify@kernel.org>
Date:   Tue, 30 Mar 2021 21:00:09 +0000
References: <1617114468-2928-1-git-send-email-wangyunjian@huawei.com>
In-Reply-To: <1617114468-2928-1-git-send-email-wangyunjian@huawei.com>
To:     wangyunjian <wangyunjian@huawei.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, xiyou.wangcong@gmail.com,
        jhs@mojatatu.com, jiri@resnulli.us, chenchanghu@huawei.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Tue, 30 Mar 2021 22:27:48 +0800 you wrote:
> From: Yunjian Wang <wangyunjian@huawei.com>
> 
> sch_htb: fix null pointer dereference on a null new_q
> 
> Currently if new_q is null, the null new_q pointer will be
> dereference when 'q->offload' is true. Fix this by adding
> a braces around htb_parent_to_leaf_offload() to avoid it.
> 
> [...]

Here is the summary with links:
  - [net] sch_htb: fix null pointer dereference on a null new_q
    https://git.kernel.org/netdev/net/c/ae81feb7338c

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


