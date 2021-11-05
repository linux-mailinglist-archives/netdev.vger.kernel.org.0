Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E2BD4465BF
	for <lists+netdev@lfdr.de>; Fri,  5 Nov 2021 16:30:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233532AbhKEPcw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Nov 2021 11:32:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:36764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233535AbhKEPct (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Nov 2021 11:32:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id C2A7C60EFE;
        Fri,  5 Nov 2021 15:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636126209;
        bh=GHN2X9hNdhcQsX8SkapeTNsqiMfVCAoIvIpHqYs3i/U=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=sdE+tOFJnvQcXfDNI+XrDZkwxCMYxW2GTrdUMo1we9WwDoviRhqiYWUCRy0lpHeEr
         ZF+8orAqLFv6KEft80HPULqnr5LrgqxHXKlSJgBqGs+aE542HYcqpfiYmIQNn+dHIr
         heuE2OvwVFSl1VyOvECgoxZAnIyHGA0SW8mWYYqOZfeD0fawsFHOeffJ7ywsJ2J/OR
         +ihGcRqh5/1YKxv3p0mHMfcRs/3fQ1F/Mas9uT38T/t1Unyt/abYsS0Y4LlQZ3Xzs2
         AzUsJnMc+Pc/hZDFU0h7rhsXIkBoyIRnEX2n7OCv336w+N4IhrMScjmCii8+O7QW6y
         bjvR09A/1Df0g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id B20FA609E6;
        Fri,  5 Nov 2021 15:30:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf] bpftool: Install libbpf headers for the bootstrap
 version, too
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163612620972.29979.8998296341719188720.git-patchwork-notify@kernel.org>
Date:   Fri, 05 Nov 2021 15:30:09 +0000
References: <20211105015813.6171-1-quentin@isovalent.com>
In-Reply-To: <20211105015813.6171-1-quentin@isovalent.com>
To:     Quentin Monnet <quentin@isovalent.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        acme@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org,
        songliubraving@fb.com, jolsa@kernel.org, namhyung@kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf.git (master)
by Daniel Borkmann <daniel@iogearbox.net>:

On Fri,  5 Nov 2021 01:58:13 +0000 you wrote:
> We recently changed bpftool's Makefile to make it install libbpf's
> headers locally instead of pulling them from the source directory of the
> library. Although bpftool needs two versions of libbpf, a "regular" one
> and a "bootstrap" version, we would only install headers for the regular
> libbpf build. Given that this build always occurs before the bootstrap
> build when building bpftool, this is enough to ensure that the bootstrap
> bpftool will have access to the headers exported through the regular
> libbpf build.
> 
> [...]

Here is the summary with links:
  - [bpf] bpftool: Install libbpf headers for the bootstrap version, too
    https://git.kernel.org/bpf/bpf/c/e41ac2020bca

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


