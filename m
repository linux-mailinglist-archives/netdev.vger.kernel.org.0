Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 204522B1482
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 04:00:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726205AbgKMDAJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 22:00:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:56008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725965AbgKMDAG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Nov 2020 22:00:06 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605236405;
        bh=m8SX2deUt3gCwYavt7yxhJQ1ULOepzgobs3A0svAeBk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ubRhP4J+w3qnoN54HEPcESpTU7xHuIquGZ8i+Mv3xbkqQSAtZEk+HNnCKyg73oaNK
         nP9UB5sn/y1WtCQxkc1w9uugQMVFuX0J1AESjp3S/vFGrrMbVoOS0EMrcaIXR4tGFf
         CKiQjzKgMBnp9hOw8U3TiU9H5PUjeMm6lxlxs7u0=
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 bpf-next 0/4] bpf: Enable bpf_sk_storage for
 FENTRY/FEXIT/RAW_TP
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160523640546.11067.18380390287451978846.git-patchwork-notify@kernel.org>
Date:   Fri, 13 Nov 2020 03:00:05 +0000
References: <20201112211255.2585961-1-kafai@fb.com>
In-Reply-To: <20201112211255.2585961-1-kafai@fb.com>
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        kernel-team@fb.com, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to bpf/bpf-next.git (refs/heads/master):

On Thu, 12 Nov 2020 13:12:55 -0800 you wrote:
> This set is to allow the FENTRY/FEXIT/RAW_TP tracing program to use
> bpf_sk_storage.  The first two patches are a cleanup.  The last patch is
> tests.  Patch 3 has the required kernel changes to
> enable bpf_sk_storage for FENTRY/FEXIT/RAW_TP.
> 
> Please see individual patch for details.
> 
> [...]

Here is the summary with links:
  - [v2,bpf-next,1/4] bpf: Folding omem_charge() into sk_storage_charge()
    https://git.kernel.org/bpf/bpf-next/c/9e838b02b0bb
  - [v2,bpf-next,2/4] bpf: Rename some functions in bpf_sk_storage
    https://git.kernel.org/bpf/bpf-next/c/e794bfddb8b8
  - [v2,bpf-next,3/4] bpf: Allow using bpf_sk_storage in FENTRY/FEXIT/RAW_TP
    https://git.kernel.org/bpf/bpf-next/c/8e4597c627fb
  - [v2,bpf-next,4/4] bpf: selftest: Use bpf_sk_storage in FENTRY/FEXIT/RAW_TP
    https://git.kernel.org/bpf/bpf-next/c/53632e111946

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


