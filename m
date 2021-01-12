Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE4942F3D67
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 01:44:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436910AbhALVgp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 16:36:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:34090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2436693AbhALUKs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Jan 2021 15:10:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 63C562311B;
        Tue, 12 Jan 2021 20:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610482208;
        bh=kzLnAAo6DaFl6tQlXlsmcIWntMaynhpmD+pwnmmXGgc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=bN678i+tTmooT2a+J2VA69fKU3QbalK9020TgN86I2X9L/+GYbHDBXCTanM4W9yTC
         VWXMtuifs9+gK/NrCKzBwR7hWm6qEzdt1tABwxkmO3Xyx8iTI139/ENEmJ014/6cly
         Yz0iGMxqh88Ju3lkWhD1gdZ22gCvAVfqW6eSHHeT2SsX7JbK4T0+8DnFFtNvmaT77M
         TVppcv2DzX5os9ej1/fKsydg31LQCCsFfqOvw7OYweUzfrySgkG0UGUhH+gXhLrQMI
         w72KhVwa6y6/cmMCU2disFuJoJ+azkIgpgfXD0reL0fK+86XPwcdEE/IXRWTfy/HXQ
         rcOD/l/nBE4qQ==
Received: from pdx-korg-docbuild-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-1.ci.codeaurora.org (Postfix) with ESMTP id 5A30260354;
        Tue, 12 Jan 2021 20:10:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf v2] bpf: don't leak memory in bpf getsockopt when optlen
 == 0
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161048220836.29857.1971562068367304132.git-patchwork-notify@kernel.org>
Date:   Tue, 12 Jan 2021 20:10:08 +0000
References: <20210112162829.775079-1-sdf@google.com>
In-Reply-To: <20210112162829.775079-1-sdf@google.com>
To:     Stanislav Fomichev <sdf@google.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, kafai@fb.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf.git (refs/heads/master):

On Tue, 12 Jan 2021 08:28:29 -0800 you wrote:
> optlen == 0 indicates that the kernel should ignore BPF buffer
> and use the original one from the user. We, however, forget
> to free the temporary buffer that we've allocated for BPF.
> 
> Reported-by: Martin KaFai Lau <kafai@fb.com>
> Fixes: d8fe449a9c51 ("bpf: Don't return EINVAL from {get,set}sockopt when optlen > PAGE_SIZE")
> Signed-off-by: Stanislav Fomichev <sdf@google.com>
> 
> [...]

Here is the summary with links:
  - [bpf,v2] bpf: don't leak memory in bpf getsockopt when optlen == 0
    https://git.kernel.org/bpf/bpf/c/4be34f3d0731

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


