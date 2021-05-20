Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D2E038B97A
	for <lists+netdev@lfdr.de>; Fri, 21 May 2021 00:30:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231524AbhETWbe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 18:31:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:37146 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230145AbhETWbc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 May 2021 18:31:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 6B6A7613B9;
        Thu, 20 May 2021 22:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621549810;
        bh=XfzHnvHNU8dVb7i4sW4oH3rJQtcmvsl/o5eW1VEPeLM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=bxeS/FK1fTZzzF3zaTX3xfMvJxRbxItxYoFS9k+yH7w9K/bStAOX5G/2rFu4Ssmuj
         +UJyXW0ZZ7asXh7IIqlqZUhSVeJFtF/05UJABRG/tPoWLN7UWSTbzvcG0TEG8T70uZ
         CxtPU7NZhhT0Qf4i+wRU6Q31nbpCqGIJJBcusnVt46snErWPKgDwafgan9G/456yak
         ebQK+9nELxj7sIjfp9FW5ovYcflyBNvZPBbhU79iC67bhfReoECTz87iKg+hPaO6Ip
         rN1gEfPRokqhuJo2iG5EiC4y/qcymGCgB+AA7DbDeALRbQwT8pbCYiePY9EVfY3uHg
         qo169lsqGC0IA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 5A8A460A56;
        Thu, 20 May 2021 22:30:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/1] ixgbe: fix large MTU request from VF
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162154981036.17678.1019128511696103998.git-patchwork-notify@kernel.org>
Date:   Thu, 20 May 2021 22:30:10 +0000
References: <20210520181835.2217268-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20210520181835.2217268-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, jesse.brandeburg@intel.com,
        netdev@vger.kernel.org, sassmann@redhat.com,
        piotrx.skajewski@intel.com, mateusz.palczewski@intel.com,
        konrad0.jankowski@intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Thu, 20 May 2021 11:18:35 -0700 you wrote:
> From: Jesse Brandeburg <jesse.brandeburg@intel.com>
> 
> Check that the MTU value requested by the VF is in the supported
> range of MTUs before attempting to set the VF large packet enable,
> otherwise reject the request. This also avoids unnecessary
> register updates in the case of the 82599 controller.
> 
> [...]

Here is the summary with links:
  - [net,1/1] ixgbe: fix large MTU request from VF
    https://git.kernel.org/netdev/net/c/63e39d29b3da

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


