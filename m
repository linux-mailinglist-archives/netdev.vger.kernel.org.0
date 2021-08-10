Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00A103E58EF
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 13:20:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240044AbhHJLU1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 07:20:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:47200 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237252AbhHJLU0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Aug 2021 07:20:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 0C0CE60EBB;
        Tue, 10 Aug 2021 11:20:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628594405;
        bh=hwedIZTUGsa3SEjAxhAa5W23ygt2a2mYnoO9/Y0NCzo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=GD2JamTSOOtUAViYJVd4q2cSFMtY+TguTnvb3dhZpeH1tqV/cGatAM15ec7SAkw98
         RLX4xWkOMdUJwuRYmO55aPgk6OQr4u3UprC15ZeE9m0XMxOqQ0xRxjoWX4fFdmNJGa
         6eKSLDYyPlldCNe5oabl1/H8hmFlzCwb4+V1ij5xRKWDAb9JjupdnQmKiHk6HFG95A
         e+dziFNe0Q6wMEbnrba4vWILtcPxy/YHQchIN8CVNT3OA7XTa0MioqYqiNCwIEHjqG
         RUcrv7p8MzinXT/ty0d5LWb/14tot+GMnb2KlyJOZ6+bK5FvMlgPBZr18j6qyKefys
         7tye4LrV9uKmA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id F3B3460A3B;
        Tue, 10 Aug 2021 11:20:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] bpf: core: fix kernel-doc notation
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162859440499.8510.15547475703902558278.git-patchwork-notify@kernel.org>
Date:   Tue, 10 Aug 2021 11:20:04 +0000
References: <20210809215229.7556-1-rdunlap@infradead.org>
In-Reply-To: <20210809215229.7556-1-rdunlap@infradead.org>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, bpf@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf.git (refs/heads/master):

On Mon,  9 Aug 2021 14:52:29 -0700 you wrote:
> Fix kernel-doc warnings in kernel/bpf/core.c (found by
> scripts/kernel-doc and W=1 builds).
> 
> Correct a function name in a comment and add return descriptions
> for 2 functions.
> 
> Fixes these kernel-doc warnings:
> 
> [...]

Here is the summary with links:
  - bpf: core: fix kernel-doc notation
    https://git.kernel.org/bpf/bpf/c/019d0454c617

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


