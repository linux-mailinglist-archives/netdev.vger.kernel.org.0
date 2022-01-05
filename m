Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47CA148597D
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 20:51:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243703AbiAETux (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 14:50:53 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:50874 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243740AbiAETuL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 14:50:11 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 871F9618EC;
        Wed,  5 Jan 2022 19:50:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E7811C36AF2;
        Wed,  5 Jan 2022 19:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641412210;
        bh=nJ8IvB9Omo4tRFb0UMgMVVVhno371eQE/tSIlUryzLk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=OFyPEqGqDSXAc9+aLzLgfwgxBq2qDip1F2SU4/G7NCHX07Z3Sj5ZDFvV5Mbk2A6Td
         4O1eodCHVW5m3Y6Z6+0mcguFyCV/eKCJ4PoNrdX7dIieNKHR6tV5rwGgrPcSVcIVIv
         IZgKyCCKCHY4LdTJFAVwBy82b9KiTI1H9hmNaYQ9wa5yKpvbHgcGIXdfKHioLYe72w
         VDODo81yriDrmH6eeeQkmwWyGLCEQpp6c/SBog0bi+jH385xo6omE3Y/CodnBSG1/5
         8/p7vSwjf4+sv1Fxcohs2RLTFh9qX3zcBuLo1bwtqo0Pe80zjUAEgROwUwNM4DHiv3
         ROR1nSrev1RxA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CD8ADF79408;
        Wed,  5 Jan 2022 19:50:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next] bpf,
 sockmap: fix return codes from tcp_bpf_recvmsg_parser()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164141220983.28548.2255582640543203112.git-patchwork-notify@kernel.org>
Date:   Wed, 05 Jan 2022 19:50:09 +0000
References: <20220104205918.286416-1-john.fastabend@gmail.com>
In-Reply-To: <20220104205918.286416-1-john.fastabend@gmail.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org, joamaki@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (master)
by Daniel Borkmann <daniel@iogearbox.net>:

On Tue,  4 Jan 2022 12:59:18 -0800 you wrote:
> Applications can be confused slightly because we do not always return the
> same error code as expected, e.g. what the TCP stack normally returns. For
> example on a sock err sk->sk_err instead of returning the sock_error we
> return EAGAIN. This usually means the application will 'try again'
> instead of aborting immediately. Another example, when a shutdown event
> is received we should immediately abort instead of waiting for data when
> the user provides a timeout.
> 
> [...]

Here is the summary with links:
  - [bpf-next] bpf, sockmap: fix return codes from tcp_bpf_recvmsg_parser()
    https://git.kernel.org/bpf/bpf-next/c/5b2c5540b811

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


