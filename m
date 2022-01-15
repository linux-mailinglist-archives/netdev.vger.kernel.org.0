Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62D3B48F3AF
	for <lists+netdev@lfdr.de>; Sat, 15 Jan 2022 02:01:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231322AbiAOBAO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jan 2022 20:00:14 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:34122 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbiAOBAN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jan 2022 20:00:13 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 00357CE24C5;
        Sat, 15 Jan 2022 01:00:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3F812C36AEA;
        Sat, 15 Jan 2022 01:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642208409;
        bh=mK8RlZtmgrkSHVB8/Qo9CsH7FJoAG438jfe55xe5CwM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=iIjYRxmFC3jyo6p5vVqDEoii4K/95e3l4BzmAKlqItf3F/X4GwVyq/+swyzj7mmub
         bWbqFu1hsfcnfaaKAIVaXZIgDVluEcYmpLJ8bPBXnB7u7YvLRfqylDKpi6Hg+LvSFl
         JgbO3cBj3jwK340w8KNZCawtGGPLaxJNNihLvwGIP2RLZuE0LezaBZUfsTlpu6Wr1c
         TQkJC3LSiuXf5TYgVrucELsyyJ3MIPJHsXcMmJde30xJEl+ZmrLEZ08tKm7OT9N6mq
         hroa5mesetSO8Ry/GHidb7n/df22XFuatjX0TdvYTnilDQhZYwqxYYJrjldFYZ0st7
         JOw+LtYneJ+fg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 25F4AF6079A;
        Sat, 15 Jan 2022 01:00:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf] tools/resolve_btfids: build with host flags
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164220840915.32473.3734511457879421361.git-patchwork-notify@kernel.org>
Date:   Sat, 15 Jan 2022 01:00:09 +0000
References: <20220112002503.115968-1-connoro@google.com>
In-Reply-To: <20220112002503.115968-1-connoro@google.com>
To:     Connor O'Brien <connoro@google.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (master)
by Andrii Nakryiko <andrii@kernel.org>:

On Wed, 12 Jan 2022 00:25:03 +0000 you wrote:
> resolve_btfids is built using $(HOSTCC) and $(HOSTLD) but does not
> pick up the corresponding flags. As a result, host-specific settings
> (such as a sysroot specified via HOSTCFLAGS=--sysroot=..., or a linker
> specified via HOSTLDFLAGS=-fuse-ld=...) will not be respected.
> 
> Fix this by setting CFLAGS to KBUILD_HOSTCFLAGS and LDFLAGS to
> KBUILD_HOSTLDFLAGS.
> 
> [...]

Here is the summary with links:
  - [bpf] tools/resolve_btfids: build with host flags
    https://git.kernel.org/bpf/bpf-next/c/0e3a1c902ffb

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


