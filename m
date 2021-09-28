Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A494D41A9F2
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 09:40:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239389AbhI1Hlu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 03:41:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:59374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239351AbhI1Hlq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Sep 2021 03:41:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 8EB2B611CB;
        Tue, 28 Sep 2021 07:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632814807;
        bh=5OQwXTM7rc+J4UhQfbazAG7F2Y1e67gBcHwMh9fJkKQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=pmw2wFjvstVKaVK6E6N3JkrSkEUpSnKWK7SIPYBgl6V+9+yC5BdgVD4TdVg3wtA8+
         0TCBC9JJaFrO2xKklaBeqFO6Jsw/RJvK37m99Vdp6G/FA3Gwm0K2AR5sX9JpWOle9S
         Gs7kg5zUEDpBpT7NumQWx49DxqSKPj4S7UranOF4EsCzRbMLIpBPSoZOv4fhVwiFDG
         XyruHbuVQkgfDksENUAGxtIhS0XU68KHIhlzUvUVt8FQ/HBFvCRTAEmiwsaJUCYj+6
         zRnHinUtJm9xzIuOYh0fLzE7q2kp9rP4W69/YdHnM5nczpJvqG2dw2F+y0FuKjGtQ2
         eu6ajoZZb+mQA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 7FDA060A69;
        Tue, 28 Sep 2021 07:40:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf] selftests: bpf: test_lwt_ip_encap: really disable
 rp_filter
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163281480751.25377.929896779107240942.git-patchwork-notify@kernel.org>
Date:   Tue, 28 Sep 2021 07:40:07 +0000
References: <b1cdd9d469f09ea6e01e9c89a6071c79b7380f89.1632386362.git.jbenc@redhat.com>
In-Reply-To: <b1cdd9d469f09ea6e01e9c89a6071c79b7380f89.1632386362.git.jbenc@redhat.com>
To:     Jiri Benc <jbenc@redhat.com>
Cc:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, posk@google.com, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf.git (refs/heads/master):

On Thu, 23 Sep 2021 10:40:22 +0200 you wrote:
> It's not enough to set net.ipv4.conf.all.rp_filter=0, that does not override
> a greater rp_filter value on the individual interfaces. We also need to set
> net.ipv4.conf.default.rp_filter=0 before creating the interfaces. That way,
> they'll also get their own rp_filter value of zero.
> 
> Fixes: 0fde56e4385b0 ("selftests: bpf: add test_lwt_ip_encap selftest")
> Signed-off-by: Jiri Benc <jbenc@redhat.com>
> 
> [...]

Here is the summary with links:
  - [bpf] selftests: bpf: test_lwt_ip_encap: really disable rp_filter
    https://git.kernel.org/bpf/bpf/c/79e2c3066675

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


