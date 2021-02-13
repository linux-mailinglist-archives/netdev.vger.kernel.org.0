Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2432F31A974
	for <lists+netdev@lfdr.de>; Sat, 13 Feb 2021 02:21:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232317AbhBMBUu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 20:20:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:60890 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229708AbhBMBUu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Feb 2021 20:20:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id D18D964EAA;
        Sat, 13 Feb 2021 01:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613179209;
        bh=pONNld+58fyMUpymhtOZBfXZkDC8jmYWGThjEiZiN3o=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=EcqWtFtkQRXnQoM5CREGIuYA+bWrzMuv9E9/LBizrQaW33VS9QFF0KQD97rUzd1sB
         io0Qmi1/qzpP07NCfZVXC8RYLIPuseKIejNaBhN/QhYsQBWSumGJX9izEqh6IfmF6E
         HHRRpHyvhrT90UBrJ8EZf97SRnDct87/y4/sYoTwL7dtLtfOeRlEKBHBIjE4r7Ujmn
         Go8GbObE0ucvbhCddP0QXb6GR7U5OVN6/1pShE2/zqmngNWwypa/yeW4jMXpNn8gGp
         f/iUde+69n3dMbEyFY6ix7v2/AyjukJdY/hFpvacmcKKnk3IWl1Cq6TyyYTQwj6w+k
         8X2wpNXhZHqXA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id C22C860A35;
        Sat, 13 Feb 2021 01:20:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/2] selftests: tc: Test tc-flower's MPLS features
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161317920979.20729.55688764658160555.git-patchwork-notify@kernel.org>
Date:   Sat, 13 Feb 2021 01:20:09 +0000
References: <cover.1613155785.git.gnault@redhat.com>
In-Reply-To: <cover.1613155785.git.gnault@redhat.com>
To:     Guillaume Nault <gnault@redhat.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Fri, 12 Feb 2021 20:05:33 +0100 you wrote:
> A couple of patches for exercising the MPLS filters of tc-flower.
> 
> Patch 1 tests basic MPLS matching features: those that only work on the
> first label stack entry (that is, the mpls_label, mpls_tc, mpls_bos and
> mpls_ttl options).
> 
> Patch 2 tests the more generic "mpls" and "lse" options, which allow
> matching MPLS fields beyond the first stack entry.
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] selftests: tc: Add basic mpls_* matching support for tc-flower
    https://git.kernel.org/netdev/net-next/c/203ee5cd7235
  - [net-next,2/2] selftests: tc: Add generic mpls matching support for tc-flower
    https://git.kernel.org/netdev/net-next/c/c09bfd9a5df9

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


