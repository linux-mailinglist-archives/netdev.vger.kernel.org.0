Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7229472C94
	for <lists+netdev@lfdr.de>; Mon, 13 Dec 2021 13:50:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236964AbhLMMuO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 07:50:14 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:53250 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233059AbhLMMuN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Dec 2021 07:50:13 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id F03ADCE0FFD
        for <netdev@vger.kernel.org>; Mon, 13 Dec 2021 12:50:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 24AF0C34607;
        Mon, 13 Dec 2021 12:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639399810;
        bh=Vb/6vNGj2+waB1TT84gmcFbkjTD8tclu24l0Nqt0sQA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=jDPE40aiolrfLxxT4XB9gBkqkj/4DGtZ5vyEL62t01b1QKrLK0Mb/ADkzWfg76JtD
         swNHpKHgbYH7xCFULMcSvmvlfLTHUn3wg5z0CvrW4BQv0gqaIqb0xyY0F4m0FITPN4
         h+Zmo0xq7BEmXtd4BHJcH49rZWHhYXNrw/Q5ecPWVZDjyZqbjl+v9cSJRHjsMcgBlT
         KBTyLomk8KwECoXELdlwWntpg1/tn2ucRV3pnCIqRuA/mi7TX837JSeFBZqGp3Cj72
         EtFhjMPHTox3t5lbQC2ZyxhLVzibyBgkMihJJGCwzs3EpMMEkMD/+/L3mjraI5vm+O
         MGrlK4vRIRjpA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id F301E60A4F;
        Mon, 13 Dec 2021 12:50:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] net: Enable max_dgram_qlen unix sysctl to be
 configurable by non-init user namespaces
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163939980999.30215.14697678206955078509.git-patchwork-notify@kernel.org>
Date:   Mon, 13 Dec 2021 12:50:09 +0000
References: <20211210204023.2595573-1-joannekoong@fb.com>
In-Reply-To: <20211210204023.2595573-1-joannekoong@fb.com>
To:     Joanne Koong <joannekoong@fb.com>
Cc:     netdev@vger.kernel.org, ebiederm@xmission.com, kuba@kernel.org,
        davem@davemloft.net, Kernel-team@fb.com, kafai@fb.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 10 Dec 2021 12:40:23 -0800 you wrote:
> This patch enables the "/proc/sys/net/unix/max_dgram_qlen" sysctl to be
> exposed to non-init user namespaces. max_dgram_qlen is used as the default
> "sk_max_ack_backlog" value for when a unix socket is created.
> 
> Currently, when a networking namespace is initialized, its unix sysctls
> are exposed only if the user namespace that "owns" it is the init user
> namespace. If there is an non-init user namespace that "owns" a networking
> namespace (for example, in the case after we call clone() with both
> CLONE_NEWUSER and CLONE_NEWNET set), the sysctls are hidden from view
> and not configurable.
> 
> [...]

Here is the summary with links:
  - [net-next,v2] net: Enable max_dgram_qlen unix sysctl to be configurable by non-init user namespaces
    https://git.kernel.org/netdev/net-next/c/cec16052d5a7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


