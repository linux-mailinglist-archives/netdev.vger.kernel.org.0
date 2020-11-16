Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82FDC2B554D
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 00:42:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730768AbgKPXkb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 18:40:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:45310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729500AbgKPXka (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Nov 2020 18:40:30 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605570030;
        bh=hcGqJi6P9O2sshDTbe79GKgjwB+bSHJraS4RBhNGTYA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Jjbjo99AN6NSm582wO6CNceuabdAx94Oas1awTmoYPqgGQNJvc9ZwUV/S7b2Kqtwk
         /Y1zx8/llsxxKf9QY9VMcV2jByAph6olpJigyoz+93ncxPQMtoHhjlu3u+Znc6zRIu
         DFRYaOg5l9TVxUpiOUnWvHnbvfVNzEekOYPUUPMQ=
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] qlcnic: fix error return code in qlcnic_83xx_restart_hw()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160557003003.13670.13412603874297837843.git-patchwork-notify@kernel.org>
Date:   Mon, 16 Nov 2020 23:40:30 +0000
References: <1605248186-16013-1-git-send-email-zhangchangzhong@huawei.com>
In-Reply-To: <1605248186-16013-1-git-send-email-zhangchangzhong@huawei.com>
To:     Zhang Changzhong <zhangchangzhong@huawei.com>
Cc:     shshaikh@marvell.com, manishc@marvell.com,
        GR-Linux-NIC-Dev@marvell.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Fri, 13 Nov 2020 14:16:26 +0800 you wrote:
> Fix to return a negative error code from the error handling
> case instead of 0, as done elsewhere in this function.
> 
> Fixes: 3ced0a88cd4c ("qlcnic: Add support to run firmware POST")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
> 
> [...]

Here is the summary with links:
  - [net] qlcnic: fix error return code in qlcnic_83xx_restart_hw()
    https://git.kernel.org/netdev/net/c/3beb9be16508

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


