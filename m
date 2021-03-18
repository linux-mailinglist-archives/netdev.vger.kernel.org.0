Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 477F233FC0B
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 01:00:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229702AbhCRAAW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 20:00:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:45642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229472AbhCRAAI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Mar 2021 20:00:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id CECEC64F26;
        Thu, 18 Mar 2021 00:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616025607;
        bh=OaunqOHLwfxLGOtubcYnnBiLC6t/N6vmt4NrpmJ00oE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=QbPVX2uV+69ZypTovAbZs+pTX98ITpEyRJVXGe3eYKz6WLLjmA4rIHpf1sRpykB3D
         PI6UaSBUeJFUOri/E71am+xSKjGUn0TzYzXn8pLaEhCS6G0l3l6Q7aCvpMEnPpDFQP
         5wlWjWphMbx7KCr+p143cDKsW6X6xivJoTGFR7zeMIl7g9dMfSt45SZMhDAGdMz8XB
         rLp39JsFKzXFZ+A10q3OifLPDaUl4udlaJZTyR7QYkIM8AlUsVM5ujDA5Y3FbTXuWD
         C1XQl2o0EhRSeJ45v/hSCGk7L7G6m67qEFBdFDkPqfRcbeArlI4yyluCgng5Hq/12c
         Wg1hq0cxoDm6w==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id BD77060A45;
        Thu, 18 Mar 2021 00:00:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next v2] libbpf: use SOCK_CLOEXEC when opening the netlink
 socket
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161602560777.28912.7973368937701638439.git-patchwork-notify@kernel.org>
Date:   Thu, 18 Mar 2021 00:00:07 +0000
References: <20210317115857.6536-1-memxor@gmail.com>
In-Reply-To: <20210317115857.6536-1-memxor@gmail.com>
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     ast@kernel.org, toke@redhat.com, daniel@iogearbox.net,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf.git (refs/heads/master):

On Wed, 17 Mar 2021 17:28:58 +0530 you wrote:
> Otherwise, there exists a small window between the opening and closing
> of the socket fd where it may leak into processes launched by some other
> thread.
> 
> Fixes: 949abbe88436 ("libbpf: add function to setup XDP")
> Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> 
> [...]

Here is the summary with links:
  - [bpf-next,v2] libbpf: use SOCK_CLOEXEC when opening the netlink socket
    https://git.kernel.org/bpf/bpf/c/58bfd95b554f

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


