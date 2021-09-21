Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30CB8413144
	for <lists+netdev@lfdr.de>; Tue, 21 Sep 2021 12:10:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231622AbhIUKLi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Sep 2021 06:11:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:47068 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229833AbhIUKLf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Sep 2021 06:11:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id B131961156;
        Tue, 21 Sep 2021 10:10:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632219007;
        bh=Mu214ano4f42Krq6cOX5QX2NIU+jkFkqLZ/mli6fYo4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=JzqjLdaqvnxe9C8WMTrPwDbz5VWsstbm6NU14zfdrHLQBKDlDYohbTFAjowhDpBQa
         9BYkOnf1ufMQnASJqa5/MPJbkoO1aE4hNfK0sBepff6DEoasHZteWAEY5hhifcCqNv
         /F/PwNWBjieBtUFnoNmgjV+AIAJuXure1w1fan3HCx2uJok/89Zrl+a3CoJEMM2TiY
         d4DOvbFTGsMpmhaKVnWqAiMQq2GvQXxWtx4sK7l3FW/1+5TbfSD3KrFHMatSG1J2G6
         nuKRFokgJLXZpzs9WL64NlxtiVH+sqzKC7KSnIT9hUq6NGHf8OBqPBPnBqnLqriPj8
         RS7TyMs/gqh/Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id A3B7760A7C;
        Tue, 21 Sep 2021 10:10:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: dsa: fix dsa_tree_setup error path
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163221900766.14288.14341504235346708492.git-patchwork-notify@kernel.org>
Date:   Tue, 21 Sep 2021 10:10:07 +0000
References: <20210920224918.1751214-1-vladimir.oltean@nxp.com>
In-Reply-To: <20210920224918.1751214-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, davem@davemloft.net,
        kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Tue, 21 Sep 2021 01:49:18 +0300 you wrote:
> Since the blamed commit, dsa_tree_teardown_switches() was split into two
> smaller functions, dsa_tree_teardown_switches and dsa_tree_teardown_ports.
> 
> However, the error path of dsa_tree_setup stopped calling dsa_tree_teardown_ports.
> 
> Fixes: a57d8c217aad ("net: dsa: flush switchdev workqueue before tearing down CPU/DSA ports")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> [...]

Here is the summary with links:
  - [net] net: dsa: fix dsa_tree_setup error path
    https://git.kernel.org/netdev/net/c/e5845aa0eadd

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


