Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEF0030E881
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 01:31:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233907AbhBDAav (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 19:30:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:35448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233165AbhBDAau (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Feb 2021 19:30:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id BE40264F68;
        Thu,  4 Feb 2021 00:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612398609;
        bh=VwFvB77n/PL54AUoVQDyHRx8OHIbHVpC1Cug2BU7Ucc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=nVmqxXgVi62kSW06vOcJ9RBX8EvDs1wLgvrNFp/pl1/EUqshU1Ol8rL88rIiiH0BT
         EGyyafVCpQZwKz6rgyHlAsycY6bCNlmN89LvFn0jXYaL5ThHU3uCg7N2u5IDVume0Q
         AevjuvuRfQvTnPdmepx6/ptjWQuXAqNTzI+GYBNm5H/TY5EsT2mOROexOQfiiTrggo
         MQz2wSOSsLUHe7LEB+8XrEc8BJl0RoQJrON9uT3ncI/NhkQAgPS/tWUaqAdzUdd3rB
         IbPNRH9BL2FlmJ7aoyYHxHRWAsSmYaqh19CiUnuM+8yJqBa8VT0arfuWDS7xKdvGmq
         teyh3wHK2jW9A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id B1487609EB;
        Thu,  4 Feb 2021 00:30:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next] libbpf: stop using feature-detection Makefiles
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161239860972.19398.7384749864414744822.git-patchwork-notify@kernel.org>
Date:   Thu, 04 Feb 2021 00:30:09 +0000
References: <20210203203445.3356114-1-andrii@kernel.org>
In-Reply-To: <20210203203445.3356114-1-andrii@kernel.org>
To:     Andrii Nakryiko <andrii@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@fb.com,
        daniel@iogearbox.net, kernel-team@fb.com, acme@redhat.com,
        rdunlap@infradead.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (refs/heads/master):

On Wed, 3 Feb 2021 12:34:45 -0800 you wrote:
> Libbpf's Makefile relies on Linux tools infrastructure's feature detection
> framework, but libbpf's needs are very modest: it detects the presence of
> libelf and libz, both of which are mandatory. So it doesn't benefit much from
> the framework, but pays significant costs in terms of maintainability and
> debugging experience, when something goes wrong. The other feature detector,
> testing for the presernce of minimal BPF API in system headers is long
> obsolete as well, providing no value.
> 
> [...]

Here is the summary with links:
  - [bpf-next] libbpf: stop using feature-detection Makefiles
    https://git.kernel.org/bpf/bpf-next/c/5f10c1aac8b2

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


