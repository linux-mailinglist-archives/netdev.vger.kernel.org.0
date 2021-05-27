Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BEA439386B
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 23:50:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234492AbhE0Vvh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 17:51:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:55944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229822AbhE0Vvg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 May 2021 17:51:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 20570613DA;
        Thu, 27 May 2021 21:50:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622152203;
        bh=63jQmPf2CLvj012dl3d3CKk5V2U75iAvGZYW9dQC56A=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=oCm1hbfWdHM4De0qkC0F4xqAyHhgMEzyDJ7UC3zGbQcfrZLNND/Sl3TqaF0/vFyO8
         A9e76Ih07NTvh0UGIS74klzOszTxztFyOGX7L2HC8OxM5c9RPT4cdqqe/3PVtti3LK
         fg7col99kozYd3H8vPHQxhsc5CPWquZxu1QuatfRiv2JIQrevEL4OnakLaBeQnpXQO
         uFMkB1jVQc6d6kDqe6Rp3+H50jhvWOVN8dI+Dn6WL0Zfi2X+tAqf0/hyJfVLzo7arf
         dujMeA92nFEshKF9v+01gOO7wMW+EMEOZDTDqevgZga0kFgfcHWxBKSM57lYyBULc0
         BNI3RH55ufELw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 1295760BE2;
        Thu, 27 May 2021 21:50:03 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] devlink: Correct VIRTUAL port to not have phys_port
 attributes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162215220307.21706.10527042945072250760.git-patchwork-notify@kernel.org>
Date:   Thu, 27 May 2021 21:50:03 +0000
References: <20210526200027.14008-1-parav@nvidia.com>
In-Reply-To: <20210526200027.14008-1-parav@nvidia.com>
To:     Parav Pandit <parav@nvidia.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        saeedm@nvidia.com, roid@nvidia.com, jiri@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed, 26 May 2021 23:00:27 +0300 you wrote:
> Physical port name, port number attributes do not belong to virtual port
> flavour. When VF or SF virtual ports are registered they incorrectly
> append "np0" string in the netdevice name of the VF/SF.
> 
> Before this fix, VF netdevice name were ens2f0np0v0, ens2f0np0v1 for VF
> 0 and 1 respectively.
> 
> [...]

Here is the summary with links:
  - [net] devlink: Correct VIRTUAL port to not have phys_port attributes
    https://git.kernel.org/netdev/net/c/b28d8f0c25a9

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


