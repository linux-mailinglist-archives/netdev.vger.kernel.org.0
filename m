Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E50A471A11
	for <lists+netdev@lfdr.de>; Sun, 12 Dec 2021 13:40:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230388AbhLLMkM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Dec 2021 07:40:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229787AbhLLMkM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Dec 2021 07:40:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D43BC061714;
        Sun, 12 Dec 2021 04:40:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 57E50B80CCC;
        Sun, 12 Dec 2021 12:40:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1E3ADC341C5;
        Sun, 12 Dec 2021 12:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639312809;
        bh=EjTezAZomPwpp/TsX1hQh5bGYTbHB73xwpC2hOTk8wM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=H7EPq/ILWTeTGG+vfZ4iIh9Lk3os7Xy/qAAErio6589s7l9NNnRLt30HTTSEXsvLy
         DaIEsUsscG5Dd10s4KeTIM8mkHtyx+jHoKW+rMbuaBIq1vQYunPM8iXahMBzUHNw9C
         UkWt925RKr67hSboBAS93c/t4F0+5CtxnONsjnjN/KhrYTX6QyvgvZSOulgfk69EtJ
         s3pwVw09j4htZ7uf1ZupftjIlrb2g/RgtKKd1uWASUGsT+wMrvWBWrbdEm4SEPEztQ
         nPQQXLkmQ4XRMjDa9NINjPQxA4y1R1a0liFfTa87cLi59gvP19hw/L2LJOMw0mXRlc
         fwnd4k5P/Nfxw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 06A7F60BD0;
        Sun, 12 Dec 2021 12:40:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: Enable neighbor sysctls that is save for userns
 root
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163931280902.8997.10185548089524649068.git-patchwork-notify@kernel.org>
Date:   Sun, 12 Dec 2021 12:40:09 +0000
References: <20211208085844.405570-1-xu.xin16@zte.com.cn>
In-Reply-To: <20211208085844.405570-1-xu.xin16@zte.com.cn>
To:     CGEL <cgel.zte@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, ebiederm@xmission.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        daniel@iogearbox.net, xu.xin16@zte.com.cn, zealci@zte.com.cn
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed,  8 Dec 2021 08:58:44 +0000 you wrote:
> From: xu xin <xu.xin16@zte.com.cn>
> 
> Inside netns owned by non-init userns, sysctls about ARP/neighbor is
> currently not visible and configurable.
> 
> For the attributes these sysctls correspond to, any modifications make
> effects on the performance of networking(ARP, especilly) only in the
> scope of netns, which does not affect other netns.
> 
> [...]

Here is the summary with links:
  - [net-next] net: Enable neighbor sysctls that is save for userns root
    https://git.kernel.org/netdev/net-next/c/8c8b7aa7fb0c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


