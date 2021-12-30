Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC9AC481C7D
	for <lists+netdev@lfdr.de>; Thu, 30 Dec 2021 14:30:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239589AbhL3NaT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Dec 2021 08:30:19 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:47130 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239519AbhL3NaN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Dec 2021 08:30:13 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 89791616EB
        for <netdev@vger.kernel.org>; Thu, 30 Dec 2021 13:30:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E70BDC36AED;
        Thu, 30 Dec 2021 13:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640871012;
        bh=J8kqKQwbVIRsVEYZnj59viYhtLdY9VFM0THAsdywZS4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=BSUGXhgz+8gNsBHiBSah15vZvIr25l/9ZrkCaqF82WE8dhRNap0Qj9SF5MpmhwVFO
         n6de9yV+TcNWzm0WNqdns9MY57RSeQErpOiSiHjV/y5lmRcFxGBTanLwXDe+8bFK7T
         ovf6KZoXl4JCMk6kFIESkXuytKGerGt2TZwwIEQK2gtVNNPuVar84G7epFZIWA9mIj
         kUxfQwsH7JSrHL1J13+7lrtdN7InR7shmaIbq+tkH7l4zNH1msS7Y3ZlgKxO9Mt5t+
         iJAISg9QgZku7nACYI44F2VjvK13oAKffhlDiMPw/DIS/NFnV7agnL3UvS8uHRddiw
         qwJUcIPoRBjOw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CE23CC395E7;
        Thu, 30 Dec 2021 13:30:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/4][pull request] 1GbE Intel Wired LAN Driver
 Updates 2021-12-29
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164087101284.9335.13494757054416669229.git-patchwork-notify@kernel.org>
Date:   Thu, 30 Dec 2021 13:30:12 +0000
References: <20211229184053.632634-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20211229184053.632634-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        kernel.hbk@gmail.com, richardcochran@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Tony Nguyen <anthony.l.nguyen@intel.com>:

On Wed, 29 Dec 2021 10:40:49 -0800 you wrote:
> Ruud Bos says:
> 
> The igb driver provides support for PEROUT and EXTTS pin functions that
> allow adapter external use of timing signals. At Hottinger Bruel & Kjaer we
> are using the PEROUT function to feed a PTP corrected 1pps signal into an
> FPGA as cross system synchronized time source.
> 
> [...]

Here is the summary with links:
  - [net-next,1/4] igb: move SDP config initialization to separate function
    https://git.kernel.org/netdev/net-next/c/8ab55aba31ee
  - [net-next,2/4] igb: move PEROUT and EXTTS isr logic to separate functions
    https://git.kernel.org/netdev/net-next/c/cf99c1dd7b77
  - [net-next,3/4] igb: support PEROUT on 82580/i354/i350
    https://git.kernel.org/netdev/net-next/c/1819fc753aca
  - [net-next,4/4] igb: support EXTTS on 82580/i354/i350
    https://git.kernel.org/netdev/net-next/c/38970eac41db

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


