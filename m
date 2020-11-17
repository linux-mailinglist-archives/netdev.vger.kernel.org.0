Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 431A02B55C6
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 01:42:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730772AbgKQAkF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 19:40:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:49760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729495AbgKQAkF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Nov 2020 19:40:05 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605573605;
        bh=1X3a6pusibxgUUs6BZZXGXf5rNn97QYSBMRr/M1ekUs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=a1hR7QP7SRgGMAus5nniKjZVFZjtHukDaahk5Br13fCpNUZxMsmHpaWU9/A5KlK0o
         cKWMaqxH654OOkPiduMnTKZBNO8TBKW9rNUhjp5rAywlVeqo4lQVM6yXXVb7txAfCB
         KEq4kBrqcfsxXUejAPbvj/Z9x2ntK96TA6Rx5weA=
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: qualcomm: rmnet: Fix incorrect receive packet
 handling during cleanup
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160557360535.10137.9289534530126610366.git-patchwork-notify@kernel.org>
Date:   Tue, 17 Nov 2020 00:40:05 +0000
References: <1605298325-3705-1-git-send-email-subashab@codeaurora.org>
In-Reply-To: <1605298325-3705-1-git-send-email-subashab@codeaurora.org>
To:     Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        stranche@codeaurora.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Fri, 13 Nov 2020 13:12:05 -0700 you wrote:
> During rmnet unregistration, the real device rx_handler is first cleared
> followed by the removal of rx_handler_data after the rcu synchronization.
> 
> Any packets in the receive path may observe that the rx_handler is NULL.
> However, there is no check when dereferencing this value to use the
> rmnet_port information.
> 
> [...]

Here is the summary with links:
  - [net] net: qualcomm: rmnet: Fix incorrect receive packet handling during cleanup
    https://git.kernel.org/netdev/net/c/fc70f5bf5e52

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


