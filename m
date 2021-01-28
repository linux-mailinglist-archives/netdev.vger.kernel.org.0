Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B14C3068D2
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 01:52:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231263AbhA1Au7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 19:50:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:60288 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231132AbhA1Auv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Jan 2021 19:50:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 9177464DD1;
        Thu, 28 Jan 2021 00:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611795010;
        bh=QzAVdbEC5wuq1JjixHbe585QHtiaNIwx0cDMENnVHuw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Ck9Igi59+O/zdixN2bhIs85tYnw9FHPUSBTuVRPDQz/wJ7peZWp8ffZjf23bn8KM6
         Jfxj8vf+xWOc6IEMqbWEbVP5WLXw4P67HwTAe5fzL4XNs2AXqwuUKu+HbNDXX3oJVE
         +pMldKMRgCmweofhKuq62Vgw602bnfM2gReII1KtaaGPV7HkDT2knokkV7eGrKvfwC
         BmyU5JirdUH4u2pk4pCbIf3E9ye/eCUumcraJQlyMdx75qa6C34Yxlx1fgHhVN0UMZ
         pQSefthVh1fR/M+UAUKu1EBwavA99ljX4jw+89ysaNTY3vXSjrtnvodjyN8hb4S+dE
         iKD3iUx68l1cQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 82A766531E;
        Thu, 28 Jan 2021 00:50:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net] net: switchdev: don't set port_obj_info->handled true
 when -EOPNOTSUPP
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161179501052.14572.15877029725652969196.git-patchwork-notify@kernel.org>
Date:   Thu, 28 Jan 2021 00:50:10 +0000
References: <20210125124116.102928-1-rasmus.villemoes@prevas.dk>
In-Reply-To: <20210125124116.102928-1-rasmus.villemoes@prevas.dk>
To:     Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Cc:     netdev@vger.kernel.org, horatiu.vultur@microchip.com,
        jiri@mellanox.com, f.fainelli@gmail.com, petrm@mellanox.com,
        idosch@mellanox.com, davem@davemloft.net, ivecera@redhat.com,
        kuba@kernel.org, petrm@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Mon, 25 Jan 2021 13:41:16 +0100 you wrote:
> It's not true that switchdev_port_obj_notify() only inspects the
> ->handled field of "struct switchdev_notifier_port_obj_info" if
> call_switchdev_blocking_notifiers() returns 0 - there's a WARN_ON()
> triggering for a non-zero return combined with ->handled not being
> true. But the real problem here is that -EOPNOTSUPP is not being
> properly handled.
> 
> [...]

Here is the summary with links:
  - [v2,net] net: switchdev: don't set port_obj_info->handled true when -EOPNOTSUPP
    https://git.kernel.org/netdev/net/c/20776b465c0c

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


