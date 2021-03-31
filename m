Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1099E34F56A
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 02:21:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232686AbhCaAUj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 20:20:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:43872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231701AbhCaAUK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Mar 2021 20:20:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 9D8AC619A7;
        Wed, 31 Mar 2021 00:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617150010;
        bh=6kSL9gs4I6to6gpb9c/w1ktYJp1T1wUwDqb+3use/xg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=FG9m+jXhO1gD3LN3WQHhIRX+K5kZADBfDnsDLUgxNXmZMkaGwDLHM/dZN1yxP503Y
         P2VfnYvrHhI2By+EoYoJg554kFpCOiQQwhG7s6bSwUBbV5F5zwgY2DJ3e3u3yipcaa
         si/T6Y/Z5GocFTnIq7MKs7p5hPccqTpoWrWbiaFXcinxMTJCaludLtJkDGGBugC5aM
         c7F9EKLfQXG9jAEVhg7OUU2aYHEf52pqDDm+TReqP4GPyy0s+uJ0ES5lOBFSV7M9b9
         0kAA/GPIszROxZjl3wUhD8sI/PPCgPGqHsIuKASy808IhyjIHf0znWmTn91mNMIWwR
         vAqNfS38C6/qA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 8F1B860A72;
        Wed, 31 Mar 2021 00:20:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] tc-testing: add simple action change test
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161715001058.3850.13772855808502684032.git-patchwork-notify@kernel.org>
Date:   Wed, 31 Mar 2021 00:20:10 +0000
References: <20210330104110.25360-1-vladbu@nvidia.com>
In-Reply-To: <20210330104110.25360-1-vladbu@nvidia.com>
To:     Vlad Buslov <vladbu@nvidia.com>
Cc:     memxor@gmail.com, xiyou.wangcong@gmail.com, davem@davemloft.net,
        jhs@mojatatu.com, jiri@resnulli.us, kuba@kernel.org,
        toke@redhat.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue, 30 Mar 2021 13:41:10 +0300 you wrote:
> Use act_simple to verify that action created with 'tc actions change'
> command exists after command returns. The goal is to verify internal action
> API reference counting to ensure that the case when netlink message has
> NLM_F_REPLACE flag set but action with specified index doesn't exist is
> handled correctly.
> 
> Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
> 
> [...]

Here is the summary with links:
  - [net-next] tc-testing: add simple action change test
    https://git.kernel.org/netdev/net-next/c/e48792a9ec78

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


