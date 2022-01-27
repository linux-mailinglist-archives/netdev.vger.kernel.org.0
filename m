Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07C4549E802
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 17:50:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243940AbiA0QuM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 11:50:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234585AbiA0QuL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 11:50:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5EF4C061714;
        Thu, 27 Jan 2022 08:50:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 42AB061A40;
        Thu, 27 Jan 2022 16:50:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id ABA68C340EB;
        Thu, 27 Jan 2022 16:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643302210;
        bh=Cz6QMeKxN77A7aL8FqHZmINBlF/a0VxVjq8JBN3/TWQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Wl0EpUBG1Qc7pGf23lssSOMLEySR8X9nCa3q6oZGgnJHTxruUzb/PIIFVr08f6opb
         znMEwLh4L7GMpoXzH7/KaBfSjfd0V/xMqWPV/A2RKdViO0HYDMMVJuJbCvEh+JjFhj
         VmpPfwh+7vIasnFcA3owUZ0M8pP4RGP3mQahwY7h295/zNxBcXJkp0PENhqI2HW/wc
         +e4ZrJr2bm0uTnKzu45pmHi6SJM+BUnXQK0lsVohROPJkDCLb9cecNZghnNnm5taum
         naiJW8py9aIWVo+oHCbgpjjwmZgnq8E2leqwRzZFVMbm2tXAIek8dZLzbhfp6oT+Xi
         jDCNuz8xFTW5Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8F3D6E5D07E;
        Thu, 27 Jan 2022 16:50:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next] selftests: xsk: fix bpf_res cleanup test
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164330221058.9164.13990882355843912872.git-patchwork-notify@kernel.org>
Date:   Thu, 27 Jan 2022 16:50:10 +0000
References: <20220125082945.26179-1-magnus.karlsson@gmail.com>
In-Reply-To: <20220125082945.26179-1-magnus.karlsson@gmail.com>
To:     Magnus Karlsson <magnus.karlsson@gmail.com>
Cc:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com, jonathan.lemon@gmail.com,
        bpf@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (master)
by Daniel Borkmann <daniel@iogearbox.net>:

On Tue, 25 Jan 2022 09:29:45 +0100 you wrote:
> From: Magnus Karlsson <magnus.karlsson@intel.com>
> 
> After commit 710ad98c363a ("veth: Do not record rx queue hint in
> veth_xmit"), veth no longer receives traffic on the same queue as it
> was sent on. This breaks the bpf_res test for the AF_XDP selftests as
> the socket tied to queue 1 will not receive traffic anymore. Modify
> the test so that two sockets are tied to queue id 0 using a shared
> umem instead. When killing the first socket enter the second socket
> into the xskmap so that traffic will flow to it. This will still test
> that the resources are not cleaned up until after the second socket
> dies, without having to rely on veth supporting rx_queue hints.
> 
> [...]

Here is the summary with links:
  - [bpf-next] selftests: xsk: fix bpf_res cleanup test
    https://git.kernel.org/bpf/bpf-next/c/3b22523bca02

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


