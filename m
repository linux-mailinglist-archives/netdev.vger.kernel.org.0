Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77C79497E8A
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 13:10:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238289AbiAXMKO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 07:10:14 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:41980 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238269AbiAXMKL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 07:10:11 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6A55860C9B
        for <netdev@vger.kernel.org>; Mon, 24 Jan 2022 12:10:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CE7D2C340EA;
        Mon, 24 Jan 2022 12:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643026210;
        bh=UnKYZIkQGjD9SDkuMVw6hSc6VEvoaeW0JYLr7xoJ0jk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=NbOAuADr1PcA2x6c1YvjNH3z0WwZ8/bJw0TpPtXjt7fg8x3EmsEeWtG5OumIHIQZT
         jpx7+YR6vqNWdAz1iwEAtpVx96cCi68al8fbCW/ruwsu3Xd25wCpfTjV663+lldUlO
         4uLyiI7Lhh3ucdEaFfN0/L6mmjLWRjBoFkJcFZDcOTtR9vcuTaFi/VOckGZzaH37YN
         YDdaX2+Pu7Fq+DbsYJtWNjHcxVUfKrs9w6axMPpL56pSRgUGnT5YtLG6p3+LSHSvib
         I6+aePIJfioyfhMBA57pWS+MdXI6EsEMbH/SysiAwNc6NdX1ZLxQdSa+YP4jrY/yaN
         8JZCxQ5X6Qp1w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B9FC7F60790;
        Mon, 24 Jan 2022 12:10:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/4] ibmvnic: Allow extra failures before disabling
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164302621075.19022.2004898566451431707.git-patchwork-notify@kernel.org>
Date:   Mon, 24 Jan 2022 12:10:10 +0000
References: <20220122025921.199446-1-sukadev@linux.ibm.com>
In-Reply-To: <20220122025921.199446-1-sukadev@linux.ibm.com>
To:     Sukadev Bhattiprolu <sukadev@linux.ibm.com>
Cc:     netdev@vger.kernel.org, brking@linux.ibm.com, drt@linux.ibm.com,
        ricklind@linux.ibm.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 21 Jan 2022 18:59:18 -0800 you wrote:
> If auto-priority-failover (APF) is enabled and there are at least two
> backing devices of different priorities, some resets like fail-over,
> change-param etc can cause at least two back to back failovers. (Failover
> from high priority backing device to lower priority one and then back
> to the higher priority one if that is still functional).
> 
> Depending on the timimg of the two failovers it is possible to trigger
> a "hard" reset and for the hard reset to fail due to failovers. When this
> occurs, the driver assumes that the network is unstable and disables the
> VNIC for a 60-second "settling time". This in turn can cause the ethtool
> command to fail with "No such device" while the vnic automatically recovers
> a little while later.
> 
> [...]

Here is the summary with links:
  - [net,1/4] ibmvnic: Allow extra failures before disabling
    https://git.kernel.org/netdev/net/c/db9f0e8bf79e
  - [net,2/4] ibmvnic: init ->running_cap_crqs early
    https://git.kernel.org/netdev/net/c/151b6a5c06b6
  - [net,3/4] ibmvnic: don't spin in tasklet
    https://git.kernel.org/netdev/net/c/48079e7fdd02
  - [net,4/4] ibmvnic: remove unused ->wait_capability
    https://git.kernel.org/netdev/net/c/3a5d9db7fbdf

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


