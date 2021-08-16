Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D3E53ED1D7
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 12:21:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235591AbhHPKVn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 06:21:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:44974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231355AbhHPKUm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Aug 2021 06:20:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 6A56261B60;
        Mon, 16 Aug 2021 10:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629109206;
        bh=A/YyMG3PJJDSovra0u10iHEEeDzm9ncXn6CTRXBv2Ts=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=qu2iq3WSBnV9Rc/1kEZUj/4C1bQLCa4BqZbsleqSkrEd3j7iCk1x0GTbX2Y/Oatjb
         XAdzw02eaMQAb4i73uqMgJQ60sOBJyz+DmlBqjK/nbj8FQsuel/SuSwpQCzzCq0CdD
         7T/d+q4J20X2CNjg5zXsZ95z9yUx9bsDk+Inu8lxS3QX/PSsf/vRQsqZ0swPDgsspm
         qGfmYimz2R9vW9pWMOzjpsbQF1+rOq+un2Smvo+yAOCXJHAn4hnICzEMrUnTyi4Bc1
         n+afklETqPdu/CyOXDThfBT6ndLrE7ZjGEKBEibpRrp4Bd7mSOFMFAQVuZ1IxfvF7z
         RS70OryEv8uKg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 5F349609DA;
        Mon, 16 Aug 2021 10:20:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] af_unix: check socket state when queuing OOB
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162910920638.28018.12242686584030572656.git-patchwork-notify@kernel.org>
Date:   Mon, 16 Aug 2021 10:20:06 +0000
References: <20210813181934.647992-1-Rao.Shoaib@oracle.com>
In-Reply-To: <20210813181934.647992-1-Rao.Shoaib@oracle.com>
To:     Rao Shoaib <rao.shoaib@oracle.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, viro@zeniv.linux.org.uk,
        edumazet@google.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Fri, 13 Aug 2021 11:19:34 -0700 you wrote:
> edumazet@google.com pointed out that queue_oob
> does not check socket state after acquiring
> the lock. He also pointed to an incorrect usage
> of kfree_skb and an unnecessary setting of skb
> length. This patch addresses those issue.
> 
> Signed-off-by: Rao Shoaib <Rao.Shoaib@oracle.com>
> 
> [...]

Here is the summary with links:
  - af_unix: check socket state when queuing OOB
    https://git.kernel.org/netdev/net-next/c/19eed7210793

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


