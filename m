Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66F1F467EF9
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 21:50:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383145AbhLCUxl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Dec 2021 15:53:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383148AbhLCUxg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Dec 2021 15:53:36 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AF4FC061751;
        Fri,  3 Dec 2021 12:50:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E69EAB82958;
        Fri,  3 Dec 2021 20:50:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A28EFC53FCD;
        Fri,  3 Dec 2021 20:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638564609;
        bh=+LyUI9UGvz/92G8ph3KeFP+/xuF9YztjsVXxZA1G0S0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=t8dLH8BX0nW96BGVfcZYMa7bKF2Ca3Devsbwzz7xkH4TxhgiTztk44rqZcMlAwo3R
         CdmHkI/PwrIbOG663lufwnz5KKAHa3k0go8yEeF+g/1/YwsRgBTEvthi6pLcKI70Wq
         JDza5nEpP/6NDfPEch/cq6I4Ay/spKwI5NTgl8f/q+GRt8KzNIe4v1Pn1pzNQc3iEM
         ry9EisVVLNjUS0syGqujlOMrcIpVMyc5tJe3V8OyBUccE6BQrYxyi5Nq1iPAN3JTXn
         fCwk4kihh51aSRHcSQuMbmy605rvs0Z8qPqqo+Wp/w/C1NiB0tNkJRLOCf2+AzKNEX
         jKCfz+4lXkokA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 8580B60A7E;
        Fri,  3 Dec 2021 20:50:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf] bpf: Fix the off-by-two error in range markings
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163856460954.2307.15260762040124068016.git-patchwork-notify@kernel.org>
Date:   Fri, 03 Dec 2021 20:50:09 +0000
References: <20211130181607.593149-1-maximmi@nvidia.com>
In-Reply-To: <20211130181607.593149-1-maximmi@nvidia.com>
To:     Maxim Mikityanskiy <maximmi@nvidia.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, shuah@kernel.org,
        davem@davemloft.net, kuba@kernel.org, hawk@kernel.org,
        bpf@vger.kernel.org, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf.git (master)
by Daniel Borkmann <daniel@iogearbox.net>:

On Tue, 30 Nov 2021 20:16:07 +0200 you wrote:
> The first commit cited below attempts to fix the off-by-one error that
> appeared in some comparisons with an open range. Due to this error,
> arithmetically equivalent pieces of code could get different verdicts
> from the verifier, for example (pseudocode):
> 
>   // 1. Passes the verifier:
>   if (data + 8 > data_end)
>       return early
>   read *(u64 *)data, i.e. [data; data+7]
> 
> [...]

Here is the summary with links:
  - [bpf] bpf: Fix the off-by-two error in range markings
    https://git.kernel.org/bpf/bpf/c/2fa7d94afc1a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


