Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E91E2C35B3
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 01:41:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727663AbgKYAkG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 19:40:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:39506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727084AbgKYAkG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Nov 2020 19:40:06 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606264805;
        bh=5KDzC9BPZzYbsqpcRCFBxEoBybh3W1z1iK7Tw0/kG4I=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=WV8xignHODss2JvajJow54ob6bcssqWfQK3oyEkvzQN86O50/xBnQzcHJGxEL8iR3
         wPEOWxSinxeayyZAX6Dr54hCz7MsZVf+7lXf3X/mxdJajO9YtHhaQ3BaMI+n4X4bEw
         MJAhS/iYG5p/Lkz6T4IYgpnNeg3LTbs1NHujPilc=
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2 0/3] ibmvnic: null pointer dereference
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160626480590.25353.12237678107052938005.git-patchwork-notify@kernel.org>
Date:   Wed, 25 Nov 2020 00:40:05 +0000
References: <20201123193547.57225-1-ljp@linux.ibm.com>
In-Reply-To: <20201123193547.57225-1-ljp@linux.ibm.com>
To:     Lijun Pan <ljp@linux.ibm.com>
Cc:     netdev@vger.kernel.org, sukadev@linux.ibm.com, drt@linux.ibm.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Mon, 23 Nov 2020 13:35:44 -0600 you wrote:
> Fix two NULL pointer dereference crash issues.
> Improve module removal procedure.
> 
> In v2, we split v1 into 3 sets according to patch dependencies so that
> individual author can rework on them during the coming holiday.
> 1-11 as a set since they are dependent and most of them are Dany's.
> 12-14 as a set since they are independent of 1-11.
> 15 to be sent to net-next.
> 
> [...]

Here is the summary with links:
  - [net,v2,1/3] ibmvnic: fix NULL pointer dereference in reset_sub_crq_queues
    https://git.kernel.org/netdev/net/c/a0faaa27c716
  - [net,v2,2/3] ibmvnic: fix NULL pointer dereference in ibmvic_reset_crq
    https://git.kernel.org/netdev/net/c/0e435befaea4
  - [net,v2,3/3] ibmvnic: enhance resetting status check during module exit
    https://git.kernel.org/netdev/net/c/3ada288150fb

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


