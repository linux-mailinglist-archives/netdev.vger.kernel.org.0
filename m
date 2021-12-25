Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67B4847F40E
	for <lists+netdev@lfdr.de>; Sat, 25 Dec 2021 18:20:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232520AbhLYRUN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Dec 2021 12:20:13 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:37232 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230127AbhLYRUM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Dec 2021 12:20:12 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 30AB8B8075B
        for <netdev@vger.kernel.org>; Sat, 25 Dec 2021 17:20:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CC3D1C36AEB;
        Sat, 25 Dec 2021 17:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640452809;
        bh=0nKMszXeN+VBRICigdWVnp5nwH8ALVHZHdvuR207cLA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ZZ1bcmC3HHMISKdORUtyjnD+PEA8+Im56sORLPddmZxH3ncDvBIJL8OKkkC1SP705
         evw6LJ+/nMfHgz2w3in/DLBFRKMidNq28H5x5SyAivxO6H+Jd9qP/SXrdMfeXe6BEq
         efXuKH8tneb6vGGk8NVqL9ugd75t6h1UcnaHO61TXRBWvt/XVYLliMdWqVib/x0yE4
         x8GMZ6Rv7+aZWJKuX8Onqf3krIjSSnnbnxfOzulJHDPN+YCWbbXgzYEBt38K5uw5Jc
         oCu/W2orUjX58sL7JhGqZKTYGDZUQKs3Dh9PNAljKYcqb8HScOQB6+G5nFON7Q4L3J
         P2Ym+Mni0lz8w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B1F6BEAC069;
        Sat, 25 Dec 2021 17:20:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] selftests: mptcp: Remove the deprecated config NFT_COUNTER
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164045280972.14262.6876774965186630202.git-patchwork-notify@kernel.org>
Date:   Sat, 25 Dec 2021 17:20:09 +0000
References: <20211224095928.60584-1-xinjianx.ma@intel.com>
In-Reply-To: <20211224095928.60584-1-xinjianx.ma@intel.com>
To:     Ma Xinjian <xinjianx.ma@intel.com>
Cc:     mathew.j.martineau@linux.intel.com, matthieu.baerts@tessares.net,
        kuba@kernel.org, shuah@kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, mptcp@lists.linux.dev, philip.li@intel.com,
        lkp@intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 24 Dec 2021 17:59:28 +0800 you wrote:
> NFT_COUNTER was removed since
> 390ad4295aa ("netfilter: nf_tables: make counter support built-in")
> LKP/0Day will check if all configs listing under selftests are able to
> be enabled properly.
> 
> For the missing configs, it will report something like:
> LKP WARN miss config CONFIG_NFT_COUNTER= of net/mptcp/config
> 
> [...]

Here is the summary with links:
  - selftests: mptcp: Remove the deprecated config NFT_COUNTER
    https://git.kernel.org/netdev/net/c/e6007b85dfa2

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


