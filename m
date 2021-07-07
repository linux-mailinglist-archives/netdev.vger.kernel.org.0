Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8ACD3BE21D
	for <lists+netdev@lfdr.de>; Wed,  7 Jul 2021 06:30:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229717AbhGGEcn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Jul 2021 00:32:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:36270 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229460AbhGGEcm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Jul 2021 00:32:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 14EE161C7F;
        Wed,  7 Jul 2021 04:30:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625632203;
        bh=RJuBN5lmc5xSl9bwxEeKOHT1X58QYuur2Dbrk8PVZ5M=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=KiwAcFIDc1LshZzSGeL5tGdIKawpSUqxXUAsFxbE1VJ9iP0nDvqzzxM/pb7D2OmvP
         ylj6fYfWF/tKFQeeb5niP5+ol8Gl+nSgBaTTylXV+IfQn6Zh5A67pHBTBfB6QpvDIv
         mCoGBb2zRHIcejDm2VUNjZptDUMMyu2F0s3KZUStWHv7e4Tkl3AnkyHJ8Z16FAj4o0
         ZjdXEEfv2UUKHGEdQUcwmA5vrUnvBj5D+kIRMKaFIu0beep7j6G8zd4qwmaehKfKDn
         qu/unda1t25hU+ykxmenTzPI8qN76j3QnxjCXpSut9j7OdtFjWcE4iOlS6KIOjT9qe
         Sa/0eGR+3YMRw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 07C3C609AD;
        Wed,  7 Jul 2021 04:30:03 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf] libbpf: restore errno return for functions that were
 already returning it
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162563220302.16281.6970918426494037005.git-patchwork-notify@kernel.org>
Date:   Wed, 07 Jul 2021 04:30:03 +0000
References: <20210706122355.236082-1-toke@redhat.com>
In-Reply-To: <20210706122355.236082-1-toke@redhat.com>
To:     =?utf-8?b?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2VuIDx0b2tlQHJlZGhhdC5jb20+?=@ci.codeaurora.org
Cc:     andrii@kernel.org, bpf@vger.kernel.org, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf.git (refs/heads/master):

On Tue,  6 Jul 2021 14:23:55 +0200 you wrote:
> The update to streamline libbpf error reporting intended to change all
> functions to return the errno as a negative return value if
> LIBBPF_STRICT_DIRECT_ERRS is set. However, if the flag is *not* set, the
> return value changes for the two functions that were already returning a
> negative errno unconditionally: bpf_link__unpin() and perf_buffer__poll().
> 
> This is a user-visible API change that breaks applications; so let's revert
> these two functions back to unconditionally returning a negative errno
> value.
> 
> [...]

Here is the summary with links:
  - [bpf] libbpf: restore errno return for functions that were already returning it
    https://git.kernel.org/bpf/bpf/c/af0efa050caa

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


