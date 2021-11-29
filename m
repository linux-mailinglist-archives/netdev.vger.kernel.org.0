Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B3624617DD
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 15:20:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238991AbhK2OXi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 09:23:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241085AbhK2OVh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 09:21:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F942C08EB30
        for <netdev@vger.kernel.org>; Mon, 29 Nov 2021 05:00:10 -0800 (PST)
Received: from mail.kernel.org (unknown [198.145.29.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 20DC66147C
        for <netdev@vger.kernel.org>; Mon, 29 Nov 2021 13:00:10 +0000 (UTC)
Received: by mail.kernel.org (Postfix) with ESMTPS id 9850460E76;
        Mon, 29 Nov 2021 13:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638190809;
        bh=wAE0oYdAfPNMmwHfWL1EwX9KxDFGxZh3dUVUU+S2Fjc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=MrCpfrsPFh/juKpPM1jxqdR6iTgnlBHkm3widBRHXMxnHNuApvqKA99m4ZtJoOnuQ
         UQ+GV5ik2+M6yi3m6eJ9vqsp+d8tO4J55OoqQroVHAQCWe4WLGAK6RDeAjOn20ZSEu
         eHL9dwifRZkYszxWbnRYVbpsL7TlFv7eRH0bC14WbfAuhcdZBeeTTCinosRLiNQWpT
         EWNoyEwzEa+TkIsiUdhYKVKebHAeDj4kv5uoqsg3TRuPec/1wOCijdclViM8IltAGq
         Lhjp0t5NUfRsN3IK6o9C6WKPqlt3wzk66kVAhPiBduJi53FRRONxt8E/ErcGSdhyjM
         DHHlMj1QQA4AA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 881E260A94;
        Mon, 29 Nov 2021 13:00:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] selftests: net: bridge: fix typo in vlan_filtering
 dependency test
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163819080955.6089.14458845613053688948.git-patchwork-notify@kernel.org>
Date:   Mon, 29 Nov 2021 13:00:09 +0000
References: <20211129095850.2018071-1-ivecera@redhat.com>
In-Reply-To: <20211129095850.2018071-1-ivecera@redhat.com>
To:     Ivan Vecera <ivecera@redhat.com>
Cc:     netdev@vger.kernel.org, nikolay@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon, 29 Nov 2021 10:58:50 +0100 you wrote:
> Prior patch:
> ]# TESTS=vlmc_filtering_test ./bridge_vlan_mcast.sh
> TEST: Vlan multicast snooping enable                                [ OK ]
> Device "bridge" does not exist.
> TEST: Disable multicast vlan snooping when vlan filtering is disabled   [FAIL]
>         Vlan filtering is disabled but multicast vlan snooping is still enabled
> 
> [...]

Here is the summary with links:
  - [net-next] selftests: net: bridge: fix typo in vlan_filtering dependency test
    https://git.kernel.org/netdev/net-next/c/754d71be5292

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


