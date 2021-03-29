Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46E9634D94E
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 22:50:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231312AbhC2UuT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 16:50:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:50974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231209AbhC2UuL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Mar 2021 16:50:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id BD036619AD;
        Mon, 29 Mar 2021 20:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617051010;
        bh=40BMpfCAQjxdAKWDy7T7LRpzunVknDrlCx5ph428Xus=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=a7RbihgHQ5FVRYWIvWTUgHzZMlzoYXgyhlR/Jg21ID0CBXTfKOEMZLdKSzKFPqtbN
         npYouxatgFZTWVG55u81Vyhx/xOZiOEVzekSW/defjN/JTyPrXR2BA+RrTH+Wb8FAG
         6HoQSMzibNanzbZpvwnyFu1V5onSNIxaUW95SrFP1glM3ESrWCqyjP5XnA6vQY6a8R
         uAlBKqHKkMjGuZyPjp8namEzy4xts118Us/AkZf/Xq1/IGdiZYIUVfs3NZuTKVlN9M
         Cnq0wWuvJosekPSdR7AtVahGkgA62FD5lA+ptUjtwoFSnJ5xMORSf+RAkNNBttWW3Q
         3TTX+njblFQ5Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id AEB7860A49;
        Mon, 29 Mar 2021 20:50:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/6] mlxsw: Two sampling fixes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161705101071.19110.2309669828575160608.git-patchwork-notify@kernel.org>
Date:   Mon, 29 Mar 2021 20:50:10 +0000
References: <20210329100948.355486-1-idosch@idosch.org>
In-Reply-To: <20210329100948.355486-1-idosch@idosch.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        jiri@nvidia.com, mlxsw@nvidia.com, idosch@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Mon, 29 Mar 2021 13:09:42 +0300 you wrote:
> From: Ido Schimmel <idosch@nvidia.com>
> 
> This patchset fixes two bugs in recent sampling submissions.
> 
> The first fix, in patch #3, prevents matchall rules with sample action
> to be added in front of flower rules on egress. Patches #1-#2 are
> preparations meant at avoiding similar bugs in the future. Patch #4 is a
> selftest.
> 
> [...]

Here is the summary with links:
  - [net-next,1/6] mlxsw: spectrum_matchall: Perform protocol check earlier
    https://git.kernel.org/netdev/net-next/c/4947e7309a31
  - [net-next,2/6] mlxsw: spectrum_matchall: Convert if statements to a switch statement
    https://git.kernel.org/netdev/net-next/c/50401f292434
  - [net-next,3/6] mlxsw: spectrum_matchall: Perform priority checks earlier
    https://git.kernel.org/netdev/net-next/c/b24303048a6b
  - [net-next,4/6] selftests: mlxsw: Test matchall failure with protocol match
    https://git.kernel.org/netdev/net-next/c/c3572a0b731f
  - [net-next,5/6] mlxsw: spectrum: Veto sampling if already enabled on port
    https://git.kernel.org/netdev/net-next/c/17b96a5cbe3d
  - [net-next,6/6] selftests: mlxsw: Test vetoing of double sampling
    https://git.kernel.org/netdev/net-next/c/7ede22e65832

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


